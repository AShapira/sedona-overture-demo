from __future__ import annotations

import json
import os
from pathlib import Path
import subprocess
import sys
import unittest
from unittest.mock import patch


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))

from overture_lab.config import load_settings  # noqa: E402
from overture_lab.regions import Bounds  # noqa: E402


class ConfigurationTests(unittest.TestCase):
    def test_defaults_are_ordered_by_safety_boundary(self):
        with patch.dict(os.environ, {}, clear=True):
            settings = load_settings()
        self.assertLessEqual(
            settings.map_feature_limit, settings.locality_sample_limit
        )
        self.assertLessEqual(
            settings.locality_sample_limit, settings.country_sample_limit
        )

    def test_type_uri_supports_local_and_s3a_roots(self):
        with patch.dict(
            os.environ, {"OVERTURE_RELEASE_URI": "s3a://maps/release/x"}, clear=True
        ):
            settings = load_settings()
        self.assertEqual(
            settings.type_uri("places", "place"),
            "s3a://maps/release/x/theme=places/type=place",
        )

    def test_partial_s3_credentials_are_rejected(self):
        with patch.dict(os.environ, {"S3_ACCESS_KEY": "only-one"}, clear=True):
            with self.assertRaisesRegex(ValueError, "must be set together"):
                load_settings()

    def test_bounds_order(self):
        bounds = Bounds(34.6, 31.7, 34.8, 31.9)
        self.assertEqual(
            bounds.as_dict(),
            {"xmin": 34.6, "ymin": 31.7, "xmax": 34.8, "ymax": 31.9},
        )


class NotebookTests(unittest.TestCase):
    def test_expected_curriculum_exists_and_is_valid_json(self):
        expected = [f"{number:02d}" for number in range(10)]
        found = sorted(path.name[:2] for path in (ROOT / "notebooks").glob("*.ipynb"))
        self.assertEqual(found, expected)
        for path in (ROOT / "notebooks").glob("*.ipynb"):
            document = json.loads(path.read_text(encoding="utf-8"))
            self.assertEqual(document["nbformat"], 4)
            self.assertGreaterEqual(len(document["cells"]), 5)

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
