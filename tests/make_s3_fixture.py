#!/usr/bin/env python3
"""Create a tiny complete-layout GeoParquet release for local S3 smoke tests."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import struct
import sys

import pyarrow as pa
import pyarrow.parquet as pq


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from overture_lab.catalog import REQUIRED_RELEASE_TYPES  # noqa: E402


def point_wkb(longitude: float, latitude: float) -> bytes:
    return struct.pack("<BIdd", 1, 1, longitude, latitude)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("output", type=Path)
    args = parser.parse_args()

    bbox_type = pa.struct(
        [
            pa.field("xmin", pa.float64()),
            pa.field("ymin", pa.float64()),
            pa.field("xmax", pa.float64()),
            pa.field("ymax", pa.float64()),
        ]
    )
    schema = pa.schema(
        [
            pa.field("id", pa.string(), nullable=False),
            pa.field("geometry", pa.binary(), nullable=False),
            pa.field("bbox", bbox_type, nullable=False),
        ],
        metadata={
            b"geo": json.dumps(
                {
                    "version": "1.1.0",
                    "primary_column": "geometry",
                    "columns": {
                        "geometry": {
                            "encoding": "WKB",
                            "geometry_types": ["Point"],
                        }
                    },
                }
            ).encode()
        },
    )
    table = pa.Table.from_pylist(
        [
            {
                "id": "fixture-feature",
                "geometry": point_wkb(34.65, 31.8),
                "bbox": {
                    "xmin": 34.65,
                    "ymin": 31.8,
                    "xmax": 34.65,
                    "ymax": 31.8,
                },
            }
        ],
        schema=schema,
    )
    for theme, feature_type in sorted(REQUIRED_RELEASE_TYPES):
        leaf = args.output / f"theme={theme}" / f"type={feature_type}"
        leaf.mkdir(parents=True, exist_ok=True)
        pq.write_table(table, leaf / "part-00000.parquet", compression="zstd")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
