#!/usr/bin/env python3
"""Generate the Overture schema 1.18.0 QGIS style pack deterministically."""

from __future__ import annotations

import argparse
import base64
from dataclasses import dataclass
import hashlib
import json
from pathlib import Path
import sys
import uuid
import xml.etree.ElementTree as ET


ROOT = Path(__file__).resolve().parent
MANIFEST_PATH = ROOT / "style_manifest.json"
UUID_NAMESPACE = uuid.UUID("314e3d2e-d51f-4f20-ae82-49916d10252e")


@dataclass(frozen=True)
class Rule:
    label: str
    filter: str
    color_key: str
    max_scale: int
    width: float = 0.7
    line_style: str = "solid"
    icon: str | None = None
    opacity: int = 255


SEMANTIC_COLORS = {
    "building_subtype": {
        "agricultural": "agriculture", "civic": "civic", "commercial": "commercial",
        "education": "poi_education", "entertainment": "poi_culture", "industrial": "industrial",
        "medical": "poi_health", "military": "brown", "outbuilding": "residential",
        "religious": "poi_culture", "residential": "residential", "service": "urban",
        "transportation": "transport",
    },
    "infrastructure_subtype": {
        "aerialway": "transport", "airport": "poi_travel", "barrier": "outline",
        "bridge": "brown", "communication": "poi_service", "emergency": "poi_health",
        "manhole": "default", "pedestrian": "path", "pier": "brown", "power": "accent",
        "quay": "brown", "recreation": "poi_sport", "tower": "poi_service",
        "transit": "poi_travel", "transportation": "transport", "utility": "poi_service",
        "waste_management": "industrial", "water": "water",
    },
    "land_subtype": {
        "crater": "brown", "desert": "sand", "forest": "dark_green", "glacier": "halo",
        "grass": "green", "land": "residential", "physical": "brown", "reef": "water",
        "rock": "brown", "sand": "sand", "shrub": "green", "tree": "dark_green",
        "wetland": "water",
    },
    "land_cover_subtype": {
        "barren": "sand", "crop": "agriculture", "forest": "dark_green", "grass": "green",
        "mangrove": "dark_green", "moss": "agriculture", "shrub": "green", "snow": "halo",
        "urban": "urban", "wetland": "water",
    },
    "land_use_subtype": {
        "agriculture": "agriculture", "aquaculture": "water", "campground": "green",
        "cemetery": "green", "construction": "brown", "developed": "urban",
        "education": "poi_education", "entertainment": "poi_culture", "golf": "green",
        "grass": "green", "horticulture": "agriculture", "landfill": "industrial",
        "managed": "agriculture", "medical": "poi_health", "military": "brown",
        "park": "green", "pedestrian": "path", "protected": "protected",
        "recreation": "poi_sport", "religious": "poi_culture", "residential": "residential",
        "resource_extraction": "brown", "transportation": "transport", "winter_sports": "halo",
    },
    "water_subtype": {key: "water" for key in (
        "canal", "human_made", "lake", "ocean", "physical", "pond", "reservoir",
        "river", "spring", "stream", "wastewater", "water"
    )},
    "place_top_level": {
        "services_and_business": "poi_service", "shopping": "poi_shop",
        "food_and_drink": "poi_food", "lifestyle_services": "poi_service",
        "travel_and_transportation": "poi_travel", "health_care": "poi_health",
        "education": "poi_education", "cultural_and_historic": "poi_culture",
        "sports_and_recreation": "poi_sport", "community_and_government": "civic",
        "lodging": "commercial", "arts_and_entertainment": "poi_culture",
        "geographic_entities": "green",
    },
}

ROAD_RULES = {
    "motorway": (10000000, 1.5, "transport"), "trunk": (5000000, 1.3, "transport"),
    "primary": (2000000, 1.1, "accent"), "secondary": (1000000, 0.95, "sand"),
    "tertiary": (500000, 0.8, "commercial"), "residential": (100000, 0.62, "residential"),
    "living_street": (100000, 0.58, "residential"), "unclassified": (100000, 0.55, "residential"),
    "service": (50000, 0.48, "urban"), "pedestrian": (25000, 0.42, "path"),
    "footway": (25000, 0.36, "path"), "steps": (10000, 0.36, "path"),
    "path": (25000, 0.34, "path"), "track": (50000, 0.42, "path"),
    "cycleway": (50000, 0.42, "poi_sport"), "bridleway": (25000, 0.36, "brown"),
    "unknown": (50000, 0.4, "default"),
}

