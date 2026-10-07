"""Generated country fixtures, budget failures, and exact GeoParquet round trip."""
import argparse
from dataclasses import replace
import json
import os
from pathlib import Path
import sys
import tempfile
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
from overture_lab.config import load_settings
from overture_lab.countries import select_world_countries, validate_countries, country_display_frame
from overture_lab.outputs import write_single_geoparquet
from overture_lab.spark import create_sedona


def expect_failure(call, text):
    try:
        call()
    except ValueError as exc:
        assert text in str(exc), str(exc)
    else:
        raise AssertionError(f"Expected failure: {text}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--s3", action="store_true")
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    for key, value in {
        "MEDIUM_STATE_CODES": '["AA"]',
        "SMALL_CITIES": '[{"name":"Fixture City","state_code":"AA"}]',
        "MEDIUM_SAMPLE_LIMIT": "20", "SMALL_SAMPLE_LIMIT": "10", "MAP_FEATURE_LIMIT": "5",
    }.items():
        os.environ.setdefault(key, value)
    settings = replace(load_settings(), write_derived=True,
                       derived_output_mode="s3" if args.s3 else "local",
                       derived_local_fallback_dir=str(args.output / "exports"))
    spark = create_sedona(settings, "countries-integration")
    from pyspark.sql import functions as F
    try:
        polygon = "POLYGON ((0 0, 0.0001 0.00002, 0.0002 0, 4 0, 4 4, 0 4, 0 0), (1 1, 1 2, 2 2, 2 1, 1 1))"
        multipart = "MULTIPOLYGON (((10 0, 11 0, 11 1, 10 1, 10 0)), ((12 0, 12.001 0, 12.001 0.001, 12 0.001, 12 0)))"
        rows = [
            ("a-land", "AA", "country", True, False, polygon),
            ("a-territorial", "AA", "country", False, True, polygon),
            ("b-dual", "BB", "country", True, True, multipart),
            ("a-perspective", "AA", "country", True, False, polygon),
            ("state", "AA", "region", True, False, polygon),
            ("unknown-land", "CC", "country", None, True, polygon),
        ]
        areas = spark.createDataFrame(rows, "id string, country string, subtype string, is_land boolean, is_territorial boolean, wkt string").selectExpr(
            "*", "ST_SetSRID(ST_GeomFromWKT(wkt), 4326) AS geometry",
            "named_struct('primary', id, 'common', map('en', id)) AS names",
            "array(named_struct('dataset', 'synthetic', 'record_id', id)) AS sources",
            "named_struct('mode', 'fixture', 'countries', array(country)) AS perspectives",
            "'divisions' AS theme", "'division_area' AS feature_type",
        ).drop("wkt")
        # Match nullable nested fields in a real GeoParquet read, rather than
        # Spark's nonnullable literal-expression schema.
        for name in ("names", "sources", "perspectives"):
            areas = areas.withColumn(name, F.from_json(F.to_json(F.col(name)), areas.schema[name].dataType))
        countries = select_world_countries(areas).cache()
        report = {"selection": validate_countries(countries)}
        assert report["selection"] == {"features": 3, "country_codes": 2, "invalid_geometries": 0}
        assert {r.id for r in countries.select("id").collect()} == {"a-land", "b-dual", "a-perspective"}
        assert "theme" not in countries.columns and "perspectives" in countries.columns
        preview = country_display_frame(countries, feature_limit=3)
        assert set(preview.id) == {"a-land", "b-dual", "a-perspective"}
        assert len(preview.loc[preview.id == "b-dual"].geometry.iloc[0].geoms) == 2
        assert len(preview.loc[preview.id == "a-land"].geometry.iloc[0].interiors) == 1
        for kwargs, error in (({"feature_limit": 2}, "MAP_FEATURE_LIMIT"),
                              ({"feature_limit": 3, "coordinate_limit": 1}, "MAP_COORDINATE_LIMIT"),
                              ({"feature_limit": 3, "tolerance": float("nan")}, "finite")):
            expect_failure(lambda: country_display_frame(countries, **kwargs), error)
        expect_failure(lambda: validate_countries(countries.limit(0)), "No land-country")
        for expression in ("ST_GeomFromWKT('POINT (0 0)')", "ST_GeomFromWKT('POLYGON EMPTY')",
                           "ST_GeomFromWKT('POLYGON ((0 0, 2 2, 2 0, 0 2, 0 0))')", "NULL"):
            broken = countries.withColumn("geometry", F.expr(f"ST_SetSRID({expression}, 4326)"))
            expect_failure(lambda: validate_countries(broken), "Invalid country geometry")
        expect_failure(lambda: validate_countries(countries.withColumn("geometry", F.expr("ST_SetSRID(geometry, 3857)"))),
                       "Invalid country geometry")
        result = write_single_geoparquet(countries, spark, settings,
                                        dataset_name="world-countries", object_name="countries.geoparquet")
        restored = spark.read.format("geoparquet").load(result.geoparquet_uri)
        # Compare every field as well as exact WKB, in both directions, including duplicates.
        columns = [F.expr("ST_AsBinary(geometry)").alias("geometry"),
                   F.to_json(F.struct(*[F.col(c) for c in countries.columns if c != "geometry"])).alias("attributes")]
        before, after = countries.select(*columns), restored.select(*columns)
        assert before.exceptAll(after).count() == after.exceptAll(before).count() == 0
        report.update(export=result.as_dict(), restored=validate_countries(restored),
                      exact_round_trip=True, map_features=len(preview), budget_and_invalid_checks="passed")
        # Execute the actual notebook with export enabled against the same
        # generated release, including its configuration and display cells.
        import ast
        import nbformat
        from nbclient import NotebookClient
        with tempfile.TemporaryDirectory(prefix="country-release-") as release:
            areas.drop("theme", "feature_type").write.format("geoparquet").option("geoparquet.version", "1.0.0").save(
                f"{release}/theme=divisions/type=division_area")
            spark.stop()
            notebook = nbformat.read(Path(__file__).resolve().parents[1] /
                                     "notebooks/15_world_countries.ipynb", as_version=4)
            with patch.dict(os.environ, {"OVERTURE_RELEASE_URI": release,
                                         "WRITE_DERIVED": "true",
                                         "DERIVED_OUTPUT_MODE": "s3" if args.s3 else "local",
                                         "SEDONA_SCRATCH_DIR": str(args.output.resolve()),
                                         "DERIVED_LOCAL_FALLBACK_DIR": str((args.output / "notebook-exports").resolve())}):
                NotebookClient(notebook, timeout=180, kernel_name="python3").execute()
            nbformat.write(notebook, args.output / "15_world_countries.executed.ipynb")
            exports = [ast.literal_eval(output["data"]["text/plain"])
                       for cell in notebook.cells for output in cell.get("outputs", [])
                       if "geoparquet_uri" in output.get("data", {}).get("text/plain", "")]
            assert len(exports) == 1 and exports[0]["status"] == "written", exports
            assert exports[0]["row_count"] == 3, exports
            report["notebook_export"] = exports[0]
            if not args.s3:
                assert Path(exports[0]["geoparquet_uri"]).is_file()
                assert "s3a://" not in exports[0]["geoparquet_uri"]
        (args.output / "report.json").write_text(json.dumps(report, indent=2) + "\n")
        print(json.dumps(report, indent=2))
    finally:
        spark.stop()


if __name__ == "__main__":
    main()
