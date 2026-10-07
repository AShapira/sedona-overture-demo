"""Generated maritime fixtures, real Sedona selection/export, and notebook smoke."""

import argparse
from dataclasses import replace
import json
import os
from pathlib import Path
import sys
import tempfile
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
from overture_lab.config import load_settings
from overture_lab.ports import discover_ports, export_ports, ports_map, validate_ports
from overture_lab.regions import Bounds, bbox_overlap, exact_intersection
from overture_lab.spark import create_sedona
from overture_lab.visualize import offline_deck_display


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    settings = replace(load_settings(), local_cores=2, shuffle_partitions=4, driver_memory="4g")
    spark = create_sedona(settings, "ports-generated-validation")
    from pyspark.sql import functions as F

    def fixture(rows):
        frame = spark.createDataFrame(rows, "id string, class string, subtype string, label string, wkt string, tags map<string,string>")
        return frame.selectExpr("id", "class", "subtype", "named_struct('primary', label) AS names",
                                "tags AS source_tags", "ST_SetSRID(ST_GeomFromWKT(wkt),4326) AS geometry",
                                "array(named_struct('dataset', 'generated', 'record_id', id)) AS sources").withColumn(
            "bbox", F.expr("named_struct('xmin',ST_XMin(geometry),'xmax',ST_XMax(geometry),"
                           "'ymin',ST_YMin(geometry),'ymax',ST_YMax(geometry))"))

    try:
        region_wkt = "POLYGON ((0 0, 10 0, 10 10, 0 10, 0 0), (4 4, 4 6, 6 6, 6 4, 4 4))"
        region = spark.sql(f"SELECT ST_GeomFromWKT('{region_wkt}') AS geometry")
        land = fixture([
            ("marina", "marina", "recreation", "M", "POINT (1 1)", None),
            ("naval", "naval_base", "military", None, "POLYGON ((1 1,2 1,2 2,1 2,1 1))", None),
            ("tagged", "industrial", "developed", "Works", "POINT (3 3)", {"industrial": "port"}),
            ("name", "industrial", "developed", "Example Container Terminal", "POINT (2 3)", None),
            ("hebrew", "industrial", "developed", "נמל בדיקה", "POINT (2 2)", None),
            ("arabic", "industrial", "developed", "ميناء اختبار", "POINT (2 2)", None),
            ("generic", "industrial", "developed", "Industrial estate", "POINT (2 2)", None),
            ("airport", "airfield", "military", "Airport", "POINT (2 2)", None),
            ("newport", "industrial", "developed", "Newport", "POINT (2 2)", None),
            ("outside", "marina", "recreation", "Outer", "POINT (20 20)", None),
            ("hole", "marina", "recreation", "Hole", "POINT (5 5)", None),
            ("denied", "industrial", "developed", "Works", "POINT (2 2)", {"harbour": "no"}),
        ])
        infra = fixture([
            ("pier", "pier", "pier", None, "LINESTRING (-1 1, 2 1)", None),
            ("quay", "quay", "quay", None, "LINESTRING (1 2, 2 2)", None),
            ("breakwater", "breakwater", "water", None, "LINESTRING (1 3, 2 3)", None),
            ("ferry", "ferry_terminal", "transit", None, "POINT (0 1)", None),
            ("bus", "bus_stop", "transit", "Marina station", "POINT (1 1)", None),
        ])
        water = fixture([("dock", "dock", "water", None, "POLYGON ((7 7,8 7,8 8,7 8,7 7))", None)])
        places = fixture([
            ("marina", None, None, "Named marina", "POINT (3 1)", None),
            ("legacy", None, None, "Legacy", "POINT (3 1)", None),
            ("alternate", None, None, "Alternate", "POINT (3 1)", None),
            ("aviation", None, None, "נמל התעופה", "POINT (3 1)", None),
        ]).withColumn("taxonomy", F.expr("named_struct('primary', CASE WHEN id='marina' THEN 'marina' ELSE 'balloon_port' END,"
                                        "'hierarchy', array('travel_and_transportation'),"
                                        "'alternates', CASE WHEN id='alternate' THEN array('pier') ELSE array() END)"))
        places = places.withColumn("categories", F.expr("named_struct('primary', CASE WHEN id='legacy' THEN 'ports_and_harbors' END,"
                                                       "'alternate', cast(array() as array<string>))"))
        frames = []
        for theme, kind, data in (("base", "land_use", land), ("base", "infrastructure", infra),
                                  ("base", "water", water), ("places", "place", places)):
            selected = discover_ports(bbox_overlap(data, Bounds(0, 0, 10, 10)), theme=theme,
                                      feature_type=kind, release="fixture")
            frames.append(exact_intersection(selected, region.union(region)))
        ports = frames[0]
        for frame in frames[1:]:
            ports = ports.unionByName(frame)
        ports = ports.union(frames[0]).dropDuplicates(["source_theme", "source_type", "id"]).cache()
        assert validate_ports(ports) == 14
        rows = {(r.source_type, r.id): r for r in ports.collect()}
        assert rows["land_use", "name"].evidence_level == "candidate"
        assert rows["land_use", "tagged"].evidence_level == "explicit"
        assert rows["infrastructure", "pier"].feature_role == "component"
        assert rows["place", "alternate"].feature_role == "component"
        assert json.loads(rows["land_use", "tagged"].source_attributes_json)["source_tags"] == {"industrial": "port"}
        assert ports.where("id='pier'").selectExpr("ST_XMin(geometry)").first()[0] == -1
        # Old-only and new-only schemas, absent optional fields and null rule arrays.
        for fields in (("taxonomy",), ("categories",)):
            assert discover_ports(places.drop(*fields), theme="places", feature_type="place", release="fixture").count() > 0
        assert discover_ports(land.select("id", "class", "geometry"), theme="base", feature_type="land_use", release="fixture").count() == 4
        basin = water.withColumn("class", F.lit("water")).withColumn("source_tags", F.expr("map('seamark:type','harbour_basin')"))
        assert discover_ports(basin, theme="base", feature_type="water", release="fixture").first().feature_role == "component"
        multilingual = land.limit(1).withColumn("names", F.expr("named_struct('primary', 'Unknown', 'common', map('en','Harbor'), 'rules', cast(NULL as array<struct<value:string>>))"))
        assert "name=Harbor" in discover_ports(multilingual, theme="base", feature_type="land_use", release="fixture").first().match_evidence
        deck, controls = ports_map(ports, region, feature_limit=14)
        assert len(controls["groups"]) == 4
        mapped = [feature for layer in json.loads(deck.to_json())["layers"][1:]
                  for feature in layer["data"]["features"]]
        assert {feature["properties"]["source_id"] for feature in mapped} == {r.id for r in ports.select("id").collect()}
        assert "{source_id}" in deck._tooltip["text"]
        for layer in json.loads(deck.to_json())["layers"][1:]:
            assert layer["pointRadiusUnits"] == "pixels"
            assert layer["pointRadiusMaxPixels"] == 6
        assert sum(len(layer.get("data", {}).get("features", [])) for layer in json.loads(deck.to_json())["layers"][1:]) == 14
        assert "ports-components" in offline_deck_display(deck, controls=controls).data
        empty_deck, empty_controls = ports_map(ports.limit(0), region, feature_limit=14)
        assert "0 source features" in empty_controls["description"]
        for geometry in ("NULL", "ST_GeomFromWKT('POINT EMPTY')", "ST_GeomFromWKT('POLYGON ((0 0,2 2,2 0,0 2,0 0))')"):
            try:
                validate_ports(ports.limit(1).withColumn("geometry", F.expr(geometry)))
                raise AssertionError("Invalid geometry must fail")
            except ValueError:
                pass
        try:
            ports_map(ports, region, feature_limit=13)
            raise AssertionError("Map must refuse truncation")
        except ValueError as exc:
            assert "MAP_FEATURE_LIMIT" in str(exc)
        with tempfile.TemporaryDirectory(dir=args.output) as temp:
            target = Path(temp) / "ports.geoparquet"
            export = export_ports(ports, spark, settings, target)
            restored = spark.read.format("geoparquet").load(str(target))
            columns = [F.expr("ST_AsBinary(geometry)").alias("geometry"),
                       F.to_json(F.struct(*[F.col(c) for c in ports.columns if c != "geometry"])).alias("attributes")]
            before, after = ports.select(*columns), restored.select(*columns)
            assert before.exceptAll(after).count() == after.exceptAll(before).count() == 0
            original = target.read_bytes()
            try:
                export_ports(ports.limit(0), spark, settings, target)
                raise AssertionError("Must refuse overwrite")
            except FileExistsError:
                assert target.read_bytes() == original
            empty = export_ports(ports.limit(0), spark, settings, target, overwrite=True)
            assert empty["row_count"] == spark.read.format("geoparquet").load(str(target)).count() == 0
            assert sorted(p.name for p in Path(temp).iterdir()) == ["ports.geoparquet"]
        # Run the actual notebook from top to bottom against a generated release.
        with tempfile.TemporaryDirectory(prefix="ports-release-") as release:
            for theme, kind, data in (("base", "land_use", land), ("base", "infrastructure", infra),
                                      ("base", "water", water), ("places", "place", places)):
                data.write.format("geoparquet").save(f"{release}/theme={theme}/type={kind}")
            area = region.withColumn("country", F.lit("AA")).withColumn("subtype", F.lit("country")).withColumn(
                "is_territorial", F.lit(True)).withColumn("bbox", F.expr("named_struct('xmin',0D,'xmax',10D,'ymin',0D,'ymax',10D)"))
            area.write.format("geoparquet").save(f"{release}/theme=divisions/type=division_area")
            spark.stop()
            import nbformat
            from nbclient import NotebookClient
            notebook = nbformat.read(Path(__file__).resolve().parents[1] / "notebooks/16_region_ports.ipynb", as_version=4)
            target = args.output / "notebook_ports.geoparquet"
            for cell in notebook.cells:
                if cell.cell_type == "code" and "REGION_PRESET =" in cell.source:
                    cell.source = cell.source.replace(
                        'OUTPUT_PATH = Path(overture_lab.__file__).resolve().parents[2] / "exports/region_ports.geoparquet"',
                        f"OUTPUT_PATH = Path({str(target)!r})")
                    cell.source = cell.source.replace('BASEMAP_MODE = "configured"', 'BASEMAP_MODE = "none"')
            with patch.dict(os.environ, {"OVERTURE_RELEASE_URI": release, "MEDIUM_STATE_CODES": '["AA"]',
                                         "LARGE_REGION_STATE_CODES": "", "SMALL_CITIES": '[{"name":"Fixture","state_code":"AA"}]',
                                         "MAP_FEATURE_LIMIT": "20", "SMALL_SAMPLE_LIMIT": "100",
                                         "SEDONA_SPARK_LOCAL_CORES": "2", "SEDONA_SPARK_PARTITIONS": "4", "SEDONA_SPARK_DRIVER_MEMORY": "4g"}):
                NotebookClient(notebook, timeout=180, kernel_name="python3").execute()
            nbformat.write(notebook, args.output / "16_region_ports.executed.ipynb")
            import geopandas as gpd
            assert len(gpd.read_parquet(target)) == 14
        report = {"status": "passed", "features": 14, "exact_round_trip": True, "empty_export": True,
                  "no_overwrite": True, "map_features": 14, "notebook": "passed"}
        (args.output / "report.json").write_text(json.dumps(report, indent=2) + "\n")
        print(json.dumps(report))
    finally:
        spark.stop()


if __name__ == "__main__":
    main()
