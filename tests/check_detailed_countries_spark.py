"""Independent geometry fixtures and exact local/S3 experimental round trips."""
import argparse
from dataclasses import replace
import json
import os
from pathlib import Path
import sys
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
from overture_lab.config import load_settings
from overture_lab.spark import create_sedona
from overture_lab.detailed_countries import (
    DetailedCountryOptions, build_detailed_countries, export_detailed_countries, validate_detailed_countries,
)
from check_surfaces_spark import fixture, expect_failure


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--s3", action="store_true")
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    for k, v in {"MEDIUM_STATE_CODES": '["AA"]', "SMALL_CITIES": '[{"name":"Fixture City","state_code":"AA"}]',
                 "MEDIUM_SAMPLE_LIMIT": "20", "SMALL_SAMPLE_LIMIT": "10", "MAP_FEATURE_LIMIT": "10"}.items():
        os.environ.setdefault(k, v)
    settings = replace(load_settings(), write_derived=True, derived_output_mode="s3" if args.s3 else "local",
                       derived_local_fallback_dir=str(args.output / "exports"))
    spark = create_sedona(settings, "detailed-country-fixtures", overlay_ng=True)
    from pyspark.sql import functions as F
    import shapely
    from shapely.geometry import box, Polygon
    frames = []
    try:
        # The same code can identify distinct representations; neither is merged.
        shapes = {"a": box(0, 0, 2, 2), "a-alt": box(0, 0, 1, 2), "b": box(2, 0, 4, 2),
                  "empty": box(10, 10, 11, 11), "east": box(179, 88, 180, 90),
                  "west": box(-180, 88, -179, 90), "touch": box(4, 0, 5, 2)}
        rows = [(k, "division-" + k, "AA" if k.startswith("a") else k.upper(), g.wkt)
                for k, g in shapes.items()]
        areas = spark.createDataFrame(rows, "id string, division_id string, country string, wkt string").selectExpr(
            "id", "division_id", "country", "'country' AS subtype", "true AS is_territorial", "false AS is_land",
            "named_struct('primary', id) AS names", "ST_SetSRID(ST_GeomFromWKT(wkt), 4326) AS geometry",
            "array(named_struct('dataset', 'synthetic-country', 'record_id', id)) AS sources")
        areas = areas.withColumn("sources", F.from_json(F.to_json("sources"), areas.schema["sources"].dataType))
        countries = areas.withColumn("is_land", F.lit(True)).withColumn("geometry", F.expr(
            "ST_SetSRID(ST_GeomFromWKT('POLYGON ((0 0, 1 0, 1 1, 0 1, 0 0))'), 4326)"))
        # Includes a hole, an island in that hole, overlapping pieces, a coastal
        # protrusion outside the coarse country, an interior lake point retained
        # as landmass, two countries sharing a border, and dateline/polar pieces.
        mainland = Polygon([(0, 0), (3.5, 0), (3.5, 2), (0, 2), (0, 0)],
                           holes=[[(.2, .2), (.2, .8), (.8, .8), (.8, .2), (.2, .2)]])
        land_shapes = [mainland, box(.4, .4, .6, .6), box(1, .5, 4, 1.5), shapes['east'], shapes['west']]
        land = fixture(spark, [(str(i), "land", "land", g.wkt) for i, g in enumerate(land_shapes)] +
                       [("peak", "physical", "peak", "POINT (1 1)")])
        result, report = build_detailed_countries(areas, countries, land, release="fixture", release_uri="generated")
        frames.append(result)
        expected_land = shapely.union_all(land_shapes)
        actual = {}
        for k, geometry in shapes.items():
            pieces = [shapely.from_wkb(bytes(r.wkb)) for r in result.where(F.col("territorial_area_id") == k)
                      .selectExpr("ST_AsBinary(geometry) AS wkb").collect()]
            actual[k] = shapely.union_all(pieces)
            expected = geometry.intersection(expected_land)
            # Boundary-only touches produce no polygon row.
            assert actual[k].symmetric_difference(expected).area < 1e-12, k
            assert abs(sum(g.area for g in pieces) - actual[k].area) < 1e-12, k
        assert actual['a'].contains(shapely.Point(1.8, 1.8))  # recovered beyond coarse land country
        assert actual['a'].contains(shapely.Point(.5, .5))  # island
        assert not actual['a'].contains(shapely.Point(.3, .3))  # source hole
        assert actual['a'].contains(shapely.Point(1.2, 1.2))  # no water subtraction
        assert actual['a'].intersection(actual['b']).area == 0
        assert {r['id'] for r in report['empty_territorial_intersections']} == {'empty', 'touch'}
        assert result.where("country = 'AA'").select('territorial_area_id').distinct().count() == 2
        assert result.where("id = territorial_area_id OR NOT experimental").count() == 0
        assert result.selectExpr('land_sources[0].dataset AS dataset').distinct().first().dataset == 'synthetic'
        for broken, message in ((result.withColumn('bbox', F.expr("named_struct('xmin', 0D, 'xmax', 0D, 'ymin', 0D, 'ymax', 0D)")), "Invalid"),
                                (result.withColumn('id', F.col('territorial_area_id')), "Invalid"),
                                (result.unionByName(result), "Duplicate")):
            expect_failure(lambda: validate_detailed_countries(broken), message)
        expect_failure(lambda: build_detailed_countries(areas.where("id <> 'a'"), countries, land,
                       release="fixture", release_uri="generated"), "Missing territorial")
        invalid = F.expr("ST_SetSRID(ST_GeomFromWKT('POLYGON ((0 0, 1 1, 0 1, 1 0, 0 0))'), 4326)")
        expect_failure(lambda: build_detailed_countries(areas, countries, land.withColumn('geometry', invalid),
                       release="fixture", release_uri="generated"), "Invalid experimental physical land")
        expect_failure(lambda: build_detailed_countries(areas.withColumn('geometry', invalid), countries, land,
                       release="fixture", release_uri="generated"), "Invalid experimental territorial")
        expect_failure(lambda: build_detailed_countries(areas, countries, land, release="fixture", release_uri="generated",
                       options=DetailedCountryOptions(max_tile_coordinates=1)), "'tile_id':")
        one_area, one_country = areas.where("id = 'a'"), countries.where("id = 'a'")
        overlapping = fixture(spark, [(str(i), "land", "land", box(.1, .1, .4, .4).wkt) for i in range(5)])
        expect_failure(lambda: build_detailed_countries(one_area, one_country, overlapping,
                       release="fixture", release_uri="generated", options=DetailedCountryOptions(max_tile_coordinates=20)),
                       "physical land tile union coordinate guard")
        hexagon = "POLYGON ((0.2 0.1, 0.3 0.1, 0.4 0.2, 0.3 0.3, 0.2 0.3, 0.1 0.2, 0.2 0.1))"
        dense_area = one_area.withColumn('geometry', F.expr(f"ST_SetSRID(ST_GeomFromWKT('{hexagon}'), 4326)"))
        dense_land = fixture(spark, [("hexagon", "land", "land", hexagon)])
        expect_failure(lambda: build_detailed_countries(dense_area, one_country, dense_land,
                       release="fixture", release_uri="generated", options=DetailedCountryOptions(max_tile_coordinates=12)),
                       "country/land intersection coordinate guard")
        empty, empty_report = build_detailed_countries(areas, countries, land.limit(0), release="fixture", release_uri="generated")
        frames.append(empty)
        assert empty.count() == 0 and len(empty_report['empty_territorial_intersections']) == len(shapes)
        with patch('overture_lab.outputs._promote_single_part') as promote:
            assert export_detailed_countries(result, spark, replace(settings, write_derived=False))['status'] == 'dry-run'
            promote.assert_not_called()
        report['export'] = export_detailed_countries(result, spark, settings)
        assert report['export']['exact_round_trip']
        fake_s3 = replace(settings, derived_output_mode='s3', derived_output_uri='s3a://fixture/output')
        with patch('overture_lab.outputs._s3_permission_probe', return_value=False):
            expect_failure(lambda: export_detailed_countries(result, spark, fake_s3), 'denied')
        with patch('overture_lab.outputs._s3_permission_probe', return_value=True), patch(
                'overture_lab.outputs._promote_single_part', side_effect=OSError('injected interruption')):
            expect_failure(lambda: export_detailed_countries(result, spark, fake_s3), 'partial prefix')
        report.update(status='passed', checks=['exact_intersection', 'recovered_coast', 'island_hole', 'overlapping_land',
            'tile_seams', 'country_border', 'distinct_representations', 'empty_and_touch', 'dateline_poles',
            'no_inland_water_subtraction', 'missing_territory', 'invalid_geometry', 'coordinate_guard',
            'local_or_s3_round_trip', 'disabled', 'denied_write', 'interrupted_write'])
        (args.output / 'detailed-country-report.json').write_text(json.dumps(report, indent=2))
        print(json.dumps(report, indent=2), flush=True)
    finally:
        for frame in frames:
            frame.unpersist()
        spark.stop()


if __name__ == '__main__':
    main()
