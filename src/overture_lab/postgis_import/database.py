"""Transactional bulk loading and bounded full-content verification."""
from __future__ import annotations

from contextlib import contextmanager
import hashlib
import json
from pathlib import Path
import sqlite3
import tempfile
import time

from .contract import BATCH_SIZE, tables_for, metric_srid, identifier, ImportValidationError
from .snapshot import emit, rows, verify_snapshot, snapshot_budget


# Geography is derived only from valid, finite, nonempty lon/lat geometry.
# The CASE prevents PostgreSQL's geography cast from coercing out-of-range data.
UTM_DECLARATIONS = (
    "CHECK (geometry_m_srid IS NULL OR geometry_m_srid BETWEEN 32601 AND 32660 OR geometry_m_srid BETWEEN 32701 AND 32760)",
    "CHECK (geometry_m IS NULL OR (geometry_m_srid IS NOT NULL AND ST_SRID(geometry_m)=geometry_m_srid))",
    "CHECK (metric_status IN ('ok','null_geometry','empty_geometry','invalid_geometry','outside_utm','projection_failed'))",
    "CHECK ((metric_status='ok') = (geometry_m IS NOT NULL))",
    "CHECK ((metric_status IN ('ok','projection_failed')) = (geometry_m_srid IS NOT NULL))",
    "CHECK ((geometry_m_srid IS NULL) = (utm_crosses_zone IS NULL))",
    "geometry_geog geography(Geometry,4326) GENERATED ALWAYS AS (CASE WHEN geometry IS NOT NULL "
    "AND NOT ST_IsEmpty(geometry) AND ST_IsValid(geometry) "
    "AND ST_XMin(Box3D(geometry)) >= -180 AND ST_XMax(Box3D(geometry)) <= 180 "
    "AND ST_YMin(Box3D(geometry)) >= -90 AND ST_YMax(Box3D(geometry)) <= 90 "
    "THEN geometry::geography ELSE NULL END) STORED",
)


def read_connections(path):
    config = dict(path) if isinstance(path, dict) else json.loads(Path(path).read_text())
    identifier(config["schema"])
    pg = config["postgis"]
    for field in ("host", "port", "dbname", "user", "password_file"):
        if field not in pg:
            raise ImportValidationError(f"PostgreSQL configuration requires {field}")
    secret = Path(pg["password_file"])
    if not secret.is_absolute() or not secret.is_file() or secret.stat().st_mode & 0o077:
        raise ImportValidationError("PostgreSQL password_file must be an absolute file with mode 0600")
    if not 0 < int(pg["port"]) <= 65535:
        raise ImportValidationError("Invalid PostgreSQL port")
    timeout = config.get("statement_timeout_seconds", 3600)
    if not isinstance(timeout, (int, float)) or not 0 < timeout <= 604800:
        raise ImportValidationError("statement_timeout_seconds must be positive and at most one week")
    return config


@contextmanager
def connection(config):
    import psycopg
    pg = config["postgis"]
    options = {k: pg[k] for k in ("host", "port", "dbname", "user", "sslmode", "sslrootcert") if k in pg}
    options.update(password=Path(pg["password_file"]).read_text().rstrip("\r\n"), connect_timeout=10,
                   application_name="sedona-overture-postgis-import")
    with psycopg.connect(**options) as conn:
        conn.execute("SELECT set_config('statement_timeout', %s, true)", (str(int(config.get("statement_timeout_seconds", 3600) * 1000)),))
        conn.execute("SELECT set_config('lock_timeout', '5000', true)")
        if not conn.execute("SELECT EXISTS (SELECT 1 FROM pg_extension WHERE extname='postgis')").fetchone()[0]:
            raise ImportValidationError("The existing database must already have PostGIS enabled")
        yield conn


def _geometry_hex(wkt, srid):
    from shapely import from_wkt, set_srid, to_wkb
    return None if wkt is None else to_wkb(set_srid(from_wkt(wkt), srid), hex=True, byte_order=1, include_srid=True).lower()


def _checksum(records):
    total = 0
    count = 0
    for record in records:
        payload = json.dumps(record, ensure_ascii=False, allow_nan=False, separators=(",", ":")).encode()
        total = (total + int.from_bytes(hashlib.sha256(payload).digest(), "big")) % (1 << 256)
        count += 1
    return {"rows": count, "multiset_sha256_sum": f"{total:064x}"}


