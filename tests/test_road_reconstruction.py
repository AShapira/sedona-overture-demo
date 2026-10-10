"""Geometry/topology contracts for the bounded reconstruction pass.

Run in the pinned Sedona image (Shapely and pyproj are already bundled).
"""
import importlib.util
from pathlib import Path
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))
from overture_lab.road_reconstruction import (
    ReconstructionLimits, _direction, _identity, reconstruct_rows,
)

HAS_GEOMETRY = all(importlib.util.find_spec(m) for m in ("shapely", "pyproj"))
if HAS_GEOMETRY:
    from pyproj import Geod
    from shapely import from_wkb, to_wkb
    from shapely.geometry import LineString


def denial(heading="backward", **when):
    return {"access_type": "denied", "when": {"heading": heading, **when}}


class DirectionTests(unittest.TestCase):
    def test_blank_identifiers_use_named_fallback(self):
        row = {"id": "source", "class": "primary", "names": {"primary": "  Main   Street "}}
        identity, basis, keys = _identity(row, [{"wikidata": " ", "network": " ", "ref": " "}])
        self.assertEqual((identity, basis, keys), (("name", "main street"), "name", []))

    def test_rules_are_ordered_and_mode_scoped(self):
        self.assertEqual(_direction([denial()], 0.5), "forward")
        self.assertEqual(_direction([denial("forward")], 0.5), "backward")
        allowed = {"access_type": "allowed", "when": {"heading": "backward", "mode": ["car"]}}
        self.assertEqual(_direction([denial(), allowed], 0.5), "bidirectional_assumed")
        self.assertEqual(_direction([allowed, denial()], 0.5), "forward")
        self.assertEqual(_direction([denial(mode=["bus"])], 0.5), "bidirectional_assumed")
        self.assertEqual(_direction([denial(), denial("forward")], 0.5), "unknown")
        self.assertEqual(_direction([denial(), {"access_type": "allowed"}], 0.5), "bidirectional_assumed")
        self.assertEqual(_direction([{"access_type": "allowed"}, denial()], 0.5), "forward")

    def test_conditional_unknown_can_be_resolved_by_a_later_rule(self):
        conditional = denial(during="Mo-Fr")
        self.assertEqual(_direction([conditional], 0.5), "unknown")
        self.assertEqual(_direction([conditional, denial()], 0.5), "forward")
        self.assertEqual(_direction([denial(), conditional], 0.5), "unknown")
        # Blanket closures are access information, not proof of one-way travel.
        self.assertEqual(_direction([{"access_type": "denied"}], 0.5), "bidirectional_assumed")

    def test_non_directional_vehicle_limits_do_not_fragment_carriageways(self):
        height = {"access_type": "denied", "when": {"vehicle": [
            {"dimension": "height", "comparison": "greater_than", "value": 5.4, "unit": "m"}]}}
        self.assertEqual(_direction([denial(), height], 0.5), "forward")
        self.assertEqual(_direction([height, denial()], 0.5), "forward")
        self.assertEqual(_direction([height], 0.5), "bidirectional_assumed")
        height["when"]["heading"] = "forward"
        self.assertEqual(_direction([denial(), height], 0.5), "unknown")