PLACE_ICONS = {
    "restaurant": "restaurant", "casual_eatery": "restaurant", "cafe": "cafe",
    "bar": "bar", "bakery": "shop", "supermarket": "shop", "shopping_mall": "shop",
    "hotel": "hotel", "hospital": "hospital", "clinic": "hospital", "pharmacy": "hospital",
    "school": "school", "university": "school", "library": "school", "museum": "museum",
    "place_of_worship": "worship", "cinema": "arts", "theater": "arts", "park": "park",
    "playground": "park", "stadium": "sport", "airport": "airport",
    "railway_station": "transit", "bus_station": "transit", "ferry_terminal": "transit",
    "parking": "parking", "fuel": "fuel", "charging_station": "fuel", "bank": "bank",
    "atm": "bank", "police": "government", "fire_station": "government",
    "post_office": "government", "peak": "peak", "beach": "peak",
}

GROUP_ICONS = {
    "services_and_business": "service", "shopping": "shop", "food_and_drink": "restaurant",
    "lifestyle_services": "service", "travel_and_transportation": "transit",
    "health_care": "hospital", "education": "school", "cultural_and_historic": "museum",
    "sports_and_recreation": "sport", "community_and_government": "government",
    "lodging": "hotel", "arts_and_entertainment": "arts", "geographic_entities": "peak",
}

INFRA_ICONS = {
    "airport": "airport", "international_airport": "airport", "regional_airport": "airport",
    "runway": "airport", "railway_station": "transit", "subway_station": "transit",
    "bus_station": "transit", "bus_stop": "transit", "ferry_terminal": "transit",
    "parking": "parking", "charging_station": "fuel", "fire_hydrant": "government",
    "power_tower": "power", "communication_tower": "tower", "water_tower": "tower",
    "toilets": "service", "recycling": "service",
}

SVG_ICONS = {
    "airport": '<path d="M3 13l7-3V3c0-1 1-2 2-2s2 1 2 2v7l7 3v3l-7-1v5l3 2v2l-5-1-5 1v-2l3-2v-5l-7 1z"/>',
    "arts": '<path d="M4 3h16v14H4z"/><path d="M8 21h8M12 17v4" fill="none"/><circle cx="9" cy="9" r="2"/><path d="M13 13l3-4 3 5" fill="none"/>',
    "bank": '<path d="M2 9l10-6 10 6zM4 10h16M5 10v8M9 10v8M15 10v8M19 10v8M3 19h18v2H3z"/>',
    "bar": '<path d="M4 4h16l-7 8v6h4v2H7v-2h4v-6z"/>',
    "cafe": '<path d="M4 7h13v8a5 5 0 01-5 5H9a5 5 0 01-5-5zM17 9h2a3 3 0 010 6h-2"/>',
    "fuel": '<path d="M5 3h10v18H5zM7 6h6v5H7zM15 7l3 3v7a2 2 0 004 0v-6l-3-3"/>',
    "government": '<path d="M3 9l9-6 9 6zM5 10h14v2H5zM6 12v7M10 12v7M14 12v7M18 12v7M4 20h16"/>',
    "hospital": '<path d="M9 3h6v6h6v6h-6v6H9v-6H3V9h6z"/>',
    "hotel": '<path d="M3 5h18v15H3zM6 8h4v4H6zM14 8h4v4h-4zM5 16h14"/>',
    "museum": '<path d="M2 8l10-5 10 5zM4 9h16M5 10v8M9 10v8M15 10v8M19 10v8M3 19h18"/>',
    "park": '<path d="M12 2l5 7h-3l5 7h-6v6h-2v-6H5l5-7H7z"/>',
    "parking": '<path d="M5 3h8a6 6 0 010 12H9v6H5zM9 7v4h4a2 2 0 000-4z"/>',
    "peak": '<path d="M2 20L9 7l3 4 3-6 7 15z"/>',
    "power": '<path d="M13 2L5 14h6l-1 8 9-13h-6z"/>',
    "restaurant": '<path d="M6 2v8M3 2v5a3 3 0 006 0V2M6 10v12M15 2v20M15 2a5 8 0 010 12" fill="none"/>',
    "school": '<path d="M2 8l10-5 10 5-10 5zM6 11v6c4 3 8 3 12 0v-6M21 9v8"/>',
    "service": '<path d="M14 3a5 5 0 01-5 7L4 21l-2-2 9-9a5 5 0 017-6l-3 3 2 2 3-3a5 5 0 01-6 7z"/>',
    "shop": '<path d="M4 3h16l2 6a4 4 0 01-5 3 4 4 0 01-5 0 4 4 0 01-5 0 4 4 0 01-5-3zM4 12v9h16v-9"/>',
    "sport": '<circle cx="12" cy="12" r="9"/><path d="M5 7l14 10M7 19l10-14" fill="none"/>',
    "tower": '<path d="M10 3h4l2 18H8zM7 8h10M6 14h12M3 21h18" fill="none"/>',
    "transit": '<rect x="4" y="3" width="16" height="16" rx="3"/><path d="M7 7h10v6H7zM8 19l-2 3M16 19l2 3" fill="none"/><circle cx="8" cy="16" r="1"/><circle cx="16" cy="16" r="1"/>',
    "worship": '<path d="M12 2v20M7 7h10M5 12l7-5 7 5v9H5z" fill="none"/>',
}


