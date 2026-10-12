#!/usr/bin/env python3
"""Sedona fixtures for complete city-road selection and bounded map display."""

import json
import os
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from overture_lab.city_roads import prepare_city_area, resolve_city, select_city_roads, city_roads_map
from overture_lab.config import load_settings
from overture_lab.spark import create_sedona


def raises(message, action):
    try:
        action()
    except ValueError as exc:
        assert message in str(exc), exc
    else:
        raise AssertionError(f"Expected ValueError containing {message!r}")


def check(spark):
    import shapely
    from pyproj import Geod
    from pyspark.sql import functions as F

    divisions = spark.createDataFrame([
        ("city", "IL", "locality", "אופקים", {"en": "Ofakim", "he": "אופקים"}, [("Ofaqim",)]),
        ("duplicate-a", "IL", "locality", "Duplicate", {}, []),
        ("duplicate-b", "IL", "locality", "Duplicate", {}, []),
        ("no-area", "IL", "locality", "Missing boundary", {}, []),
        ("foreign", "AA", "locality", "Ofakim", {}, []),
        ("region", "IL", "region", "Ofakim", {}, []),
    ], "id string, country string, subtype string, primary string, common map<string,string>, rules array<struct<value:string>>"
    ).selectExpr("id", "country", "subtype", "named_struct('primary', primary, 'common', common, 'rules', rules) AS names")
    # A main square plus a detached land polygon. The territorial polygon is ignored.
    main_wkt = "POLYGON ((34.6 31.3, 34.61 31.3, 34.61 31.31, 34.6 31.31, 34.6 31.3))"
    areas = spark.createDataFrame([
        ("city", True, main_wkt),
        ("city", True, "POLYGON ((34.65 31.3, 34.651 31.3, 34.651 31.301, 34.65 31.301, 34.65 31.3))"),
        ("city", False, "POLYGON ((34 31, 35 31, 35 32, 34 32, 34 31))"),
    ], "division_id string, is_land boolean, wkt string").selectExpr(
        "division_id", "is_land", "ST_GeomFromWKT(wkt) AS geometry")
    for name in ("Ofakim", "אופקים", "Ofaqim", " ofAKim "):
        assert resolve_city(divisions, city_name=name, country_code="il").id == "city"
    raises("found 0", lambda: resolve_city(divisions, city_name="Absent", country_code="IL"))
    raises("duplicate-a", lambda: resolve_city(divisions, city_name="Duplicate", country_code="IL"))
    assert resolve_city(divisions, city_name="Ignored", country_code="IL", division_id="duplicate-b").id == "duplicate-b"
    raises("found 0", lambda: resolve_city(divisions, city_name="Ofakim", country_code="AA", division_id="city"))
    minimal = divisions.selectExpr("id", "country", "subtype", "named_struct('primary', names.primary) AS names")
    assert resolve_city(minimal, city_name="אופקים", country_code="IL").id == "city"
    raises("No land boundary", lambda: prepare_city_area(divisions, areas,
        city_name="Missing boundary", country_code="IL"))
    for invalid in (-1, float("nan"), float("inf"), True):
        raises("BUFFER_METERS", lambda: prepare_city_area(divisions, areas,
            city_name="Ofakim", country_code="IL", buffer_m=invalid))
    invalid_areas = areas.withColumn("geometry", F.expr("ST_GeomFromWKT('POLYGON ((0 0, 1 1, 0 1, 1 0, 0 0))')"))
    raises("Invalid", lambda: prepare_city_area(divisions, invalid_areas, city_name="Ofakim", country_code="IL"))

    area = prepare_city_area(divisions, areas, city_name="Ofakim", country_code="IL", buffer_m=2000)
    zero = prepare_city_area(divisions, areas, city_name="Ofakim", country_code="IL", buffer_m=0)
    def shape(frame):
        return shapely.from_wkb(bytes(frame.selectExpr("ST_AsBinary(geometry) AS wkb").first().wkb))
    original, buffered = shape(area.boundary), shape(area.search_area)
    assert original.geom_type == "MultiPolygon" and len(original.geoms) == 2
    assert original.equals(shape(zero.search_area))
    assert buffered.covers(original)
    # Independent geodesic oracle: points 1.9 km and 2.1 km due west of the
    # main square's western edge should straddle its 2 km buffer.
    geod = Geod(ellps="WGS84")
    for distance, expected in ((1900, True), (2100, False)):
        lon, lat, _ = geod.fwd(34.6, 31.305, 270, distance)
        assert buffered.covers(shapely.Point(lon, lat)) == expected

    b = area.bounds
    false_hit = f"LINESTRING ({b.xmin} {b.ymin}, {b.xmin + 0.000001} {b.ymin + 0.000001})"
    segments = spark.createDataFrame([
        ("crossing", "road", "primary", "LINESTRING (34.5 31.305, 34.8 31.305)"),
        ("inside", "road", "residential", "LINESTRING (34.602 31.302, 34.607 31.308)"),
        ("path", "road", "footway", "LINESTRING (34.602 31.302, 34.607 31.308)"),
        ("rail", "rail", "primary", "LINESTRING (34.602 31.302, 34.607 31.308)"),
        ("unknown", "road", "unknown", "LINESTRING (34.602 31.302, 34.607 31.308)"),
        ("outside", "road", "primary", "LINESTRING (35 32, 35.1 32.1)"),
        ("bbox-only", "road", "service", false_hit),
    ], "id string, subtype string, class string, wkt string").selectExpr(
        "id", "subtype", "class", "ST_GeomFromWKT(wkt) AS geometry",
        "named_struct('primary', CAST(NULL AS STRING)) AS names", "'retained' AS source_attribute"
    ).withColumn("bbox", F.expr("named_struct('xmin', ST_XMin(geometry), 'ymin', ST_YMin(geometry), "
                               "'xmax', ST_XMax(geometry), 'ymax', ST_YMax(geometry))"))
    def ids(frame):
        return {row.id for row in frame.select("id").collect()}
    roads = select_city_roads(segments, area).cache()
    assert ids(roads) == {"crossing", "inside"}
    assert roads.columns == segments.columns
    assert roads.select("source_attribute").first()[0] == "retained"
    assert roads.where("id = 'crossing'").selectExpr("ST_AsText(geometry)").first()[0] == "LINESTRING (34.5 31.305, 34.8 31.305)"
    assert ids(select_city_roads(segments, area, road_classes=None)) == {"crossing", "inside", "path", "unknown"}
    assert ids(select_city_roads(segments, area, road_classes=("footway",))) == {"path"}
    assert ids(select_city_roads(segments, zero)) == {"crossing", "inside"}
    empty = select_city_roads(segments, area, road_classes=())
    assert empty.count() == 0
    raises("ROAD_CLASSES", lambda: select_city_roads(segments, area, road_classes="primary"))
    raises("2 road segments", lambda: city_roads_map(roads, area, feature_limit=1))
    for selected, expected in ((roads, 2), (empty, 0)):
        deck, controls = city_roads_map(selected, area, feature_limit=2)
        document = json.loads(deck.to_json())
        road_layers = [layer for layer in document["layers"] if layer["id"].startswith("city-roads-class-")]
        assert sum(len(layer["data"]["features"]) for layer in road_layers) == expected
        assert len(controls["groups"]) == 2 + len(road_layers)
        assert all(layer["data"]["features"][0]["properties"]["name"] == "Unnamed road" for layer in road_layers)
    roads.unpersist()
    print("PASS: city names/IDs, ambiguity, missing/invalid boundaries, metric and zero buffers, "
          "crossing roads, bbox false positives, classes, original fields, empty maps, display cap")


def main():
    defaults = {
        "MEDIUM_STATE_CODES": '["IL"]', "SMALL_CITIES": '[{"name":"Ofakim","state_code":"IL"}]',
        "MEDIUM_SAMPLE_LIMIT": "20", "SMALL_SAMPLE_LIMIT": "10", "MAP_FEATURE_LIMIT": "5",
        "SEDONA_SPARK_LOCAL_CORES": "2", "SEDONA_SPARK_DRIVER_MEMORY": "4g",
        "SEDONA_SPARK_PARTITIONS": "4", "SEDONA_SPARK_LOCAL_DIR": "/tmp/spark-city-roads-check",
        "SEDONA_SCRATCH_DIR": "/tmp", "SEDONA_SCRATCH_BUDGET_GB": "20", "SEDONA_SCRATCH_RESERVE_GB": "2",
        "DERIVED_LOCAL_FALLBACK_DIR": "/tmp/derived",
    }
    for key, value in defaults.items():
        os.environ.setdefault(key, value)
    spark = create_sedona(load_settings(), "city-roads-fixtures")
    try:
        check(spark)
    finally:
        spark.stop()


if __name__ == "__main__":
    main()
