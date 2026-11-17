"""Contracts for an offline quarter: completeness, safe manifests and endpoints."""
import copy
import hashlib
import importlib.util
import io
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'src'))
from overture_lab.planequery import planequery_source_uri, validate_manifest

PERIOD = ('2026-07-01', '2026-07-03')


def fixture_manifest(contents):
    return {'format_version': 1, 'dataset': 'PlaneQuery', 'dataset_id': 'ggman12/planequery-data-flights',
            'revision': 'a'*40, 'airport_revision': 'b'*40, 'airport_reference_date': '2026-10-06',
            'source_partition': 'source=algorithm-nn/adsb_source=adsblol/version=4',
            'period_start': PERIOD[0], 'period_end_exclusive': PERIOD[1], 'days': 2, 'license': 'ODbL-1.0',
            'files': {name: {'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest(),
                            'role': 'airports' if name == 'airports.csv' else ('flights' if name.endswith('.parquet') else 'daily_provenance'),
                            **({'date': name.split('date=')[1][:10]} if 'date=' in name else {})}
                      for name, data in contents.items()}}


class PlaneQueryContracts(unittest.TestCase):
    def setUp(self):
        self.manifest = fixture_manifest({'airports.csv': b'reference', **{
            f'flights/date=2026-07-{day:02}/{name}': b'data'
            for day in (1, 2) for name in ('data.parquet', 'flight_manifest.json')}})

    def test_manifest_and_offline_uri(self):
        self.assertEqual(len(validate_manifest(self.manifest, expected_period=PERIOD)), 5)
        self.assertEqual(planequery_source_uri('/release'), '/release/external_sources/planequery/2026-Q3')
        self.assertEqual(planequery_source_uri('/release', '  '), '/release/external_sources/planequery/2026-Q3')
        self.assertEqual(planequery_source_uri('/release', 's3://bucket/prefix'), 's3a://bucket/prefix')
        with self.assertRaises(ValueError):
            planequery_source_uri('/release', 'https://example.com/data')

    def test_missing_day_wrong_period_hash_and_unsafe_paths_rejected(self):
        with self.assertRaisesRegex(ValueError, 'Expected PlaneQuery period'):
            validate_manifest(self.manifest)
        for mutate in (
            lambda m: m['files'].pop('flights/date=2026-07-02/data.parquet'),
            lambda m: m['files']['airports.csv'].update(sha256='bad'),
            lambda m: m['files'].update({'../escape': m['files']['airports.csv']}),
            lambda m: m['files']['flights/date=2026-07-01/data.parquet'].update(date='2026-07-02'),
            lambda m: m.update(airport_revision='main'),
        ):
            m = copy.deepcopy(self.manifest)
            mutate(m)
            with self.assertRaises(ValueError):
                validate_manifest(m, expected_period=PERIOD)

    def test_downloader_checks_upstream_bytes(self):
        spec = importlib.util.spec_from_file_location('download_planequery', Path(__file__).resolve().parents[1] / 'scripts/download-planequery.py')
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        data = b'fixture'
        expected = {'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest(),
                    'git_blob_sha1': hashlib.sha1(b'blob 7\0' + data).hexdigest()}
        self.assertEqual(module.verify(data, expected), expected)
        with self.assertRaises(ValueError):
            module.verify(b'corrupt', expected)

    def test_resume_cannot_override_upstream_hash_with_checkpoint(self):
        spec = importlib.util.spec_from_file_location('download_planequery', Path(__file__).resolve().parents[1] / 'scripts/download-planequery.py')
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        with tempfile.TemporaryDirectory() as temporary:
            output = Path(temporary) / 'quarter'
            partial = output.with_name('quarter.partial'); partial.mkdir()
            (partial / 'data.parquet').write_bytes(b'old')
            record = {'url': 'https://example.invalid/pinned', 'role': 'flights', 'bytes': 3,
                      'sha256': hashlib.sha256(b'new').hexdigest()}
            checkpoint = {**record, 'sha256': hashlib.sha256(b'old').hexdigest()}
            (partial / 'preparation.json').write_text(json.dumps({'data.parquet': checkpoint}))
            with patch.object(module, 'inventory', return_value={'data.parquet': record}), patch('sys.stdout', new=io.StringIO()):
                with self.assertRaisesRegex(ValueError, 'SHA-256'):
                    module.download_bundle(output, resume=True, workers=1)
            self.assertFalse(output.exists())


if __name__ == '__main__':
    unittest.main()