def load_manifest() -> dict:
    return json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))


def rgba(hex_color: str, alpha: int = 255) -> str:
    value = hex_color.lstrip("#")
    return f"{int(value[0:2],16)},{int(value[2:4],16)},{int(value[4:6],16)},{alpha}"


def deterministic_uuid(*parts: object) -> str:
    return "{" + str(uuid.uuid5(UUID_NAMESPACE, "|".join(map(str, parts)))) + "}"


def field_value(field: str, value: object) -> str:
    quoted = str(value).replace("'", "''")
    return f"attribute(@feature, '{field}') = '{quoted}'"


def max_scale_for(classification: str | None, value: str, scales: dict) -> int:
    if classification == "building_subtype":
        return 100000
    if classification == "land_cover_subtype":
        return scales["world"]
    if classification == "land_subtype":
        return scales["metro"] if value in {"land", "physical", "forest", "desert", "glacier"} else scales["city"]
    if classification == "land_use_subtype":
        return scales["metro"] if value in {"protected", "military", "transportation"} else scales["city"]
    if classification == "water_subtype":
        return scales["world"] if value == "ocean" else scales["metro"] if value in {"lake", "reservoir", "river"} else scales["city"]
    if classification == "infrastructure_subtype":
        return scales["regional"] if value == "airport" else scales["city"] if value in {"transit", "power", "communication", "bridge"} else scales["street"]
    if classification == "place_top_level":
        return scales["city"] if value in {"travel_and_transportation", "geographic_entities"} else scales["street"]
    return scales["street"]


