"""Bounded snapshot preparation and validation, without a database connection."""
from __future__ import annotations

from contextlib import contextmanager
import hashlib
import importlib.metadata
import json
import os
from pathlib import Path
import shutil
import sqlite3
import tempfile
import threading
import time
import uuid

from .contract import (BATCH_SIZE, TABLES, VERSION, tables_for, arrow_schema, digest,
                       identifier, normalize_partition, validate_bbox, ImportValidationError, ImportResourceError)

from .utm import METRIC_CRS, UTM_POLICY, bbox_utm_srids, validate_metric_row


def sha256(path):
    checksum = hashlib.sha256()
    with Path(path).open("rb") as stream:
        for chunk in iter(lambda: stream.read(1024 * 1024), b""):
            checksum.update(chunk)
    return checksum.hexdigest()


def emit(event, **values):
    print(json.dumps({"event": event, **values}, ensure_ascii=False), flush=True)


def rows(root, table):
    import pyarrow.parquet as pq
    for batch in pq.ParquetFile(Path(root) / f"{table}.parquet").iter_batches(batch_size=BATCH_SIZE):
        yield from batch.to_pylist()


def check_budget(settings, extra_roots=()):
    """Soft watchdog, including Spark spill and retained snapshots, not a quota."""
    from ..scratch import _tree_bytes
    roots = sorted({Path(settings.scratch_dir).resolve(), Path(settings.spark_local_dir).resolve(),
                    *(Path(root).resolve() for root in extra_roots)}, key=lambda p: len(p.parts))
    distinct = []
    for root in roots:
        root.mkdir(parents=True, exist_ok=True)
        if not any(root.is_relative_to(parent) for parent in distinct):
            distinct.append(root)
    used = sum(_tree_bytes(root) for root in distinct)
    if used > (settings.scratch_budget_gb - settings.scratch_reserve_gb) * 1024**3:
        raise ImportResourceError("Import scratch budget exceeded; retain evidence and clean explicitly")
    if any(shutil.disk_usage(root).free < settings.scratch_reserve_gb * 1024**3 for root in distinct):
        raise ImportResourceError("Import scratch filesystem reserve exhausted")


def snapshot_budget(root):
    """Load/verify also enforce storage limits, without needing source settings."""
    from types import SimpleNamespace
    budget = int(os.getenv("SEDONA_SCRATCH_BUDGET_GB", "20"))
    reserve = int(os.getenv("SEDONA_SCRATCH_RESERVE_GB", "2"))
    if budget <= 0 or not 0 <= reserve < budget:
        raise ImportValidationError("Invalid snapshot scratch budget/reserve")
    settings = SimpleNamespace(scratch_dir=os.getenv("SEDONA_SCRATCH_DIR", str(root)),
        spark_local_dir=os.getenv("SEDONA_SPARK_LOCAL_DIR", str(root)),
        scratch_budget_gb=budget, scratch_reserve_gb=reserve)
    check_budget(settings, extra_roots=(root,))


@contextmanager
def budget_watch(spark, settings):
    check_budget(settings)
    stopped = threading.Event()
    errors = []
    group = "postgis-prepare-" + uuid.uuid4().hex
    spark.sparkContext.setJobGroup(group, "Prepare immutable PostGIS snapshot", interruptOnCancel=True)

    def watch():
        while not stopped.wait(1):
            try:
                check_budget(settings)
            except Exception as exc:
                errors.append(exc)
                spark.sparkContext.cancelJobGroup(group)
                return

    thread = threading.Thread(target=watch, daemon=True)
    thread.start()
    try:
        yield
        if errors:
            raise errors[0]
        check_budget(settings)
    finally:
        stopped.set()
        thread.join()
        spark.sparkContext.setLocalProperty("spark.jobGroup.id", None)
        spark.sparkContext.setLocalProperty("spark.job.description", None)
        spark.sparkContext.setLocalProperty("spark.job.interruptOnCancel", None)


