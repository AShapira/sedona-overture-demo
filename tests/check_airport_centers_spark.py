"""Check Notebook 11's airport centers and GeoParquet IO in the pinned image."""

import argparse
import ast
from dataclasses import replace
import json
import math
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from overture_lab.config import load_settings
from overture_lab.outputs import _geoparquet_metadata, write_single_geoparquet


def main():
    from pyspark import StorageLevel
    from pyspark.sql import functions as F
    from sedona.spark import SedonaContext

    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    settings = replace(
        load_settings(), write_derived=True, derived_output_mode="local",
        derived_local_fallback_dir=str(args.output / "exports"),
        scratch_dir=str(args.output),
    )
    spark = SedonaContext.create(
        SedonaContext.builder().master("local[1]")
        .appName("airport-center-integration")
        .config("spark.driver.memory", "1g")
        .config("spark.sql.shuffle.partitions", "2")
        .config("spark.ui.enabled", "false").getOrCreate()
    )
    spark.sparkContext.setLogLevel("ERROR")
    try:
        fixtures = [
            ("point", "POINT (7 9)", (7, 9)),
            ("rectangle", "POLYGON ((0 0, 4 0, 4 2, 0 2, 0 0))", (2, 1)),
            ("line", "LINESTRING (0 0, 6 2)", (3, 1)),
            ("bent-line", "LINESTRING (0 0, 6 0, 6 2)", (3.75, 0.25)),
            ("multiline", "MULTILINESTRING ((0 0, 2 0), (4 0, 8 0))", (13 / 3, 0)),
            ("multipolygon", "MULTIPOLYGON (((0 0, 2 0, 2 2, 0 2, 0 0)), "
             "((4 0, 6 0, 6 2, 4 2, 4 0)))", (3, 1)),
            ("multipoint", "MULTIPOINT ((0 0), (4 2))", (2, 1)),
            ("null", None, None),
        ]
        rows = [(key, "airport", "airport", wkt) for key, wkt, _ in fixtures]
        rows.append(("runway", "airport", "runway", "LINESTRING (0 0, 2 2)"))
        source = spark.createDataFrame(
            rows, "id string, subtype string, class string, wkt string",
        ).selectExpr("*", "ST_GeomFromWKT(wkt) AS geometry")

        # Execute the actual notebook assignments, avoiding a duplicate of its
        # selection and centroid expressions or a scan of the worldwide data.
        path = ROOT / "notebooks/11_world_airports_and_medium_runways.py"
        tree = ast.parse(path.read_text())
        namespace = {"F": F, "StorageLevel": StorageLevel, "infrastructure": source}
        assignments = [
            node for node in tree.body if isinstance(node, ast.Assign)
            and any(isinstance(target, ast.Name)
                    and target.id in {"AIRPORT_CLASSES", "airports"}
                    for target in node.targets)
        ]
        assert len(assignments) == 2
        exec(compile(ast.Module(body=assignments, type_ignores=[]), str(path), "exec"), namespace)
        airports = namespace["airports"]
        assert airports.columns == source.columns + ["center_point"]
        actual = {row.id: row for row in airports.selectExpr(
            "id", "ST_X(center_point) AS x", "ST_Y(center_point) AS y",
            "GeometryType(center_point) AS kind", "ST_SRID(center_point) AS srid",
            "ST_AsBinary(geometry) AS original", "ST_AsBinary(center_point) AS center",
        ).collect()}
        assert set(actual) == {key for key, _, _ in fixtures}
        for key, _, expected in fixtures:
            row = actual[key]
            if expected is None:
                assert row.center is None and row.original is None
            else:
                assert row.kind == "POINT" and row.srid == 4326, row
                assert math.isclose(row.x, expected[0], abs_tol=1e-12), row
                assert math.isclose(row.y, expected[1], abs_tol=1e-12), row
        assert actual["point"].original == actual["point"].center
        original_wkb = {r.id: r.wkb for r in source.selectExpr(
            "id", "ST_AsBinary(geometry) AS wkb",
        ).collect()}
        assert all(row.original == original_wkb[key] for key, row in actual.items())

        # The notebook rejects null source geometry before exporting. Exercise
        # both the new two-geometry result and the original one-geometry contract.
        valid = airports.where("geometry IS NOT NULL")
        report = {"status": "passed", "fixtures": list(actual), "exports": {}}
        for label, frame in (("airports", valid), ("single-geometry", valid.drop("center_point"))):
            result = write_single_geoparquet(
                frame, spark, settings, dataset_name=label,
                object_name="airports.geoparquet",
            )
            restored = spark.read.format("geoparquet").load(result.geoparquet_uri)
            geometries = [name for name in ("geometry", "center_point") if name in frame.columns]
            comparison = [
                F.expr(f"ST_AsBinary({name})").alias(name) if name in geometries
                else F.col(name) for name in frame.columns
            ]
            before, after = frame.select(*comparison), restored.select(*comparison)
            assert before.exceptAll(after).count() == after.exceptAll(before).count() == 0
            metadata = _geoparquet_metadata(spark, result.geoparquet_uri)
            assert metadata["primary_column"] == "geometry"
            assert set(metadata["columns"]) == set(geometries)
            for name in geometries:
                assert restored.where(F.expr(f"ST_SRID({name}) <> 4326")).count() == 0
            if "center_point" in geometries:
                assert metadata["columns"]["center_point"]["geometry_types"] == ["Point"]
            report["exports"][label] = result.as_dict()
        airports.unpersist()
        (args.output / "report.json").write_text(json.dumps(report, indent=2) + "\n")
        print(json.dumps(report, indent=2))
    finally:
        spark.stop()


if __name__ == "__main__":
    main()
