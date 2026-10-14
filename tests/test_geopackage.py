"""GeoPackage round trips, coverage invariants, routing failures, and SLD scales."""
import importlib.util
import json
import math
from pathlib import Path
import shutil
import sqlite3
import sys
import tempfile
from types import SimpleNamespace
import unittest
from unittest.mock import patch
from urllib.parse import urlparse, unquote
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "src"))
from overture_lab.geopackage import (
    DEFAULT_LEVELS, GeneralizationOptions, _upload_verified, build_surface_geopackage,
    export_surface_geopackage, generalize_tile, iter_geopackage_features,
    surface_tiles, validate_geopackage,
)
from overture_lab.regions import Bounds

HAS_GEO = all(importlib.util.find_spec(m) for m in ("shapely", "pyogrio", "geopandas", "pyarrow"))


def sample_records():
    """Edge-matched jagged coast, native seams, island, and an ocean hole."""
    import shapely
    from shapely.geometry import Polygon
    coast = [(1 + (0.002 if i % 2 else 0), i / 100) for i in range(201)]
    mainland = Polygon([(0, 0), *coast, (0, 2), (0, 0)])
    island = shapely.box(3, 0.4, 3.2, 0.6)
    ocean = shapely.box(0, 0, 4, 2).difference(mainland.union(island))
    shapes = [("landmass", mainland.intersection(shapely.box(0, 0, 2, 1))),
              ("landmass", mainland.intersection(shapely.box(0, 1, 2, 2))),
              ("landmass", island), ("ocean", ocean)]
    for index, (surface, shape) in enumerate(shapes):
        xmin, ymin, xmax, ymax = shape.bounds
        attrs = {"surface": surface, "source_id": f"piece-{index}", "source_version": 7,
                 "sources_json": json.dumps([{"dataset": "synthetic", "record_id": str(index)}]),
                 "source_type": "base/land" if surface == "landmass" else "base/water",
                 "source_filter": "synthetic", "release": "fixture", "release_uri": "generated",
                 "scope": "regional", "geometry_policy": "exact; fixture", "extent_json": None,
                 "bbox_xmin": xmin, "bbox_ymin": ymin, "bbox_xmax": xmax, "bbox_ymax": ymax}
        yield attrs, shapely.to_wkb(shape)


class OptionTests(unittest.TestCase):
    def test_options_and_tile_alignment(self):
        GeneralizationOptions().validate()
        for kwargs in ({"tile_degrees": 0}, {"tile_degrees": math.nan}, {"tile_degrees": 7},
                       {"levels": {}}, {"levels": {"full": 1}}, {"levels": {"fine": -1}},
                       {"levels": {"fine": 1, "coarse": 0.1}}, {"max_tile_coordinates": 0},
                       {"precision_grid_degrees": 0}, {"precision_grid_degrees": math.nan},
                       {"precision_grid_degrees": 0.001}):
            with self.subTest(kwargs=kwargs), self.assertRaises(ValueError):
                GeneralizationOptions(**kwargs).validate()
        tiles = list(surface_tiles(Bounds(0.3, 0.2, 3.7, 1.9), 2))
        self.assertEqual([b for _, b in tiles], [Bounds(0.3, 0.2, 2, 1.9), Bounds(2, 0.2, 3.7, 1.9)])
        self.assertEqual(len(list(surface_tiles(Bounds(-180, -90, 180, 90), 2))), 16200)
        self.assertEqual(list(surface_tiles(Bounds(178, 88, 180, 90), 2))[0][1], Bounds(178, 88, 180, 90))

    def test_dry_run_does_not_import_dependencies_or_touch_spark(self):
        with patch("overture_lab.geopackage.check_geopackage_dependencies", side_effect=AssertionError):
            result = export_surface_geopackage(None, None, SimpleNamespace(write_derived=False),
                                               scope="world", bounds=Bounds(-180, -90, 180, 90))
        self.assertEqual(result["status"], "dry-run")

    def test_s3_copy_verification_and_no_overwrite(self):
        with tempfile.TemporaryDirectory() as root:
            source, target, verified = [Path(root) / n for n in ("source", "remote", "verify")]
            source.write_bytes(b"complete GeoPackage bytes")
            class FS:
                corrupt = False
                def exists(self, path):
                    return path.exists()
                def copyFromLocalFile(self, delete, overwrite, origin, destination):
                    self.assert_flags = (delete, overwrite)
                    shutil.copyfile(origin, destination)
                def copyToLocalFile(self, delete, origin, destination, raw):
                    shutil.copyfile(origin, destination)
                    if self.corrupt:
                        destination.write_bytes(b"corrupted")
            filesystem = FS()
            class HadoopPath(type(Path())):
                def getFileSystem(self, configuration):
                    return filesystem
            def path_type(value):
                return HadoopPath(unquote(urlparse(value).path) if value.startswith("file:") else value)
            spark = SimpleNamespace(_jvm=SimpleNamespace(org=SimpleNamespace(apache=SimpleNamespace(
                hadoop=SimpleNamespace(fs=SimpleNamespace(Path=path_type))))),
                _jsc=SimpleNamespace(hadoopConfiguration=lambda: None))
            _upload_verified(spark, source, str(target), verified)
            self.assertEqual(target.read_bytes(), source.read_bytes())
            self.assertFalse(verified.exists())
            self.assertEqual(filesystem.assert_flags, (False, False))
            with self.assertRaises(FileExistsError):
                _upload_verified(spark, source, str(target), verified)
            target.unlink()
            filesystem.corrupt = True
            with self.assertRaisesRegex(RuntimeError, "byte verification"):
                _upload_verified(spark, source, str(target), verified)


