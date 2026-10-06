"""Pure extent validation; geometry and IO checks live in check_surfaces_spark."""
import math
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
from overture_lab.regions import Bounds
from overture_lab.surfaces import regional_bounds


class SurfaceBoundsTests(unittest.TestCase):
    def test_union_includes_intervening_sea(self):
        self.assertEqual(regional_bounds((Bounds(1, 2, 3, 4), Bounds(4, 1, 6, 5))),
                         Bounds(1, 1, 6, 5))

    def test_wrapped_ambiguous_and_invalid_regions_fail(self):
        for boxes in ((), (Bounds(170, 0, -170, 10),),
                      (Bounds(-179, 0, -170, 10), Bounds(170, 0, 179, 10)),
                      (Bounds(0, 0, math.nan, 10),), (Bounds(0, 0, 0, 1),),
                      (Bounds(0, -91, 1, 0),)):
            with self.subTest(boxes=boxes), self.assertRaises(ValueError):
                regional_bounds(boxes)


if __name__ == "__main__":
    unittest.main()
