"""Dependency-free normalization/configuration regressions, also run in CI."""
import json
from pathlib import Path
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
from overture_lab.postgis_import.contract import normalize, normalized, identifier, validate_bbox
from overture_lab.postgis_import.database import read_connections
from overture_lab.postgis_import.utm import utm_srid, bbox_utm_srids
from overture_lab.postgis_import.contract import tables_for


class ContractTests(unittest.TestCase):
    def test_versioned_feature_contract(self):
        self.assertNotIn(("geometry_m_srid", "int"), tables_for(2)["features"])
        self.assertIn(("geometry_m_srid", "int"), tables_for(3)["features"])
        with self.assertRaises(ValueError):
            tables_for(4)

    def test_utm_zone_edges_and_hemispheres(self):
        for longitude, latitude, expected in [(-180, 0, 32601), (180, 0, 32660),
                (5.999999, 50, 32631), (6, 50, 32632), (6, -1, 32732),
                (34.78, 31.98, 32636), (0, -80, 32731), (0, 84, 32631)]:
            self.assertEqual(utm_srid(longitude, latitude), expected)
        for point in [(181, 0), (0, 84.001), (0, -80.001), (float("nan"), 1)]:
            with self.assertRaises(ValueError):
                utm_srid(*point)

    def test_bbox_lists_all_touched_zones(self):
        self.assertEqual(bbox_utm_srids([5.9, 49, 6.1, 51]), [32631, 32632])
        self.assertEqual(bbox_utm_srids([5.9, -1, 6.1, 1]), [32631, 32632, 32731, 32732])
        self.assertEqual(bbox_utm_srids([5, -2, 6, -1]), [32731, 32732])
        self.assertEqual(bbox_utm_srids([5, 85, 7, 86]), [])

    def test_unicode_order_multiplicity_and_reference_paths(self):
        payload = {"names": {"primary": "Straße", "common": {"he": "רִאשׁוֹן לציון", "en": "Straße"}},
                   "categories": {"primary": "shop", "alternate": ["shop", "cafe"]},
                   "addresses": [{"street": "Main", "number": "1", "locality": "City"}] * 2,
                   "connectors": [{"id": "c1"}, {"id": "c1"}], "division_id": "d1",
                   "sources": [{"record_id": "do-not-index"}]}
        result = normalize({"relation": "places_place", "id": "p1", "raw_json": json.dumps(payload)})
        self.assertEqual([r["name"] for r in result["names"]], ["Straße", "רִאשׁוֹן לציון", "Straße"])
        self.assertEqual(result["names"][0]["normalized"], " strasse ")
        self.assertEqual([r["ordinal"] for r in result["addresses"]], [0, 1])
        self.assertEqual([r["is_primary"] for r in result["categories"]], [True, False, False])
        self.assertEqual([(r["field"], r["target_id"]) for r in result["links"]],
                         [("connectors[0].id", "c1"), ("connectors[1].id", "c1"), ("division_id", "d1")])

    def test_address_feature_and_unavailable_metric(self):
        result = normalize({"relation": "addresses_address", "id": "a", "geometry_m": "POINT (Infinity NaN)",
                            "raw_json": json.dumps({"postal_city": "Town", "number": "7"})})
        self.assertIsNone(result["features"][0]["geometry_m"])
        self.assertEqual(result["addresses"][0]["city"], "Town")
        self.assertEqual(result["addresses"][0]["number"], "7")

    def test_empty_values_and_casefold(self):
        self.assertEqual(normalized("Ａ_B—C"), " a b c ")
        result = normalize({"relation": "base_land", "id": "l", "raw_json": "{}"})
        self.assertEqual([len(result[k]) for k in result], [1, 0, 0, 0, 0])
        with self.assertRaises(ValueError):
            normalize({"relation": "base_land", "id": None, "raw_json": "{}"})

    def test_identifiers_and_bbox(self):
        for value in ("public; DROP", "x.y", "A", "a" * 64):
            with self.assertRaises(ValueError):
                identifier(value)
        for bbox in ([0, 0, float("nan"), 1], [1, 0, -1, 1], [0, 0, 181, 1]):
            with self.assertRaises(ValueError):
                validate_bbox(bbox)

    def test_secret_permissions_and_timeout(self):
        with tempfile.TemporaryDirectory() as directory:
            secret = Path(directory) / "password"
            secret.write_text("fixture")
            secret.chmod(0o600)
            config = {"schema": "import_test", "postgis": {"host": "db", "port": 5432,
                      "dbname": "test", "user": "loader", "password_file": str(secret)}}
            self.assertEqual(read_connections(config)["schema"], "import_test")
            secret.chmod(0o644)
            with self.assertRaises(ValueError):
                read_connections(config)


if __name__ == "__main__":
    unittest.main()