def standard_rules(style: dict, manifest: dict) -> list[Rule]:
    classification = style["classification"]
    if not classification:
        max_scale = manifest["scale_bands"]["detail"] if "building-part" in style["id"] else manifest["scale_bands"]["connector"]
        return [Rule("All features", "ELSE", "default", max_scale, 0.55)]
    values = manifest["classifications"][classification]
    scales = manifest["scale_bands"]
    rules: list[Rule] = []
    if classification == "bathymetry_depth":
        for depth in values:
            rules.append(Rule(
                f"Deeper than {depth} m",
                field_value("depth", depth),
                f"bathymetry_{depth}",
                scales["world"],
                opacity=245,
            ))
        rules.append(Rule("Other depth", "ELSE", "deep_water", scales["world"], opacity=245))
        return rules
    if style["id"] == "transportation-segment-line":
        for value in manifest["classifications"]["road_class"]:
            maximum, width, color = ROAD_RULES[value]
            line_style = "dash" if value in {"steps", "footway", "path", "bridleway"} else "solid"
            rules.append(Rule(f"Road — {value}", f"attribute(@feature, 'subtype') = 'road' AND {field_value('class', value)}", color, maximum, width, line_style))
        for value in manifest["classifications"]["rail_class"]:
            maximum = scales["metro"] if value in {"standard_gauge", "subway"} else scales["city"]
            rules.append(Rule(f"Rail — {value}", f"attribute(@feature, 'subtype') = 'rail' AND {field_value('class', value)}", "rail", maximum, 0.65, "dash" if value in {"subway", "tram"} else "solid"))
        rules.append(Rule("Water route", "attribute(@feature, 'subtype') = 'water'", "water", scales["metro"], 0.65, "dash"))
        rules.append(Rule("Other segment", "ELSE", "default", scales["street"], 0.4))
        return rules
    if classification == "place_top_level":
        key_values = sorted(PLACE_ICONS)
        basic = "coalesce(attribute(@feature, 'basic_category'), attribute(@feature, 'categories.primary'))"
        open_filter = "coalesce(attribute(@feature, 'operating_status'), 'open') <> 'permanently_closed'"
        for value in key_values:
            color = "poi_service"
            for group, group_color in SEMANTIC_COLORS["place_top_level"].items():
                if value in {"restaurant", "casual_eatery", "cafe", "bar", "bakery"}: color = "poi_food"
                elif value in {"supermarket", "shopping_mall"}: color = "poi_shop"
                elif value in {"hospital", "clinic", "pharmacy"}: color = "poi_health"
                elif value in {"school", "university", "library"}: color = "poi_education"
                elif value in {"park", "playground", "stadium"}: color = "poi_sport"
                elif value in {"airport", "railway_station", "bus_station", "ferry_terminal", "parking", "fuel", "charging_station"}: color = "poi_travel"
                elif value in {"museum", "place_of_worship", "cinema", "theater"}: color = "poi_culture"
                elif value in {"hotel"}: color = "commercial"
                elif value in {"peak", "beach"}: color = "green"
                elif value in {"police", "fire_station", "post_office"}: color = "civic"
                elif value in {"bank", "atm"}: color = "poi_service"
                break
            maximum = scales["city"] if value in {"airport", "peak", "hospital", "university", "stadium"} else scales["street"]
            rules.append(Rule(value.replace("_", " ").title(), f"{open_filter} AND {basic} = '{value}'", color, maximum, 0.75, icon=PLACE_ICONS[value]))
        excluded = ",".join("'" + item + "'" for item in key_values)
        top = "array_first(attribute(@feature, 'taxonomy.hierarchy'))"
        for value in values:
            color = SEMANTIC_COLORS[classification][value]
            filt = f"{open_filter} AND {top} = '{value}' AND ({basic} IS NULL OR {basic} NOT IN ({excluded}))"
            rules.append(Rule(value.replace("_", " ").title(), filt, color, max_scale_for(classification, value, scales), 0.68, icon=GROUP_ICONS[value]))
        rules.append(Rule("Unclassified open place", f"{open_filter} AND {top} IS NULL", "default", scales["detail"], 0.55, icon="service"))
        rules.append(Rule("Suppressed closed place", "ELSE", "default", scales["detail"], 0.55, icon="service", opacity=0))
        return rules
    if classification == "infrastructure_subtype" and style["geometry"] == "point":
        key_values = sorted(INFRA_ICONS)
        for value in key_values:
            color = "poi_travel" if value in {"airport", "international_airport", "regional_airport", "runway", "railway_station", "subway_station", "bus_station", "bus_stop", "ferry_terminal", "parking"} else "poi_service"
            rules.append(Rule(value.replace("_", " ").title(), field_value("class", value), color, scales["regional"] if "airport" in value else scales["city"], 0.7, icon=INFRA_ICONS[value]))
        excluded = ",".join("'" + item + "'" for item in key_values)
        for value in values:
            color = SEMANTIC_COLORS[classification][value]
            filt = f"{field_value(style['field'], value)} AND (attribute(@feature, 'class') IS NULL OR attribute(@feature, 'class') NOT IN ({excluded}))"
            rules.append(Rule(value.replace("_", " ").title(), filt, color, max_scale_for(classification, value, scales), 0.62, icon=GROUP_ICONS.get("travel_and_transportation", "service") if value in {"airport", "transit", "transportation"} else "service"))
        rules.append(Rule("Other infrastructure", "ELSE", "default", scales["detail"], 0.55, icon="service"))
        return rules
    for value in values:
        color = SEMANTIC_COLORS.get(classification, {}).get(str(value), "default")
        maximum = max_scale_for(classification, str(value), scales)
        filt = field_value(style["field"], value)
        if classification == "land_cover_subtype":
            zoom = "(ln(559082264.028 / @map_scale) / ln(2))"
            filt += f" AND (attribute(@feature, 'cartography.min_zoom') IS NULL OR {zoom} >= attribute(@feature, 'cartography.min_zoom')) AND (attribute(@feature, 'cartography.max_zoom') IS NULL OR {zoom} <= attribute(@feature, 'cartography.max_zoom'))"
        if classification == "water_subtype" and style["geometry"] == "line":
            rules.append(Rule(f"{value} — intermittent", filt + " AND coalesce(attribute(@feature, 'is_intermittent'), false)", color, maximum, 0.45, "dash"))
            filt += " AND NOT coalesce(attribute(@feature, 'is_intermittent'), false)"
        if classification == "water_subtype" and style["geometry"] == "polygon":
            rules.append(Rule(f"{value} — salt", filt + " AND coalesce(attribute(@feature, 'is_salt'), false)", "deep_water", maximum, 0.45, opacity=205))
            filt += " AND NOT coalesce(attribute(@feature, 'is_salt'), false)"
        rules.append(Rule(str(value).replace("_", " ").title(), filt, color, maximum, 0.55, opacity=205 if style["geometry"] == "polygon" else 255))
    rules.append(Rule("Other or missing value", "ELSE", "default", scales["detail"], 0.45, opacity=190))
    return rules


