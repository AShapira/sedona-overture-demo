"""Offline source integrity, endpoint-resolution, and geodesic regressions."""

from copy import deepcopy
import csv
import hashlib
import importlib.util
import io
import math
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from overture_lab.flight_routes import (
    FILE_COLUMNS, build_flight_records, flight_source_uri, geodesic_route, parse_bundle,
)


def fixture_tables():
    def airport(identifier, code, lon, lat, kind="airport"):
        return [identifier, f"Airport {code}", "City", "Country", code, None, str(lat), str(lon),
                "0", "0", "U", "UTC", kind, "Fixture"]
    airports = [airport("1", "AAA", 179, 10), airport("2", "BBB", -179, 11),
                airport("3", "DUP", 5, 30), airport("4", "DUP", 6, 31),
                airport("5", "BAD", "nan", 0), airport("6", "PRT", 30, 30, "port")]
    valid = ["XY", "10", "AAA", "1", "BBB", "2", "", "0", "320"]
    routes = [valid, valid.copy(), ["XY", "10", "BBB", "2", "AAA", "1", "Y", "1", "320 737"],
              ["XY", None, "AAA", None, "BBB", "2", "", "0", None],
              ["XY", "10", "OLD", "1", "BBB", "2", "", "0", None],
              ["XY", "10", "AAA", "999", "BBB", "2", "", "0", None],
              ["XY", "10", "DUP", None, "BBB", "2", "", "0", None],
              ["XY", "10", "BAD", "5", "BBB", "2", "", "0", None],
              ["XY", "10", "PRT", "6", "BBB", "2", "", "0", None],
              ["XY", "10", "AAA", "1", "AAA", "1", "", "0", None],
              ["XY", "10", "AAA", "1", "BBB", "2", "", "oops", None]]
    return {"airports.dat": airports, "airlines.dat": [["10", "Fixture Air", "", "XY", None, "CALL", "Country", "N"]],
            "routes.dat": routes}


def fixture_bundle():
    tables = fixture_tables()
    manifest = {"format_version": 1, "dataset": "OpenFlights", "revision": "a" * 40,
                "route_period": "2014-06", "license": "ODbL-1.0", "downloaded_at_utc": "2026-11-17T00:00:00+00:00", "files": {}}
    contents = {}
    for name, rows in tables.items():
        stream = io.StringIO()
        csv.writer(stream).writerows([[r"\N" if item is None else item for item in row] for row in rows])
        contents[name] = stream.getvalue().encode("utf-8")
        manifest["files"][name] = {"sha256": hashlib.sha256(contents[name]).hexdigest(),
                                   "bytes": len(contents[name]), "rows": len(rows)}
    return manifest, contents


class OfflineBundleTests(unittest.TestCase):
    def test_local_and_s3_source_locations(self):
        self.assertEqual(flight_source_uri("/data/overture"), "/data/overture/external_sources/openflights")
        self.assertEqual(flight_source_uri("s3a://bucket/release"), "s3a://bucket/release/external_sources/openflights")
        self.assertEqual(flight_source_uri("/data", "s3://other/flights/"), "s3a://other/flights")
        self.assertEqual(flight_source_uri("/data", "file:///shared/flights"), "file:///shared/flights")
        for uri in ("https://example.com/routes", "relative/folder", "s3a://bucket", "s3a://user:secret@bucket/path", "file://remote/path"):
            with self.subTest(uri=uri), self.assertRaises(ValueError):
                flight_source_uri("/data", uri)

    def test_bundle_verification_and_null_values(self):
        manifest, contents = fixture_bundle()
        self.assertEqual(parse_bundle(manifest, contents), fixture_tables())
        broken = dict(contents, **{"routes.dat": contents["routes.dat"] + b"x"})
        with self.assertRaisesRegex(ValueError, "SHA-256"):
            parse_bundle(manifest, broken)
        broken_manifest = deepcopy(manifest)
        broken_manifest["files"]["routes.dat"]["rows"] += 1
        with self.assertRaisesRegex(ValueError, "CSV"):
            parse_bundle(broken_manifest, contents)
        broken_manifest["route_period"] = "2026-11"
        with self.assertRaisesRegex(ValueError, "manifest"):
            parse_bundle(broken_manifest, contents)