def source_inventory(spark, settings, selected=None):
    """Fresh per-object identities; never trust the demo's aggregate cache."""
    import re
    pattern = re.compile(r"(?:^|/)theme=([a-z][a-z0-9_]*)/type=([a-z][a-z0-9_]*)/[^/]+\.parquet$")
    path = spark._jvm.org.apache.hadoop.fs.Path(settings.release_uri)
    filesystem = path.getFileSystem(spark._jsc.hadoopConfiguration())
    iterator = filesystem.listFiles(path, True)
    objects = []
    found = set()
    while iterator.hasNext():
        status = iterator.next()
        uri = status.getPath().toString()
        match = pattern.search(uri)
        if not match:
            continue
        theme, kind = match.groups()
        key = f"{theme}/{kind}"
        found.add(key)
        if selected is not None and key not in selected:
            continue
        item = {"uri": uri, "theme": theme, "type": kind,
                "bytes": int(status.getLen()), "mtime": int(status.getModificationTime())}
        if settings.storage_mode == "s3a":
            etag = status.getETag()
            if not etag:
                raise ImportValidationError("S3 source inventory requires per-object ETags")
            item["etag"] = str(etag)
        else:
            from urllib.parse import unquote, urlparse
            item["sha256"] = sha256(unquote(urlparse(uri).path))
        objects.append(item)
    if selected is not None and set(selected) - found:
        raise ImportValidationError("Requested feature types are missing from the source")
    if not objects:
        raise ImportValidationError("No selected Overture GeoParquet files found")
    return sorted(objects, key=lambda item: item["uri"])


def accumulate_metrics(row, srid_counts, status_counts):
    status = row["metric_status"]
    status_counts[status] = status_counts.get(status, 0) + 1
    if row["geometry_m"] is not None:
        key = str(row["geometry_m_srid"])
        srid_counts[key] = srid_counts.get(key, 0) + 1


def metric_summary(srid_counts, status_counts, crossing_count):
    return {"metric_srids_present": sorted(map(int, srid_counts)),
            "metric_srid_counts": dict(srid_counts), "metric_status_counts": dict(status_counts),
            "utm_crossing_features": crossing_count}


def verify_snapshot(root, *, manifest=None, budget=None):
    """Validate checksums, schemas, complete keys, and child joins using disk SQL."""
    import pyarrow.parquet as pq
    root = Path(root)
    budget = budget or (lambda: snapshot_budget(root))
    budget()
    manifest = manifest or json.loads((root / "manifest.json").read_text())
    version = manifest.get("version")
    tables = tables_for(version)
    if manifest.get("normalization_version") != version:
        raise ImportValidationError("Snapshot normalization version mismatch")
    if manifest.get("fingerprint") != digest({k: v for k, v in manifest.items() if k != "fingerprint"}):
        raise ImportValidationError("Snapshot manifest fingerprint mismatch")
    expected_metric_crs = "EPSG:2039" if version == 2 else METRIC_CRS
    if manifest.get("geometry_crs") != "EPSG:4326" or manifest.get("metric_geometry_crs") != expected_metric_crs:
        raise ImportValidationError("Snapshot geometry CRS mismatch")
    validate_bbox(manifest["bbox"])
    if version == 3 and (manifest.get("utm_policy") != UTM_POLICY
                         or manifest.get("bbox_utm_srids") != bbox_utm_srids(manifest["bbox"])):
        raise ImportValidationError("Snapshot UTM policy or bbox zone inventory mismatch")
    if set(manifest["tables"]) != set(tables):
        raise ImportValidationError("Snapshot must contain exactly the five normalized tables")
    for table, info in manifest["tables"].items():
        if info["file"] != f"{table}.parquet":
            raise ImportValidationError("Snapshot filenames must follow the normalized snapshot contract")
        file = root / info["file"]
        if file.is_symlink() or sha256(file) != info["sha256"]:
            raise ImportValidationError(f"Snapshot checksum mismatch: {table}")
        parquet = pq.ParquetFile(file)
        if not parquet.schema_arrow.equals(arrow_schema(table, version), check_metadata=False):
            raise ImportValidationError(f"Snapshot column schema mismatch: {table}")
        if parquet.metadata.num_rows != info["rows"]:
            raise ImportValidationError(f"Snapshot row count mismatch: {table}")
    # A disk-backed key index avoids loading millions of IDs into a Python set.
    with tempfile.TemporaryDirectory(prefix=".verify-", dir=root) as temporary:
        with sqlite3.connect(str(Path(temporary) / "keys.sqlite")) as db:
            db.execute("PRAGMA cache_size=-8192")
            db.execute("PRAGMA foreign_keys=ON")
            db.execute("CREATE TABLE features (relation TEXT NOT NULL, id TEXT NOT NULL, PRIMARY KEY(relation,id)) WITHOUT ROWID")
            counts, srid_counts, status_counts = {}, {}, {}
            crossing_count = 0
            try:
                for index, row in enumerate(rows(root, "features")):
                    identifier(row["relation"])
                    if version == 3:
                        validate_metric_row(row)
                        accumulate_metrics(row, srid_counts, status_counts)
                        crossing_count += row["utm_crosses_zone"] is True
                    if not row["id"]:
                        raise ImportValidationError("Empty feature ID")
                    db.execute("INSERT INTO features VALUES (?,?)", (row["relation"], row["id"]))
                    counts[row["relation"]] = counts.get(row["relation"], 0) + 1
                    if budget and index % BATCH_SIZE == 0:
                        budget()
                expected_counts = {k: v for k, v in manifest["relations"].items() if v}
                if counts != expected_counts:
                    raise ImportValidationError("Manifest relation counts mismatch")
                if version == 3:
                    expected = metric_summary(srid_counts, status_counts, crossing_count)
                    if any(manifest.get(k) != v for k, v in expected.items()):
                        raise ImportValidationError("Snapshot metric counts or SRID inventory mismatch")
                for table in tables:
                    if table == "features":
                        continue
                    db.execute("CREATE TABLE child (relation TEXT NOT NULL, id TEXT NOT NULL, ordinal INTEGER NOT NULL CHECK(ordinal>=0), PRIMARY KEY(relation,id,ordinal), FOREIGN KEY(relation,id) REFERENCES features) WITHOUT ROWID")
                    for index, row in enumerate(rows(root, table)):
                        db.execute("INSERT INTO child VALUES (?,?,?)", (row["relation"], row["id"], row["ordinal"]))
                        if budget and index % BATCH_SIZE == 0:
                            budget()
                    db.execute("DROP TABLE child")
            except sqlite3.IntegrityError as exc:
                raise ImportValidationError("Duplicate feature/child key, orphan child or invalid ordinal") from exc
    if budget:
        budget()
    return manifest


