"""Generated-data land/water coverage and local/S3 export regression checks."""
from dataclasses import replace
import argparse
import json
import os
from pathlib import Path
import sys
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
from overture_lab.config import load_settings
from overture_lab.spark import create_sedona
from overture_lab.regions import Bounds
from overture_lab.land_water import LandWaterOptions, build_land_water, clip_land_water, export_land_water, validate_land_water
from check_surfaces_spark import fixture, expect_failure


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--s3", action="store_true")
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    for key, value in {"MEDIUM_STATE_CODES": '["AA"]', "SMALL_CITIES": '[{"name":"Fixture City","state_code":"AA"}]',
                       "MEDIUM_SAMPLE_LIMIT": "20", "SMALL_SAMPLE_LIMIT": "10", "MAP_FEATURE_LIMIT": "5"}.items():
        os.environ.setdefault(key, value)
    settings = replace(load_settings(), write_derived=True, derived_output_mode="s3" if args.s3 else "local",
                       derived_local_fallback_dir=str(args.output / "exports"))
    spark = create_sedona(settings, "land-water-integration", overlay_ng=True)
    for key in ("jts.overlay", "jts.relate"):
        assert spark._jvm.java.lang.System.getProperty(key) == "ng", key
    from pyspark.sql import functions as F
    import shapely
    from shapely.geometry import box
    from shapely.ops import unary_union
    frames = []
    try:
        land = fixture(spark, [
            ("mainland", "land", "land", "POLYGON ((0 0, 2.5 0, 2.5 2, 0 2, 0 0))"),
            ("east", "land", "land", "POLYGON ((179 88, 180 88, 180 90, 179 90, 179 88))"),
            ("west", "land", "land", "POLYGON ((-180 88, -179 88, -179 90, -180 90, -180 88))"),
            ("peak", "physical", "peak", "POINT (1 1)"),
        ])
        water = fixture(spark, [
            ("ocean", "ocean", "ocean", "POLYGON ((2.5 0, 4 0, 4 2, 2.5 2, 2.5 0))"),
            ("lake", "lake", "lake", "POLYGON ((0.2 0.2, 0.9 0.2, 0.9 0.9, 0.2 0.9, 0.2 0.2), (0.4 0.4, 0.4 0.6, 0.6 0.6, 0.6 0.4, 0.4 0.4))"),
            ("river", "river", "river", "POLYGON ((1.8 0, 2.2 0, 2.2 2, 1.8 2, 1.8 0))"),
            ("overlap", "water", "water", "POLYGON ((0.7 0.7, 1 0.7, 1 1, 0.7 1, 0.7 0.7))"),
            ("pool", "human_made", "swimming_pool", "POLYGON ((1.2 1.2, 1.3 1.2, 1.3 1.3, 1.2 1.3, 1.2 1.2))"),
            ("seasonal", "pond", "pond", "POLYGON ((1.4 1.4, 1.5 1.4, 1.5 1.5, 1.4 1.5, 1.4 1.4))"),
            ("line", "river", "river", "LINESTRING (1.1 0, 1.1 2)"),
            ("point", "spring", "spring", "POINT (1.1 1)"),
            ("label", "physical", "sea", "POLYGON ((0 0, 4 0, 4 2, 0 2, 0 0))"),
        ]).withColumn("is_intermittent", F.col("id") == "seasonal")
        world, report = build_land_water(land, water, release="fixture", release_uri="generated")
        frames.append(world)
        for x, y, expected in ((0.3, 0.3, "water"), (0.5, 0.5, "land"), (1.9, 1, "water"),
                               (2.1, 1, "water"), (0.8, 0.8, "water"), (1.25, 1.25, "water"),
                               (1.45, 1.45, "water"), (1.1, 1, "land"), (3, 1, "water")):
            rows = world.where(F.expr(f"ST_Contains(geometry, ST_Point({x}, {y}))")).select("surface").collect()
            assert [r.surface for r in rows] == [expected], (x, y, rows)
        def union(frame):
            return unary_union([shapely.from_wkb(bytes(r.wkb)) for r in frame.selectExpr("ST_AsBinary(geometry) AS wkb").collect()])
        expected_water = union(water.where("subtype <> 'physical' AND ST_GeometryType(geometry) IN ('ST_Polygon', 'ST_MultiPolygon')"))
        expected_land = union(land.where("subtype = 'land' AND class = 'land'"))
        actual_water, actual_land = union(world.where("surface='water'")), union(world.where("surface='land'"))
        assert actual_water.symmetric_difference(expected_water).area < 1e-12
        assert actual_land.symmetric_difference(expected_land.difference(expected_water)).area < 1e-12
        assert actual_water.intersection(actual_land).area < 1e-12
        assert union(world).symmetric_difference(expected_land.union(expected_water)).area < 1e-12
        assert world.groupBy("tile_id", "surface").count().where("count > 1").count() == 0
        assert "source_id" not in world.columns
        assert world.selectExpr("sources[0].dataset AS dataset").distinct().first().dataset == "synthetic"
        assert sum(r["line_rows"] for r in report["water_classifications"]) == 1
        assert sum(r["point_rows"] for r in report["water_classifications"]) == 1
        region = clip_land_water(world, Bounds(0.1, 0.1, 2.1, 1.9)).cache()
        frames.append(region)
        assert union(region).symmetric_difference(union(world).intersection(box(0.1, 0.1, 2.1, 1.9))).area < 1e-12
        assert region.where("geometry_policy LIKE '%inland_water_within_landmass%'").count() == 0
        assert clip_land_water(world, Bounds(4, 0, 5, 2)).count() == 0  # boundary-only contact
        assert validate_land_water(region)
        for bad in (world.withColumn("bbox", F.expr("named_struct('xmin', 0D, 'xmax', 0D, 'ymin', 0D, 'ymax', 0D)")),
                    world.withColumn("surface", F.lit("ocean"))):
            expect_failure(lambda: validate_land_water(bad), "Invalid land/water")
        invalid = water.withColumn("geometry", F.expr("ST_SetSRID(ST_GeomFromWKT('POLYGON ((0 0, 1 1, 0 1, 1 0, 0 0))'), 4326)"))
        expect_failure(lambda: build_land_water(land, invalid, release="fixture", release_uri="generated"), "Invalid land/water source")
        expect_failure(lambda: build_land_water(land, water, release="fixture", release_uri="generated",
                                                options=LandWaterOptions(max_tile_coordinates=1)), "coordinate guard")
        empty, empty_report = build_land_water(land.limit(0), water.limit(0), release="fixture", release_uri="generated")
        frames.append(empty)
        assert empty.count() == 0 and empty_report["coverage"]["occupied_tiles"] == 0
        for kind, l, w in (("land", land, water.limit(0)), ("water", land.limit(0), water)):
            frame, _ = build_land_water(l, w, release="fixture", release_uri="generated")
            frames.append(frame)
            assert {r.surface for r in frame.select("surface").distinct().collect()} == {kind}
        with patch("overture_lab.outputs._promote_single_part") as promotion:
            assert export_land_water(world, spark, replace(settings, write_derived=False), scope="world")["status"] == "dry-run"
            promotion.assert_not_called()
        for scope, frame in (("world", world), ("regional", region)):
            report[scope + "_export"] = export_land_water(frame, spark, settings, scope=scope)
        report["empty_export"] = export_land_water(empty, spark, settings, scope="regional")
        fake_s3 = replace(settings, derived_output_mode="s3", derived_output_uri="s3a://fixture/output", allow_local_derived_fallback=True)
        with patch("overture_lab.outputs._s3_permission_probe", return_value=False), patch("overture_lab.outputs._promote_single_part") as promotion:
            expect_failure(lambda: export_land_water(world, spark, fake_s3, scope="world"), "denied")
            promotion.assert_not_called()
        with patch("overture_lab.outputs._s3_permission_probe", return_value=True), patch("overture_lab.outputs._promote_single_part", side_effect=OSError("injected interruption")):
            expect_failure(lambda: export_land_water(world, spark, fake_s3, scope="world"), "partial prefix")
        report.update(status="passed", checks=["lake_island", "polygon_river", "line_and_point_exclusion", "physical_label_exclusion",
                     "pool", "intermittent", "water_overlap", "tile_seam", "dateline_poles", "footprint", "regional_clip", "attribution",
                     "empty", "single_class", "invalid_source", "invalid_mask", "coordinate_guard", "local_or_s3_roundtrip", "disabled", "write_failure"])
        (args.output / "land-water-report.json").write_text(json.dumps(report, indent=2) + "\n")
        print(json.dumps(report, indent=2), flush=True)
    finally:
        for frame in frames:
            frame.unpersist()
        spark.stop()


if __name__ == "__main__":
    main()