GEO_AVAILABLE = all(importlib.util.find_spec(name) for name in ("pyproj", "shapely"))


@unittest.skipUnless(GEO_AVAILABLE, "Run geodesic tests in the pinned Sedona image")
class FlightGeometryTests(unittest.TestCase):
    def test_date_line_both_directions_and_boundary_endpoints(self):
        from pyproj import Geod
        geod = Geod(ellps="WGS84")
        examples = [(179, 10, -179, 11), (-179, 11, 179, 10), (180, 10, -179, 11),
                    (-180, 10, 179, 11), (179, 10, -180, 11), (-179, 10, 180, 11),
                    (151.177, -33.946, -118.408, 33.943), (-0.4543, 51.47, -73.7781, 40.6413),
                    (20, 80, -160, 80)]
        for coordinates in examples:
            with self.subTest(coordinates=coordinates):
                geometry, distance = geodesic_route(*coordinates, max_segment_km=200)
                self.assertTrue(geometry.is_valid and not geometry.is_empty)
                lines = [geometry] if geometry.geom_type == "LineString" else list(geometry.geoms)
                self.assertLess(geod.inv(*coordinates[:2], *lines[0].coords[0])[2], 0.01)
                self.assertLess(geod.inv(*coordinates[2:], *lines[-1].coords[-1])[2], 0.01)
                measured = 0
                for line in lines:
                    for a, b in zip(line.coords, list(line.coords)[1:]):
                        self.assertLessEqual(abs(b[0] - a[0]), 180)
                        length = geod.inv(*a, *b)[2]
                        self.assertLessEqual(length, 200_000.01)
                        measured += length
                self.assertAlmostEqual(measured / 1000, distance, places=5)
                if abs(coordinates[0] - coordinates[2]) > 180 and abs(coordinates[0]) != 180 and abs(coordinates[2]) != 180:
                    self.assertEqual(geometry.geom_type, "MultiLineString")

    def test_geodesic_is_not_a_straight_lon_lat_chord(self):
        geometry, distance = geodesic_route(-0.4543, 51.47, -73.7781, 40.6413)
        self.assertTrue(5500 < distance < 5600)
        self.assertGreater(max(point[1] for point in geometry.coords), 53)
        for coordinates in ((0, 0, 0, 0), (181, 0, 0, 0), (0, math.nan, 0, 0)):
            with self.assertRaises(ValueError):
                geodesic_route(*coordinates)
        for step in (0, -1, math.nan, True, 1001):
            with self.assertRaises(ValueError):
                geodesic_route(0, 0, 1, 1, max_segment_km=step)

    def test_records_account_for_all_rows_without_inventing_endpoint_matches(self):
        manifest, contents = fixture_bundle()
        records, excluded, report = build_flight_records(parse_bundle(manifest, contents), manifest)
        self.assertEqual((len(records), len(excluded)), (5, 6))
        self.assertEqual(report["input_route_rows"], len(records) + len(excluded))
        self.assertEqual(len({row["id"] for row in records}), 5)
        self.assertEqual(records[0]["geometry_wkb"], records[1]["geometry_wkb"])
        self.assertEqual(records[2]["stops"], 1)
        self.assertEqual(records[3]["source_match_method"], "unique_code")
        self.assertIsNone(records[3]["airline_name"])
        self.assertTrue(records[4]["source_code_disagrees"])
        self.assertEqual(records[0]["airline_name"], "Fixture Air")  # Historical inactive airline stays.
        self.assertEqual(report["endpoint_code_disagreements"], 1)
        self.assertIn("source:unknown_airport_id", excluded[0]["reason"])
        self.assertIn("source:ambiguous_airport_code", excluded[1]["reason"])
        self.assertIn("coincident_endpoints", excluded[4]["reason"])


if __name__ == "__main__":
    unittest.main()