def _expected(root, table, version):
    for row in rows(root, table):
        values = []
        for name, kind in tables_for(version)[table]:
            value = row[name]
            if name in {"geometry", "geometry_m"}:
                value = _geometry_hex(value, 4326 if name == "geometry" else metric_srid(row, version))
            elif kind == "float" and value is not None:
                value = float(value)
                if value == 0:
                    value = 0.0
            values.append(value)
        if version == 3 and table == "features":
            from shapely import from_wkt
            from .utm import geography_eligible
            geom = from_wkt(row["geometry"]) if row["geometry"] is not None else None
            values.append(_geometry_hex(row["geometry"], 4326) if geography_eligible(geom) else None)
        yield values


def _verify_database(conn, config, root, manifest):
    from psycopg import sql
    schema = config["schema"]
    version = manifest["version"]
    tables = tables_for(version)
    identity = conn.execute(sql.SQL("SELECT fingerprint FROM {}.dataset_identity").format(sql.Identifier(schema))).fetchall()
    if identity != [(manifest["fingerprint"],)]:
        raise ImportValidationError("Database snapshot identity mismatch")
    result = {}
    with tempfile.TemporaryDirectory(prefix=".db-verify-", dir=root) as temporary:
        with sqlite3.connect(str(Path(temporary) / "keys.sqlite")) as keys:
            keys.execute("PRAGMA cache_size=-8192")
            keys.execute("CREATE TABLE features (relation TEXT, id TEXT, seen INTEGER DEFAULT 0, PRIMARY KEY(relation,id)) WITHOUT ROWID")
            keys.executemany("INSERT INTO features(relation,id) VALUES (?,?)",
                             ((r["relation"], r["id"]) for r in rows(root, "features")))
            for table, columns in tables.items():
                if version == 3 and table == "features":
                    columns = [*columns, ("geometry_geog", "str")]
                expressions = []
                for name, _ in columns:
                    expr = sql.Identifier(name)
                    if name == "geometry_geog":
                        expr = sql.SQL("encode(ST_AsEWKB(geometry_geog::geometry, 'NDR'), 'hex')")
                    elif name in {"geometry", "geometry_m"}:
                        expr = sql.SQL("encode(ST_AsEWKB({}, 'NDR'), 'hex')").format(expr)
                    expressions.append(expr)
                query = sql.SQL("SELECT {} FROM {}.{}").format(sql.SQL(",").join(expressions), sql.Identifier(schema), sql.Identifier(table))

                def actual():
                    # A named cursor streams at the server, unlike fetchmany on
                    # an ordinary psycopg cursor (which buffers the full result).
                    with conn.cursor(name=f"verify_{table}") as cursor:
                        cursor.itersize = BATCH_SIZE
                        cursor.execute(query)
                        for index, record in enumerate(cursor):
                            if index % BATCH_SIZE == 0:
                                snapshot_budget(root)
                            if table == "features":
                                matched = keys.execute("UPDATE features SET seen=1 WHERE relation=? AND id=? AND seen=0", record[:2]).rowcount
                                if matched != 1:
                                    raise ImportValidationError("Unexpected or duplicate database feature key")
                            yield [0.0 if kind == "float" and value == 0 else value
                                   for value, (_, kind) in zip(record, columns)]

                expected = _checksum(_expected(root, table, version))
                loaded = _checksum(actual())
                if expected != loaded:
                    raise ImportValidationError(f"Database content or geometry differs: {table}")
                result[table] = loaded
            if keys.execute("SELECT 1 FROM features WHERE seen=0 LIMIT 1").fetchone():
                raise ImportValidationError("Missing database feature key")
    emit("verified", fingerprint=manifest["fingerprint"], rows={k: v["rows"] for k, v in result.items()})
    return {"fingerprint": manifest["fingerprint"], "tables": result,
            "snapshot_version": version,
            "verification": "complete feature keys, all scalar/JSON fields, child multiplicity and EWKB including per-row SRID and generated geography" if version == 3 else "complete feature keys, scalar/JSON fields, child multiplicity and legacy EWKB"}


def verify(dataset, connections):
    from psycopg import IsolationLevel
    root = Path(dataset)
    manifest = verify_snapshot(root)
    config = read_connections(connections)
    with connection(config) as conn:
        # SET TRANSACTION must precede the first query; connection() has already
        # performed preflight, so start a separate repeatable, read-only transaction.
        conn.commit()
        conn.isolation_level = IsolationLevel.REPEATABLE_READ
        conn.read_only = True
        conn.execute("SELECT set_config('statement_timeout', %s, true)", (str(int(config.get("statement_timeout_seconds", 3600) * 1000)),))
        conn.execute("SELECT set_config('lock_timeout', '5000', true)")
        return _verify_database(conn, config, root, manifest)