def add_prop(parent: ET.Element, key: str, value: object) -> None:
    ET.SubElement(parent, "prop", {"k": key, "v": str(value)})


def add_symbol(parent: ET.Element, index: int, geometry: str, rule: Rule, palette: dict, style_id: str) -> None:
    symbol_type = {"point": "marker", "line": "line", "polygon": "fill"}[geometry]
    symbol = ET.SubElement(parent, "symbol", {
        "alpha": "1", "clip_to_extent": "1", "force_rhr": "0", "frame_rate": "10",
        "is_animated": "0", "name": str(index), "type": symbol_type,
    })
    color = rgba(palette[rule.color_key], rule.opacity)
    outline = rgba(palette["outline"], min(255, rule.opacity))
    render_pass = index if style_id.startswith("base-bathymetry-polygon") else 0
    if geometry == "point" and rule.icon:
        embedded_svg = "base64:" + base64.b64encode(
            svg_bytes(rule.icon, SVG_ICONS[rule.icon])
        ).decode("ascii")
        layer = ET.SubElement(symbol, "layer", {"class": "SvgMarker", "enabled": "1", "id": deterministic_uuid(style_id, index, "svg"), "locked": "0", "pass": str(render_pass)})
        for key, value in {
            "angle": 0, "color": color, "fixedAspectRatio": 0, "horizontal_anchor_point": 1,
            "name": embedded_svg, "offset": "0,0", "offset_unit": "MM",
            "outline_color": outline, "outline_width": 0.25, "outline_width_unit": "MM",
            "size": 3.3, "size_unit": "MM", "vertical_anchor_point": 1,
        }.items(): add_prop(layer, key, value)
    elif geometry == "point":
        layer = ET.SubElement(symbol, "layer", {"class": "SimpleMarker", "enabled": "1", "id": deterministic_uuid(style_id, index, "marker"), "locked": "0", "pass": str(render_pass)})
        for key, value in {
            "angle": 0, "color": color, "horizontal_anchor_point": 1, "joinstyle": "bevel",
            "name": "circle", "offset": "0,0", "offset_unit": "MM", "outline_color": outline,
            "outline_style": "solid", "outline_width": 0.25, "outline_width_unit": "MM",
            "scale_method": "diameter", "size": 2.6, "size_unit": "MM", "vertical_anchor_point": 1,
        }.items(): add_prop(layer, key, value)
    elif geometry == "line":
        casing = ET.SubElement(symbol, "layer", {"class": "SimpleLine", "enabled": "1", "id": deterministic_uuid(style_id, index, "casing"), "locked": "0", "pass": str(render_pass)})
        for key, value in {
            "capstyle": "round", "customdash": "3;2", "customdash_unit": "MM",
            "joinstyle": "round", "line_color": outline, "line_style": "solid",
            "line_width": round(rule.width + 0.32, 2), "line_width_unit": "MM", "offset": 0,
            "offset_unit": "MM", "use_custom_dash": 0,
        }.items(): add_prop(casing, key, value)
        line = ET.SubElement(symbol, "layer", {"class": "SimpleLine", "enabled": "1", "id": deterministic_uuid(style_id, index, "line"), "locked": "0", "pass": str(render_pass)})
        for key, value in {
            "capstyle": "round", "customdash": "3;2", "customdash_unit": "MM",
            "joinstyle": "round", "line_color": color, "line_style": rule.line_style,
            "line_width": rule.width, "line_width_unit": "MM", "offset": 0,
            "offset_unit": "MM", "use_custom_dash": 1 if rule.line_style == "dash" else 0,
        }.items(): add_prop(line, key, value)
    else:
        fill = ET.SubElement(symbol, "layer", {"class": "SimpleFill", "enabled": "1", "id": deterministic_uuid(style_id, index, "fill"), "locked": "0", "pass": str(render_pass)})
        for key, value in {
            "color": color, "joinstyle": "round", "offset": "0,0", "offset_unit": "MM",
            "outline_color": outline, "outline_style": "solid", "outline_width": 0.22,
            "outline_width_unit": "MM", "style": "solid",
        }.items(): add_prop(fill, key, value)