@unittest.skipUnless(HAS_GEOMETRY, "Run geometry tests in the pinned Sedona container")
class ReconstructionTests(unittest.TestCase):
    def setUp(self):
        self.rows, self.connectors = [], {}
        self.geod = Geod(ellps="WGS84")

    def add(self, identifier, points, nodes, *, one_way=True, name="Road", routes=None,
            subclass=None, subclass_rules=None, access=None, road_class="primary", countries=None):
        geometry = LineString(points)
        total = self.geod.geometry_length(geometry)
        distances = [0.0]
        for a, b in zip(points, points[1:]):
            distances.append(distances[-1] + self.geod.inv(*a, *b)[2])
        references = []
        for index, node in nodes.items():
            self.connectors[node] = points[index]
            references.append({"connector_id": node, "at": distances[index] / total})
        row = dict(id=identifier, geometry=to_wkb(geometry), connectors=references,
                   names={"primary": name}, routes=routes, **{"class": road_class},
                   subclass=subclass, subclass_rules=subclass_rules,
                   access_restrictions=access if access is not None else [denial()] if one_way else [],
                   country_codes=countries or ["AA"])
        self.rows.append(row)
        return row

    def run_graph(self, **kwargs):
        return reconstruct_rows(self.rows, self.connectors, release="fixture", **kwargs)

    def test_two_carriageways_and_deterministic_membership(self):
        for side, x, ys in [("n", 0, [0, 1, 2]), ("s", 0.01, [2, 1, 0])]:
            for i in range(2):
                self.add(f"{side}{i}", [(x, ys[i]), (x, ys[i+1])], {0: f"{side}{i}", 1: f"{side}{i+1}"})
        result = self.run_graph()
        self.assertEqual({r["direction"] for r in result.roads}, {"northbound", "southbound"})
        self.assertEqual([r["source_segment_count"] for r in result.roads], [2, 2])
        self.rows.reverse()
        self.assertEqual(result, self.run_graph())

    def test_backward_geometry_is_reversed_for_travel(self):
        self.add("a", [(0, 0), (0, 1)], {0: "a", 1: "b"})
        self.add("b", [(0, 2), (0, 1)], {0: "c", 1: "b"}, access=[denial("forward")])
        result = self.run_graph()
        self.assertEqual(len(result.roads), 1)
        self.assertEqual(list(from_wkb(result.roads[0]["geometry"]).coords), [(0, 0), (0, 1), (0, 2)])
        self.assertEqual([m["reversed"] for m in result.membership], [False, True])

    def test_spark_binary_values_and_partial_blanket_override(self):
        row = self.add("a", [(0, 0), (0, 1)], {0: "a", 1: "b"}, access=[
            denial(), {"access_type": "allowed", "between": [0.5, 1.0]}])
        row["geometry"] = bytearray(row["geometry"])
        result = self.run_graph()
        self.assertEqual(len(result.roads), 2)
        self.assertEqual({r["direction"] for r in result.roads}, {"northbound", "bidirectional"})

    def test_two_way_is_one_geometry_and_stops_at_one_way_change(self):
        self.add("a", [(0, 0), (0, 1)], {0: "a", 1: "b"}, one_way=False)
        self.add("b", [(0, 2), (0, 1)], {0: "c", 1: "b"}, one_way=False)
        self.add("c", [(0, 2), (0, 3)], {0: "c", 1: "d"})
        result = self.run_graph()
        self.assertEqual(len(result.roads), 2)
        self.assertEqual(sorted(r["direction"] for r in result.roads), ["bidirectional", "northbound"])

    def test_internal_connector_external_road_and_grade_separation(self):
        self.add("a", [(0, 0), (0, 1), (0, 2)], {0: "a", 1: "junction", 2: "b"})
        self.add("b", [(0, 1), (1, 1)], {0: "junction", 1: "c"}, name="Other")
        self.add("overpass", [(-1, 0.5), (1, 0.5)], {0: "over-a", 1: "over-b"})
        result = self.run_graph()
        self.assertEqual(len(result.roads), 3)
        self.assertEqual(len(result.membership), 4)
        road = next(r for r in result.roads if from_wkb(r["geometry"]).coords[0] == (0, 0))
        self.assertEqual(len(from_wkb(road["geometry"]).coords), 3)

    def test_same_identity_branch_is_not_arbitrarily_joined(self):
        self.add("a", [(0, 0), (0, 1)], {0: "a", 1: "fork"})
        self.add("b", [(0, 1), (0, 2)], {0: "fork", 1: "b"})
        self.add("c", [(0, 1), (1, 2)], {0: "fork", 1: "c"})
        result = self.run_graph()
        self.assertEqual(len(result.roads), 3)
        self.assertIn("ambiguous_branch", result.summary["diagnostics"])

    def test_anonymous_chain_stops_at_named_junction_and_class_change(self):
        self.add("a", [(0, 0), (0, 1)], {0: "a", 1: "b"}, name=None)
        self.add("b", [(0, 1), (0, 2)], {0: "b", 1: "c"}, name=None)
        self.add("c", [(0, 2), (0, 3)], {0: "c", 1: "d"}, name=None)
        self.add("d", [(0, 2), (1, 2)], {0: "c", 1: "e"}, name="Branch")
        self.add("e", [(0, 3), (0, 4)], {0: "d", 1: "f"}, name=None, road_class="trunk")
        result = self.run_graph()
        self.assertEqual(len(result.roads), 4)
        self.assertEqual(sorted(r["source_segment_count"] for r in result.roads), [1, 1, 1, 2])

    def test_no_join_by_equal_coordinates_or_disconnected_names(self):
        self.add("a", [(0, 0), (0, 1)], {0: "a", 1: "b"})
        self.add("b", [(0, 1), (0, 2)], {0: "different-b", 1: "c"})
        self.assertEqual(len(self.run_graph().roads), 2)

    def test_directed_and_bidirectional_loops(self):
        for one_way in (True, False):
            self.rows, self.connectors = [], {}
            self.add("a", [(0, 0), (0, 1)], {0: "a", 1: "b"}, one_way=one_way)
            self.add("b", [(0, 1), (1, 1)], {0: "b", 1: "c"}, one_way=one_way)
            self.add("c", [(1, 1), (0, 0)], {0: "c", 1: "a"}, one_way=one_way)
            result = self.run_graph()
            self.assertEqual(len(result.roads), 1)
            self.assertEqual(result.roads[0]["direction"], "loop")
            self.assertTrue(from_wkb(result.roads[0]["geometry"]).is_closed)

    def test_single_segment_ring(self):
        self.add("ring", [(0, 0), (0, 1), (1, 1), (0, 0)], {0: "a", 3: "a"})
        self.assertEqual(self.run_graph().roads[0]["direction"], "loop")

    def test_concurrent_routes_are_not_duplicated_and_identity_changes_split(self):
        a, b = {"wikidata": "Q1", "ref": "1"}, {"wikidata": "Q2", "ref": "2"}
        self.add("a", [(0, 0), (0, 1)], {0: "a", 1: "b"}, routes=[a])
        self.add("b", [(0, 1), (0, 2)], {0: "b", 1: "c"}, routes=[b, a, a])
        self.add("c", [(0, 2), (0, 3)], {0: "c", 1: "d"}, routes=[a, b])
        result = self.run_graph()
        self.assertEqual(len(result.roads), 2)
        self.assertEqual(len(result.membership), 3)
        self.assertEqual(sorted(len(r["route_ids"]) for r in result.roads), [1, 2])

    def test_partial_membership_partial_links_and_geodesic_cuts(self):
        points = [(0, 60), (1, 60), (1, 61)]
        row = self.add("a", points, {0: "a", 2: "b"}, routes=[{"ref": "1", "between": [0.25, 0.75]}],
            subclass_rules=[{"value": "link", "between": [0, 0.25]}])
        result = self.run_graph()
        self.assertEqual(len(result.roads), 2)
        self.assertEqual([(m["start_lr"], m["end_lr"]) for m in result.membership], [(0.25, 0.75), (0.75, 1.0)])
        total = self.geod.geometry_length(LineString(points))
        self.assertAlmostEqual(result.summary["excluded_link_length_m"], total * 0.25, places=5)
        # A planar 25% cut would be at longitude .5, which is wrong here.
        self.assertGreater(from_wkb(result.roads[0]["geometry"]).bounds[0], 0.5)
        self.assertAlmostEqual(result.summary["retained_length_m"], total * 0.75, places=3)

    def test_subclass_rule_overrides_whole_link(self):
        self.add("a", [(0, 0), (0, 1)], {0: "a", 1: "b"}, subclass="link",
                 subclass_rules=[{"value": None, "between": [0.5, 1]}])
        result = self.run_graph()
        self.assertEqual(len(result.roads), 1)
        self.assertEqual(result.membership[0]["start_lr"], 0.5)

    def test_partial_direction_change_and_conditional_diagnostics(self):
        self.add("a", [(0, 0), (0, 1)], {0: "a", 1: "b"},
                 access=[dict(denial(), between=[0, 0.5])])
        self.add("b", [(0, 1), (0, 2)], {0: "b", 1: "c"}, access=[denial(during="Mo-Fr")])
        result = self.run_graph()
        self.assertEqual(len(result.roads), 3)
        self.assertEqual({r["direction"] for r in result.roads}, {"northbound", "bidirectional", "unknown"})

    def test_representative_class_and_name_by_length_and_boundary_flag(self):
        routes = [{"ref": "1", "wikidata": "Q1"}]
        self.add("a", [(0, 0), (0, 1)], {0: "a", 1: "b"}, routes=routes, name="Short", road_class="motorway")
        row = self.add("b", [(0, 1), (0, 3)], {0: "b", 1: "c"}, routes=routes, name="Long", road_class="trunk")
        row["extent_limited"] = True
        result = self.run_graph()
        self.assertEqual((result.roads[0]["name"], result.roads[0]["road_class"]), ("Long", "trunk"))
        self.assertEqual(result.summary["diagnostics"]["region_limited"], 1)

    def test_country_scoped_refs_do_not_merge_across_jurisdictions(self):
        self.add("a", [(0, 0), (0, 1)], {0: "a", 1: "b"}, routes=[{"ref": "1"}], countries=["AA"])
        self.add("b", [(0, 1), (0, 2)], {0: "b", 1: "c"}, routes=[{"ref": "1"}], countries=["BB"])
        self.assertEqual(len(self.run_graph().roads), 2)

    def test_fail_on_limits_bad_ranges_missing_connectors_and_duplicates(self):
        row = self.add("a", [(0, 0), (0, 1)], {0: "a", 1: "b"})
        for limits in (ReconstructionLimits(segments=0), ReconstructionLimits(connector_references=1),
                       ReconstructionLimits(vertices=1), ReconstructionLimits(pieces=0)):
            with self.assertRaisesRegex(ValueError, "limit"):
                self.run_graph(limits=limits)
        row["routes"] = [{"between": [0.7, 0.2]}]
        with self.assertRaisesRegex(ValueError, "linear reference"):
            self.run_graph()
        row["routes"] = None
        point = self.connectors.pop("b")
        with self.assertRaisesRegex(ValueError, "Missing connector"):
            self.run_graph()
        self.connectors["b"] = point
        self.rows.append(row)
        with self.assertRaisesRegex(ValueError, "Duplicate"):
            self.run_graph()


if __name__ == "__main__":
    unittest.main()
