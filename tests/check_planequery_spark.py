"""Network-free local/internal-S3 fixture with period, aggregation and integrity checks."""
import argparse
from dataclasses import replace
from datetime import datetime, timedelta
import json
import os
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'src'))
from test_planequery import fixture_manifest, PERIOD
from overture_lab.config import load_settings
from overture_lab.flight_routes import validate_flight_routes, flight_routes_map
from overture_lab.planequery import read_planequery_bundle, build_connections, connection_display_frame, write_connection_audit
from overture_lab.outputs import write_single_geoparquet
from overture_lab.spark import create_sedona


def make_bundle(folder):
    import pyarrow as pa
    import pyarrow.parquet as pq
    folder.mkdir(parents=True, exist_ok=True)
    contents = {'airports.csv': ("id,ident,type,name,latitude_deg,longitude_deg,iso_country\n"
        "1,AAA,large_airport,Airport A,35,170,AA\n"
        "2,BBB,small_airport,Airport B,40,-170,BB\n"
        "3,CCC,closed,Airport C,40,-170,BB\n"
        "4,DDD,heliport,Invalid coordinates,95,0,DD\n").encode()}
    def row(day=1, a=1, b=2, ident='AAA', hour=10, **changes):
        takeoff = datetime(2026, 7, day, hour)
        return dict(icao='abc123', takeoff_time=takeoff, landing_time=takeoff+timedelta(hours=2),
                    takeoff_airport_id=a, landing_airport_id=b, takeoff_airport_ident=ident,
                    landing_airport_ident='BBB', **changes)
    rows = [row(), row(), row(a=2, b=1, ident='BBB'), row(b=None), row(b=99), row(b=1), row(a=2, b=3), row(b=4)]
    bad_time = row(); bad_time['landing_time'] = bad_time['takeoff_time']; rows.append(bad_time)
    outside = row(); outside['takeoff_time'] = datetime(2026, 6, 30, 23); rows.append(outside)
    late = row(day=2); late['takeoff_time'] = datetime(2026, 7, 3); late['landing_time'] = datetime(2026, 7, 3, 1)
    for day, batch in ((1, rows), (2, [row(day=2, ident='OLD'), row(day=1, hour=18), late])):
        name = f'flights/date=2026-07-{day:02}/data.parquet'
        sink = pa.BufferOutputStream(); pq.write_table(pa.Table.from_pylist(batch), sink)
        contents[name] = sink.getvalue().to_pybytes()
        contents[f'flights/date=2026-07-{day:02}/flight_manifest.json'] = b'{"fixture":true}'
    manifest = fixture_manifest(contents)
    for name, data in contents.items():
        path = folder / name; path.parent.mkdir(parents=True, exist_ok=True); path.write_bytes(data)
    (folder / 'manifest.json').write_text(json.dumps(manifest))
    return manifest


