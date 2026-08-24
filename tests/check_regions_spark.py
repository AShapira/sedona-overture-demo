#!/usr/bin/env python3
"""Container integration check for multi-boundary filtering and deduplication."""

from __future__ import annotations

import os
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from overture_lab.config import load_settings  # noqa: E402
from overture_lab.regions import Bounds, bbox_overlap, exact_intersection  # noqa: E402
from overture_lab.spark import create_sedona  # noqa: E402


def main() -> int:
    defaults = {
        "MEDIUM_STATE_CODES": '["AA","BB"]',
        "SMALL_CITIES": '[{"name":"City A","state_code":"AA"}]',
        "MEDIUM_SAMPLE_LIMIT": "20",
        "SMALL_SAMPLE_LIMIT": "10",
        "MAP_FEATURE_LIMIT": "5",
        "SEDONA_SPARK_LOCAL_CORES": "2",
        "SEDONA_SPARK_DRIVER_MEMORY": "4g",
        "SEDONA_SPARK_PARTITIONS": "4",
        "SEDONA_SPARK_LOCAL_DIR": "/tmp/spark-regions-check",
        "SEDONA_SCRATCH_DIR": "/tmp",
        "SEDONA_SCRATCH_BUDGET_GB": "20",
        "SEDONA_SCRATCH_RESERVE_GB": "2",
        "DERIVED_LOCAL_FALLBACK_DIR": "/tmp/derived",
    }
    for name, value in defaults.items():
        os.environ.setdefault(name, value)

    spark = create_sedona(load_settings(), "regions-integration-check")
    candidates = (
        spark.createDataFrame(
            [
                ("overlap", "POINT (1.5 1.5)", (1.5, 1.5, 1.5, 1.5)),
                ("second", "POINT (2.5 2.5)", (2.5, 2.5, 2.5, 2.5)),
                ("outside", "POINT (50 50)", (50.0, 50.0, 50.0, 50.0)),
            ],
            "id string, wkt string, bbox struct<xmin:double,ymin:double,xmax:double,ymax:double>",
        )
        .selectExpr("id", "ST_GeomFromWKT(wkt) AS geometry", "bbox")
    )
    boundaries = (
        spark.createDataFrame(
            [
                ("first", "POLYGON ((0 0, 2 0, 2 2, 0 2, 0 0))"),
                ("second", "POLYGON ((1 1, 3 1, 3 3, 1 3, 1 1))"),
            ],
            "id string, wkt string",
        )
        .selectExpr("id", "ST_GeomFromWKT(wkt) AS geometry")
    )
    bounds = (Bounds(0, 0, 2, 2), Bounds(1, 1, 3, 3))
    result = exact_intersection(bbox_overlap(candidates, bounds), boundaries)
    rows = sorted(row.id for row in result.select("id").collect())
    assert rows == ["overlap", "second"], rows
    assert result.where("id = 'overlap'").count() == 1
    spark.stop()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
