"""Real-export regression: outward-rounded source bboxes are valid coverings."""
import argparse
from dataclasses import replace
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
from overture_lab.config import load_settings
from overture_lab.outputs import write_single_file_exports
from overture_lab.spark import create_sedona


def main():
    from pyspark.sql import functions as F
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    settings = replace(load_settings(), write_derived=True, derived_output_mode="local",
                       scratch_dir=str(args.output), derived_local_fallback_dir=str(args.output / "exports"))
    spark = create_sedona(settings, "road-bbox-regression")
    try:
        source = spark.createDataFrame([
            ("exact", 1., 1., 2., 2.), ("rounded", .999999, .999999, 2.000001, 2.000001),
        ], "id string, xmin double, ymin double, xmax double, ymax double").selectExpr(
            "id", "'road' AS subtype", "'primary' AS class",
            "ST_SetSRID(ST_GeomFromWKT('LINESTRING (1 1, 2 2)'),4326) AS geometry",
            "named_struct('xmin',xmin,'ymin',ymin,'xmax',xmax,'ymax',ymax) AS bbox",
        )
        def export(frame, name):
            roads = frame.selectExpr("concat(id,'#0') AS road_id", "id AS source_segment_id", "class AS road_class", "*")
            return write_single_file_exports(roads, spark, settings, dataset_name=name, geoparquet_dataframe=frame)
        result = export(source, "valid-rounded")
        restored = spark.read.format("geoparquet").load(result.geoparquet_uri)
        assert restored.count() == 2
        assert restored.select("id", "bbox").exceptAll(source.select("id", "bbox")).count() == 0
        failures = {}
        for label, value in (("too-small", "1.5D"), ("null", "CAST(NULL AS DOUBLE)"),
                             ("nan", "CAST('NaN' AS DOUBLE)")):
            broken = source.withColumn("bbox", F.expr(
                f"named_struct('xmin',{value},'ymin',bbox.ymin,'xmax',bbox.xmax,'ymax',bbox.ymax)"))
            # Match nullable fields from real Parquet input, so the intended
            # geometry-covering failure is reached rather than schema widening.
            broken = broken.withColumn("bbox", F.from_json(F.to_json("bbox"), source.schema["bbox"].dataType))
            try:
                export(broken, label)
            except RuntimeError as error:
                assert "invalid rows" in str(error.__cause__), error
                failures[label] = "rejected"
            else:
                raise AssertionError(f"Accepted {label} source bbox")
        report = {"status": "passed", "exact_and_outward_boxes": "preserved", "bad_boxes": failures}
        (args.output / "report.json").write_text(json.dumps(report, indent=2))
        print(json.dumps(report))
    finally:
        spark.stop()


if __name__ == "__main__":
    main()
