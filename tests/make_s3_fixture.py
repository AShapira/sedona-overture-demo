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

    names_type = pa.struct(
        [
            pa.field("primary", pa.string()),
            pa.field("common", pa.map_(pa.string(), pa.string())),
        ]
    )
    between_type = pa.list_(pa.float64())
    connector_reference_type = pa.struct(
        [
            pa.field("connector_id", pa.string()),
            pa.field("at", pa.float64()),
        ]
    )
    route_type = pa.struct(
        [
            pa.field("name", pa.string()),
            pa.field("network", pa.string()),
            pa.field("ref", pa.string()),
            pa.field("symbol", pa.string()),
            pa.field("wikidata", pa.string()),
            pa.field("between", between_type),
        ]
    )
    source_type = pa.struct(
        [
            pa.field("property", pa.string()),
            pa.field("dataset", pa.string()),
            pa.field("license", pa.string()),
            pa.field("record_id", pa.string()),
            pa.field("update_time", pa.string()),
            pa.field("confidence", pa.float64()),
            pa.field("between", between_type),
        ]
    )
    simple_when_type = pa.struct(
        [
            pa.field("heading", pa.string()),
            pa.field("mode", pa.list_(pa.string())),
            pa.field("using", pa.list_(pa.string())),
        ]
    )
    speed_limit_type = pa.struct(
        [
            pa.field(
                "max_speed",
                pa.struct(
                    [
                        pa.field("value", pa.int32()),
                        pa.field("unit", pa.string()),
                    ]
                ),
            ),
            pa.field("when", simple_when_type),
            pa.field("between", between_type),
        ]
    )
    access_type = pa.struct(
        [
            pa.field("access_type", pa.string()),
            pa.field("when", simple_when_type),
            pa.field("between", between_type),
        ]
    )
    destination_type = pa.struct(
        [
            pa.field(
                "labels",
                pa.list_(
                    pa.struct(
                        [
                            pa.field("value", pa.string()),
                            pa.field("type", pa.string()),
                        ]
                    )
                ),
            ),
            pa.field("symbols", pa.list_(pa.string())),
            pa.field("from_connector_id", pa.string()),
            pa.field("to_segment_id", pa.string()),
            pa.field("to_connector_id", pa.string()),
            pa.field("final_heading", pa.string()),
        ]
    )
    segment_schema = geo_schema(
        [
            pa.field("id", pa.string(), nullable=False),
            pa.field("names", names_type),
            pa.field("class", pa.string(), nullable=False),
            pa.field("subclass", pa.string()),
            pa.field("subtype", pa.string(), nullable=False),
            pa.field("connectors", pa.list_(connector_reference_type)),
            pa.field(
                "road_surface",
                pa.list_(
                    pa.struct(
                        [
                            pa.field("value", pa.string()),
                            pa.field("between", between_type),
                        ]
                    )
                ),
            ),
            pa.field(
                "road_flags",
                pa.list_(
                    pa.struct(
                        [
                            pa.field("values", pa.list_(pa.string())),
                            pa.field("between", between_type),
                        ]
                    )
                ),
            ),
            pa.field(
                "level_rules",
                pa.list_(
                    pa.struct(
                        [
                            pa.field("value", pa.int32()),
                            pa.field("between", between_type),
                        ]
                    )
                ),
            ),
            pa.field("access_restrictions", pa.list_(access_type)),
            pa.field("speed_limits", pa.list_(speed_limit_type)),
            pa.field(
                "prohibited_transitions",
                pa.list_(
                    pa.struct([pa.field("between", between_type)])
                ),
            ),
            pa.field("routes", pa.list_(route_type)),
            pa.field("destinations", pa.list_(destination_type)),
            pa.field("sources", pa.list_(source_type)),
            pa.field("geometry", pa.binary(), nullable=False),
            pa.field("version", pa.int32()),
            pa.field("bbox", bbox_type, nullable=False),
        ],
        ["LineString"],
    )

    def segment_record(
        feature_id: str,
        road_class: str,
        points: list[tuple[float, float]],
        *,
        name: str | None = None,
        subclass: str | None = None,
        connectors: list[dict[str, object]] | None = None,
        routes: list[dict[str, object]] | None = None,
        speed_limits: list[dict[str, object]] | None = None,
        road_flags: list[dict[str, object]] | None = None,
        level_rules: list[dict[str, object]] | None = None,
        access_restrictions: list[dict[str, object]] | None = None,
        road_surface: list[dict[str, object]] | None = None,
        destinations: list[dict[str, object]] | None = None,
        sources: list[dict[str, object]] | None = None,
    ) -> dict[str, object]:
        return {
            "id": feature_id,
            "names": (
                {"primary": name, "common": {"en": name}} if name else None
            ),
            "class": road_class,
            "subclass": subclass,
            "subtype": "road",
            "connectors": connectors,
            "road_surface": road_surface,
            "road_flags": road_flags,
            "level_rules": level_rules,
            "access_restrictions": access_restrictions,
            "speed_limits": speed_limits,
            "prohibited_transitions": [],
            "routes": routes,
            "destinations": destinations,
            "sources": sources,
            "geometry": line_wkb(points),
            "version": 1,
            "bbox": bounds(points),
        }

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
        segment_rows.append(segment_record(feature_id, road_class, points))

    route_6 = {
        "name": "כביש חוצה ישראל",
        "network": None,
        "ref": "6",
        "symbol": None,
        "wikidata": "Q595131",
        "between": None,
    }
    denied_backward = [
        {
            "access_type": "denied",
            "when": {"heading": "backward", "mode": None, "using": None},
            "between": None,
        }
    ]
    paved = [{"value": "paved", "between": None}]

    def osm_source(record_id: str, between=None) -> list[dict[str, object]]:
        return [
            {
                "property": "",
                "dataset": "OpenStreetMap",
                "license": "ODbL-1.0",
                "record_id": record_id,
                "update_time": "2026-01-01T00:00:00Z",
                "confidence": None,
                "between": between,
            }
        ]

    segment_rows.extend(
        [
            segment_record(
                "road6-north-one",
                "motorway",
                [(34.80, 31.40), (34.80, 31.45), (34.80, 31.50)],
                name="כביש חוצה ישראל",
                connectors=[
                    {"connector_id": "road6-north-start", "at": 0.0},
                    {"connector_id": "road6-interchange", "at": 0.5},
                    {"connector_id": "road6-north-middle", "at": 1.0},
                ],
                routes=[route_6],
                speed_limits=[
                    {
                        "max_speed": {"value": 110, "unit": "km/h"},
                        "when": None,
                        "between": None,
                    }
                ],
                road_flags=[
                    {"values": ["is_bridge"], "between": [0.2, 0.4]}
                ],
                level_rules=[{"value": 1, "between": [0.2, 0.4]}],
                access_restrictions=denied_backward,
                road_surface=paved,
                sources=osm_source("w6001@1"),
            ),
            segment_record(
                "road6-north-two",
                "motorway",
                [(34.80, 31.50), (34.80, 31.60)],
                name="כביש חוצה ישראל",
                connectors=[
                    {"connector_id": "road6-north-middle", "at": 0.0},
                    {"connector_id": "road6-north-end", "at": 1.0},
                ],
                routes=[route_6],
                speed_limits=[
                    {
                        "max_speed": {"value": 120, "unit": "km/h"},
                        "when": None,
                        "between": [0.0, 0.6],
                    },
                    {
                        "max_speed": {"value": 100, "unit": "km/h"},
                        "when": None,
                        "between": [0.6, 1.0],
                    },
                ],
                road_flags=[
                    {
                        "values": ["is_under_construction"],
                        "between": [0.7, 0.9],
                    }
                ],
                access_restrictions=denied_backward,
                road_surface=paved,
                sources=osm_source("w6002@1"),
            ),
            segment_record(
                "road6-south-one",
                "motorway",
                [(34.81, 31.60), (34.81, 31.50)],
                name="כביש חוצה ישראל",
                connectors=[
                    {"connector_id": "road6-south-end", "at": 0.0},
                    {"connector_id": "road6-south-middle", "at": 1.0},
                ],
                routes=[route_6],
                speed_limits=[
                    {
                        "max_speed": {"value": 110, "unit": "km/h"},
                        "when": None,
                        "between": None,
                    }
                ],
                road_flags=[
                    {"values": ["is_tunnel"], "between": [0.3, 0.6]}
                ],
                level_rules=[{"value": -1, "between": [0.3, 0.6]}],
                access_restrictions=denied_backward,
                road_surface=paved,
                sources=osm_source("w6003@1"),
            ),
            segment_record(
                "road6-south-two",
                "motorway",
                [(34.81, 31.50), (34.81, 31.40)],
                name="כביש חוצה ישראל",
                connectors=[
                    {"connector_id": "road6-south-middle", "at": 0.0},
                    {"connector_id": "road6-south-start", "at": 1.0},
                ],
                routes=[{**route_6, "between": [0.0, 0.8]}],
                speed_limits=[
                    {
                        "max_speed": {"value": 90, "unit": "km/h"},
                        "when": None,
                        "between": None,
                    }
                ],
                access_restrictions=denied_backward,
                road_surface=paved,
                sources=osm_source("w6004@1", [0.0, 0.8]),
            ),
            segment_record(
                "road6-connected-ramp",
                "motorway",
                [(34.80, 31.45), (34.75, 31.45)],
                name="Fixture interchange ramp",
                subclass="link",
                connectors=[
                    {"connector_id": "road6-interchange", "at": 0.0},
                    {"connector_id": "road6-ramp-end", "at": 1.0},
                ],
                access_restrictions=denied_backward,
                road_surface=paved,
                sources=osm_source("w6010@1"),
            ),
            segment_record(
                "road6-unconnected-crossing",
                "primary",
                [(34.75, 31.55), (34.85, 31.55)],
                name="Fixture crossing road",
                connectors=[
                    {"connector_id": "road6-crossing-west", "at": 0.0},
                    {"connector_id": "road6-crossing-east", "at": 1.0},
                ],
                road_surface=paved,
                sources=osm_source("w6011@1"),
            ),
        ]
    )
    segment_table = pa.Table.from_pylist(
        segment_rows,
        schema=segment_schema,
    )

    connector_points = {
        "road6-north-start": (34.80, 31.40),
        "road6-interchange": (34.80, 31.45),
        "road6-north-middle": (34.80, 31.50),
        "road6-north-end": (34.80, 31.60),
        "road6-south-end": (34.81, 31.60),
        "road6-south-middle": (34.81, 31.50),
        "road6-south-start": (34.81, 31.40),
        "road6-ramp-end": (34.75, 31.45),
        "road6-crossing-west": (34.75, 31.55),
        "road6-crossing-east": (34.85, 31.55),
    }
    connector_schema = geo_schema(
        [
            pa.field("id", pa.string(), nullable=False),
            pa.field("sources", pa.list_(source_type)),
            pa.field("geometry", pa.binary(), nullable=False),
            pa.field("version", pa.int32()),
            pa.field("bbox", bbox_type, nullable=False),
        ],
        ["Point"],
    )
    connector_table = pa.Table.from_pylist(
        [
            {
                "id": connector_id,
                "sources": osm_source(f"n{index}@1"),
                "geometry": point_wkb(*point),
                "version": 1,
                "bbox": bounds([point]),
            }
            for index, (connector_id, point) in enumerate(
                sorted(connector_points.items()), start=1
            )
        ],
        schema=connector_schema,
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
    canonical_airport_one = [
        (34.45, 32.40),
        (34.65, 32.40),
        (34.65, 32.50),
        (34.45, 32.50),
        (34.45, 32.40),
    ]
    canonical_airport_two = [
        (-73.82, 40.62),
        (-73.74, 40.62),
        (-73.74, 40.68),
        (-73.82, 40.68),
        (-73.82, 40.62),
    ]
    infrastructure_rows = []
    for feature_id, feature_class, surface, points, geometry in (
        (
            "canonical-airport-one",
            "international_airport",
            None,
            canonical_airport_one,
            polygon_wkb(canonical_airport_one),
        ),
        (
            "canonical-airport-two",
            "regional_airport",
            None,
            canonical_airport_two,
            polygon_wkb(canonical_airport_two),
        ),
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
        elif (theme, feature_type) == ("transportation", "connector"):
            table = connector_table
        pq.write_table(table, leaf / "part-00000.parquet", compression="zstd")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
