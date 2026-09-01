#!/usr/bin/env python3
"""Validate a QGIS layer or field fixture against a v1.18.0 style contract."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parent
MANIFEST = json.loads((ROOT / "style_manifest.json").read_text(encoding="utf-8"))


def style_by_id(style_id: str) -> dict:
    for style in MANIFEST["styles"]:
        if style["id"] == style_id:
            return style
    raise ValueError(f"Unknown style id: {style_id}")


def canonical_field_type(value: str) -> str:
    """Normalize equivalent provider-specific QGIS type labels."""
    lowered = value.lower().replace(" ", "")
    if "stringlist" in lowered or "qstringlist" in lowered:
        return "StringList"
    if "bool" in lowered:
        return "Boolean"
    if any(token in lowered for token in ("int", "longlong", "uint")):
        return "Integer"
    if any(token in lowered for token in ("real", "double", "float", "decimal")):
        return "Real"
    if any(token in lowered for token in ("string", "text", "varchar")):
        return "String"
    return value


def validate_contract(
    style: dict,
    fields: dict[str, str],
    geometry: str,
    declared_schema_version: str,
) -> list[str]:
    errors: list[str] = []
    if declared_schema_version != MANIFEST["schema_version"]:
        errors.append(
            "This style pack is bound to Overture schema 1.18.0; "
            f"declared schema {declared_schema_version!r} is unverified."
        )
    if geometry.lower() != style["geometry"]:
        errors.append(
            f"Geometry mismatch: style requires {style['geometry']}, found {geometry}."
        )
    for name, accepted in style["required_fields"].items():
        actual = fields.get(name)
        if actual is None:
            errors.append(f"Missing required QGIS field {name!r}.")
        elif canonical_field_type(actual) not in accepted:
            errors.append(
                f"Field {name!r} has type {actual!r}; expected one of {accepted}."
            )
    return errors


def qgis_layer_fields(path: str) -> tuple[dict[str, str], str]:
    try:
        from qgis.core import QgsApplication, QgsVectorLayer, QgsWkbTypes
    except ImportError as exc:
        raise RuntimeError(
            "--layer must run with the QGIS Python environment, for example "
            "python-qgis.bat on Windows."
        ) from exc
    app = QgsApplication.instance()
    owns_app = app is None
    if owns_app:
        app = QgsApplication([], False)
        app.initQgis()
    layer = QgsVectorLayer(path, "schema-check", "ogr")
    if not layer.isValid():
        raise RuntimeError(f"QGIS could not open layer: {path}")
    fields = {field.name(): field.typeName() for field in layer.fields()}
    family = QgsWkbTypes.geometryType(layer.wkbType())
    geometry = {0: "point", 1: "line", 2: "polygon"}.get(int(family), "unknown")
    if owns_app:
        app.exitQgis()
    return fields, geometry


def main() -> int:
    parser = argparse.ArgumentParser(
        description=(
            "Check a layer against QGIS styles bound to Overture schema 1.18.0. "
            "Other schema versions are unverified."
        )
    )
    parser.add_argument("--style", required=True, help="Style id from style_manifest.json")
    parser.add_argument("--schema-version", default="1.18.0")
    source = parser.add_mutually_exclusive_group(required=True)
    source.add_argument("--layer", help="GeoParquet layer path, opened with QGIS/OGR")
    source.add_argument(
        "--fields-json",
        help='JSON object with "geometry" and a "fields" name-to-QGIS-type object',
    )
    args = parser.parse_args()
    style = style_by_id(args.style)
    if args.layer:
        fields, geometry = qgis_layer_fields(args.layer)
    else:
        fixture = json.loads(args.fields_json)
        fields = fixture["fields"]
        geometry = fixture["geometry"]
    errors = validate_contract(style, fields, geometry, args.schema_version)
    if errors:
        print("INCOMPATIBLE — Overture schema 1.18.0 style contract failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1
    print(
        f"COMPATIBLE — {args.style} matches the Overture schema 1.18.0 "
        f"{style['geometry']} contract."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
