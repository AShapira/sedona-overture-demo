from __future__ import annotations

import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from overture_lab.config import CitySpec, load_settings  # noqa: E402
from overture_lab.catalog import aggregate_s3_objects  # noqa: E402
from overture_lab.outputs import is_permission_error  # noqa: E402
from overture_lab.regions import (  # noqa: E402
    Bounds,
    _bounds_from_values,
    _resolve_city_division_ids,
)
from overture_lab.scratch import scratch_status  # noqa: E402


SCALE_ENVIRONMENT = {
    "MEDIUM_STATE_CODES": '["AA","bb"]',
    "SMALL_CITIES": (
        '[{"name":"First City","state_code":"AA"},'
        '{"name":"Second City","state_code":"BB"}]'
    ),
    "MEDIUM_SAMPLE_LIMIT": "100",
    "SMALL_SAMPLE_LIMIT": "50",
    "MAP_FEATURE_LIMIT": "10",
}


def test_environment(**overrides: str) -> dict[str, str]:
    return {**SCALE_ENVIRONMENT, **overrides}


class ConfigurationTests(unittest.TestCase):
    def test_configured_limits_are_ordered_by_safety_boundary(self):
        with patch.dict(os.environ, test_environment(), clear=True):
            settings = load_settings()
        self.assertLessEqual(
            settings.map_feature_limit, settings.small_sample_limit
        )
        self.assertLessEqual(
            settings.small_sample_limit, settings.medium_sample_limit
        )

    def test_scale_configuration_is_required_and_normalised(self):
        with patch.dict(os.environ, {}, clear=True):
            with self.assertRaisesRegex(ValueError, "MEDIUM_STATE_CODES is required"):
                load_settings()
        with patch.dict(os.environ, test_environment(), clear=True):
            settings = load_settings()
        self.assertEqual(settings.medium_state_codes, ("AA", "BB"))
        self.assertEqual(
            settings.small_cities,
            (CitySpec("First City", "AA"), CitySpec("Second City", "BB")),
        )

    def test_invalid_scale_json_and_shapes_are_rejected(self):
        cases = [
            ({"MEDIUM_STATE_CODES": "not-json"}, "valid JSON"),
            ({"MEDIUM_STATE_CODES": "[]"}, "non-empty JSON array"),
            ({"MEDIUM_STATE_CODES": '["AAA"]'}, "two-letter state code"),
            ({"MEDIUM_STATE_CODES": '["AA","aa"]'}, "duplicates"),
            ({"SMALL_CITIES": "[]"}, "non-empty JSON array"),
            ({"SMALL_CITIES": '[{"name":"City"}]'}, "exactly name and state_code"),
            (
                {"SMALL_CITIES": '[{"name":"City","state_code":"CC"}]'},
                "must also appear",
            ),
            (
                {
                    "SMALL_CITIES": (
                        '[{"name":"City","state_code":"AA"},'
                        '{"name":"City","state_code":"aa"}]'
                    )
                },
                "duplicate city",
            ),
        ]
        for overrides, message in cases:
            with self.subTest(overrides=overrides):
                with patch.dict(
                    os.environ, test_environment(**overrides), clear=True
                ):
                    with self.assertRaisesRegex(ValueError, message):
                        load_settings()

    def test_invalid_limit_order_is_rejected(self):
        with patch.dict(
            os.environ,
            test_environment(MEDIUM_SAMPLE_LIMIT="20", SMALL_SAMPLE_LIMIT="30"),
            clear=True,
        ):
            with self.assertRaisesRegex(ValueError, "SMALL_SAMPLE_LIMIT"):
                load_settings()
        with patch.dict(
            os.environ,
            test_environment(SMALL_SAMPLE_LIMIT="5", MAP_FEATURE_LIMIT="6"),
            clear=True,
        ):
            with self.assertRaisesRegex(ValueError, "MAP_FEATURE_LIMIT"):
                load_settings()

    def test_type_uri_supports_local_and_s3a_roots(self):
        with patch.dict(
            os.environ,
            test_environment(OVERTURE_RELEASE_URI="s3a://maps/release/x"),
            clear=True,
        ):
            settings = load_settings()
        self.assertEqual(
            settings.type_uri("places", "place"),
            "s3a://maps/release/x/theme=places/type=place",
        )

    def test_partial_s3_credentials_are_rejected(self):
        with patch.dict(
            os.environ, test_environment(S3_ACCESS_KEY="only-one"), clear=True
        ):
            with self.assertRaisesRegex(ValueError, "must be set together"):
                load_settings()

    def test_public_settings_redact_s3_credentials(self):
        environment = test_environment(**{
            "S3_ACCESS_KEY": "example-access",
            "S3_SECRET_KEY": "example-secret",
        })
        with patch.dict(os.environ, environment, clear=True):
            public = load_settings().public_dict()
        self.assertEqual(public["s3_access_key"], "<set>")
        self.assertEqual(public["s3_secret_key"], "<set>")
        self.assertNotIn("example-access", repr(public))
        self.assertNotIn("example-secret", repr(public))

    def test_windows_mode_requires_s3a_release(self):
        with patch.dict(
            os.environ,
            test_environment(
                REQUIRE_S3_RELEASE="true", OVERTURE_RELEASE_URI="/data"
            ),
            clear=True,
        ):
            with self.assertRaisesRegex(ValueError, "requires.*s3a"):
                load_settings()

    def test_derived_prefix_cannot_overlap_immutable_release(self):
        environment = test_environment(**{
            "OVERTURE_RELEASE_URI": "s3a://maps/releases/2026-07-22.0",
            "DERIVED_OUTPUT_URI": "s3a://maps/releases/2026-07-22.0/derived",
        })
        with patch.dict(os.environ, environment, clear=True):
            with self.assertRaisesRegex(ValueError, "must not equal"):
                load_settings()

    def test_separate_derived_prefix_is_allowed(self):
        environment = test_environment(**{
            "OVERTURE_RELEASE_URI": "s3a://maps/releases/2026-07-22.0",
            "DERIVED_OUTPUT_URI": "s3a://maps/derived/sedona-lab",
        })
        with patch.dict(os.environ, environment, clear=True):
            settings = load_settings()
        self.assertEqual(settings.storage_mode, "s3a")

    def test_scratch_status_reports_namespaced_usage(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "small.bin").write_bytes(b"x" * (2 * 1024**2))
            environment = test_environment(**{
                "SEDONA_SCRATCH_DIR": directory,
                "DERIVED_LOCAL_FALLBACK_DIR": str(root / "derived"),
                "SEDONA_SCRATCH_RESERVE_GB": "0",
            })
            with patch.dict(os.environ, environment, clear=True):
                status = scratch_status(load_settings())
        self.assertEqual(status.path, directory)
        self.assertGreater(status.namespace_used_gib, 0)

    def test_permission_error_classifier_is_conservative(self):
        self.assertTrue(is_permission_error(RuntimeError("AccessDenied: 403")))
        self.assertFalse(is_permission_error(RuntimeError("connection timed out")))

    def test_s3_inventory_aggregates_only_hive_parquet_leaves(self):
        totals = aggregate_s3_objects(
            [
                (
                    "s3a://maps/release/theme=places/type=place/part-0.parquet",
                    100,
                ),
                (
                    "s3a://maps/release/theme=places/type=place/part-1.parquet",
                    250,
                ),
                ("s3a://maps/release/manifest.json", 50),
            ]
        )
        self.assertEqual(
            totals, {("places", "place"): {"files": 2, "bytes": 350}}
        )

    def test_bounds_order(self):
        bounds = Bounds(34.6, 31.7, 34.8, 31.9)
        self.assertEqual(
            bounds.as_dict(),
            {"xmin": 34.6, "ymin": 31.7, "xmax": 34.8, "ymax": 31.9},
        )

    def test_disjoint_boundary_boxes_remain_independent(self):
        bounds = _bounds_from_values(
            [(1.0, 2.0, 3.0, 4.0), (100.0, 20.0, 101.0, 21.0)]
        )
        self.assertEqual(len(bounds), 2)
        self.assertEqual(bounds[0].xmax, 3.0)
        self.assertEqual(bounds[1].xmin, 100.0)

    def test_city_resolution_requires_one_exact_match_per_city(self):
        specs = (CitySpec("First City", "AA"), CitySpec("Second City", "BB"))
        rows = [
            {
                "id": "one",
                "country": "AA",
                "names": {"common": {"en": "First City"}},
            },
            {
                "id": "two",
                "country": "BB",
                "names": {"common": {"en": "Second City"}},
            },
        ]
        self.assertEqual(_resolve_city_division_ids(rows, specs), ("one", "two"))
        with self.assertRaisesRegex(RuntimeError, "found 0"):
            _resolve_city_division_ids(rows[:1], specs)
        with self.assertRaisesRegex(RuntimeError, "found 2"):
            _resolve_city_division_ids(rows + [rows[1]], specs)


