from html.parser import HTMLParser
import importlib.util
import json
from pathlib import Path
import sys
from types import SimpleNamespace
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from overture_lab.config import WmsSettings
from overture_lab.region_overview import (
    PUBLIC_OSM_WMS, PUBLIC_OSM_ATTRIBUTION, overview_basemap,
    check_overview_limit, build_region_overview_deck,
)
from overture_lab.visualize import _offline_deck_document


class RegionOverviewTests(unittest.TestCase):
    def test_background_modes_are_local_and_explicit(self):
        internal = WmsSettings("https://internal.example/wms", ("base",), "EPSG:4326")
        self.assertEqual(overview_basemap("public_osm", internal),
                         (PUBLIC_OSM_WMS, PUBLIC_OSM_ATTRIBUTION))
        self.assertEqual(overview_basemap("configured", internal, "Provider"),
                         (internal, "Provider"))
        self.assertEqual(overview_basemap("none", internal), (None, ""))
        with self.assertRaisesRegex(ValueError, "requires WMS_URL"):
            overview_basemap("configured", None)
        with self.assertRaisesRegex(ValueError, "BASEMAP_MODE must be"):
            overview_basemap("unknown", None)

    def test_limit_rejects_partial_maps_and_counts_markers(self):
        counts = {"large": 28, "medium": 8, "cities": 1, "markers": 1}
        self.assertEqual(check_overview_limit(counts, 38), 38)
        with self.assertRaisesRegex(ValueError, "needs 38 features.*MAP_FEATURE_LIMIT=37"):
            check_overview_limit(counts, 37)

    def test_controls_attribution_and_tooltips_do_not_interpret_source_html(self):
        attack = '</script><img src="bad" onerror="alert(1)">'
        class FakeDeck:
            _tooltip = {"text": "{display_name}"}
            def to_json(self):
                return json.dumps({"layers": [], "display_name": attack})
        controls = {"groups": [{"label": attack}], "cities": [{"label": attack}],
                    "description": attack}
        document = _offline_deck_document(
            FakeDeck(), bundle="window.createDeck = () => null;",
            controls=controls, attribution=attack,
        )
        class Tags(HTMLParser):
            def __init__(self):
                super().__init__()
                self.tags = []
            def handle_starttag(self, tag, attrs):
                self.tags.append(tag)
        parser = Tags()
        parser.feed(document)
        self.assertNotIn("img", parser.tags)
        self.assertEqual(parser.tags.count("script"), 2)
        self.assertIn(r"\u003c/script\u003e", document)
        self.assertIn("&lt;img", document)
        self.assertNotIn("setupMapControls", _offline_deck_document(FakeDeck(), bundle=""))

    @unittest.skipUnless(importlib.util.find_spec("pydeck"), "pydeck unavailable")
    def test_map_groups_preserve_overlap_and_toggle_city_markers_together(self):
        def frame(codes):
            return SimpleNamespace(
                total_bounds=[0, 0, 12, 12],
                __geo_interface__={"type": "FeatureCollection", "features": [
                    {"type": "Feature", "properties": {"country": code},
                     "geometry": {"type": "Point", "coordinates": [1, 1]}}
                    for code in codes
                ]},
            )
        overview = SimpleNamespace(
            extent_label="Land and territorial waters",
            large=frame(["AA", "BB"]), medium=frame(["AA"]), cities=frame(["AA"]),
            markers=[{"position": [1, 1], "display_name": "City A", "country": "AA"}],
            city_views=[{"id": "a", "label": "City A", "bounds": [[0, 0], [1, 1]]}],
        )
        deck, controls = build_region_overview_deck(overview, wms=PUBLIC_OSM_WMS)
        layers = {item["id"]: item for item in json.loads(deck.to_json())["layers"]}
        self.assertEqual(len(layers["overview-large"]["data"]["features"]), 2)
        self.assertEqual(len(layers["overview-medium"]["data"]["features"]), 1)
        city_group = next(group for group in controls["groups"] if group["id"] == "cities")
        self.assertEqual(city_group["layer_ids"], ["overview-cities", "overview-city-markers"])
        self.assertEqual(deck._tooltip, {"text": "{display_name}\nCode: {country}\n{membership}\nExtent: {extent}"})
        self.assertEqual(controls["description"],
                         "Country extent: Land and territorial waters. Cities: land only.")
        _, offline_controls = build_region_overview_deck(overview)
        self.assertNotIn("background", [item["id"] for item in offline_controls["groups"]])
