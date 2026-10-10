"""Generated-data integration: exact regional selection, caps, full endpoints."""
from dataclasses import replace
import json
from pathlib import Path
import sys

from pyspark.sql import functions as F
from shapely import from_wkb
from shapely.geometry import LineString

from overture_lab.config import load_settings
from overture_lab.road_reconstruction import ReconstructionLimits, reconstruct_major_roads
from overture_lab.spark import create_sedona


def main():
    destination = Path(sys.argv[1])
    destination.mkdir(parents=True, exist_ok=True)
    settings = replace(load_settings(), local_cores=2, driver_memory="2g", shuffle_partitions=2)
    spark = create_sedona(settings, "road-reconstruction-fixture")
    try:
        nodes = {"a": (0.5, 0.5), "b": (0.5, 1.5), "c": (0.5, 2.5),
                 "d": (0.5, 3.5), "r1": (0.6, 0.6), "r2": (0.8, 0.8)}
        rows = []
        for identifier, start, end, subclass in [("a", "a", "b", None), ("b", "b", "c", None),
                                                  ("outside", "c", "d", None), ("ramp", "r1", "r2", "link")]:
            a, b = nodes[start], nodes[end]
            rows.append(dict(id=identifier, geometry=LineString([a, b]).wkt,
                bbox=dict(xmin=min(a[0], b[0]), ymin=min(a[1], b[1]), xmax=max(a[0], b[0]), ymax=max(a[1], b[1])),
                subtype="road", **{"class": "motorway"}, subclass=subclass, subclass_rules=None,
                names={"primary": "Fixture Highway"}, routes=[dict(ref="1", wikidata="Q1")],
                access_restrictions=[dict(access_type="denied", when={"heading": "backward"})],
                connectors=[dict(connector_id=start, at=0.0), dict(connector_id=end, at=1.0)]))
        schema = """id string, geometry string, bbox struct<xmin:double,ymin:double,xmax:double,ymax:double>,
            subtype string, class string, subclass string, subclass_rules array<struct<value:string,between:array<double>>>,
            names struct<primary:string>, routes array<struct<ref:string,network:string,wikidata:string,between:array<double>>>,
            connectors array<struct<connector_id:string,at:double>>,
            access_restrictions array<struct<access_type:string,between:array<double>,when:struct<heading:string>>>"""
        segments = spark.createDataFrame(rows, schema).withColumn("geometry", F.expr("ST_SetSRID(ST_GeomFromWKT(geometry),4326)"))
        connector_rows = [dict(id=k, x=v[0], y=v[1], bbox=dict(xmin=v[0], ymin=v[1], xmax=v[0], ymax=v[1])) for k, v in nodes.items()]
        connectors = spark.createDataFrame(connector_rows, "id string, x double, y double, bbox struct<xmin:double,ymin:double,xmax:double,ymax:double>").withColumn("geometry", F.expr("ST_SetSRID(ST_Point(x,y),4326)"))
        areas = spark.sql("""SELECT 'AA' country,
            named_struct('xmin',0D,'ymin',0D,'xmax',2D,'ymax',2D) bbox,
            ST_SetSRID(ST_GeomFromWKT('POLYGON ((0 0,2 0,2 2,0 2,0 0))'),4326) geometry""")
        result = reconstruct_major_roads(spark, segments, connectors, areas,
                                        release="fixture", verify_determinism=True)
        assert result.summary["input_segments"] == 3
        assert result.summary["retained_source_segments"] == 2
        assert result.roads.count() == 1
        assert result.membership.count() == 2
        assert result.diagnostics.where("kind='region_limited'").count() == 1
        geometry = from_wkb(bytes(result.roads.selectExpr("ST_AsBinary(geometry)").first()[0]))
        assert list(geometry.coords) == [(0.5, 0.5), (0.5, 1.5), (0.5, 2.5)]
        assert result.roads.selectExpr("ST_SRID(geometry)").first()[0] == 4326
        assert result.membership.select("source_segment_id").distinct().count() == 2
        try:
            reconstruct_major_roads(spark, segments, connectors, areas, release="fixture",
                                    limits=ReconstructionLimits(segments=1))
        except ValueError as error:
            assert "no sampling" in str(error)
        else:
            raise AssertionError("The regional cap silently truncated or accepted an oversized graph")
        report = dict(result.summary, status="passed", whole_intersecting_segments_verified=True,
                      out_of_region_endpoint_connector_resolved=True, precollection_cap_verified=True,
                      unchanged_source_vertices_verified=True)
        (destination / "report.json").write_text(json.dumps(report, indent=2))
        print(json.dumps(report, indent=2))
    finally:
        spark.stop()


if __name__ == "__main__":
    main()