def main():
    parser = argparse.ArgumentParser(); parser.add_argument('--output', type=Path, required=True); parser.add_argument('--s3', action='store_true')
    args = parser.parse_args(); args.output.mkdir(parents=True, exist_ok=True)
    for k, v in {'MEDIUM_STATE_CODES':'["AA"]', 'SMALL_CITIES':'[{"name":"Fixture","state_code":"AA"}]',
                 'MEDIUM_SAMPLE_LIMIT':'20','SMALL_SAMPLE_LIMIT':'10','MAP_FEATURE_LIMIT':'5'}.items():
        os.environ.setdefault(k, v)
    folder = args.output / 'source'; manifest = make_bundle(folder); source_uri = str(folder)
    if args.s3:
        from pyarrow import fs
        client = fs.S3FileSystem(access_key='flightfixture', secret_key='flightfixturesecret',
            endpoint_override='minio:9000', scheme='http', region='us-east-1', allow_bucket_creation=True)
        client.create_dir('flight-test')
        for item in folder.rglob('*'):
            if item.is_file():
                with client.open_output_stream(f'flight-test/source/{item.relative_to(folder)}') as stream:
                    stream.write(item.read_bytes())
        source_uri = 's3a://flight-test/source'
    settings = replace(load_settings(), release_uri='/tmp/no-overture-needed', write_derived=True,
        derived_output_mode='local', derived_output_uri=None, derived_local_fallback_dir=str(args.output/'exports'))
    spark = create_sedona(settings, 'planequery-fixtures', input_uris=(source_uri,))
    from pyspark.sql import functions as F
    try:
        loaded, observations, airports = read_planequery_bundle(spark, source_uri, expected_period=PERIOD)
        assert loaded == manifest
        routes, classified, quality = build_connections(observations, airports, manifest)
        routes = routes.cache(); geometry = validate_flight_routes(routes)
        assert geometry['features'] == 2
        assert quality['input_observations'] == 13 and quality['accepted_observations'] == 5 and quality['excluded_observations'] == 8, quality
        assert quality['excluded_by_reason'] == {'missing_airport_id':1, 'unknown_airport_id':1, 'same_airport':1,
            'coincident_endpoints':1, 'invalid_airport_coordinates':1, 'invalid_times':1, 'outside_period':2}, quality
        recurring = routes.filter('origin_airport_id = 1').first()
        assert recurring.observation_count == 4 and recurring.active_days == 2
        assert recurring.ident_disagreement_count == 1 and recurring.partition_day_disagreement_count == 1
        assert recurring.observations_07 == 4 and recurring.observations_08 == 0
        assert recurring.geometry.geom_type == 'MultiLineString'
        frame = connection_display_frame(routes, min_active_days=2)
        assert len(frame) == 1 and int(frame.observation_count.sum()) == 4
        try:
            connection_display_frame(routes, min_active_days=1, feature_limit=1)
        except ValueError as error:
            assert 'no routes were sampled' in str(error)
        else:
            raise AssertionError('Map budget accepted truncation')
        if args.s3:
            settings = replace(settings, derived_output_mode='s3', derived_output_uri='s3a://flight-test/derived')
        result = write_single_geoparquet(routes, spark, settings, dataset_name='world-flight-routes', object_name='world_flight_routes.geoparquet')
        audits = write_connection_audit(spark, result.run_prefix, manifest, quality, classified)
        restored = spark.read.format('geoparquet').load(result.geoparquet_uri)
        columns = [F.expr('ST_AsBinary(geometry)').alias('wkb'), *[F.col(c) for c in routes.columns if c != 'geometry']]
        before, after = routes.select(*columns), restored.select(*columns)
        assert before.exceptAll(after).count() == after.exceptAll(before).count() == 0
        assert validate_flight_routes(restored) == geometry
        assert spark.read.parquet(audits['excluded-observations']).count() == 8
        saved_quality = spark.read.option('multiLine', True).json(audits['route-quality.json']).first()
        assert saved_quality.input_observations == 13
        deck, controls = flight_routes_map(frame, observed=True, min_active_days=2)
        assert 'PlaneQuery' in controls['description']
        assert json.loads(deck.to_json())['layers'][0]['id'] == 'world-flight-routes'
        # Corruption with identical byte length must fail before parsing input.
        tamper_name = 'flights/date=2026-07-01/flight_manifest.json'
        tampered = b'x' * len((folder/tamper_name).read_bytes())
        if args.s3:
            with client.open_output_stream(f'flight-test/source/{tamper_name}') as stream: stream.write(tampered)
        else:
            (folder/tamper_name).write_bytes(tampered)
        try:
            read_planequery_bundle(spark, source_uri, expected_period=PERIOD)
        except ValueError as error:
            assert 'SHA-256' in str(error)
        else:
            raise AssertionError('Corrupted source was accepted')
        (args.output/'report.json').write_text(json.dumps({'status':'passed','mode':'s3' if args.s3 else 'local',
            'quality':quality,'geometry':geometry,'export':result.as_dict(),'audit':audits,
            'mapped_pairs':len(frame), 'exported_pairs':geometry['features'], 'exact_attribute_geometry_round_trip':True,
            'same_size_tampering_rejected':True},indent=2))
        print('PASS: PlaneQuery integrity, quarter boundaries, ID joins, recurrence, all-pair export, exact round trip and audit')
    finally:
        spark.stop()

if __name__ == '__main__':
    main()
