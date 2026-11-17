"""Audit a completed notebook 15 run using Arrow/Shapely, independently of Sedona."""
import argparse
import json
from pathlib import Path
import re


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('attempt', type=Path)
    parser.add_argument('release', type=Path)
    args = parser.parse_args()
    import pyarrow as pa
    import pyarrow.dataset as ds
    import shapely
    pa.set_cpu_count(2)
    pa.set_io_thread_count(2)
    report = {'status': 'running'}
    doc = (args.attempt / 'map-01.html').read_text()
    match = re.search(r'const\s+jsonInput\s*=\s*', doc)
    assert match, 'No map data found'
    data, _ = json.JSONDecoder().raw_decode(doc[match.end():])
    del doc
    assert [l['id'] for l in data['layers']] == ['world-countries']
    features = data['layers'][0]['data']['features']
    mapped = {f['properties']['source_id']: shapely.from_geojson(json.dumps(f['geometry'])) for f in features}
    assert len(mapped) == len(features), 'Duplicate map feature IDs'
    del data, features
    areas = ds.dataset(args.release / 'theme=divisions/type=division_area', format='parquet')
    country_filter = (ds.field('subtype') == 'country') & (ds.field('is_land') == True)
    count = coordinates = 0
    for batch in areas.scanner(filter=country_filter, columns=['id', 'geometry'], batch_size=1,
                              batch_readahead=1, fragment_readahead=1).to_batches():
        for row in batch.to_pylist():
            g = shapely.from_wkb(row['geometry'])
            assert g.equals_exact(mapped.pop(row['id']), 0), row['id']
            count += 1
            coordinates += int(shapely.get_num_coordinates(g))
    assert not mapped, 'Unexpected map features'
    captured = json.loads((args.attempt / 'maps.json').read_text())
    assert captured[0]['coordinate_counts'] == {'world-countries': coordinates}
    report['map'] = {'features': count, 'coordinates': coordinates, 'exact_original_geometry': True,
                     'only_original_countries_displayed': True}

    # Independent, bounded coastline audit. Tile seams disappear in this union.
    window = shapely.box(34.93, 32.77, 35.10, 32.90)
    overlap = ((ds.field(('bbox', 'xmin')) <= window.bounds[2]) &
               (ds.field(('bbox', 'xmax')) >= window.bounds[0]) &
               (ds.field(('bbox', 'ymin')) <= window.bounds[3]) &
               (ds.field(('bbox', 'ymax')) >= window.bounds[1]))
    territory_filter = (ds.field('subtype') == 'country') & (ds.field('country') == 'IL') & (ds.field('is_territorial') == True)
    territories = areas.to_table(filter=territory_filter, columns=['id', 'geometry']).to_pylist()
    assert territories, 'No Haifa territorial country to audit'
    land = ds.dataset(args.release / 'theme=base/type=land', format='parquet')
    selected = land.to_table(filter=overlap & (ds.field('subtype') == 'land') & (ds.field('class') == 'land'),
                             columns=['geometry']).to_pylist()
    physical = shapely.union_all([shapely.intersection(shapely.from_wkb(r['geometry']), window) for r in selected])
    files = list((args.attempt / 'exports').rglob('detailed_countries_experimental.geoparquet'))
    assert len(files) == 1, files
    detailed = ds.dataset(files[0], format='parquet')
    comparisons = []
    for row in territories:
        expected = shapely.intersection(shapely.from_wkb(row['geometry']), physical)
        saved = detailed.to_table(filter=overlap & (ds.field('territorial_area_id') == row['id']),
                                  columns=['geometry']).to_pylist()
        pieces = [shapely.intersection(shapely.from_wkb(r['geometry']), window) for r in saved]
        actual = shapely.union_all(pieces)
        difference = float(shapely.area(shapely.symmetric_difference(expected, actual)))
        overlap_area = abs(sum(g.area for g in pieces) - actual.area)
        assert difference < 1e-12, difference
        assert overlap_area < 1e-12, overlap_area
        assert shapely.is_valid(actual)
        comparisons.append({'territorial_area_id': row['id'], 'saved_pieces': len(pieces),
                            'difference_square_degrees': difference, 'overlap_square_degrees': overlap_area,
                            'coordinates': int(shapely.get_num_coordinates(actual))})
    report.update(status='passed', haifa={'bounds': list(window.bounds), 'comparisons': comparisons})
    (args.attempt / 'independent-country-audit.json').write_text(json.dumps(report, indent=2))
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
