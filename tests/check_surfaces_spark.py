"""Run with the pinned Sedona image; retains a JSON report and local exports.

Use --s3 with configured S3 credentials to repeat the successful IO test on S3.
Permission denial and interrupted promotion are injected independently.
"""
from dataclasses import replace
import argparse
import json
import os
from pathlib import Path
import sys
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
from overture_lab.config import load_settings
from overture_lab.regions import Bounds
from overture_lab.spark import create_sedona
from overture_lab.surfaces import (
    clip_surfaces, coverage_report, display_surfaces, export_surfaces,
    geometry_bbox, select_world_surfaces, surface_grid, validate_surfaces,
)


def fixture(spark, rows):
    from pyspark.sql import functions as F
    return (spark.createDataFrame(rows, "id string, subtype string, class string, wkt string")
            .withColumn("geometry", F.expr("ST_SetSRID(ST_GeomFromWKT(wkt), 4326)"))
            .withColumn("bbox", geometry_bbox()).withColumn("version", F.lit(1))
            .withColumn("sources", F.from_json(
                F.to_json(F.expr("array(named_struct('dataset', 'synthetic', 'record_id', id))")),
                "array<struct<dataset:string,record_id:string>>"))
            .drop("wkt"))


def expect_failure(call, message):
    try:
        call()
    except (ValueError, RuntimeError) as exc:
        assert message in str(exc), str(exc)
    else:
        raise AssertionError(f"Expected failure containing {message!r}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--s3", action="store_true")
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    defaults = {"MEDIUM_STATE_CODES": '["AA"]',
                "SMALL_CITIES": '[{"name":"Fixture City","state_code":"AA"}]',
                "MEDIUM_SAMPLE_LIMIT": "20", "SMALL_SAMPLE_LIMIT": "10", "MAP_FEATURE_LIMIT": "5"}
    for key, value in defaults.items():
        os.environ.setdefault(key, value)
    settings = replace(load_settings(), write_derived=True,
                       derived_output_mode="s3" if args.s3 else "local",
                       derived_local_fallback_dir=str(args.output / "exports"))
    spark = create_sedona(settings, "surface-integration")
    from pyspark.sql import functions as F
    try:
        land = fixture(spark, [
            ("mainland", "land", "land", "POLYGON ((0 0, 0.5 0, 0.5 1, 0 1, 0 0))"),
            ("island", "land", "land", "POLYGON ((0.7 0.4, 0.8 0.4, 0.8 0.6, 0.7 0.6, 0.7 0.4))"),
            ("peak", "physical", "peak", "POINT (0.2 0.2)"),
        ])
        water = fixture(spark, [
            ("sea", "ocean", "ocean", "POLYGON ((0.5 0, 1 0, 1 1, 0.5 1, 0.5 0), (0.7 0.4, 0.7 0.6, 0.8 0.6, 0.8 0.4, 0.7 0.4))"),
            ("lake", "lake", "lake", "POLYGON ((0.1 0.1, 0.2 0.1, 0.2 0.2, 0.1 0.2, 0.1 0.1))"),
            ("label", "physical", "ocean", "POINT (0.9 0.9)"),
            ("river", "river", "river", "LINESTRING (0.1 0.5, 0.4 0.5)"),
        ])
        # Real Overture pruning bboxes are rounded outward. They must not cause
        # false invalid-geometry failures or remain stale in the derivative.
        land = land.withColumn("bbox", F.expr("named_struct('xmin', bbox.xmin - 0.00003D, 'xmax', bbox.xmax + 0.00003D, 'ymin', bbox.ymin - 0.00003D, 'ymax', bbox.ymax + 0.00003D)"))
        world = select_world_surfaces(land, water, release="fixture", release_uri="generated").cache()
        assert world.count() == 3
        comparison = world.where("surface = 'landmass'").alias("derived").join(
            land.alias("source"), F.col("derived.source_id") == F.col("source.id"))
        assert comparison.where("ST_AsBinary(derived.geometry) <> ST_AsBinary(source.geometry)").count() == 0
        report = {"world": validate_surfaces(world, require_both=True)}
        # A lake remains inside landmass, while ocean holes preserve islands.
        for x, y, expected in ((0.15, 0.15, "landmass"), (0.75, 0.5, "landmass"), (0.9, 0.5, "ocean")):
            matches = world.where(F.expr(f"ST_Contains(geometry, ST_Point({x}, {y}))")).select("surface").collect()
            assert [r.surface for r in matches] == [expected]
        qa = coverage_report(world, Bounds(0, 0, 1, 1))
        assert qa["overlap_deg2"] < 1e-12 and qa["uncovered_deg2"] < 1e-12, qa
        report["coverage"] = qa
        # Gaps and overlap must be visible, not corrected.
        gap = coverage_report(world.where("source_id <> 'island'"), Bounds(0, 0, 1, 1))
        assert abs(gap["uncovered_deg2"] - 0.02) < 1e-12, gap
        overlap_frame = world.unionByName(world.where("source_id = 'mainland'").withColumn("surface", F.lit("ocean")))
        assert abs(coverage_report(overlap_frame, Bounds(0, 0, 1, 1))["overlap_deg2"] - 0.5) < 1e-12
        assert abs(coverage_report(world, Bounds(2, 2, 3, 3))["uncovered_deg2"] - 1) < 1e-12
        assert coverage_report(world, Bounds(0, 0, 0.4, 0.4))["uncovered_deg2"] < 1e-12
        region = clip_surfaces(world, Bounds(0.25, 0.25, 0.75, 0.75)).cache()
        validate_surfaces(region)
        assert region.count() == 3
        assert region.where("bbox.xmin < 0.25 OR bbox.xmax > 0.75").count() == 0
        # Boundary-only contacts do not become polygon rows.
        assert clip_surfaces(world.where("surface = 'landmass'"), Bounds(0.8, 0.4, 1, 0.6)).count() == 0
        assert display_surfaces(world, limit=2, tolerance=0.01).count() <= 2
        assert display_surfaces(world, limit=3, tolerance=0.01, max_points_per_feature=1).count() == 0
        limited = display_surfaces(world, limit=3, tolerance=0.01, max_total_points=10)
        assert (limited.selectExpr("ST_NPoints(geometry) AS n").agg(F.sum("n")).first()[0] or 0) <= 10
        grid = surface_grid(world, bounds=Bounds(0, 0, 1, 1), cell_degrees=0.25)
        assert grid.count() == 16
        assert grid.where("surface IN ('uncovered', 'ambiguous')").count() == 0
        assert surface_grid(world, bounds=Bounds(2, 2, 3, 3), cell_degrees=1).first().surface == 'uncovered'
        assert surface_grid(overlap_frame, bounds=Bounds(0, 0, 0.4, 0.4), cell_degrees=1).first().surface == 'ambiguous'
        expect_failure(lambda: surface_grid(world, cell_degrees=0.1), 'exceeding')
        expect_failure(lambda: validate_surfaces(world.where("surface = 'landmass'"), require_both=True), "required")
        invalid = world.withColumn("geometry", F.expr("ST_SetSRID(ST_GeomFromWKT('POLYGON ((0 0, 1 1, 0 1, 1 0, 0 0))'), 4326)"))
        expect_failure(lambda: validate_surfaces(invalid), "Invalid analytical")
        expect_failure(lambda: validate_surfaces(world.withColumn("geometry", F.lit(None).cast(world.schema['geometry'].dataType))), "Invalid analytical")
        expect_failure(lambda: validate_surfaces(world.withColumn("bbox", F.expr("named_struct('xmin', 9D, 'xmax', 10D, 'ymin', 9D, 'ymax', 10D)"))), "Invalid analytical")
        expect_failure(lambda: coverage_report(world, Bounds(0, 0, 2, 1)), "one degree")
        expect_failure(lambda: coverage_report(world, Bounds(0, 0, 1, 1), max_vertices=1), "vertices")
        # World polygons may touch both dateline sides or the pole. No wrapping
        # or projection is applied to their coordinates.
        extreme = fixture(spark, [
            ("east", "land", "land", "POLYGON ((179 88, 180 88, 180 90, 179 90, 179 88))"),
            ("west", "land", "land", "POLYGON ((-180 88, -179 88, -179 90, -180 90, -180 88))"),
        ])
        poles = select_world_surfaces(extreme, water, release="fixture", release_uri="generated")
        validate_surfaces(poles, require_both=True)
        assert clip_surfaces(poles, Bounds(179.5, 88.5, 180, 90)).count() == 1
        with patch("overture_lab.outputs._promote_single_part") as promotion:
            assert export_surfaces(world, spark, replace(settings, write_derived=False), scope="world")["status"] == "dry-run"
            promotion.assert_not_called()
        for scope, frame in (("world", world), ("regional", region)):
            report[scope + "_export"] = export_surfaces(frame, spark, settings, scope=scope)
        # A valid empty regional extent is also a reloadable file.
        report["empty_export"] = export_surfaces(clip_surfaces(world, Bounds(2, 2, 3, 3)), spark, settings, scope="regional")
        fake_s3 = replace(settings, derived_output_mode="s3", derived_output_uri="s3a://fixture/output", allow_local_derived_fallback=True)
        with patch("overture_lab.outputs._s3_permission_probe", return_value=False), patch("overture_lab.outputs._promote_single_part") as promotion:
            expect_failure(lambda: export_surfaces(world, spark, fake_s3, scope="world"), "denied")
            promotion.assert_not_called()
        with patch("overture_lab.outputs._s3_permission_probe", return_value=True), patch("overture_lab.outputs._promote_single_part", side_effect=OSError("injected interruption")):
            expect_failure(lambda: export_surfaces(world, spark, fake_s3, scope="world"), "partial prefix")
        report["status"] = "passed"
        report["checks"] = ["filters", "lake", "island_hole", "clipping", "boundary_contact", "gap", "overlap", "empty", "invalid_geometry", "bbox", "missing_class", "display_bounds", "dateline", "poles", "dry_run", "local_or_s3_roundtrip", "denied_probe", "interrupted_promotion"]
        (args.output / "report.json").write_text(json.dumps(report, indent=2) + "\n")
        print(json.dumps(report, indent=2))
    finally:
        spark.stop()


if __name__ == "__main__":
    main()