def label_expression(style: dict) -> str:
    names = "coalesce(map_get(attribute(@feature, 'names.common'), left(@qgis_locale, 2)), map_get(attribute(@feature, 'names.common'), 'en'), attribute(@feature, 'names.primary'))"
    if style["type"] == "place":
        return f"CASE WHEN coalesce(attribute(@feature, 'operating_status'), 'open') <> 'permanently_closed' AND (attribute(@feature, 'confidence') IS NULL OR attribute(@feature, 'confidence') >= 0.5) THEN {names} END"
    return names


def add_labeling(root: ET.Element, style: dict, palette: dict) -> None:
    maximum = int(style["label_max_scale"])
    if maximum <= 0:
        return
    labeling = ET.SubElement(root, "labeling", {"type": "simple"})
    settings = ET.SubElement(labeling, "settings", {"calloutType": "simple"})
    text = ET.SubElement(settings, "text-style", {
        "allowHtml": "0", "blendMode": "0", "capitalization": "0", "fieldName": label_expression(style),
        "fontFamily": "Noto Sans", "fontItalic": "0", "fontKerning": "1", "fontLetterSpacing": "0",
        "fontSize": "9", "fontSizeUnit": "Point", "fontStrikeout": "0", "fontUnderline": "0",
        "fontWeight": "400", "fontWordSpacing": "0", "forcedBold": "0", "forcedItalic": "0",
        "isExpression": "1", "multilineHeight": "1", "namedStyle": "Regular",
        "textColor": rgba(palette["label"]), "textOpacity": "1", "textOrientation": "horizontal",
    })
    ET.SubElement(text, "families")
    ET.SubElement(text, "text-buffer", {
        "bufferBlendMode": "0", "bufferColor": rgba(palette["halo"]), "bufferDraw": "1",
        "bufferJoinStyle": "128", "bufferNoFill": "1", "bufferOpacity": "0.92",
        "bufferSize": "1.1", "bufferSizeUnits": "MM",
    })
    ET.SubElement(text, "text-mask", {"maskEnabled": "0"})
    ET.SubElement(text, "background", {"shapeDraw": "0"})
    ET.SubElement(text, "shadow", {"shadowDraw": "0"})
    ET.SubElement(text, "substitutions")
    ET.SubElement(settings, "text-format", {"autoWrapLength": "0", "multilineAlign": "0", "wrapChar": ""})
    placement_value = "2" if style["geometry"] == "line" else "1" if style["geometry"] == "polygon" else "6"
    ET.SubElement(settings, "placement", {
        "allowDegraded": "0", "centroidInside": "1", "dist": "1", "distUnits": "MM",
        "fitInPolygonOnly": "0", "layerType": style["geometry"].title() + "Geometry",
        "maxCurvedCharAngleIn": "25", "maxCurvedCharAngleOut": "-25", "offsetType": "0",
        "overlapHandling": "PreventOverlap", "placement": placement_value, "placementFlags": "10",
        "predefinedPositionOrder": "TR,TL,BR,BL,R,L", "priority": "5", "quadOffset": "4",
        "repeatDistance": "40", "repeatDistanceUnits": "MM",
    })
    ET.SubElement(settings, "rendering", {
        "drawLabels": "1", "fontLimitPixelSize": "0", "fontMaxPixelSize": "10000",
        "fontMinPixelSize": "3", "limitNumLabels": "1", "maxNumLabels": "2000",
        "mergeLines": "1" if style["geometry"] == "line" else "0", "minFeatureSize": "1",
        "obstacle": "1", "obstacleFactor": "1", "obstacleType": "1", "scaleMax": str(maximum),
        "scaleMin": "0", "scaleVisibility": "1", "unplacedVisibility": "0",
    })


