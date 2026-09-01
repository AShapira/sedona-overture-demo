#!/usr/bin/env python3
"""Native QGIS 4.2 load, expression, SVG, and render validation."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys

from qgis.PyQt.QtCore import QMetaType, QSize
from qgis.PyQt.QtGui import QColor
from qgis.core import (
    QgsApplication,
    QgsExpression,
    QgsFeature,
    QgsField,
    QgsGeometry,
    QgsMapRendererParallelJob,
    QgsMapSettings,
    QgsRectangle,
    QgsVectorLayer,
    Qgis,
)

from validate_schema import validate_contract


ROOT = Path(__file__).resolve().parent
MANIFEST = json.loads((ROOT / "style_manifest.json").read_text(encoding="utf-8"))
TYPE_MAP = {
    "String": QMetaType.Type.QString,
    "Integer": QMetaType.Type.Int,
    "Boolean": QMetaType.Type.Bool,
    "Real": QMetaType.Type.Double,
    "StringList": QMetaType.Type.QStringList,
}


def layer_for(style: dict) -> QgsVectorLayer:
    uri_geometry = {"point": "Point", "line": "LineString", "polygon": "Polygon"}[style["geometry"]]
    layer = QgsVectorLayer(f"{uri_geometry}?crs=EPSG:4326", style["id"], "memory")
    fields = []
    for name, accepted in style["required_fields"].items():
        type_name = "Boolean" if "Boolean" in accepted else accepted[0]
        fields.append(QgsField(name, TYPE_MAP[type_name], typeName=type_name))
    if "names.common" not in style["required_fields"] and style["label_max_scale"]:
        fields.append(QgsField("names.common", QMetaType.Type.QVariantMap, typeName="JSON"))
    layer.dataProvider().addAttributes(fields)
    layer.updateFields()
    feature = QgsFeature(layer.fields())
    if style["geometry"] == "point":
        feature.setGeometry(QgsGeometry.fromWkt("POINT (0 0)"))
    elif style["geometry"] == "line":
        feature.setGeometry(QgsGeometry.fromWkt("LINESTRING (-0.02 0, 0.02 0)"))
    else:
        feature.setGeometry(QgsGeometry.fromWkt("POLYGON ((-0.015 -0.01, 0.015 -0.01, 0.015 0.01, -0.015 0.01, -0.015 -0.01))"))
    values = {
        "id": "sample-id", "building_id": "sample-building", "subtype": "residential",
        "class": "residential", "names.primary": "Sample feature", "names.common": {"en": "Sample feature"},
        "height": 12.0, "num_floors": 3, "depth": 500, "cartography.min_zoom": 0,
        "cartography.max_zoom": 23, "cartography.sort_key": 0, "is_salt": False,
        "is_intermittent": False, "taxonomy.hierarchy": ["food_and_drink", "restaurant"],
        "taxonomy.primary": "restaurant", "basic_category": "restaurant",
        "categories.primary": "restaurant", "confidence": 0.95, "operating_status": "open",
        "subclass": "link",
    }
    if style["type"] == "infrastructure":
        values.update({"subtype": "airport", "class": "airport"})
    elif style["type"] == "land":
        values.update({"subtype": "forest", "class": "forest"})
    elif style["type"] == "land_cover":
        values.update({"subtype": "forest"})
    elif style["type"] == "land_use":
        values.update({"subtype": "park", "class": "park"})
    elif style["type"] == "water":
        values.update({"subtype": "river", "class": "river"})
    elif style["type"] == "segment":
        values.update({"subtype": "road", "class": "motorway", "subclass": "link"})
    for name, value in values.items():
        if layer.fields().indexOf(name) >= 0:
            feature[name] = value
    layer.dataProvider().addFeature(feature)
    layer.updateExtents()
    return layer


def check_style(layer: QgsVectorLayer, style_path: Path) -> list[str]:
    errors: list[str] = []
    result = layer.loadNamedStyle(str(style_path))
    if isinstance(result, tuple):
        message, ok = result[0], bool(result[1])
    else:
        message, ok = str(result), True
    if not ok:
        errors.append(f"failed to load: {message}")
        return errors
    renderer = layer.renderer()
    if renderer is None or renderer.type() != "RuleRenderer":
        errors.append("style did not load a rule renderer")
        return errors
    seen: set[str] = set()
    has_else = False
    for rule in renderer.rootRule().children():
        key = rule.ruleKey()
        if key in seen:
            errors.append(f"duplicate rule key {key}")
        seen.add(key)
        if rule.isElse():
            has_else = True
            continue
        expression = QgsExpression(rule.filterExpression())
        if expression.hasParserError():
            errors.append(f"rule {rule.label()!r}: {expression.parserErrorString()}")
    if not has_else:
        errors.append("renderer has no ELSE rule")
    if layer.labelsEnabled() and layer.labeling() is not None:
        settings = layer.labeling().settings()
        expression = QgsExpression(settings.fieldName)
        if settings.isExpression and expression.hasParserError():
            errors.append(f"label expression: {expression.parserErrorString()}")
    return errors


def render_layer(
    layer: QgsVectorLayer,
    destination: Path,
    scale: float,
    background: str,
    focus_on_feature: bool = False,
) -> None:
    width_px, height_px, dpi = 640, 420, 96
    width_m = scale * width_px / dpi * 0.0254
    width_degrees = width_m / 111320.0
    height_degrees = width_degrees * height_px / width_px
    settings = QgsMapSettings()
    settings.setLayers([layer])
    settings.setBackgroundColor(QColor(background))
    settings.setOutputSize(QSize(width_px, height_px))
    settings.setOutputDpi(dpi)
    center = layer.extent().center()
    if focus_on_feature:
        feature = next(layer.getFeatures(), None)
        if feature is not None and feature.hasGeometry():
            center = feature.geometry().boundingBox().center()
    settings.setExtent(QgsRectangle(
        center.x() - width_degrees / 2,
        center.y() - height_degrees / 2,
        center.x() + width_degrees / 2,
        center.y() + height_degrees / 2,
    ))
    job = QgsMapRendererParallelJob(settings)
    job.start()
    job.waitForFinished()
    image = job.renderedImage()
    destination.parent.mkdir(parents=True, exist_ok=True)
    if not image.save(str(destination), "PNG"):
        raise RuntimeError(f"Could not save QGIS render: {destination}")


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate all Overture schema 1.18.0 styles with native QGIS 4.2.")
    parser.add_argument("--render-dir", help="Optional untracked directory for PNG render evidence")
    parser.add_argument(
        "--subset-dir",
        help="Optional extracted subset directory to contract-check, style, and render",
    )
    args = parser.parse_args()
    if not Qgis.QGIS_VERSION.startswith("4.2."):
        parser.error(f"QGIS 4.2 is required, found {Qgis.QGIS_VERSION}")
    app = QgsApplication([], False)
    app.initQgis()
    errors: list[str] = []
    render_dir = Path(args.render_dir).resolve() if args.render_dir else None
    subset_dir = Path(args.subset_dir).resolve() if args.subset_dir else None
    real_style_applications = 0
    try:
        for style in MANIFEST["styles"]:
            for palette in sorted(MANIFEST["palettes"]):
                layer = layer_for(style)
                path = ROOT / "styles" / palette / f"{style['id']}.qml"
                for error in check_style(layer, path):
                    errors.append(f"{palette}/{style['id']}: {error}")
                if render_dir:
                    scale = min(5000, max(1000, style["label_max_scale"] or 5000))
                    render_layer(layer, render_dir / palette / f"{style['id']}.png", scale, MANIFEST["palettes"][palette]["background"])
        if render_dir:
            scale_values = [100000000, 10000000, 2000000, 250000, 50000, 10000, 5000, 1000]
            for palette in sorted(MANIFEST["palettes"]):
                for style_id in ("transportation-segment-line", "places-place-point"):
                    style = next(value for value in MANIFEST["styles"] if value["id"] == style_id)
                    layer = layer_for(style)
                    check_style(layer, ROOT / "styles" / palette / f"{style_id}.qml")
                    for scale in scale_values:
                        render_layer(layer, render_dir / "scale-boundaries" / palette / f"{style_id}-{scale}.png", scale, MANIFEST["palettes"][palette]["background"])
        if subset_dir:
            subset_manifest_path = subset_dir / "subset-manifest.json"
            subset_manifest = json.loads(subset_manifest_path.read_text(encoding="utf-8"))
            declared_version = subset_manifest.get("overture_schema_version", "")
            for output in subset_manifest["outputs"]:
                if not output.get("file"):
                    continue
                feature_type = output["type"].replace("_", "-")
                style_id = f"{output['theme']}-{feature_type}-{output['geometry']}"
                style = next((item for item in MANIFEST["styles"] if item["id"] == style_id), None)
                if style is None:
                    errors.append(f"subset output has no matching style: {style_id}")
                    continue
                layer_path = subset_dir / output["file"]
                layer_source = str(layer_path)
                if output["rows"] == 0:
                    provider_geometry = {
                        "point": "Point",
                        "line": "LineString",
                        "polygon": "Polygon",
                    }[output["geometry"]]
                    layer_source += f"|geometrytype={provider_geometry}"
                layer = QgsVectorLayer(layer_source, style_id, "ogr")
                if not layer.isValid():
                    errors.append(f"QGIS could not open extracted layer: {layer_path}")
                    continue
                fields = {field.name(): field.typeName() for field in layer.fields()}
                family = {0: "point", 1: "line", 2: "polygon"}.get(
                    int(layer.geometryType()), "unknown"
                )
                for error in validate_contract(style, fields, family, declared_version):
                    errors.append(f"subset/{style_id}: {error}")
                for palette in sorted(MANIFEST["palettes"]):
                    style_path = ROOT / "styles" / palette / f"{style_id}.qml"
                    for error in check_style(layer, style_path):
                        errors.append(f"subset/{palette}/{style_id}: {error}")
                    real_style_applications += 1
                    if render_dir:
                        scale = min(5000, max(1000, style["label_max_scale"] or 5000))
                        render_layer(
                            layer,
                            render_dir / "real-subset" / palette / f"{style_id}.png",
                            scale,
                            MANIFEST["palettes"][palette]["background"],
                            focus_on_feature=True,
                        )
    finally:
        app.exitQgis()
    if errors:
        print("Native QGIS validation failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1
    print(
        "Native QGIS 4.2 loaded 38 synthetic style fixtures, parsed all "
        f"expressions, applied {real_style_applications} real-subset styles, "
        "and completed requested renders."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
