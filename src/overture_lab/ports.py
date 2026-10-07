"""Evidence-labelled maritime discovery, mapping, and local single-file export."""

from __future__ import annotations

from dataclasses import replace
from pathlib import Path
import os
import re
import tempfile


# Exact classification labels, not substring tests against arbitrary categories.
DEFAULT_SITE_LABELS = (
    "port", "ports", "seaport", "harbor", "harbour", "port_and_harbor",
    "ports_and_harbors", "marina", "naval_base", "ferry_terminal",
    "cruise_terminal", "fishing_port", "container_terminal", "cargo_terminal",
    "shipyard",
)
DEFAULT_COMPONENT_LABELS = ("pier", "quay", "breakwater", "dock", "fuel_dock", "harbour_basin")
DEFAULT_NAME_EXCLUDED_LABELS = (
    "airport", "airports", "airfield", "heliport", "balloon_port", "glider_port",
    "air_transport_facility_or_service", "military_airport", "international_airport",
)
DEFAULT_NAME_TERMS = (
    "port", "harbor", "harbour", "seaport", "marina", "naval base",
    "ferry terminal", "cruise terminal", "fishing port", "container terminal",
    "cargo terminal", "shipyard", "נמל", "נמלים", "מרינה", "מעגן",
    "ميناء", "مرفأ", "مارينا",
)
DEFAULT_TAG_RULES = {
    "landuse": ("port", "harbour"), "industrial": ("port", "shipyard"),
    "harbour": ("yes", "marina", "fishing", "commercial", "military"),
    "leisure": ("marina",), "military": ("naval_base",),
    "amenity": ("ferry_terminal",), "waterway": ("dock",),
    "man_made": ("pier", "quay", "breakwater"),
    "seamark:type": ("harbour", "harbour_basin", "pier", "dock"),
}
BASE_CLASSES = {
    "land_use": ("marina", "naval_base"),
    "infrastructure": ("ferry_terminal", "pier", "quay", "breakwater"),
    "water": ("dock",),
}


def name_pattern(terms):
    """Unicode word boundaries also avoid matching 'port' inside 'airport'."""
    if not terms or any(not term.strip() for term in terms):
        raise ValueError("Port name terms must be nonempty strings")
    return r"(?iu)(?<![\p{L}\p{N}_])(?:" + "|".join(
        re.escape(term) for term in terms
    ) + r")(?![\p{L}\p{N}_])"