def qml_bytes(style: dict, palette_name: str, manifest: dict) -> bytes:
    palette = manifest["palettes"][palette_name]
    geometry_code = {"point": "0", "line": "1", "polygon": "2"}[style["geometry"]]
    root = ET.Element("qgis", {
        "version": "4.2.0-Belém do Pará", "styleCategories": "Symbology|Labeling|Rendering",
        "labelsEnabled": "1" if style["label_max_scale"] else "0", "layerType": "Vector",
        "hasScaleBasedVisibilityFlag": "0", "maxScale": "0", "minScale": "100000000",
        "simplifyDrawingHints": "1", "simplifyDrawingTol": "1", "simplifyLocal": "1",
        "simplifyMaxScale": "1", "symbologyReferenceScale": "-1",
    })
    renderer = ET.SubElement(root, "renderer-v2", {"type": "RuleRenderer", "symbollevels": "1", "enableorderby": "0", "forceraster": "0"})
    rules_element = ET.SubElement(renderer, "rules", {"key": deterministic_uuid(style["id"], palette_name, "root")})
    symbols_element = ET.SubElement(renderer, "symbols")
    rules = standard_rules(style, manifest)
    for index, rule in enumerate(rules):
        attrs = {
            "key": deterministic_uuid(style["id"], palette_name, index), "label": rule.label,
            "symbol": str(index), "filter": rule.filter, "scalemaxdenom": str(rule.max_scale),
        }
        ET.SubElement(rules_element, "rule", attrs)
        add_symbol(symbols_element, index, style["geometry"], rule, palette, style["id"] + "-" + palette_name)
    custom = ET.SubElement(root, "customproperties")
    for key, value in {
        "overture/schema_version": manifest["schema_version"], "overture/style_id": style["id"],
        "overture/palette": palette_name,
        "overture/description": (
            f"{style['id']} {palette_name} style bound to Overture schema 1.18.0"
        ),
        "overture/compatibility": "Bound to Overture schema 1.18.0; other versions are unverified",
    }.items(): ET.SubElement(custom, "property", {"key": key, "value": value})
    add_labeling(root, style, palette)
    ET.SubElement(root, "blendMode").text = "0"
    ET.SubElement(root, "featureBlendMode").text = "0"
    ET.SubElement(root, "layerOpacity").text = "1"
    ET.SubElement(root, "layerGeometryType").text = geometry_code
    ET.indent(root, space="  ")
    xml = ET.tostring(root, encoding="utf-8", xml_declaration=True)
    doctype = b"<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>\n"
    return xml.split(b"\n", 1)[0] + b"\n" + doctype + xml.split(b"\n", 1)[1] + b"\n"


def svg_bytes(name: str, body: str) -> bytes:
    svg = f'''<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
  <g fill="param(fill) #4f7ea8" stroke="param(outline) #ffffff" stroke-width="param(outline-width) 1" stroke-linecap="round" stroke-linejoin="round">
    {body}
  </g>
  <metadata>Original offline symbol for Overture schema 1.18.0: {name}</metadata>
</svg>
'''
    return svg.encode("utf-8")


