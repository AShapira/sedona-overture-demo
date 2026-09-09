#!/usr/bin/env python3
"""Runtime acceptance in the pinned image; use only a disposable database.

python3 tests/check_postgis_import.py --root /work/check --connections ...
Optional --source s3a://fixture/release reuses an uploaded copy of the fixture.
"""
from __future__ import annotations

import argparse
import ast
from dataclasses import replace
import json
import os
from pathlib import Path
import sys
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))


def fixture(root):
    import pyarrow as pa
    import pyarrow.parquet as pq
    from shapely import from_wkt, to_wkb
    schema = pa.schema([
        ("id", pa.string()), ("geometry", pa.binary()),
        ("bbox", pa.struct([(k, pa.float64()) for k in ("xmin", "ymin", "xmax", "ymax")])),
        ("names", pa.struct([("primary", pa.string()), ("common", pa.map_(pa.string(), pa.string()))])),
        ("categories", pa.struct([("primary", pa.string()), ("alternate", pa.list_(pa.string()))])),
        ("addresses", pa.list_(pa.struct([(k, pa.string()) for k in ("street", "number", "locality", "postcode", "country")]))),
        ("connectors", pa.list_(pa.struct([("id", pa.string())]))),
        ("division_id", pa.string()), ("sources", pa.list_(pa.struct([("record_id", pa.string())]))),
        ("height", pa.float64()), ("num_floors", pa.int64()), ("class", pa.string()),
        ("subtype", pa.string()), ("street", pa.string()), ("number", pa.string()),
        ("postal_city", pa.string()), ("postcode", pa.string()), ("country", pa.string()),
    ], metadata={b"geo": json.dumps({"version": "1.1.0", "primary_column": "geometry",
                                    "columns": {"geometry": {"encoding": "WKB", "geometry_types": []}}}).encode()})
    data = {
        "places/place": [("p1", "POINT (34.78 31.98)"), ("p2", "POINT (34.76 31.96)"), ("outside", "POINT (35 32)")],
        "buildings/building": [("b1", "POLYGON ((34.75 31.95,34.79 31.95,34.79 31.99,34.75 31.99,34.75 31.95))"),
                               ("invalid", "POLYGON ((34.77 31.97,34.79 31.99,34.79 31.97,34.77 31.99,34.77 31.97))"),
                               ("global", "POLYGON ((-179 -89,179 -89,179 89,-179 89,-179 -89))")],
        "divisions/division": [("d1", "POINT (34.78 31.98)"), ("d2", "POINT (0 0)"), ("d3", None)],
        "addresses/address": [("a1", "POINT (34.78 31.98)")],
    }
    for relation, items in data.items():
        records = []
        for fid, wkt in items:
            geom = from_wkt(wkt) if wkt else None
            records.append({"id": fid, "geometry": to_wkb(geom) if geom is not None else None,
                "bbox": dict(zip(("xmin", "ymin", "xmax", "ymax"), geom.bounds)) if geom is not None else None,
                "names": {"primary": "Straße ראשון", "common": [("he", "ראשון לציון"), ("en", "Straße")]},
                "categories": {"primary": "shop", "alternate": ["shop", "cafe"]},
                "addresses": [{"street": "ראשון", "number": "7", "locality": "City"}] * 2,
                "connectors": [{"id": "c1"}, {"id": "c1"}], "division_id": "d1",
                "sources": [{"record_id": "ignored"}], "height": 12.5, "num_floors": 3,
                "class": "test", "postal_city": "Address City", "number": "11"})
        theme, kind = relation.split("/")
        leaf = root / f"theme={theme}" / f"type={kind}"
        leaf.mkdir(parents=True)
        pq.write_table(pa.Table.from_pylist(records, schema=schema), leaf / "part-0.parquet")