class NotebookTests(unittest.TestCase):
    def test_expected_curriculum_exists_and_is_valid_json(self):
        expected = [f"{number:02d}" for number in range(10)]
        found = sorted(path.name[:2] for path in (ROOT / "notebooks").glob("*.ipynb"))
        self.assertEqual(found, expected)
        for path in (ROOT / "notebooks").glob("*.ipynb"):
            document = json.loads(path.read_text(encoding="utf-8"))
            self.assertEqual(document["nbformat"], 4)
            self.assertGreaterEqual(len(document["cells"]), 5)

    def test_windows_compose_has_no_raw_release_mount(self):
        compose = (ROOT / "compose.windows-s3-airgap.yml").read_text(
            encoding="utf-8"
        )
        self.assertIn("REQUIRE_S3_RELEASE", compose)
        self.assertIn("target: /scratch", compose)
        self.assertNotIn("target: /data/overture", compose)

    def test_compose_requires_scale_configuration(self):
        for name in ("compose.yml", "compose.windows-s3-airgap.yml"):
            compose = (ROOT / name).read_text(encoding="utf-8")
            self.assertIn("MEDIUM_STATE_CODES:?", compose)
            self.assertIn("SMALL_CITIES:?", compose)
            self.assertIn("MEDIUM_SAMPLE_LIMIT:?", compose)
            self.assertIn("SMALL_SAMPLE_LIMIT:?", compose)

    def test_removed_geographic_terms_and_interfaces_are_absent(self):
        forbidden = (
            "isr" + "ael",
            "ash" + "dod",
            "focus_" + "country_code",
            "focus_" + "locality_en",
            "focus_" + "locality_country_code",
            "country_" + "sample_limit",
            "locality_" + "sample_limit",
            "resolve_" + "focus_regions",
        )
        tracked = subprocess.run(
            ["git", "ls-files", "-z"],
            cwd=ROOT,
            check=True,
            capture_output=True,
        ).stdout.split(b"\0")
        matches = []
        for raw_path in tracked:
            if not raw_path:
                continue
            path = ROOT / os.fsdecode(raw_path)
            try:
                content = path.read_text(encoding="utf-8").lower()
            except UnicodeDecodeError:
                continue
            for term in forbidden:
                if term in content:
                    matches.append(f"{path.relative_to(ROOT)}: {term}")
        self.assertEqual(matches, [])

    def test_generated_notebooks_are_current(self):
        result = subprocess.run(
            [sys.executable, "scripts/sync_notebooks.py", "--check"],
            cwd=ROOT,
            text=True,
            capture_output=True,
            check=False,
        )
        self.assertEqual(result.returncode, 0, result.stderr)


if __name__ == "__main__":
    unittest.main()