def discover_ports(df, *, theme, feature_type, release,
                   site_labels=DEFAULT_SITE_LABELS,
                   component_labels=DEFAULT_COMPONENT_LABELS,
                   name_terms=DEFAULT_NAME_TERMS, tag_rules=None,
                   name_excluded_labels=DEFAULT_NAME_EXCLUDED_LABELS):
    """Normalize one already bbox-filtered source; retain auditable evidence.

    Both old categories and new taxonomy are supported without missing-field
    analysis errors. Names alone always produce candidates, never confirmed sites.
    """
    from pyspark.sql import functions as F
    from pyspark.sql.types import StructType

    def has(path):
        datatype = df.schema
        for part in path.split("."):
            if not isinstance(datatype, StructType) or part not in datatype.names:
                return False
            datatype = datatype[part].dataType
        return True

    def scalar(path):
        return F.col(path).cast("string") if has(path) else F.lit(None).cast("string")

    empty = F.array().cast("array<string>")

    def array(path):
        return F.coalesce(F.col(path), empty) if has(path) else empty

    def as_json(path):
        return F.to_json(F.col(path)) if has(path) else F.lit(None).cast("string")

    labels = F.array_distinct(F.filter(F.concat(
        F.array(scalar("basic_category"), scalar("taxonomy.primary"), scalar("categories.primary")),
        array("taxonomy.hierarchy"), array("taxonomy.alternates"),
        array("taxonomy.alternate"), array("categories.alternate"), array("categories.alternates"),
    ), lambda x: x.isNotNull()))
    names = F.concat(F.array(scalar("names.primary")),
                     F.coalesce(F.map_values(F.col("names.common")), empty)
                     if has("names.common") else empty)
    if has("names.rules"):
        names = F.concat(names, F.coalesce(F.transform(F.col("names.rules"), lambda x: x["value"]), empty))
    names = F.coalesce(names, F.array(scalar("names.primary")))
    name_matches = F.filter(names, lambda x: x.rlike(name_pattern(name_terms)))
    aviation = F.exists(labels, lambda x: F.lower(x).isin(*name_excluded_labels)) | F.coalesce(
        F.lower(scalar("class")).isin(*name_excluded_labels) | (scalar("subtype") == "airport"), F.lit(False))
    name_eligible = ~aviation
    if feature_type == "infrastructure":
        # Bus stops, parking, etc. often inherit nearby harbor names. Their
        # names alone do not identify a port; explicit maritime tags still can.
        name_eligible = name_eligible & scalar("class").isin("terminal", *BASE_CLASSES["infrastructure"])
    name_matches = F.when(name_eligible, name_matches).otherwise(empty)
    class_match = F.coalesce(scalar("class").isin(*BASE_CLASSES.get(feature_type, ())), F.lit(False))
    label_matches = F.filter(labels, lambda x: F.lower(x).isin(*(site_labels + component_labels)))
    if theme != "places":
        label_matches = empty
    tags = []
    component_tag_hits = []
    for key, values in (DEFAULT_TAG_RULES if tag_rules is None else tag_rules).items():
        value = F.element_at(F.col("source_tags"), F.lit(key)) if has("source_tags") else F.lit(None)
        hit = F.lower(value).isin(*values)
        tags.append(F.when(hit, F.concat(F.lit(f"source_tags.{key}="), value)))
        component_tag_hits.append(F.coalesce(hit & F.lower(value).isin(*component_labels), F.lit(False)))
    tag_matches = F.filter(F.array(*tags).cast("array<string>"), lambda x: x.isNotNull())
    evidence = F.concat(
        F.when(class_match, F.array(F.concat(F.lit("class="), scalar("class")))).otherwise(empty),
        F.transform(label_matches, lambda x: F.concat(F.lit("category="), x)),
        tag_matches, F.transform(name_matches, lambda x: F.concat(F.lit("name="), x)),
    )
    explicit = class_match | (F.size(label_matches) > 0) | (F.size(tag_matches) > 0)
    component = (class_match & scalar("class").isin(*component_labels)) | F.exists(
        label_matches, lambda x: F.lower(x).isin(*component_labels))
    for hit in component_tag_hits:
        component = component | hit
    attributes = [F.col(f"`{c}`") for c in df.columns if c not in ("geometry", "theme", "feature_type")]
    return df.select(
        scalar("id").alias("id"), F.lit(theme).alias("source_theme"),
        F.lit(feature_type).alias("source_type"), scalar("names.primary").alias("name"),
        scalar("class").alias("class"), scalar("subtype").alias("subtype"),
        labels.alias("categories"),
        F.when(component, "component").otherwise("site").alias("feature_role"),
        F.when(explicit, "explicit").otherwise("candidate").alias("evidence_level"),
        F.array_distinct(evidence).alias("match_evidence"),
        as_json("sources").alias("sources_json"),
        F.to_json(F.struct(*attributes)).alias("source_attributes_json"),
        F.lit(release).alias("release"),
        F.expr("ST_SetSRID(geometry, 4326)").alias("geometry"),
    ).where(F.size("match_evidence") > 0)


def validate_ports(df):
    from pyspark.sql import functions as F

    row = df.agg(F.count("*").alias("rows"), F.sum(F.when(F.expr(
        "id IS NULL OR geometry IS NULL OR ST_IsEmpty(geometry) "
        "OR NOT ST_IsValid(geometry) OR ST_SRID(geometry) <> 4326"
    ), 1).otherwise(0)).alias("invalid")).first()
    if row.invalid:
        raise ValueError(f"Port results contain {row.invalid} invalid IDs/geometries")
    return int(row.rows)