def visual_svg(manifest: dict, palette_name: str, kind: str) -> bytes:
    palette = manifest["palettes"][palette_name]
    title = "Legend" if kind == "legend" else "Synthetic map preview"
    width, height = (1100, 760) if kind == "legend" else (1200, 720)
    swatches = [
        ("Water", "water"), ("Forest", "dark_green"), ("Land cover", "green"),
        ("Residential", "residential"), ("Commercial", "commercial"),
        ("Industrial", "industrial"), ("Transport", "transport"), ("Places", "poi_food"),
    ]
    chunks = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
              f'<rect width="100%" height="100%" fill="{palette["background"]}"/>',
              f'<text x="50" y="65" font-family="sans-serif" font-size="32" font-weight="700" fill="{palette["label"]}">{title} — {palette_name.title()}</text>']
    if kind == "legend":
        for index, (label, key) in enumerate(swatches):
            x = 60 + (index % 2) * 520
            y = 125 + (index // 2) * 125
            chunks += [f'<rect x="{x}" y="{y}" width="90" height="58" rx="8" fill="{palette[key]}" stroke="{palette["outline"]}" stroke-width="2"/>',
                       f'<text x="{x+115}" y="{y+39}" font-family="sans-serif" font-size="23" fill="{palette["label"]}">{label}</text>']
    else:
        chunks += [
            f'<path d="M0 490 C230 430 350 590 610 500 S920 400 1200 470 V720 H0Z" fill="{palette["water"]}"/>',
            f'<path d="M0 0 H1200 V500 C900 410 750 520 530 485 S220 430 0 500Z" fill="{palette["green"]}" opacity="0.45"/>',
            f'<path d="M80 140 H520 V390 H80Z" fill="{palette["residential"]}" opacity="0.9"/>',
            f'<path d="M660 95 H1080 V355 H660Z" fill="{palette["commercial"]}" opacity="0.9"/>',
            f'<path d="M-30 260 C250 220 520 315 790 245 S1050 190 1230 225" fill="none" stroke="{palette["outline"]}" stroke-width="24"/>',
            f'<path d="M-30 260 C250 220 520 315 790 245 S1050 190 1230 225" fill="none" stroke="{palette["transport"]}" stroke-width="16"/>',
            f'<path d="M250 -20 C260 170 300 410 360 740" fill="none" stroke="{palette["outline"]}" stroke-width="14"/>',
            f'<path d="M250 -20 C260 170 300 410 360 740" fill="none" stroke="{palette["accent"]}" stroke-width="8"/>',
        ]
        for x, y, key in [(170,180,"poi_food"),(465,325,"poi_health"),(760,155,"poi_education"),(980,310,"poi_travel")]:
            chunks += [f'<circle cx="{x}" cy="{y}" r="16" fill="{palette[key]}" stroke="{palette["halo"]}" stroke-width="5"/>']
        chunks += [f'<text x="105" y="110" font-family="sans-serif" font-size="21" fill="{palette["label"]}" stroke="{palette["halo"]}" stroke-width="5" paint-order="stroke">Sample district</text>',
                   f'<text x="700" y="395" font-family="sans-serif" font-size="20" fill="{palette["label"]}" stroke="{palette["halo"]}" stroke-width="5" paint-order="stroke">Civic center</text>']
    chunks += [f'<text x="50" y="{height-35}" font-family="sans-serif" font-size="18" fill="{palette["label"]}">Bound to Overture schema 1.18.0 · QGIS 4.2 · synthetic data</text>', '</svg>']
    return ("\n".join(chunks) + "\n").encode("utf-8")


def expected_outputs(manifest: dict) -> dict[Path, bytes]:
    outputs: dict[Path, bytes] = {}
    for style in manifest["styles"]:
        for palette in sorted(manifest["palettes"]):
            outputs[ROOT / "styles" / palette / f"{style['id']}.qml"] = qml_bytes(style, palette, manifest)
    for name, body in sorted(SVG_ICONS.items()):
        outputs[ROOT / "symbols" / f"{name}.svg"] = svg_bytes(name, body)
    for palette in sorted(manifest["palettes"]):
        outputs[ROOT / "previews" / f"legend-{palette}.svg"] = visual_svg(manifest, palette, "legend")
        outputs[ROOT / "previews" / f"preview-{palette}.svg"] = visual_svg(manifest, palette, "preview")
    return outputs


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate QGIS styles bound to Overture schema 1.18.0.")
    parser.add_argument("--check", action="store_true", help="Fail if generated assets are missing or stale.")
    args = parser.parse_args()
    manifest = load_manifest()
    if manifest["schema_version"] != "1.18.0":
        raise RuntimeError("This generator is intentionally bound to Overture schema 1.18.0")
    stale: list[str] = []
    for path, content in expected_outputs(manifest).items():
        if args.check:
            if not path.exists() or path.read_bytes() != content:
                stale.append(str(path.relative_to(ROOT)))
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(content)
    if stale:
        print("Generated QGIS assets are stale or missing:", file=sys.stderr)
        for value in stale: print(f"  {value}", file=sys.stderr)
        return 1
    digest = hashlib.sha256(b"".join(expected_outputs(manifest).values())).hexdigest()[:16]
    print(f"Overture schema 1.18.0 QGIS assets OK ({len(expected_outputs(manifest))} files, digest {digest})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
