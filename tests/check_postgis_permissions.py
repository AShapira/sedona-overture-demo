#!/usr/bin/env python3
"""Compatibility, projection oracle, and least-privilege disposable-DB checks."""
import argparse
import json
from pathlib import Path
import sys
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))


def main():
    import psycopg
    from psycopg import sql
    from overture_lab.postgis_import import load, verify
    from overture_lab.postgis_import.database import connection, read_connections, _verify_database
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--connections", type=Path, required=True)
    parser.add_argument("--guide-snapshot", type=Path, required=True)
    parser.add_argument("--s3-snapshot", type=Path, required=True)
    args = parser.parse_args()
    admin = read_connections(args.connections)
    with connection(admin) as conn:
        password = Path(admin["postgis"]["password_file"]).read_text().strip()
        for name in ("import_loader", "import_reader"):
            if not conn.execute("SELECT 1 FROM pg_roles WHERE rolname=%s", (name,)).fetchone():
                conn.execute(sql.SQL("CREATE ROLE {} LOGIN PASSWORD {}").format(sql.Identifier(name), sql.Literal(password)))
        conn.execute(sql.SQL("GRANT CREATE ON DATABASE {} TO import_loader").format(sql.Identifier(admin["postgis"]["dbname"])))
    loader = {**admin, "schema": "import_guide_compatible", "postgis": {**admin["postgis"], "user": "import_loader"}}
    def load_or_verify(snapshot, config):
        with connection(config) as conn:
            exists = conn.execute("SELECT 1 FROM pg_namespace WHERE nspname=%s", (config["schema"],)).fetchone()
        return verify(snapshot, config) if exists else load(snapshot, config)

    load_or_verify(args.guide_snapshot, loader)
    loader["schema"] = "import_s3_compatible"
    load_or_verify(args.s3_snapshot, loader)
    with connection(admin) as conn:
        conn.execute("GRANT USAGE ON SCHEMA import_s3_compatible TO import_reader")
        conn.execute("GRANT SELECT ON ALL TABLES IN SCHEMA import_s3_compatible TO import_reader")
        flags = conn.execute("SELECT rolsuper,rolcreaterole FROM pg_roles WHERE rolname='import_loader'").fetchone()
        assert flags == (False, False)
        metric_delta = conn.execute("SELECT max(ST_Distance(geometry_m, ST_Transform(geometry,geometry_m_srid))) FROM import_s3_compatible.features WHERE id IN ('p1','b1')").fetchone()[0]
        assert metric_delta < 0.00001, metric_delta
        print("Independent PostGIS UTM difference (metres):", metric_delta)
    reader = {**loader, "postgis": {**loader["postgis"], "user": "import_reader"}}

    def read_only_check(conn, *arguments):
        assert conn.execute("SHOW transaction_isolation").fetchone()[0] == "repeatable read"
        assert conn.execute("SHOW transaction_read_only").fetchone()[0] == "on"
        return _verify_database(conn, *arguments)

    with patch("overture_lab.postgis_import.database._verify_database", side_effect=read_only_check):
        verify(args.s3_snapshot, reader)
    try:
        with connection(reader) as conn:
            conn.execute("UPDATE import_s3_compatible.features SET name='not allowed'")
        raise AssertionError("Reader unexpectedly has write access")
    except psycopg.errors.InsufficientPrivilege:
        pass
    print("ORIGINAL SNAPSHOT, S3 LOAD, PROJECTION AND READER PERMISSIONS PASSED")


if __name__ == "__main__":
    main()
