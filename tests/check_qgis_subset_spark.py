#!/usr/bin/env python3
"""Sedona integration check for exact QGIS subset selection semantics."""

from __future__ import annotations

import importlib.util
from pathlib import Path
import sys

from pyspark.sql import functions as F
from sedona.spark import SedonaContext


ROOT = Path(__file__).resolve().parents[1]
EXTRACTOR_PATH = ROOT / "qgis" / "schema-1.18.0" / "extract_test_subset.py"
SPEC = importlib.util.spec_from_file_location("qgis_subset_extractor_spark", EXTRACTOR_PATH)
if SPEC is None or SPEC.loader is None:
    raise RuntimeError(f"Could not load {EXTRACTOR_PATH}")
EXTRACTOR = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = EXTRACTOR
SPEC.loader.exec_module(EXTRACTOR)


def main() -> int:
    builder = (
        SedonaContext.builder()
        .master("local[2]")
        .appName("qgis-subset-exact-selection-check")
        .config("spark.driver.memory", "2g")
        .config("spark.ui.showConsoleProgress", "false")
    )
    spark = SedonaContext.create(builder.getOrCreate())
    spark.sparkContext.setLogLevel("ERROR")
    try:
        rows = [
            ("inside", "LINESTRING (-0.5 0.5, 1.5 0.5)", -0.5, 0.5, 1.5, 0.5),
            # Deliberately stale/coarse bbox metadata makes this a pruning false positive.
            ("false-positive", "LINESTRING (2 2, 3 3)", 0.2, 0.2, 3.0, 3.0),
            ("outside", "LINESTRING (4 4, 5 5)", 4.0, 4.0, 5.0, 5.0),
        ]
        frame = spark.createDataFrame(rows, "id string, wkt string, xmin double, ymin double, xmax double, ymax double")
        frame = frame.select(
            "id",
            F.expr("ST_GeomFromWKT(wkt)").alias("geometry"),
            F.struct("xmin", "ymin", "xmax", "ymax").alias("bbox"),
        )
        candidates, exact = EXTRACTOR.select_source_features(
            frame, (0.0, 0.0, 1.0, 1.0), F
        )
        candidate_ids = {row.id for row in candidates.select("id").collect()}
        exact_rows = exact.select("id", F.expr("ST_AsText(geometry)").alias("wkt")).collect()
        if candidate_ids != {"inside", "false-positive"}:
            raise AssertionError(f"Unexpected bbox candidates: {candidate_ids}")
        if [row.id for row in exact_rows] != ["inside"]:
            raise AssertionError(f"Exact filter did not remove false positive: {exact_rows}")
        if exact_rows[0].wkt != "LINESTRING (-0.5 0.5, 1.5 0.5)":
            raise AssertionError("Crossing geometry was clipped instead of retained whole")
        if exact.columns != frame.columns:
            raise AssertionError("Exact selection changed the source schema")
    finally:
        spark.stop()
    print("QGIS subset exact-intersection check passed; false positive removed and whole geometry retained.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