def prepare(spark, settings, dataset, bbox, *, schema_version, types=None, max_features=None):
    """Create a normalized-v3 UTM snapshot. Partial directories are not resumed."""
    import pyarrow as pa
    import pyarrow.parquet as pq
    from pyspark.sql import functions as F
    import re
    bbox = validate_bbox(bbox)
    if not re.fullmatch(r"v?\d+\.\d+\.\d+", schema_version):
        raise ImportValidationError("Supply the source release's official schema version, e.g. v1.18.0")
    if max_features is not None and max_features < 1:
        raise ImportValidationError("max_features must be positive")
    selected = None if types is None else set(types)
    if selected is not None and (not selected or any(not re.fullmatch(r"[a-z][a-z0-9_]*/[a-z][a-z0-9_]*", t) for t in selected)):
        raise ImportValidationError("Types must be theme/type values")
    root = Path(dataset).resolve()
    if not root.is_relative_to(Path(settings.scratch_dir).resolve()):
        raise ImportValidationError("Snapshot directory must be inside SEDONA_SCRATCH_DIR")
    if root.exists():
        raise FileExistsError("Snapshot directory exists; choose a fresh path")
    if importlib.metadata.version("apache-sedona") != "1.9.0":
        raise ImportValidationError("This importer requires the validated Sedona 1.9.0 runtime")
    started = time.monotonic()
    objects = source_inventory(spark, settings, selected)
    groups = {}
    for item in objects:
        groups.setdefault((item["theme"], item["type"]), []).append(item["uri"])
    root.mkdir(parents=True)
    counts = dict.fromkeys(TABLES, 0)
    relations, schemas = {}, {}
    total = 0
    unavailable = 0
    srid_counts, status_counts = {}, {}
    crossing_count = 0
    w, s, e, n = bbox
    envelope = F.expr(f"ST_PolygonFromEnvelope({w}, {s}, {e}, {n})")
    with budget_watch(spark, settings):
        for (theme, kind), files in groups.items():
            relation = identifier(f"{theme}_{kind}")
            source = (spark.read.format("geoparquet").option("mergeSchema", "true")
                      .option("basePath", settings.release_uri).load(files))
            if not {"id", "bbox", "geometry"}.issubset(source.columns):
                raise ImportValidationError(f"Missing required Overture fields: {relation}")
            schemas[relation] = source.schema.jsonValue()
            exact = F.expr("ST_Intersects(geometry, __import_region)")
            source_columns = list(source.columns)
            source = source.withColumn("__import_region", envelope)
            if relation != "divisions_division":
                source = source.filter((F.col("bbox.xmin") <= e) & (F.col("bbox.xmax") >= w)
                                       & (F.col("bbox.ymin") <= n) & (F.col("bbox.ymax") >= s)).filter(exact)
            count = source.limit(max_features + 1).count() if max_features else source.count()
            total += count
            if max_features and total > max_features:
                raise ImportValidationError("Notebook feature guard exceeded; narrow bbox/types or use the production CLI")
            relations[relation] = count
            payload = F.to_json(F.struct(*[F.col(f"`{c}`") for c in source_columns if c != "geometry"]), {"ignoreNullFields": "false"})
            projected = source.select(F.lit(relation).alias("relation"), F.col("id"),
                F.expr("ST_AsText(geometry)").alias("geometry"),
                F.expr("ST_X(ST_Centroid(geometry))").alias("longitude"),
                F.expr("ST_Y(ST_Centroid(geometry))").alias("latitude"),
                (~F.coalesce(exact, F.lit(False))).alias("reference_only"), payload.alias("raw_json"))
            # Spark owns task retries. Workers emit data only, never database writes.
            normalized = spark.createDataFrame(projected.rdd.mapPartitions(normalize_partition), "table_name string, payload string")
            temporary = root / "_parts" / relation
            normalized.write.mode("error").partitionBy("table_name").parquet(str(temporary))
            emit("selected", relation=relation, rows=count)
        # Consolidate with bounded Arrow batches: five ordinary Parquet files,
        # not a collect/coalesce(1) Spark bottleneck or a different manifest format.
        for table in TABLES:
            schema = arrow_schema(table)
            with pq.ParquetWriter(root / f"{table}.parquet", schema, compression="zstd") as writer:
                for part in sorted((root / "_parts").glob(f"*/table_name={table}/*.parquet")):
                    for batch in pq.ParquetFile(part).iter_batches(batch_size=BATCH_SIZE):
                        records = [json.loads(item) for item in batch.column("payload").to_pylist()]
                        writer.write_table(pa.Table.from_pylist(records, schema=schema))
                        counts[table] += len(records)
                        if table == "features":
                            unavailable += sum(row["geometry_m"] is None for row in records)
                            for row in records:
                                accumulate_metrics(row, srid_counts, status_counts)
                                crossing_count += row["utm_crosses_zone"] is True
                        check_budget(settings)
        if source_inventory(spark, settings, selected) != objects:
            raise ImportValidationError("Source objects changed during preparation")
        manifest = {"version": VERSION, "normalization_version": VERSION,
            "release": settings.release, "schema_version": schema_version,
            "bbox": bbox, "geometry_crs": "EPSG:4326", "metric_geometry_crs": METRIC_CRS,
            "utm_policy": UTM_POLICY, "bbox_utm_srids": bbox_utm_srids(bbox),
            **metric_summary(srid_counts, status_counts, crossing_count),
            "selection": "bbox prefilter then exact intersection; whole geometries retained; all selected division references retained",
            "source_fingerprint": digest({"release": settings.release, "schema_version": schema_version, "objects": objects, "schemas": schemas}),
            "source_objects": objects, "source_schemas": schemas, "relations": relations,
            "prepare_seconds": time.monotonic() - started, "unprojectable_features": unavailable,
            "producer": {"engine": "SedonaSpark", "sedona": "1.9.0", "spark": spark.version,
                         "metric_projection": "pyproj " + importlib.metadata.version("pyproj")},
            "tables": {table: {"file": f"{table}.parquet", "rows": counts[table],
                "bytes": (root / f"{table}.parquet").stat().st_size,
                "sha256": sha256(root / f"{table}.parquet"), "columns": TABLES[table]} for table in TABLES}}
        manifest["fingerprint"] = digest(manifest)
        verify_snapshot(root, manifest=manifest, budget=lambda: check_budget(settings))
        # Publish last. Retain intermediates: host-mounted files are never deleted
        # automatically. The operator can remove _parts after verification.
        with (root / "manifest.json").open("x", encoding="utf-8") as stream:
            stream.write(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n")
        emit("prepared", fingerprint=manifest["fingerprint"], rows=counts,
             **metric_summary(srid_counts, status_counts, crossing_count))
    return manifest