def load(dataset, connections):
    """Create and publish one fresh schema atomically, including verification."""
    from psycopg import sql
    root = Path(dataset)
    manifest = verify_snapshot(root)
    config = read_connections(connections)
    schema = config["schema"]
    version = manifest["version"]
    tables = tables_for(version)
    started = time.monotonic()
    timings = {}
    with connection(config) as conn:
        conn.execute(sql.SQL("CREATE SCHEMA {}").format(sql.Identifier(schema)))
        types = {"str": "TEXT", "float": "DOUBLE PRECISION", "int": "BIGINT", "bool": "BOOLEAN"}
        for table, columns in tables.items():
            before = time.monotonic()
            declarations = []
            for name, kind in columns:
                datatype = types[kind]
                if name in {"geometry", "geometry_m"}:
                    datatype = "geometry(Geometry,4326)" if name == "geometry" else ("geometry(Geometry,2039)" if version == 2 else "geometry(Geometry)")
                if name == "geometry_m_srid":
                    datatype = "INTEGER"
                if name in {"relation", "id", "ordinal", "metric_status"}:
                    datatype += " NOT NULL"
                declarations.append(sql.SQL("{} {}").format(sql.Identifier(name), sql.SQL(datatype)))
            if version == 3 and table == "features":
                declarations.extend(sql.SQL(part) for part in UTM_DECLARATIONS)
            target = sql.Identifier(schema, table)
            conn.execute(sql.SQL("CREATE TABLE {} ({})").format(target, sql.SQL(",").join(declarations)))
            names = sql.SQL(",").join(sql.Identifier(n) for n, _ in columns)
            with conn.cursor() as cursor:
                with cursor.copy(sql.SQL("COPY {} ({}) FROM STDIN").format(target, names)) as copy:
                    for index, row in enumerate(rows(root, table), 1):
                        if index % BATCH_SIZE == 0:
                            snapshot_budget(root)
                        values = []
                        for name, _ in columns:
                            value = row[name]
                            if name in {"geometry", "geometry_m"} and value is not None:
                                value = f"SRID={4326 if name == 'geometry' else metric_srid(row, version)};" + value
                            values.append(value)
                        copy.write_row(values)
                        if index % (BATCH_SIZE * 16) == 0:
                            emit("copy_progress", table=table, rows=index)
            timings[table] = time.monotonic() - before
            emit("copied", table=table, rows=manifest["tables"][table]["rows"])
        index_started = time.monotonic()
        conn.execute(sql.SQL("CREATE UNIQUE INDEX ON {} (relation,id)").format(sql.Identifier(schema, "features")))
        for table in ("names", "addresses", "categories", "links"):
            conn.execute(sql.SQL("CREATE INDEX ON {} (relation,id)").format(sql.Identifier(schema, table)))
        if version == 3:
            conn.execute(sql.SQL("CREATE INDEX ON {} (geometry_m_srid)").format(sql.Identifier(schema, "features")))
        for column in (("geometry", "geometry_m", "geometry_geog") if version == 3 else ("geometry", "geometry_m")):
            conn.execute(sql.SQL("CREATE INDEX ON {} USING GIST ({})").format(sql.Identifier(schema, "features"), sql.Identifier(column)))
        for table, column in (("names", "normalized"), ("addresses", "city"), ("categories", "category")):
            conn.execute(sql.SQL("CREATE INDEX ON {} ({})").format(sql.Identifier(schema, table), sql.Identifier(column)))
        for relation in manifest["relations"]:
            identifier(relation)
            conn.execute(sql.SQL("CREATE VIEW {} AS SELECT * FROM {} WHERE relation={}").format(
                sql.Identifier(schema, relation), sql.Identifier(schema, "features"), sql.Literal(relation)))
        conn.execute(sql.SQL("CREATE TABLE {} (fingerprint VARCHAR(128) NOT NULL)").format(sql.Identifier(schema, "dataset_identity")))
        conn.execute(sql.SQL("INSERT INTO {} VALUES (%s)").format(sql.Identifier(schema, "dataset_identity")), (manifest["fingerprint"],))
        for table in tables:
            conn.execute(sql.SQL("ANALYZE {}").format(sql.Identifier(schema, table)))
        verification = _verify_database(conn, config, root, manifest)
        index_seconds = time.monotonic() - index_started
        # Recheck the immutable files before publication, including concurrent edits.
        current = verify_snapshot(root)
        if current["fingerprint"] != manifest["fingerprint"]:
            raise ImportValidationError("Snapshot changed during database loading")
    # connection() commits only when every preceding step has completed.
    result = {"schema": schema, "snapshot_version": version, "fingerprint": manifest["fingerprint"], "copy_seconds": timings,
              "index_and_verify_seconds": index_seconds, "load_seconds": time.monotonic() - started,
              "verification": verification}
    emit("committed", schema=schema, fingerprint=manifest["fingerprint"])
    return result
