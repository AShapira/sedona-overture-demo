"""Local/S3 offline bundle, exact GeoParquet, map coverage, and audit integration."""

import argparse
from dataclasses import replace
import json
import os
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from test_flight_routes import fixture_bundle
from overture_lab.config import load_settings
from overture_lab.flight_routes import (
    build_flight_records, flight_dataframe, flight_display_frame, flight_routes_map,
    read_flight_bundle, validate_flight_routes, write_flight_audit,
)
from overture_lab.outputs import write_single_geoparquet
from overture_lab.spark import create_sedona


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--s3", action="store_true")
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    for key, value in {
        "MEDIUM_STATE_CODES": '["AA"]', "SMALL_CITIES": '[{"name":"Fixture City","state_code":"AA"}]',
        "MEDIUM_SAMPLE_LIMIT": "20", "SMALL_SAMPLE_LIMIT": "10", "MAP_FEATURE_LIMIT": "5",
    }.items():
        os.environ.setdefault(key, value)
    manifest, contents = fixture_bundle()
    folder = args.output / "source"
    folder.mkdir(exist_ok=True)
    (folder / "manifest.json").write_text(json.dumps(manifest))
    for name, content in contents.items():
        (folder / name).write_bytes(content)
    source_uri = str(folder)
    if args.s3:
        from pyarrow import fs
        client = fs.S3FileSystem(access_key="flightfixture", secret_key="flightfixturesecret",
            endpoint_override="minio:9000", scheme="http", region="us-east-1", allow_bucket_creation=True)
        client.create_dir("flight-test")
        for item in folder.iterdir():
            with client.open_output_stream(f"flight-test/source/{item.name}") as stream:
                stream.write(item.read_bytes())
        source_uri = "s3a://flight-test/source"
    # S3 source must configure credentials even with LOCAL Overture and output.
    settings = replace(load_settings(), release_uri="/tmp/no-overture-needed", write_derived=True,
                       derived_output_mode="local", derived_output_uri=None,
                       derived_local_fallback_dir=str(args.output / "exports"))
    spark = create_sedona(settings, "flight-route-fixtures", input_uris=(source_uri,))
    from pyspark.sql import functions as F
    try:
        loaded_manifest, tables = read_flight_bundle(spark, source_uri)
        assert loaded_manifest == manifest
        try:
            read_flight_bundle(spark, f"{source_uri}/missing")
        except FileNotFoundError as error:
            assert "OPEN-NETWORK" in str(error)
        else:
            raise AssertionError("Missing offline bundle was accepted")
        records, excluded, quality = build_flight_records(tables, loaded_manifest)
        routes = flight_dataframe(spark, records).cache()
        validation = validate_flight_routes(routes)
        assert validation["features"] == 5 and validation["invalid_features"] == 0
        frame = flight_display_frame(routes)
        assert len(frame) == 2 and int(frame.route_records.sum()) == 5
        assert set(frame.source_id) == {"1→2", "2→1"}
        for limits in ({"feature_limit": 1}, {"coordinate_limit": 1}):
            try:
                flight_display_frame(routes, **limits)
            except ValueError as error:
                assert "no routes were sampled" in str(error)
            else:
                raise AssertionError("Display budget did not stop collection")
        if args.s3:
            settings = replace(settings, derived_output_mode="s3", derived_output_uri="s3a://flight-test/derived")
        result = write_single_geoparquet(routes, spark, settings,
                                        dataset_name="world-flight-routes", object_name="world_flight_routes.geoparquet")
        audits = write_flight_audit(spark, result.run_prefix, manifest, quality, excluded)
        restored = spark.read.format("geoparquet").load(result.geoparquet_uri)
        columns = [F.expr("ST_AsBinary(geometry)").alias("wkb"),
                   F.to_json(F.struct(*[F.col(c) for c in routes.columns if c != "geometry"]),
                             options={"ignoreNullFields": "false"}).alias("attributes")]
        before, after = routes.select(*columns), restored.select(*columns)
        assert before.exceptAll(after).count() == after.exceptAll(before).count() == 0
        assert validate_flight_routes(restored) == validation
        saved_exclusions = spark.read.option("header", True).csv(audits["excluded-routes.csv"])
        assert saved_exclusions.count() == len(excluded)
        assert {int(row.source_row) for row in saved_exclusions.select("source_row").collect()} == {row["source_row"] for row in excluded}
        saved_quality = spark.read.option("multiLine", True).json(audits["route-quality.json"]).first()
        assert saved_quality.input_route_rows == saved_quality.exported_route_rows + saved_quality.excluded_route_rows == 11
        deck, controls = flight_routes_map(frame)
        layer = json.loads(deck.to_json())["layers"][0]
        assert layer["id"] == "world-flight-routes" and layer["pickable"] and layer["wrapLongitude"]
        from overture_lab.visualize import _offline_deck_document
        (args.output / "map-01.html").write_text(_offline_deck_document(deck, controls=controls))
        (args.output / "report.json").write_text(json.dumps({
            "status": "passed", "mode": "s3" if args.s3 else "local", "geometry": validation,
            "quality": quality, "map_pairs": len(frame), "represented_records": int(frame.route_records.sum()),
            "export": result.as_dict(), "audit": audits, "exact_attribute_geometry_round_trip": True,
        }, indent=2))
        print("PASS: offline source integrity, endpoint audit, full map pair coverage, exact export and audit round trip")
    finally:
        spark.stop()


if __name__ == "__main__":
    main()
