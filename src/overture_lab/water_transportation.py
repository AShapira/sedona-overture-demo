"""Complete worldwide water-segment selection and bounded offline maps."""

from __future__ import annotations

import math


def select_world_water_transportation(segments):
    """Keep every water segment and its original attributes and geometry."""
    return segments.where("subtype = 'water'").drop("theme", "feature_type")


def validate_water_transportation(water):
    """Validate the whole selection before export or driver collection."""
    from pyspark.sql import functions as F

    invalid = F.expr(
        "id IS NULL OR subtype IS NULL OR subtype <> 'water' "
        "OR geometry IS NULL OR ST_IsEmpty(geometry) OR NOT ST_IsValid(geometry) "
        "OR ST_SRID(geometry) <> 4326 "
        "OR GeometryType(geometry) NOT IN ('LINESTRING', 'MULTILINESTRING') "
        "OR ST_XMin(geometry) < -180 OR ST_XMax(geometry) > 180 "
        "OR ST_YMin(geometry) < -90 OR ST_YMax(geometry) > 90"
    )
    report = water.agg(
        F.count("*").alias("features"),
        F.countDistinct("id").alias("distinct_ids"),
        F.sum(F.expr("ST_NPoints(geometry)")).alias("coordinates"),
        F.sum(F.when(invalid, 1).otherwise(0)).alias("invalid_features"),
    ).first().asDict()
    if not report["features"]:
        raise ValueError("No water transportation segments found in this release")
    if report["invalid_features"]:
        raise ValueError(f"Invalid water transportation features: {report}")
    return report


def water_transportation_display_frame(water, *, feature_limit=100_000,
                                       coordinate_limit=2_000_000, tolerance=0.0):
    """Collect all selected lines only after checking both display budgets."""
    from pyspark.sql import functions as F
    from .visualize import collect_geodataframe

    for name, value in (("MAP_FEATURE_LIMIT", feature_limit),
                        ("MAP_COORDINATE_LIMIT", coordinate_limit)):
        if isinstance(value, bool) or not isinstance(value, int) or value < 1:
            raise ValueError(f"{name} must be a positive integer")
    if isinstance(tolerance, bool) or not math.isfinite(tolerance) or tolerance < 0:
        raise ValueError("MAP_SIMPLIFY_TOLERANCE must be finite and nonnegative")
    report = validate_water_transportation(water)
    for key, limit, setting in (("features", feature_limit, "MAP_FEATURE_LIMIT"),
                                ("coordinates", coordinate_limit, "MAP_COORDINATE_LIMIT")):
        if report[key] > limit:
            raise ValueError(
                f"World water map needs {report[key]:,} {key}; increase {setting}={limit:,}. "
                "No segments were omitted. The complete export is independent of display limits."
            )
    name = F.lit(None).cast("string")
    if "names" in water.columns and "primary" in water.schema["names"].dataType.fieldNames():
        name = F.col("names.primary")
    display_frame = water.select(
        F.col("id").alias("source_id"),
        F.coalesce(name, F.lit("Unnamed water segment")).alias("name"),
        "geometry",
    )
    frame = collect_geodataframe(display_frame.orderBy("source_id"), limit=feature_limit,
                                columns=["source_id", "name"])
    if tolerance:
        simplified = frame.geometry.simplify(tolerance, preserve_topology=True)
        usable = ~simplified.is_empty & simplified.is_valid & simplified.geom_type.isin(
            ["LineString", "MultiLineString"]
        )
        frame.geometry = simplified.where(usable, frame.geometry)
    return frame


def water_transportation_map(frame, *, countries=None, wms=None):
    """Render every prepared water line, optional country context, and controls."""
    import pydeck as pdk
    from .visualize import build_interactive_deck

    layers, groups = [], []
    if wms is not None:
        groups.append({"id": "background", "label": "Background",
                       "layer_ids": ["airgap-wms-background"]})
    if countries is not None:
        layers.append(pdk.Layer(
            "GeoJsonLayer", countries.__geo_interface__, id="water-country-context",
            pickable=False, filled=True, stroked=True,
            get_fill_color=[224, 230, 235], get_line_color=[145, 158, 170],
            line_width_min_pixels=0.5,
        ))
        groups.append({"id": "countries", "label": "Country context",
                       "layer_ids": ["water-country-context"], "color": [224, 230, 235]})
    layers.append(pdk.Layer(
        "GeoJsonLayer", frame.__geo_interface__, id="world-water-transportation",
        pickable=True, auto_highlight=True, filled=False, stroked=True,
        get_line_color=[0, 103, 175], highlight_color=[240, 130, 35, 255],
        line_width_min_pixels=1.5, wrap_longitude=True,
    ))
    groups.append({"id": "water", "label": f"Water transportation ({len(frame):,} segments)",
                   "layer_ids": ["world-water-transportation"], "color": [0, 103, 175]})
    controls = {
        "groups": groups, "cities": [],
        "views": {"world": [[-180, -65], [180, 80]]},
        "description": "All Overture water segments in this release. Hover for names and source IDs.",
    }
    deck = build_interactive_deck(
        layers, pdk.ViewState(longitude=0, latitude=15, zoom=0.5), wms=wms,
        tooltip={"text": "{name}\nWater transportation\nSource ID: {source_id}"},
    )
    return deck, controls
