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


def line_wkb(points: list[tuple[float, float]]) -> bytes:
    return b"".join(
        [struct.pack("<BII", 1, 2, len(points))]
        + [struct.pack("<dd", x, y) for x, y in points]
    )


def polygon_wkb(ring: list[tuple[float, float]]) -> bytes:
    return b"".join(
        [struct.pack("<BII", 1, 3, 1), struct.pack("<I", len(ring))]
        + [struct.pack("<dd", x, y) for x, y in ring]
    )


def bounds(points: list[tuple[float, float]]) -> dict[str, float]:
    xs = [point[0] for point in points]
    ys = [point[1] for point in points]
    return {
        "xmin": min(xs),
        "ymin": min(ys),
        "xmax": max(xs),
        "ymax": max(ys),
    }


def geo_schema(fields: list[pa.Field], geometry_types: list[str]) -> pa.Schema:
    return pa.schema(
        fields,
        metadata={
            b"geo": json.dumps(
                {
                    "version": "1.1.0",
                    "primary_column": "geometry",
                    "columns": {
                        "geometry": {
                            "encoding": "WKB",
                            "geometry_types": geometry_types,
                        }
                    },
                }
            ).encode()
        },
    )


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
    default_schema = geo_schema(
        [
            pa.field("id", pa.string(), nullable=False),
            pa.field("geometry", pa.binary(), nullable=False),
            pa.field("bbox", bbox_type, nullable=False),
        ],
        ["Point"],
    )
    default_table = pa.Table.from_pylist(
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
        schema=default_schema,
    )

    country_ring = [
        (34.0, 32.0),
        (35.0, 32.0),
        (35.0, 33.0),
        (34.0, 33.0),
        (34.0, 32.0),
    ]
    division_schema = geo_schema(
        [
            pa.field("id", pa.string(), nullable=False),
            pa.field("country", pa.string(), nullable=False),
            pa.field("subtype", pa.string(), nullable=False),
            pa.field("is_land", pa.bool_(), nullable=False),
            pa.field("geometry", pa.binary(), nullable=False),
            pa.field("bbox", bbox_type, nullable=False),
        ],
        ["Polygon"],
    )
    division_table = pa.Table.from_pylist(
        [
            {
                "id": "fixture-country",
                "country": "AA",
                "subtype": "country",
                "is_land": True,
                "geometry": polygon_wkb(country_ring),
                "bbox": bounds(country_ring),
            }
        ],
        schema=division_schema,
    )

    segment_schema = geo_schema(
        [
            pa.field("id", pa.string(), nullable=False),
            pa.field("class", pa.string(), nullable=False),
            pa.field("subtype", pa.string(), nullable=False),
            pa.field("geometry", pa.binary(), nullable=False),
            pa.field("bbox", bbox_type, nullable=False),
        ],
        ["LineString"],
    )
    segment_rows = []
    for feature_id, road_class, points in (
        (
            "inside-road",
            "primary",
            [(34.2, 32.2), (34.8, 32.8)],
        ),
        (
            "crossing-road",
            "secondary",
            [(33.5, 32.5), (34.5, 32.5)],
        ),
        (
            "outside-road",
            "residential",
            [(36.0, 32.5), (36.5, 32.5)],
        ),
        (
            "excluded-footway",
            "footway",
            [(34.3, 32.3), (34.4, 32.4)],
        ),
    ):
        segment_rows.append(
            {
                "id": feature_id,
                "class": road_class,
                "subtype": "road",
                "geometry": line_wkb(points),
                "bbox": bounds(points),
            }
        )
    segment_table = pa.Table.from_pylist(
        segment_rows,
        schema=segment_schema,
    )

    names_type = pa.struct(
        [
            pa.field("primary", pa.string()),
            pa.field("common", pa.map_(pa.string(), pa.string())),
        ]
    )
    categories_type = pa.struct(
        [
            pa.field("primary", pa.string()),
            pa.field("alternate", pa.list_(pa.string())),
        ]
    )
    address_type = pa.struct(
        [
            pa.field("freeform", pa.string()),
            pa.field("locality", pa.string()),
            pa.field("postcode", pa.string()),
            pa.field("region", pa.string()),
            pa.field("country", pa.string()),
        ]
    )
    place_schema = geo_schema(
        [
            pa.field("id", pa.string(), nullable=False),
            pa.field("geometry", pa.binary(), nullable=False),
            pa.field("categories", categories_type),
            pa.field("confidence", pa.float64()),
            pa.field("websites", pa.list_(pa.string())),
            pa.field("emails", pa.list_(pa.string())),
            pa.field("socials", pa.list_(pa.string())),
            pa.field("phones", pa.list_(pa.string())),
            pa.field("brand", pa.struct([pa.field("names", names_type)])),
            pa.field("addresses", pa.list_(address_type)),
            pa.field("names", names_type),
            pa.field("sources", pa.list_(pa.string())),
            pa.field("operating_status", pa.string()),
            pa.field("basic_category", pa.string()),
            pa.field("taxonomy", pa.string()),
            pa.field("version", pa.int32()),
            pa.field("bbox", bbox_type, nullable=False),
        ],
        ["Point"],
    )
    place_rows = []
    for (
        feature_id,
        longitude,
        latitude,
        basic_category,
        primary_category,
        confidence,
        operating_status,
        country,
    ) in (
        (
            "world-airport-one",
            34.55,
            32.45,
            "airport",
            "airport",
            0.95,
            "open",
            "AA",
        ),
        (
            "world-airport-two",
            -73.78,
            40.64,
            "airport",
            "airport_terminal",
            0.8,
            None,
            "US",
        ),
        (
            "not-an-airport",
            34.6,
            32.5,
            "restaurant",
            "restaurant",
            0.7,
            "open",
            "AA",
        ),
    ):
        place_rows.append(
            {
                "id": feature_id,
                "geometry": point_wkb(longitude, latitude),
                "categories": {
                    "primary": primary_category,
                    "alternate": [],
                },
                "confidence": confidence,
                "websites": [],
                "emails": [],
                "socials": [],
                "phones": [],
                "brand": None,
                "addresses": [
                    {
                        "freeform": None,
                        "locality": None,
                        "postcode": None,
                        "region": None,
                        "country": country,
                    }
                ],
                "names": {
                    "primary": feature_id.replace("-", " ").title(),
                    "common": {"en": feature_id},
                },
                "sources": ["fixture"],
                "operating_status": operating_status,
                "basic_category": basic_category,
                "taxonomy": "fixture",
                "version": 1,
                "bbox": bounds([(longitude, latitude)]),
            }
        )
    place_table = pa.Table.from_pylist(place_rows, schema=place_schema)

    infrastructure_schema = geo_schema(
        [
            pa.field("id", pa.string(), nullable=False),
            pa.field("geometry", pa.binary(), nullable=False),
            pa.field("sources", pa.list_(pa.string())),
            pa.field("names", names_type),
            pa.field("level", pa.int32()),
            pa.field("wikidata", pa.string()),
            pa.field("source_tags", pa.map_(pa.string(), pa.string())),
            pa.field("subtype", pa.string(), nullable=False),
            pa.field("class", pa.string(), nullable=False),
            pa.field("height", pa.float64()),
            pa.field("surface", pa.string()),
            pa.field("version", pa.int32()),
            pa.field("bbox", bbox_type, nullable=False),
        ],
        ["LineString", "Polygon"],
    )
    inside_runway = [(34.2, 32.2), (34.8, 32.8)]
    crossing_runway = [
        (33.8, 32.35),
        (34.2, 32.35),
        (34.2, 32.45),
        (33.8, 32.45),
        (33.8, 32.35),
    ]
    outside_runway = [(36.0, 32.2), (36.5, 32.2)]
    taxiway = [(34.3, 32.6), (34.7, 32.6)]
    infrastructure_rows = []
    for feature_id, feature_class, surface, points, geometry in (
        (
            "inside-runway",
            "runway",
            "asphalt",
            inside_runway,
            line_wkb(inside_runway),
        ),
        (
            "crossing-runway",
            "runway",
            None,
            crossing_runway,
            polygon_wkb(crossing_runway),
        ),
        (
            "outside-runway",
            "runway",
            "gravel",
            outside_runway,
            line_wkb(outside_runway),
        ),
        (
            "excluded-taxiway",
            "taxiway",
            "asphalt",
            taxiway,
            line_wkb(taxiway),
        ),
    ):
        infrastructure_rows.append(
            {
                "id": feature_id,
                "geometry": geometry,
                "sources": ["fixture"],
                "names": {
                    "primary": feature_id.replace("-", " ").title(),
                    "common": {"en": feature_id},
                },
                "level": None,
                "wikidata": None,
                "source_tags": {},
                "subtype": "airport",
                "class": feature_class,
                "height": None,
                "surface": surface,
                "version": 1,
                "bbox": bounds(points),
            }
        )
    infrastructure_table = pa.Table.from_pylist(
        infrastructure_rows,
        schema=infrastructure_schema,
    )

    for theme, feature_type in sorted(REQUIRED_RELEASE_TYPES):
        leaf = args.output / f"theme={theme}" / f"type={feature_type}"
        leaf.mkdir(parents=True, exist_ok=True)
        table = default_table
        if (theme, feature_type) == ("divisions", "division_area"):
            table = division_table
        elif (theme, feature_type) == ("places", "place"):
            table = place_table
        elif (theme, feature_type) == ("base", "infrastructure"):
            table = infrastructure_table
        elif (theme, feature_type) == ("transportation", "segment"):
            table = segment_table
        pq.write_table(table, leaf / "part-00000.parquet", compression="zstd")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