def export_ports(df, spark, settings, destination, *, overwrite=False):
    """Validate a staged single GeoParquet before atomic local promotion."""
    from .outputs import write_single_geoparquet

    target = Path(destination).expanduser().absolute()
    if target.suffix != ".geoparquet":
        raise ValueError("Port export must end in .geoparquet")
    if target.is_symlink():
        raise ValueError("Port export destination must not be a symlink")
    if not settings.release_uri.startswith("s3a://"):
        source = Path(settings.release_uri.removeprefix("file://")).resolve()
        if target.resolve().is_relative_to(source):
            raise ValueError("Port export must not write into the source release")
    if target.exists() and not overwrite:
        raise FileExistsError(f"{target} already exists; choose a new path or set OVERWRITE=True")
    rows = validate_ports(df)
    target.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix=".region-ports-", dir=target.parent) as staging:
        local = replace(settings, write_derived=True, derived_output_mode="local",
                        derived_local_fallback_dir=staging)
        result = write_single_geoparquet(df, spark, local, dataset_name="region_ports",
                                        object_name="region_ports.geoparquet")
        staged = Path(result.geoparquet_uri)
        if overwrite:
            os.replace(staged, target)
        else:
            # An atomic exclusive link also protects against concurrent writers.
            os.link(staged, target)
    return {"status": "written", "destination": str(target), "row_count": rows}


def ports_map(df, boundary, *, feature_limit, wms=None):
    """Return a complete mixed-geometry map; never silently sample its rows."""
    import pydeck as pdk
    from pyspark.sql import functions as F
    from .visualize import build_interactive_deck, collect_geodataframe

    if feature_limit < 1:
        raise ValueError("MAP_FEATURE_LIMIT must be positive")
    count = df.count()
    if count > feature_limit:
        raise ValueError(f"Map requires {count} features; raise MAP_FEATURE_LIMIT={feature_limit}. "
                         "The complete export is independent of this display limit.")
    frame = collect_geodataframe(df.withColumn("evidence", F.concat_ws("; ", "match_evidence")),
                                limit=feature_limit, columns=["id", "name", "source_theme", "source_type",
                                "class", "feature_role", "evidence_level", "evidence", "geometry"]).rename(
                                    columns={"id": "source_id"})
    outline = collect_geodataframe(boundary, limit=1, columns=["geometry"])
    layers = [pdk.Layer("GeoJsonLayer", outline.__geo_interface__, id="ports-region",
                        filled=False, stroked=True, get_line_color=[70, 80, 90], line_width_min_pixels=1)]
    groups = [{"id": "region", "label": "Region", "layer_ids": ["ports-region"]}]
    for key, label, mask, color in (
        ("explicit", "Explicit sites", (frame.feature_role == "site") & (frame.evidence_level == "explicit"), [0, 135, 105]),
        ("candidate", "Candidate sites", (frame.feature_role == "site") & (frame.evidence_level == "candidate"), [220, 140, 0]),
        ("components", "Components", frame.feature_role == "component", [55, 110, 210]),
    ):
        layer_id = f"ports-{key}"
        layers.append(pdk.Layer("GeoJsonLayer", frame.loc[mask].__geo_interface__, id=layer_id,
                                pickable=True, filled=True, stroked=True,
                                get_fill_color=color + [150], get_line_color=color,
                                get_point_radius=5, point_radius_units="'pixels'",
                                point_radius_max_pixels=6, line_width_min_pixels=2))
        groups.append({"id": key, "label": label, "layer_ids": [layer_id], "color": color})
    if wms:
        groups.append({"id": "background", "label": "WMS background", "layer_ids": ["airgap-wms-background"]})
    xmin, ymin, xmax, ymax = map(float, outline.total_bounds)
    deck = build_interactive_deck(layers, pdk.ViewState(longitude=(xmin+xmax)/2, latitude=(ymin+ymax)/2, zoom=6),
                                 wms=wms, tooltip={"text": "{name}\n{source_theme}/{source_type}: {class}\n"
                                 "{feature_role} / {evidence_level}\nID: {source_id}\n{evidence}"})
    controls = {"groups": groups, "views": {"region": [[xmin, ymin], [xmax, ymax]]}, "cities": [],
                "description": f"{count:,} source features. Candidates require review; components are not separate ports."}
    return deck, controls