def configuration(root, source=None):
    from overture_lab.config import load_settings
    environment = {"MEDIUM_STATE_CODES": '["IL"]', "SMALL_CITIES": '[{"name":"Rishon LeZion","state_code":"IL"}]',
        "MEDIUM_SAMPLE_LIMIT": "100", "SMALL_SAMPLE_LIMIT": "100", "MAP_FEATURE_LIMIT": "10",
        "OVERTURE_RELEASE_URI": source or str(root / "source"), "OVERTURE_RELEASE": "fixture",
        "SEDONA_SPARK_LOCAL_CORES": "2", "SEDONA_SPARK_PARTITIONS": "2", "SEDONA_SPARK_DRIVER_MEMORY": "2g",
        "SEDONA_SPARK_LOCAL_DIR": str(root / "spark"), "SEDONA_SCRATCH_DIR": str(root),
        "SEDONA_SCRATCH_BUDGET_GB": "8", "SEDONA_SCRATCH_RESERVE_GB": "1",
        "DERIVED_LOCAL_FALLBACK_DIR": str(root / "derived"), "WRITE_DERIVED": "false"}
    os.environ.update(environment)
    return load_settings()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--connections", type=Path)
    parser.add_argument("--source")
    parser.add_argument("--reference", type=Path)
    parser.add_argument("--fixture-only", action="store_true")
    args = parser.parse_args()
    args.root.mkdir(parents=True, exist_ok=True)
    if not args.source:
        fixture(args.root / "source")
    if args.fixture_only:
        return
    from overture_lab.spark import create_sedona
    from overture_lab.postgis_import import prepare, verify_snapshot, load, verify
    from overture_lab.postgis_import.snapshot import rows, source_inventory
    from overture_lab.postgis_import.contract import normalize, TABLES, digest, arrow_schema
    settings = configuration(args.root, args.source)
    spark = create_sedona(settings, "postgis-import-acceptance")
    bbox = [34.76, 31.96, 34.80, 32.00]
    dataset = args.root / "snapshot"
    try:
        manifest = prepare(spark, settings, dataset, bbox, schema_version="v1.18.0")
        assert manifest["tables"]["features"]["rows"] == 9, manifest["relations"]
        features = {r["id"]: r for r in rows(dataset, "features")}
        assert features["d2"]["reference_only"] and features["d3"]["reference_only"]
        assert features["invalid"]["geometry_m"] is None
        assert "34.75" in features["b1"]["geometry"]  # whole geometry, not clipped
        assert features["p1"]["geometry_m"] is not None
        assert manifest["version"] == 3
        assert features["p1"]["geometry_m_srid"] == 32636
        assert features["global"]["metric_status"] == "outside_utm"
        assert features["d2"]["geometry_m_srid"] == 32631
        assert manifest["bbox_utm_srids"] == [32636]
        assert manifest["metric_srids_present"] == [32631, 32636]
        verify_snapshot(dataset)
        if args.reference:
            import re
            import unicodedata
            namespace = {"re": re, "json": json, "unicodedata": unicodedata, "TABLES": TABLES}
            tree = ast.parse(args.reference.read_text())
            tree.body = [node for node in tree.body if isinstance(node, ast.FunctionDef) and node.name in {"normalize", "normalized", "strings"}]
            exec(compile(tree, str(args.reference), "exec"), namespace)
            for row in features.values():
                assert normalize(row) == namespace["normalize"](dict(row))
        for label, options in (("guard", {"max_features": 1}),):
            try:
                prepare(spark, settings, args.root / label, bbox, schema_version="v1.18.0", **options)
                raise AssertionError("Expected notebook guard failure")
            except ValueError as exc:
                assert "guard" in str(exc)
                assert not (args.root / label / "manifest.json").exists()
        try:
            prepare(spark, replace(settings, scratch_budget_gb=1, scratch_reserve_gb=1), args.root / "no-space", bbox, schema_version="v1.18.0")
            raise AssertionError("Expected scratch budget failure")
        except RuntimeError:
            pass
        original = (dataset / "names.parquet").read_bytes()
        with (dataset / "names.parquet").open("ab") as stream:
            stream.write(b"corrupted")
        try:
            verify_snapshot(dataset)
            raise AssertionError("Expected checksum failure")
        except ValueError:
            pass
        (dataset / "names.parquet").write_bytes(original)
        if args.connections:
            import psycopg
            from psycopg import sql
            from overture_lab.postgis_import.database import connection, read_connections
            config = read_connections(args.connections)
            report = load(dataset, config)
            assert verify(dataset, config)["tables"] == report["verification"]["tables"]
            try:
                load(dataset, config)
                raise AssertionError("Expected existing schema failure")
            except psycopg.errors.DuplicateSchema:
                pass
            rollback = {**config, "schema": config["schema"] + "_rollback"}
            with patch("overture_lab.postgis_import.database._verify_database", side_effect=RuntimeError("Injected interruption")):
                try:
                    load(dataset, rollback)
                    raise AssertionError("Expected failure")
                except RuntimeError:
                    pass
            with connection(config) as conn:
                assert conn.execute("SELECT 1 FROM pg_namespace WHERE nspname=%s", (rollback["schema"],)).fetchone() is None
            load(dataset, rollback)
            with connection(config) as conn:
                indexes = conn.execute("SELECT count(*) FROM pg_indexes WHERE schemaname=%s", (config["schema"],)).fetchone()[0]
                assert indexes == 12, indexes
                conn.execute(sql.SQL("UPDATE {}.names SET name='tampered' WHERE ordinal=0").format(sql.Identifier(config["schema"])))
            try:
                verify(dataset, config)
                raise AssertionError("Expected database content failure")
            except ValueError:
                pass
            (args.root / "load-report.json").write_text(json.dumps(report, indent=2))
        print("POSTGIS IMPORT ACCEPTANCE PASSED", flush=True)
    finally:
        spark.stop()


if __name__ == "__main__":
    main()
