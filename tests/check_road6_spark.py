#!/usr/bin/env python3
"""Focused Sedona check for Road 6 route ranges and connector topology."""

from __future__ import annotations

import os
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from overture_lab.config import load_settings  # noqa: E402
from overture_lab.spark import create_sedona  # noqa: E402
from overture_lab.transportation_case import _route_topology  # noqa: E402
from pyspark.sql import functions as F  # noqa: E402


def main() -> int:
    defaults = {
        "MEDIUM_STATE_CODES": '["AA"]',
        "SMALL_CITIES": '[{"name":"Fixture City","state_code":"AA"}]',
        "MEDIUM_SAMPLE_LIMIT": "20",
        "SMALL_SAMPLE_LIMIT": "10",
        "MAP_FEATURE_LIMIT": "5",
        "SEDONA_SPARK_LOCAL_CORES": "2",
        "SEDONA_SPARK_DRIVER_MEMORY": "4g",
        "SEDONA_SPARK_PARTITIONS": "4",
        "SEDONA_SPARK_LOCAL_DIR": "/tmp/spark-road6-check",
        "SEDONA_SCRATCH_DIR": "/tmp",
        "SEDONA_SCRATCH_BUDGET_GB": "20",
        "SEDONA_SCRATCH_RESERVE_GB": "2",
        "DERIVED_LOCAL_FALLBACK_DIR": "/tmp/derived",
    }
    for name, value in defaults.items():
        os.environ.setdefault(name, value)

    spark = create_sedona(load_settings(), "road6-integration-check")
    route_type = (
        "ARRAY<STRUCT<name:STRING,network:STRING,ref:STRING,symbol:STRING,"
        "wikidata:STRING,between:ARRAY<DOUBLE>>>"
    )
    segments = spark.sql(
        f"""
        SELECT * FROM VALUES
          ('north-1', array(named_struct(
            'name', 'Road 6', 'network', cast(null as string), 'ref', '6',
            'symbol', cast(null as string), 'wikidata', 'Q595131',
            'between', cast(null as array<double>))),
           array(named_struct('connector_id', 'n0', 'at', 0D),
                 named_struct('connector_id', 'n1', 'at', 1D)),
           ST_SetSRID(ST_GeomFromWKT('LINESTRING (34.80 31.40, 34.80 31.50)'), 4326)),
          ('north-2', array(named_struct(
            'name', 'Road 6', 'network', cast(null as string), 'ref', '6',
            'symbol', cast(null as string), 'wikidata', 'Q595131',
            'between', cast(null as array<double>))),
           array(named_struct('connector_id', 'n1', 'at', 0D),
                 named_struct('connector_id', 'n2', 'at', 1D)),
           ST_SetSRID(ST_GeomFromWKT('LINESTRING (34.80 31.50, 34.80 31.60)'), 4326)),
          ('south-1', array(named_struct(
            'name', 'Road 6', 'network', cast(null as string), 'ref', '6',
            'symbol', cast(null as string), 'wikidata', 'Q595131',
            'between', cast(null as array<double>))),
           array(named_struct('connector_id', 's2', 'at', 0D),
                 named_struct('connector_id', 's1', 'at', 1D)),
           ST_SetSRID(ST_GeomFromWKT('LINESTRING (34.81 31.60, 34.81 31.50)'), 4326)),
          ('south-2', array(named_struct(
            'name', 'Road 6', 'network', cast(null as string), 'ref', '6',
            'symbol', cast(null as string), 'wikidata', 'Q595131',
            'between', array(0D, 0.8D))),
           array(named_struct('connector_id', 's1', 'at', 0D),
                 named_struct('connector_id', 's0', 'at', 1D)),
           ST_SetSRID(ST_GeomFromWKT('LINESTRING (34.81 31.50, 34.81 31.40)'), 4326)),
          ('ramp', cast(array() as {route_type}),
           array(named_struct('connector_id', 'n1', 'at', 0D),
                 named_struct('connector_id', 'r0', 'at', 1D)),
           ST_SetSRID(ST_GeomFromWKT('LINESTRING (34.80 31.50, 34.75 31.50)'), 4326)),
          ('crossing', cast(array() as {route_type}),
           array(named_struct('connector_id', 'x0', 'at', 0D),
                 named_struct('connector_id', 'x1', 'at', 1D)),
           ST_SetSRID(ST_GeomFromWKT('LINESTRING (34.75 31.55, 34.85 31.55)'), 4326))
        AS fixture(id, routes, connectors, geometry)
        """
    )
    road_6 = segments.where(
        F.expr(
            "exists(routes, route -> "
            "route.ref = '6' AND route.wikidata = 'Q595131')"
        )
    )
    assert road_6.count() == 4

    rules = road_6.select("id", "geometry", F.explode("routes").alias("route"))
    assert rules.count() == 4
    assert rules.where("route.between IS NOT NULL").count() == 1
    lengths = (
        rules.select(
            "id",
            F.expr("ST_LengthSpheroid(geometry)").alias("full_m"),
            F.when(F.col("route.between").isNull(), F.col("geometry"))
            .otherwise(
                F.expr(
                    "ST_LineSubstring(geometry, "
                    "route.between[0], route.between[1])"
                )
            )
            .alias("scoped_geometry"),
        )
        .withColumn("scoped_m", F.expr("ST_LengthSpheroid(scoped_geometry)"))
    )
    totals = lengths.agg(
        F.sum("full_m").alias("full_m"), F.sum("scoped_m").alias("scoped_m")
    ).first()
    assert totals.scoped_m < totals.full_m

    connector_coordinates = {
        "n0": (34.80, 31.40),
        "n1": (34.80, 31.50),
        "n2": (34.80, 31.60),
        "s2": (34.81, 31.60),
        "s1": (34.81, 31.50),
        "s0": (34.81, 31.40),
    }
    connectors = spark.createDataFrame(
        [
            (connector_id, f"POINT ({longitude} {latitude})")
            for connector_id, (longitude, latitude) in connector_coordinates.items()
        ],
        "connector_id string, wkt string",
    ).select(
        "connector_id",
        F.expr("ST_SetSRID(ST_GeomFromWKT(wkt), 4326)").alias(
            "connector_geometry"
        ),
    )
    references = road_6.select(
        F.col("id").alias("segment_id"),
        "geometry",
        F.expr("ST_Y(ST_StartPoint(geometry))").alias("start_lat"),
        F.expr("ST_Y(ST_EndPoint(geometry))").alias("end_lat"),
        F.explode("connectors").alias("connector"),
    ).select(
        "segment_id",
        "geometry",
        "start_lat",
        "end_lat",
        F.col("connector.connector_id").alias("connector_id"),
        F.col("connector.at").alias("at"),
    )
    joined = references.join(connectors, "connector_id", "left")
    assert joined.where("connector_geometry IS NULL").count() == 0
    assert joined.where(
        "NOT ST_Intersects(geometry, connector_geometry)"
    ).count() == 0

    topology = _route_topology(
        [
            row.asDict(recursive=True)
            for row in references.select(
                "segment_id", "connector_id", "at", "start_lat", "end_lat"
            ).collect()
        ]
    )
    assert sorted(item["segment_count"] for item in topology.components) == [2, 2]
    assert {item["direction"] for item in topology.components} == {
        "northbound",
        "southbound",
    }

    crossing_intersects = (
        segments.where("id = 'crossing'")
        .select(F.col("geometry").alias("crossing_geometry"))
        .crossJoin(
            road_6.where("id = 'north-2'").select(
                F.col("geometry").alias("route_geometry")
            )
        )
        .selectExpr(
            "ST_Intersects(crossing_geometry, route_geometry) AS intersects"
        )
        .first()
        .intersects
    )
    assert crossing_intersects
    crossing_connectors = {
        row.connector.connector_id
        for row in segments.where("id = 'crossing'").select(
            F.explode("connectors").alias("connector")
        ).collect()
    }
    north_connectors = {
        row.connector.connector_id
        for row in road_6.where("id = 'north-2'").select(
            F.explode("connectors").alias("connector")
        ).collect()
    }
    assert crossing_connectors.isdisjoint(north_connectors)
    spark.stop()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