@unittest.skipUnless(HAS_GEO, "optional requirements-geopackage.txt not installed")
class GeometryTests(unittest.TestCase):
    def build(self, root, records=None, bounds=Bounds(0, 0, 4, 2), options=None):
        path = Path(root) / "surfaces.gpkg"
        result = build_surface_geopackage(path, sample_records() if records is None else records,
            scope="regional", bounds=bounds, release="fixture", release_uri="generated", options=options)
        return path, result

    def test_exact_roundtrip_reduction_seams_island_and_rtrees(self):
        import shapely
        with tempfile.TemporaryDirectory() as root:
            path, report = self.build(root)
            self.assertEqual(len(report["layers"]), 8)
            self.assertEqual(report["tiles"], 2)
            originals = {a["source_id"]: (a, shapely.from_wkb(w)) for a, w in sample_records()}
            for surface in ("landmass", "ocean"):
                for attrs, geometry in iter_geopackage_features(path, surface + "_full"):
                    before, original = originals[attrs["source_id"]]
                    self.assertEqual(attrs, before)
                    self.assertTrue(geometry.equals(original))
                    self.assertEqual(shapely.get_num_coordinates(geometry), shapely.get_num_coordinates(original))
            for level in DEFAULT_LEVELS:
                shapes = {s: [g for _, g in iter_geopackage_features(path, f"{s}_{level}")]
                          for s in ("landmass", "ocean")}
                land, ocean = [shapely.union_all(shapes[s]) for s in ("landmass", "ocean")]
                self.assertLess(land.intersection(ocean).area, 1e-12)
                self.assertLess(land.union(ocean).symmetric_difference(shapely.box(0, 0, 4, 2)).area, 1e-12)
                self.assertTrue(land.contains(shapely.Point(3.1, 0.5)))
                self.assertFalse(ocean.contains(shapely.Point(3.1, 0.5)))
                self.assertLessEqual(sum(report["layers"][f"{s}_{level}"]["vertices"] for s in shapes),
                                     report["dissolved_vertices"])
            self.assertLess(sum(report["layers"][f"{s}_coarse"]["vertices"] for s in shapes),
                            sum(report["layers"][f"{s}_full"]["vertices"] for s in shapes))
            # Attribute corruption is caught without relying on row counts.
            with sqlite3.connect(path) as db:
                # Plain SQLite lacks GDAL's trigger functions. Remove only this
                # disposable table's triggers to inject attribute corruption;
                # geometries and R-tree contents remain unchanged.
                for (name,) in db.execute("SELECT name FROM sqlite_master WHERE type='trigger' "
                                          "AND tbl_name='landmass_full'").fetchall():
                    db.execute('DROP TRIGGER "' + name.replace('"', '""') + '"')
                db.execute("UPDATE landmass_full SET source_id='changed'")
            with self.assertRaisesRegex(RuntimeError, "fingerprint mismatch"):
                validate_geopackage(path, report["layers"])

    def test_empty_layers_and_single_surface(self):
        with tempfile.TemporaryDirectory() as root:
            path, report = self.build(root, records=[])
            self.assertTrue(all(r["rows"] == 0 for r in report["layers"].values()))
        with tempfile.TemporaryDirectory() as root:
            _, report = self.build(root, records=[r for r in sample_records() if r[0]["surface"] == "landmass"])
            self.assertTrue(all(r["rows"] == 0 for n, r in report["layers"].items() if n.startswith("ocean")))

    def test_guard_overlap_gap_and_interrupted_build(self):
        import shapely
        options = GeneralizationOptions()
        with self.assertRaisesRegex(ValueError, "invalid or non-edge-matched"):
            generalize_tile({"landmass": [shapely.box(0, 0, 2, 2)], "ocean": [shapely.box(1, 0, 3, 2)]},
                            tile_id="overlap", options=options)
        pieces = {"landmass": [shapely.box(0, 0, 1, 1)], "ocean": [shapely.box(2, 0, 3, 1)]}
        result, _ = generalize_tile(pieces, tile_id="gap", options=options)
        self.assertAlmostEqual(shapely.union_all(list(result["fine"].values())).area, 2)
        with tempfile.TemporaryDirectory() as root:
            with self.assertRaisesRegex(ValueError, "coordinate guard"):
                self.build(root, options=GeneralizationOptions(max_tile_coordinates=4))
            self.assertTrue((Path(root) / "surfaces.gpkg").exists())
            with self.assertRaises(FileExistsError):
                self.build(root)

    def test_dateline_and_polar_tile_edges(self):
        import shapely
        for bounds in (Bounds(-180, -90, -178, -88), Bounds(178, 88, 180, 90)):
            shape = shapely.box(bounds.xmin, bounds.ymin, bounds.xmax, bounds.ymax)
            attrs = next(sample_records())[0]
            attrs.update(bbox_xmin=bounds.xmin, bbox_ymin=bounds.ymin,
                         bbox_xmax=bounds.xmax, bbox_ymax=bounds.ymax)
            with tempfile.TemporaryDirectory() as root:
                path, _ = self.build(root, [(attrs, shapely.to_wkb(shape))], bounds)
                generalized = list(iter_geopackage_features(path, "landmass_coarse"))[0][1]
                self.assertTrue(generalized.equals(shape))

    def test_opt_in_normalization_nodes_edges_and_reports_changes(self):
        import shapely
        from shapely.affinity import translate
        # Same coastline with an extra vertex and a sub-grid numerical overlap.
        land = shapely.Polygon([(0, 0), (1.00000000001, 0),
                                (1.00000000001, 1), (0, 1)])
        ocean = shapely.Polygon([(1, 0), (2, 0), (2, 1), (1, 1), (1, 0.5)])
        parts = {"landmass": [land], "ocean": [ocean]}
        with self.assertRaisesRegex(ValueError, "invalid or non-edge-matched"):
            generalize_tile(parts, tile_id="numerical", options=GeneralizationOptions())
        options = GeneralizationOptions(precision_grid_degrees=1e-10)
        levels, stats = generalize_tile(parts, tile_id="numerical", options=options)
        self.assertGreater(stats["normalization"]["landmass"]["symmetric_difference_deg2"], 0)
        for shapes in levels.values():
            self.assertTrue(shapely.coverage_is_valid(list(shapes.values())))
            self.assertTrue(shapely.union_all(list(shapes.values())).equals(shapely.box(0, 0, 2, 1)))
        self.assertEqual(stats["normalization"]["landmass"]["components_after"], 1)
        with self.assertRaisesRegex(ValueError, "overlap remains"):
            generalize_tile({"landmass": [shapely.box(0, 0, 2, 2)],
                             "ocean": [shapely.box(1, 0, 3, 2)]}, tile_id="overlap", options=options)
        gap, _ = generalize_tile({"landmass": [shapely.box(0, 0, 1, 1)],
                                  "ocean": [shapely.box(2, 0, 3, 1)]}, tile_id="gap", options=options)
        self.assertEqual(shapely.union_all(list(gap["coarse"].values())).area, 2)

        records = []
        for attrs, wkb in sample_records():
            shape = translate(shapely.from_wkb(wkb), xoff=1e-11)
            records.append((attrs, shapely.to_wkb(shape)))
        with tempfile.TemporaryDirectory() as strict_root, tempfile.TemporaryDirectory() as rounded_root:
            _, strict = self.build(strict_root, records=records)
            path, rounded = self.build(rounded_root, records=records, options=options)
            for surface in ("landmass", "ocean"):
                self.assertEqual(strict["layers"][surface + "_full"], rounded["layers"][surface + "_full"])
                attrs, _ = next(iter_geopackage_features(path, surface + "_fine"))
                self.assertEqual(attrs["precision_grid_degrees"], 1e-10)
                self.assertGreaterEqual(attrs["normalization_area_change_deg2"], 0)
            self.assertEqual(len(rounded["normalization"]), 2)

    def test_normalization_reports_subgrid_component_and_hole_loss(self):
        import shapely
        tiny_hole = shapely.box(0.50001, 0.50001, 0.50002, 0.50002)
        tiny_island = shapely.box(2.00001, 0.00001, 2.00002, 0.00002)
        land = shapely.union_all([shapely.box(0, 0, 1, 1).difference(tiny_hole), tiny_island])
        _, stats = generalize_tile({"landmass": [land]}, tile_id="subgrid",
            options=GeneralizationOptions(precision_grid_degrees=0.0001))
        changes = stats["normalization"]["landmass"]
        self.assertEqual((changes["components_before"], changes["components_after"]), (2, 1))
        self.assertEqual((changes["holes_before"], changes["holes_after"]), (1, 0))
        self.assertGreater(changes["symmetric_difference_deg2"], 0)


