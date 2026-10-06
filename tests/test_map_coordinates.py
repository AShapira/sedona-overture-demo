import contextlib
import io
import json
from pathlib import Path
import sys
from types import SimpleNamespace
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))

from overture_lab.visualize import (
    geometry_coordinate_count, deck_coordinate_counts, notify_map_coordinates,
    _offline_deck_document, static_geometry_plot,
)


class MapCoordinateTests(unittest.TestCase):
    def test_positions_include_holes_closures_and_geometry_collections(self):
        ring = [[0, 0], [2, 0], [2, 2], [0, 0]]
        polygon = {"type": "Polygon", "coordinates": [ring, ring]}
        collection = {"type": "GeometryCollection", "geometries": [
            polygon, {"type": "Point", "coordinates": [1, 2, 3]},
            {"type": "MultiPolygon", "coordinates": [[ring], [ring]]},
        ]}
        self.assertEqual(geometry_coordinate_count(collection), 17)
        self.assertEqual(geometry_coordinate_count({"type": "Point", "coordinates": []}), 0)
        self.assertEqual(geometry_coordinate_count(None), 0)
        feature = {"type": "Feature", "geometry": collection}
        self.assertEqual(geometry_coordinate_count({
            "type": "FeatureCollection", "features": [feature, feature],
        }), 34)

    def test_counts_visible_layers_separately_and_excludes_background(self):
        geometry = {"type": "LineString", "coordinates": [[0, 0], [1, 1]]}
        counts = deck_coordinate_counts({"layers": [
            {"id": "large", "data": geometry, "@@type": "GeoJsonLayer"},
            {"id": "medium", "data": geometry, "@@type": "GeoJsonLayer"},
            {"id": "hidden", "data": geometry, "visible": False},
            {"id": "markers", "data": [{"position": [1, 2]}], "@@type": "ScatterplotLayer"},
            {"id": "background", "data": "https://example.org/wms", "@@type": "_WMSLayer"},
        ]})
        self.assertEqual(counts, {"large": 2, "medium": 2, "markers": 1})

    def test_notice_is_printed_before_static_plotting(self):
        stream = io.StringIO()
        frame = SimpleNamespace(empty=True, __geo_interface__={
            "type": "LineString", "coordinates": [[0, 0], [1, 1]],
        })
        axis = SimpleNamespace(text=lambda *a, **k: None, set_axis_off=lambda: None,
                               set_title=lambda title: None)
        def subplots(**kwargs):
            self.assertIn("Drawing map: 2 coordinate positions", stream.getvalue())
            return None, axis
        def rc_context(options):
            self.assertEqual(options, {"path.simplify": False})
            return contextlib.nullcontext()
        pyplot = SimpleNamespace(subplots=subplots, rc_context=rc_context)
        with patch.dict(sys.modules, {"matplotlib": SimpleNamespace(pyplot=pyplot),
                                      "matplotlib.pyplot": pyplot}), \
             patch("overture_lab.visualize.collect_geodataframe", return_value=frame), \
             contextlib.redirect_stdout(stream):
            static_geometry_plot(None, limit=1)
            self.assertEqual(notify_map_coordinates({"Empty": None}), {"Empty": 0})

    def test_interactive_notice_precedes_rendering_and_escapes_layer_names(self):
        attack = '</script><img src=x onerror="alert(1)">'
        deck = SimpleNamespace(to_json=lambda: json.dumps({"layers": [{
            "id": attack, "data": {"type": "Point", "coordinates": [1, 2]},
        }]}))
        stream = io.StringIO()
        with contextlib.redirect_stdout(stream):
            document = _offline_deck_document(deck, bundle="")
        self.assertIn("Drawing map: 1 coordinate positions", stream.getvalue())
        self.assertLess(document.index('id="map-coordinate-notice"'), document.index("createDeck("))
        self.assertNotIn("<img", document)
        self.assertIn("&lt;img", document)
        self.assertIn(r"\u003c/script\u003e", document)
