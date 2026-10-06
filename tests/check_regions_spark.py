#!/usr/bin/env python3
"""Container integration check for multi-boundary filtering and deduplication."""

from __future__ import annotations

import os
from dataclasses import replace
from pathlib import Path
import sys
from unittest.mock import patch


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from overture_lab.config import load_settings  # noqa: E402
from overture_lab.regions import (  # noqa: E402
    Bounds, bbox_overlap, exact_intersection, resolve_scale_regions,
)
from overture_lab.spark import create_sedona  # noqa: E402
from overture_lab.region_overview import prepare_region_overview  # noqa: E402


def check_presets(spark, candidates):
    """Exercise the real resolver against overlapping, added, and water areas."""
    import shapely
    from pyspark.sql import functions as F
    with patch.dict(os.environ, {
        "MEDIUM_STATE_CODES": '["AA","BB"]',
        "LARGE_REGION_STATE_CODES": '["AA","BB","CC"]',
        "SMALL_CITIES": '[{"name":"City A","state_code":"AA"}]',
    }):
        medium_settings = load_settings(include_territorial_waters=False)
        large_settings = load_settings(region_preset="large", include_territorial_waters=False)
    divisions = spark.sql("""
        SELECT 'city-a' AS id, 'AA' AS country, 'locality' AS subtype,
               'city' AS class,
               named_struct('common', map('en', 'City A')) AS names
    """)
    areas = spark.createDataFrame(
        [
            ('a', 'country-a', 'AA', 'country', True, False, 0., 0., 2., 2.),
            ('b', 'country-b', 'BB', 'country', True, True, 1., 1., 3., 3.),
            ('c', 'country-c', 'CC', 'country', True, False, 10., 10., 12., 12.),
            ('a-territorial', 'country-a', 'AA', 'country', False, True, -1., -1., 2., 2.),
            ('c-territorial', 'country-c', 'CC', 'country', False, True, 9., 9., 14., 14.),
            ('d-land-only', 'country-d', 'DD', 'country', True, False, 20., 20., 21., 21.),
            ('city', 'city-a', 'AA', 'locality', True, False, 0., 0., 1., 1.),
            ('city-territorial', 'city-a', 'AA', 'locality', False, True, -1., -1., 1., 1.),
        ],
        'id string, division_id string, country string, subtype string, '
        'is_land boolean, is_territorial boolean, xmin double, ymin double, xmax double, ymax double',
    ).selectExpr(
        'id', 'division_id', 'country', 'subtype', 'is_land', 'is_territorial',
        "named_struct('common', map('en', id), 'primary', id) AS names",
        "named_struct('xmin', xmin, 'ymin', ymin, 'xmax', xmax, 'ymax', ymax) AS bbox",
        'ST_PolygonFromEnvelope(xmin, ymin, xmax, ymax) AS geometry',
    )
    # Tiny bends would disappear under the previous country/city tolerances.
    areas = areas.withColumn("geometry", F.when(
        F.col("id") == "a",
        F.expr("ST_GeomFromWKT('POLYGON ((0 0, 0.0001 0.00002, 0.0002 0, 2 0, 2 2, 0 2, 0 0))')"),
    ).when(
        F.col("id") == "city",
        F.expr("ST_GeomFromWKT('POLYGON ((0 0, 0.000001 0.0000002, 0.000002 0, 1 0, 1 1, 0 1, 0 0))')"),
    ).otherwise(F.col("geometry")))
    originals = {
        row.division_id: shapely.from_wkb(bytes(row.wkb))
        for row in areas.where("is_land").selectExpr(
            "division_id", "ST_AsBinary(geometry) AS wkb"
        ).collect()
    }
    def fixture_read(spark, settings, theme, feature_type):
        assert theme == 'divisions'
        return divisions if feature_type == 'division' else areas

    with patch('overture_lab.regions.read_type', side_effect=fixture_read):
        medium = resolve_scale_regions(spark, medium_settings)
        large = resolve_scale_regions(spark, large_settings)
        assert {r.country for r in medium.medium.collect()} == {'AA', 'BB'}
        assert {r.country for r in large.medium.collect()} == {'AA', 'BB', 'CC'}
        assert medium.small.collect() == large.small.collect()
        assert medium.small_bounds == large.small_bounds
        assert medium.small_division_ids == large.small_division_ids == ('city-a',)
        overview_settings = replace(large_settings, map_feature_limit=20)
        overview = prepare_region_overview(large, overview_settings)
        assert set(overview.large.country) == {'AA', 'BB', 'CC'}
        assert set(overview.medium.country) == {'AA', 'BB'}
        assert set(overview.cities.division_id) == {'city-a'}
        assert overview.markers[0]['display_name'] == 'City A'
        assert overview.markers[0]['country'] == 'AA'
        assert len(overview.markers) == 1
        assert sum(overview.counts.values()) == 7
        for frame in (overview.large, overview.medium):
            for row in frame.itertuples():
                original = originals['country-' + row.country.lower()[0]]
                assert shapely.equals_exact(original, row.geometry, tolerance=0)
        for row in overview.cities.itertuples():
            assert shapely.equals_exact(originals[row.division_id], row.geometry, tolerance=0)
        assert overview.large.loc[overview.large.country == 'AA', 'membership'].iloc[0] == 'Medium + large'
        try:
            prepare_region_overview(large, replace(large_settings, map_feature_limit=6))
        except ValueError as exc:
            assert 'MAP_FEATURE_LIMIT=6' in str(exc), exc
        else:
            raise AssertionError('Overview silently exceeded its feature limit')
        for regions, expected in (
            (medium, ['overlap', 'second']),
            (large, ['large-only', 'overlap', 'second']),
        ):
            result = exact_intersection(
                bbox_overlap(candidates, regions.medium_bounds), regions.medium
            )
            ids = sorted(row.id for row in result.select('id').collect())
            assert ids == expected, ids
        for preset, land_regions in (("medium", medium), ("large", large)):
            territorial_settings = replace(large_settings if preset == "large" else medium_settings,
                                           include_territorial_waters=True, map_feature_limit=20)
            territorial = resolve_scale_regions(spark, territorial_settings)
            assert territorial.small.collect() == land_regions.small.collect()
            assert territorial.small_bounds == land_regions.small_bounds
            assert territorial.small_division_ids == land_regions.small_division_ids
            ids = sorted(row.id for row in territorial.medium.select('id').collect())
            assert ids == (['a-territorial', 'b', 'c-territorial'] if preset == 'large'
                           else ['a-territorial', 'b']), ids
            assert territorial.medium_bounds != land_regions.medium_bounds
            selected = exact_intersection(bbox_overlap(candidates, territorial.medium_bounds), territorial.medium)
            expected = ['offshore-medium', 'overlap', 'second']
            if preset == 'large':
                expected += ['large-only', 'offshore-large']
            assert sorted(row.id for row in selected.select('id').collect()) == sorted(expected)
            if preset == 'large':
                territorial_overview = prepare_region_overview(territorial, territorial_settings)
                original_by_code = {row.country: shapely.from_wkb(bytes(row.wkb))
                    for row in areas.where("subtype = 'country' AND is_territorial").selectExpr(
                        'country', 'ST_AsBinary(geometry) AS wkb').collect()}
                for frame in (territorial_overview.large, territorial_overview.medium):
                    for row in frame.itertuples():
                        assert shapely.equals_exact(original_by_code[row.country], row.geometry, 0)
                assert territorial_overview.cities.geometry.equals(overview.cities.geometry)
                assert territorial_overview.counts == overview.counts
                assert set(territorial_overview.large.extent) == {'Land and territorial waters'}
        try:
            resolve_scale_regions(spark, replace(large_settings,
                include_territorial_waters=True, large_region_state_codes=('AA', 'BB', 'CC', 'DD')))
        except RuntimeError as exc:
            assert 'No territorial country area' in str(exc) and 'DD' in str(exc), exc
        else:
            raise AssertionError('Land-only country silently used as a territorial fallback')
        try:
            resolve_scale_regions(
                spark, replace(large_settings, large_region_state_codes=('AA', 'BB', 'CC', 'EE'))
            )
        except RuntimeError as exc:
            assert 'EE' in str(exc), exc
        else:
            raise AssertionError('Missing large-region country was not rejected')
    print('PASS: medium/large selection, exact country/city coordinates, city stability, territorial/land selection, offshore inclusion, landlocked areas, deduplication, missing extent')


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
                ("large-only", "POINT (10.5 10.5)", (10.5, 10.5, 10.5, 10.5)),
                ("offshore-medium", "POINT (-0.5 0.5)", (-0.5, 0.5, -0.5, 0.5)),
                ("offshore-large", "POINT (13 11)", (13., 11., 13., 11.)),
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
    check_presets(spark, candidates)
    spark.stop()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
