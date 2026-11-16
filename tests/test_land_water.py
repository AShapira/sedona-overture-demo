"""Non-Spark configuration and notebook gating checks."""
import ast
from pathlib import Path
import sys
import unittest
from unittest.mock import Mock

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
from overture_lab.land_water import LandWaterOptions


class LandWaterTests(unittest.TestCase):
    def test_tile_options(self):
        LandWaterOptions().validate()
        LandWaterOptions(0.5, 100).validate()
        for d in (0, -1, 7, float("nan"), float("inf"), 181):
            with self.subTest(d=d), self.assertRaises(ValueError):
                LandWaterOptions(d).validate()
        for n in (0, -1, 1.5, True):
            with self.subTest(n=n), self.assertRaises(ValueError):
                LandWaterOptions(max_tile_coordinates=n).validate()

    def test_disabled_notebook_section_never_builds_overlay(self):
        path = Path(__file__).resolve().parents[1] / "notebooks/14_landmass_and_oceans.py"
        section = next(c for c in path.read_text().split("# %%\n") if c.startswith("land_water_exports ="))
        for enabled, writes in ((False, False), (False, True), (True, False)):
            build = Mock(side_effect=AssertionError("Overlay must not run"))
            display = Mock()
            namespace = dict(EXPORT_LAND_WATER=enabled, settings=Mock(write_derived=writes),
                             build_land_water=build, display=display)
            exec(compile(ast.parse(section), str(path), "exec"), namespace)
            build.assert_not_called()
            self.assertEqual(display.call_args.args[0]["land_water_status"], "dry-run" if enabled else "disabled")


if __name__ == "__main__":
    unittest.main()
