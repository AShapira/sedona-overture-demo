"""Pinned-Sedona integration: exact rows, local export and injected S3 failures.

Optionally --regional-geoparquet reloads a prior exact Notebook 14 export, and
--source-release measures bounded coastal tiles from the immutable Overture release.
All outputs and measurements are retained under --output.
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
from overture_lab.geopackage import GeneralizationOptions, export_surface_geopackage
from overture_lab.regions import Bounds, bbox_overlap
from overture_lab.spark import create_sedona, read_type
from overture_lab.surfaces import clip_surfaces, select_world_surfaces
from check_surfaces_spark import fixture
from test_geopackage import sample_records


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--regional-geoparquet")
    parser.add_argument("--source-release")
    parser.add_argument("--precision-grid", type=float, help="Explicit normalization for real-data checks only")
    parser.add_argument("--s3", action="store_true", help="Use explicitly configured test S3 destination")
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    defaults = {"MEDIUM_STATE_CODES": '["AA"]',
                "SMALL_CITIES": '[{"name":"Fixture City","state_code":"AA"}]',
                "MEDIUM_SAMPLE_LIMIT": "20", "SMALL_SAMPLE_LIMIT": "10", "MAP_FEATURE_LIMIT": "5",
                "DERIVED_OUTPUT_MODE": "local", "SEDONA_SPARK_LOCAL_CORES": "2",
                "DERIVED_LOCAL_FALLBACK_DIR": str(args.output / "exports"),
                "SEDONA_SPARK_DRIVER_MEMORY": "4g", "SEDONA_SPARK_PARTITIONS": "4",
                "SEDONA_SCRATCH_DIR": str(args.output), "SEDONA_SCRATCH_BUDGET_GB": "12",
                "SEDONA_SCRATCH_RESERVE_GB": "1"}
    for key, value in defaults.items():
        os.environ.setdefault(key, value)
    settings = replace(load_settings(), write_derived=True, derived_output_mode="local",
                       derived_local_fallback_dir=str(args.output / "exports"))
    spark = create_sedona(settings, "geopackage-integration")
    report = {}
    try:
        import shapely
        rows = {s: [] for s in ("landmass", "ocean")}
        for attributes, wkb in sample_records():
            surface = attributes["surface"]
            subtype = "land" if surface == "landmass" else "ocean"
            rows[surface].append((attributes["source_id"], subtype, subtype, shapely.from_wkb(wkb).wkt))
        world = select_world_surfaces(fixture(spark, rows["landmass"]), fixture(spark, rows["ocean"]),
                                      release="fixture", release_uri="generated").cache()
        bounds = Bounds(0, 0, 4, 2)
        region = clip_surfaces(world, bounds).cache()
        report["fixture"] = export_surface_geopackage(region, spark, settings, scope="regional", bounds=bounds)
        report["world_fixture"] = export_surface_geopackage(
            world, spark, settings, scope="world", bounds=Bounds(-180, -90, 180, 90),
            options=GeneralizationOptions(tile_degrees=180))
        report["dry_run"] = export_surface_geopackage(None, None, replace(settings, write_derived=False),
                                                      scope="regional", bounds=bounds)
        s3_settings = replace(settings, derived_output_mode="s3", derived_output_uri="s3a://fixture-test/derived")
        with patch("overture_lab.geopackage._s3_permission_probe", return_value=False):
            try:
                export_surface_geopackage(region, spark, s3_settings, scope="regional", bounds=bounds)
            except RuntimeError as exc:
                assert "denied write" in str(exc)
                report["denied_s3"] = "passed"
            else:
                raise AssertionError("Denied S3 destination accepted")
        with patch("overture_lab.geopackage._s3_permission_probe", return_value=True), patch(
                "overture_lab.geopackage._upload_verified", side_effect=OSError("injected upload interruption")):
            try:
                export_surface_geopackage(region, spark, s3_settings, scope="regional", bounds=bounds)
            except RuntimeError as exc:
                assert "no target fallback" in str(exc)
                assert list(args.output.glob("geopackage/*/*.partial.gpkg"))
                report["interrupted_s3"] = "passed; staging retained"
            else:
                raise AssertionError("Interrupted export reported success")
        if args.s3:
            report["s3_fixture"] = export_surface_geopackage(
                region, spark, replace(settings, derived_output_mode="s3"), scope="regional", bounds=bounds)
        if args.regional_geoparquet:
            frame = spark.read.format("geoparquet").load(args.regional_geoparquet)
            extent = json.loads(frame.select("extent_json").first().extent_json)
            report["real_regional"] = export_surface_geopackage(
                frame, spark, settings, scope="regional", bounds=Bounds(**extent),
                options=GeneralizationOptions(precision_grid_degrees=args.precision_grid),
                progress=lambda event: print(json.dumps(event), flush=True))
        if args.source_release:
            source_settings = replace(settings, release_uri=args.source_release)
            land = read_type(spark, source_settings, "base", "land")
            water = read_type(spark, source_settings, "base", "water")
            # Distinct coastline patterns, including high latitude and dateline vicinity.
            for name, extent in {"mediterranean": Bounds(34, 31, 36, 33),
                                 "norway": Bounds(4, 60, 6, 62),
                                 "dateline": Bounds(178, -18, 180, -16)}.items():
                selected = select_world_surfaces(bbox_overlap(land, extent), bbox_overlap(water, extent),
                                                release=settings.release, release_uri=args.source_release)
                report[name] = export_surface_geopackage(
                    clip_surfaces(selected, extent), spark, settings, scope="regional", bounds=extent,
                    options=GeneralizationOptions(precision_grid_degrees=args.precision_grid),
                    progress=lambda event: print(json.dumps({"sample": name, **event}), flush=True))
        report["status"] = "passed"
    finally:
        (args.output / "geopackage-report.json").write_text(json.dumps(report, indent=2) + "\n")
        spark.stop()
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