class StyleTests(unittest.TestCase):
    def test_filters_fills_and_exactly_one_scale_level(self):
        ns = {"s": "http://www.opengis.net/sld", "o": "http://www.opengis.net/ogc"}
        ranges = []
        for level in ("full", *DEFAULT_LEVELS):
            root = ET.parse(ROOT / "geoserver" / "styles" / f"surfaces_{level}.sld").getroot()
            rules = root.findall(".//s:Rule", ns)
            self.assertEqual(len(rules), 2)
            for rule, surface, color in zip(rules, ("ocean", "landmass"), ("#78bce0", "#cfbd8a")):
                self.assertEqual(rule.findtext(".//o:PropertyName", namespaces=ns), "surface")
                self.assertEqual(rule.findtext(".//o:Literal", namespaces=ns), surface)
                self.assertEqual(rule.findtext(".//s:CssParameter[@name='fill']", namespaces=ns), color)
                self.assertIsNone(rule.find(".//s:Stroke", ns))
            ranges.append((float(rules[0].findtext("s:MinScaleDenominator", "0", ns)),
                           float(rules[0].findtext("s:MaxScaleDenominator", "inf", ns))))
            self.assertEqual(rules[0].findtext("s:MinScaleDenominator", namespaces=ns),
                             rules[1].findtext("s:MinScaleDenominator", namespaces=ns))
            self.assertEqual(rules[0].findtext("s:MaxScaleDenominator", namespaces=ns),
                             rules[1].findtext("s:MaxScaleDenominator", namespaces=ns))
        for scale in (1, 499999, 500000, 500001, 4999999, 5000000, 5000001, 24999999, 25000000, 25000001, 1e9):
            self.assertEqual(sum(lo <= scale < hi for lo, hi in ranges), 1, scale)


if __name__ == "__main__":
    unittest.main()
