"""Configuration and disabled-export execution boundaries."""
import ast
from pathlib import Path
import sys
import unittest
from unittest.mock import Mock

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
from overture_lab.detailed_countries import DetailedCountryOptions


class DetailedCountryTests(unittest.TestCase):
    def test_invalid_options(self):
        DetailedCountryOptions().validate()
        for d in (True, 0, -1, 7, float("nan"), float("inf"), 181):
            with self.subTest(tile=d), self.assertRaises(ValueError):
                DetailedCountryOptions(tile_degrees=d).validate()
        for n in (0, -1, 1.5, True):
            with self.subTest(coordinates=n), self.assertRaises(ValueError):
                DetailedCountryOptions(max_tile_coordinates=n).validate()

    def test_disabled_or_unconfigured_never_reads_land_or_builds_overlay(self):
        path = Path(__file__).resolve().parents[1] / "notebooks/15_world_countries.py"
        section = next(c for c in path.read_text().split("# %%\n") if c.startswith("detailed_country_export ="))
        for enabled, writes in ((False, False), (False, True), (True, False)):
            build = Mock(side_effect=AssertionError("Overlay must not run"))
            read = Mock(side_effect=AssertionError("Land must not be read"))
            namespace = dict(EXPORT_DETAILED_COUNTRIES=enabled, settings=Mock(write_derived=writes),
                             build_detailed_countries=build, read_type=read, display=Mock())
            exec(compile(ast.parse(section), str(path), "exec"), namespace)
            build.assert_not_called()
            read.assert_not_called()
            self.assertEqual(namespace["detailed_country_export"]["status"], "dry-run" if enabled else "disabled")
