"""Sedona fixtures for complete water selection, map guards, and exact exports."""

import argparse
from dataclasses import replace
import json
import os
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from overture_lab.config import load_settings
from overture_lab.outputs import write_single_geoparquet
from overture_lab.spark import create_sedona
from overture_lab.water_transportation import (
    select_world_water_transportation, validate_water_transportation,
    water_transportation_display_frame, water_transportation_map,
)


def expect_failure(action, message):
    try:
        action()
    except ValueError as error:
        assert message in str(error), error
    else:
        raise AssertionError(f"Expected {message!r}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    for key, value in {
        "MEDIUM_STATE_CODES": '["AA"]',
        "SMALL_CITIES": '[{"name":"Fixture City","state_code":"AA"}]',
        "MEDIUM_SAMPLE_LIMIT": "20", "SMALL_SAMPLE_LIMIT": "10", "MAP_FEATURE_LIMIT": "5",
    }.items():
        os.environ.setdefault(key, value)
    settings = replace(load_settings(), write_derived=True, derived_output_mode="local",
                       derived_local_fallback_dir=str(args.output / "exports"))
    spark = create_sedona(settings, "water-transportation-fixtures")
    from pyspark.sql import functions as F
    try:
        # Far-apart rows and a duplicate make regional filtering, sampling, and
        # unintended deduplication observable. The dateline edge must stay intact
        # in the export while the browser wraps its display path.
        rows = [
            ("europe", "water", "Ferry", "LINESTRING (5 44, 6 43, 8 40)"),
            ("pacific", "water", None, "LINESTRING (179 -16, -179 -16)"),
            ("america", "water", "River crossing", "MULTILINESTRING ((-75 40, -74 41), (-74 41, -73 42))"),
            ("europe", "water", "Ferry", "LINESTRING (5 44, 6 43, 8 40)"),
            ("road", "road", "Road", "LINESTRING (5 44, 6 43)"),
            ("rail", "rail", "Rail", "LINESTRING (5 44, 6 43)"),
            ("unknown", None, "Unknown", "LINESTRING (5 44, 6 43)"),
        ]
        segments = spark.createDataFrame(rows, "id string, subtype string, name string, wkt string").selectExpr(
            "id", "subtype", "ST_SetSRID(ST_GeomFromWKT(wkt), 4326) AS geometry",
            "named_struct('primary', name) AS names",
            "array(named_struct('dataset', 'fixture', 'record_id', id)) AS sources",
            "array(named_struct('connector_id', concat(id, '-start'), 'at', 0.0D), "
            "named_struct('connector_id', concat(id, '-end'), 'at', 1.0D)) AS connectors",
            "'transportation' AS theme", "'segment' AS feature_type",
        )
        for name in ("names", "sources", "connectors"):
            segments = segments.withColumn(name, F.from_json(F.to_json(name), segments.schema[name].dataType))
        water = select_world_water_transportation(segments).cache()
        report = validate_water_transportation(water)
        assert report == {"features": 4, "distinct_ids": 3, "coordinates": 12, "invalid_features": 0}, report
        assert water.columns == [c for c in segments.columns if c not in ("theme", "feature_type")]
        result = write_single_geoparquet(water, spark, settings,
            dataset_name="world-water-transportation", object_name="world_water_transportation.geoparquet")
        restored = spark.read.format("geoparquet").load(result.geoparquet_uri)
        columns = [F.expr("ST_AsBinary(geometry)").alias("wkb"),
                   F.to_json(F.struct(*[F.col(c) for c in water.columns if c != "geometry"])).alias("attributes")]
        before, after = water.select(*columns), restored.select(*columns)
        assert before.exceptAll(after).count() == after.exceptAll(before).count() == 0
        assert validate_water_transportation(restored) == report
        for kwargs, message in (
            ({"feature_limit": 3}, "MAP_FEATURE_LIMIT"),
            ({"coordinate_limit": 11}, "MAP_COORDINATE_LIMIT"),
            ({"feature_limit": True}, "positive integer"),
            ({"coordinate_limit": 0}, "positive integer"),
            ({"tolerance": float("nan")}, "finite"),
            ({"tolerance": -1}, "nonnegative"),
        ):
            expect_failure(lambda: water_transportation_display_frame(water, **kwargs), message)
        expect_failure(lambda: validate_water_transportation(water.limit(0)), "No water transportation")
        for expression in ("NULL", "ST_GeomFromWKT('LINESTRING EMPTY')",
                           "ST_GeomFromWKT('POINT (0 0)')", "ST_GeomFromWKT('LINESTRING (181 0, 182 0)')",
                           "ST_GeomFromWKT('LINESTRING (0 91, 1 92)')"):
            expect_failure(lambda: validate_water_transportation(water.withColumn(
                "geometry", F.expr(f"ST_SetSRID({expression}, 4326)"))), "Invalid water")
        expect_failure(lambda: validate_water_transportation(water.withColumn(
            "geometry", F.expr("ST_SetSRID(geometry, 3857)"))), "Invalid water")
        expect_failure(lambda: validate_water_transportation(water.withColumn("id", F.lit(None))), "Invalid water")
        expect_failure(lambda: validate_water_transportation(water.withColumn("subtype", F.lit("road"))), "Invalid water")
        frame = water_transportation_display_frame(water, feature_limit=4, coordinate_limit=12)
        assert len(frame) == 4 and set(frame.source_id) == {"europe", "pacific", "america"}
        assert frame.loc[frame.source_id == "pacific", "name"].iloc[0] == "Unnamed water segment"
        assert list(frame.loc[frame.source_id == "pacific"].geometry.iloc[0].coords) == [(179, -16), (-179, -16)]
        minimal = water_transportation_display_frame(water.drop("names"), feature_limit=4)
        assert set(minimal.name) == {"Unnamed water segment"}
        dense = water.withColumn("geometry", F.expr(
            "ST_SetSRID(ST_GeomFromWKT('LINESTRING (0 0, 0.0001 0.00001, 0.0002 0, 1 0)'), 4326)"))
        simplified = water_transportation_display_frame(dense, feature_limit=4, tolerance=0.001)
        assert len(simplified) == 4 and all(len(g.coords) == 2 for g in simplified.geometry)
        assert validate_water_transportation(dense)["coordinates"] == 16
        deck, controls = water_transportation_map(frame)
        document = json.loads(deck.to_json())
        layer = document["layers"][0]
        assert layer["wrapLongitude"] is True and layer["pickable"] is True
        assert len(layer["data"]["features"]) == 4
        assert document.get("mapStyle") is None
        from overture_lab.visualize import _offline_deck_document
        (args.output / "map-01.html").write_text(_offline_deck_document(deck, controls=controls))
        (args.output / "report.json").write_text(json.dumps({
            "status": "passed", "selection": report, "export": result.as_dict(),
            "exact_round_trip": True, "display_budget_checks": "passed",
            "invalid_geometry_checks": "passed", "mapped_features": len(frame),
        }, indent=2))
        print("PASS: global subtype selection, duplicate preservation, nested fields and exact WKB round trip, "
              "empty/invalid/CRS checks, both map budgets, names, and dateline display configuration")
    finally:
        spark.stop()


if __name__ == "__main__":
    main()
