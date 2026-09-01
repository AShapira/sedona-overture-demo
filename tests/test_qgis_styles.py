from __future__ import annotations

import base64
import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import unittest
import uuid
import xml.etree.ElementTree as ET


ROOT = Path(__file__).resolve().parents[1]
PACK = ROOT / "qgis" / "schema-1.18.0"
MANIFEST = json.loads((PACK / "style_manifest.json").read_text(encoding="utf-8"))


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Could not load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


schema_validator = load_module("qgis_schema_validator", PACK / "validate_schema.py")
subset_extractor = load_module("qgis_subset_extractor", PACK / "extract_test_subset.py")


def qml_paths() -> list[Path]:
    return sorted((PACK / "styles").glob("*/*.qml"))


def properties(root: ET.Element) -> dict[str, str]:
    return {
        item.attrib["key"]: item.attrib["value"]
        for item in root.findall("./customproperties/property")
    }


def rule_structure(path: Path) -> list[tuple[str, str, str]]:
    root = ET.parse(path).getroot()
    return [
        (
            rule.attrib.get("label", ""),
            rule.attrib.get("filter", ""),
            rule.attrib.get("scalemaxdenom", ""),
        )
        for rule in root.findall("./renderer-v2/rules/rule")
    ]


class QgisStyleGenerationTests(unittest.TestCase):
    def test_manifest_and_exact_style_inventory(self):
        self.assertEqual(MANIFEST["schema_version"], "1.18.0")
        self.assertEqual(MANIFEST["qgis_version"], "4.2")
        self.assertEqual(len(MANIFEST["styles"]), 19)
        self.assertEqual(set(MANIFEST["palettes"]), {"light", "dark"})
        paths = qml_paths()
        self.assertEqual(len(paths), 38)
        expected = {
            PACK / "styles" / palette / f"{style['id']}.qml"
            for palette in MANIFEST["palettes"]
            for style in MANIFEST["styles"]
        }
        self.assertEqual(set(paths), expected)

    def test_generator_is_deterministic_and_outputs_are_current(self):
        result = subprocess.run(
            [sys.executable, str(PACK / "generate_styles.py"), "--check"],
            cwd=ROOT,
            text=True,
            capture_output=True,
            check=False,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_qml_xml_metadata_rules_scales_and_svg_references(self):
        for path in qml_paths():
            with self.subTest(path=path):
                root = ET.parse(path).getroot()
                renderer = root.find("./renderer-v2")
                self.assertIsNotNone(renderer)
                self.assertEqual(renderer.attrib["type"], "RuleRenderer")
                props = properties(root)
                self.assertEqual(props["overture/schema_version"], "1.18.0")
                self.assertIn("Overture schema 1.18.0", props["overture/description"])
                self.assertIn("other versions are unverified", props["overture/compatibility"])
                rules = root.findall("./renderer-v2/rules/rule")
                keys = [rule.attrib["key"] for rule in rules]
                self.assertEqual(len(keys), len(set(keys)))
                self.assertTrue(any(rule.attrib.get("filter") == "ELSE" for rule in rules))
                for rule in rules:
                    self.assertGreater(float(rule.attrib["scalemaxdenom"]), 0)
                for prop in root.findall(".//layer[@class='SvgMarker']/prop[@k='name']"):
                    name = prop.attrib.get("v", "")
                    self.assertTrue(name.startswith("base64:"), name[:80])
                    embedded = base64.b64decode(name.removeprefix("base64:"))
                    self.assertEqual(ET.fromstring(embedded).tag, "{http://www.w3.org/2000/svg}svg")

    def test_parameterized_svg_sources_are_valid_and_offline(self):
        paths = sorted((PACK / "symbols").glob("*.svg"))
        self.assertEqual(len(paths), 22)
        for path in paths:
            with self.subTest(path=path):
                content = path.read_text(encoding="utf-8")
                self.assertEqual(ET.fromstring(content).tag, "{http://www.w3.org/2000/svg}svg")
                self.assertIn("param(fill)", content)
                self.assertIn("param(outline)", content)
                self.assertNotIn("http://", content.replace("http://www.w3.org/2000/svg", ""))

    def test_light_and_dark_have_identical_rule_structure(self):
        for style in MANIFEST["styles"]:
            style_id = style["id"]
            with self.subTest(style=style_id):
                light = PACK / "styles" / "light" / f"{style_id}.qml"
                dark = PACK / "styles" / "dark" / f"{style_id}.qml"
                self.assertEqual(rule_structure(light), rule_structure(dark))

    def test_bathymetry_has_ordered_stacking_and_distinct_depth_tints(self):
        for palette in MANIFEST["palettes"]:
            path = PACK / "styles" / palette / "base-bathymetry-polygon.qml"
            root = ET.parse(path).getroot()
            layers = root.findall("./renderer-v2/symbols/symbol/layer")
            self.assertEqual([int(layer.attrib["pass"]) for layer in layers], list(range(11)))
            colors = [
                layer.find("./prop[@k='color']").attrib["v"]
                for layer in layers[:10]
            ]
            self.assertEqual(len(set(colors)), 10)

    def test_scale_density_road_casings_and_label_collision_settings(self):
        road_path = PACK / "styles" / "light" / "transportation-segment-line.qml"
        road_root = ET.parse(road_path).getroot()
        road_rules = road_root.findall("./renderer-v2/rules/rule")
        road_scales = {int(rule.attrib["scalemaxdenom"]) for rule in road_rules}
        self.assertTrue({10_000_000, 2_000_000, 250_000, 50_000, 10_000}.issubset(road_scales))
        for symbol in road_root.findall("./renderer-v2/symbols/symbol")[:17]:
            layers = symbol.findall("./layer")
            self.assertEqual(len(layers), 2)
            casing = float(layers[0].find("./prop[@k='line_width']").attrib["v"])
            center = float(layers[1].find("./prop[@k='line_width']").attrib["v"])
            self.assertGreater(casing, center)
            self.assertEqual(layers[0].find("./prop[@k='line_width_unit']").attrib["v"], "MM")
        for path in qml_paths():
            root = ET.parse(path).getroot()
            if root.attrib["labelsEnabled"] != "1":
                continue
            buffer = root.find("./labeling/settings/text-style/text-buffer")
            placement = root.find("./labeling/settings/placement")
            rendering = root.find("./labeling/settings/rendering")
            self.assertEqual(buffer.attrib["bufferDraw"], "1")
            self.assertEqual(buffer.attrib["bufferSizeUnits"], "MM")
            self.assertEqual(placement.attrib["overlapHandling"], "PreventOverlap")
            self.assertEqual(rendering.attrib["limitNumLabels"], "1")

    def test_declared_enum_values_are_covered_or_have_fallback(self):
        for style in MANIFEST["styles"]:
            classification = style["classification"]
            if classification is None:
                continue
            path = PACK / "styles" / "light" / f"{style['id']}.qml"
            rules = rule_structure(path)
            text = "\n".join(label + " " + expression for label, expression, _ in rules)
            self.assertTrue(any(expression == "ELSE" for _, expression, _ in rules))
            for value in MANIFEST["classifications"][classification]:
                with self.subTest(style=style["id"], value=value):
                    self.assertIn(str(value), text)

    def test_no_real_data_or_named_default_location_in_tracked_pack(self):
        self.assertFalse(list(PACK.rglob("*.geoparquet")))
        # Keep even the checker source geographically neutral while testing the
        # prohibited strings supplied by the repository hygiene contract.
        banned = tuple(bytes.fromhex(value).decode("ascii") for value in (
            "617368646f64",
            "67616e207961766e65",
            "6173686b656c6f6e",
            "676564657261",
        ))
        paths = [ROOT / "README.md"] + [
            path
            for path in PACK.rglob("*")
            if path.is_file() and path.suffix.lower() in {".md", ".json", ".py", ".qml", ".svg"}
        ]
        for path in paths:
            content = path.read_text(encoding="utf-8").lower()
            for name in banned:
                with self.subTest(path=path, name=name):
                    self.assertNotIn(name, content)

    def test_synthetic_previews_and_legends_declare_schema(self):
        for name in ("legend-light.svg", "legend-dark.svg", "preview-light.svg", "preview-dark.svg"):
            content = (PACK / "previews" / name).read_text(encoding="utf-8")
            self.assertIn("Overture schema 1.18.0", content)


class QgisSchemaContractTests(unittest.TestCase):
    def test_compatible_contracts_pass(self):
        for style in MANIFEST["styles"]:
            fields = {name: accepted[0] for name, accepted in style["required_fields"].items()}
            errors = schema_validator.validate_contract(
                style, fields, style["geometry"], "1.18.0"
            )
            self.assertEqual(errors, [], style["id"])

    def test_missing_renamed_and_wrongly_typed_fields_fail_clearly(self):
        style = schema_validator.style_by_id("places-place-point")
        fields = {name: accepted[0] for name, accepted in style["required_fields"].items()}
        missing = dict(fields)
        missing.pop("taxonomy.hierarchy")
        self.assertIn("Missing required QGIS field", " ".join(
            schema_validator.validate_contract(style, missing, "point", "1.18.0")
        ))
        renamed = {**fields, "taxonomy_hierarchy": fields["taxonomy.hierarchy"]}
        renamed.pop("taxonomy.hierarchy")
        self.assertIn("taxonomy.hierarchy", " ".join(
            schema_validator.validate_contract(style, renamed, "point", "1.18.0")
        ))
        wrong = {**fields, "taxonomy.hierarchy": "String"}
        self.assertIn("expected one of", " ".join(
            schema_validator.validate_contract(style, wrong, "point", "1.18.0")
        ))

    def test_different_schema_version_warns_with_binding_message(self):
        style = schema_validator.style_by_id("transportation-segment-line")
        fields = {name: accepted[0] for name, accepted in style["required_fields"].items()}
        errors = schema_validator.validate_contract(style, fields, "line", "1.19.0")
        self.assertIn(
            "style pack is bound to Overture schema 1.18.0",
            " ".join(errors),
        )


class QgisSubsetConfigurationTests(unittest.TestCase):
    def test_bbox_precedence_and_default(self):
        self.assertEqual(subset_extractor.resolve_bbox(None, {}), (34.58, 31.74, 34.76, 31.86))
        self.assertEqual(
            subset_extractor.resolve_bbox(None, {"QGIS_STYLE_TEST_BBOX": "1,2,3,4"}),
            (1.0, 2.0, 3.0, 4.0),
        )
        self.assertEqual(
            subset_extractor.resolve_bbox("5,6,7,8", {"QGIS_STYLE_TEST_BBOX": "1,2,3,4"}),
            (5.0, 6.0, 7.0, 8.0),
        )

    def test_invalid_bbox_values_are_rejected(self):
        cases = ("1,2,3", "x,2,3,4", "181,0,182,1", "0,-91,1,-90", "3,2,1,4", "1,4,3,2")
        for value in cases:
            with self.subTest(value=value), self.assertRaises(ValueError):
                subset_extractor.parse_bbox(value)

    def test_large_bbox_requires_explicit_override(self):
        bbox = subset_extractor.parse_bbox("0,0,0.6,0.1")
        with self.assertRaisesRegex(ValueError, "allow-large-bbox"):
            subset_extractor.validate_bbox_size(bbox, False)
        subset_extractor.validate_bbox_size(bbox, True)

    def test_output_is_confined_to_ignored_artifact_tree(self):
        valid = subset_extractor.ARTIFACT_ROOT / f"unit-{uuid.uuid4()}"
        self.assertEqual(subset_extractor.safe_output_path(str(valid)), valid)
        with self.assertRaisesRegex(ValueError, "must be beneath"):
            subset_extractor.safe_output_path("/tmp/qgis-style-test-outside")

    def test_extractor_contract_preserves_schema_and_uses_exact_filter(self):
        source = (PACK / "extract_test_subset.py").read_text(encoding="utf-8")
        self.assertIn("ST_Intersects(geometry", source)
        self.assertIn("ST_PolygonFromEnvelope", source)
        self.assertIn("family_frame.select(*columns)", source)
        self.assertNotIn("ST_Intersection(", source)
        self.assertNotIn('"file": None', source)


if __name__ == "__main__":
    unittest.main()
