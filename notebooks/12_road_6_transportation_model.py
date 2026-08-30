# %% [markdown]
# # 12 — How one real highway becomes an Overture transportation graph
#
# **Case study:** Road 6 / כביש חוצה ישראל.
# **Audience:** GIS and data engineers.
# **Execution engine:** SedonaSpark for all complete-route analysis; pandas,
# GeoPandas, Matplotlib, and pydeck only after explicit bounded collection.
#
# A road number is not one Overture geometry. Road 6 is a collection of
# `transportation/segment` features whose nested `routes` rules identify the
# shared real-world route. Segment connector references form the network graph;
# rule arrays describe properties that may apply to only part of a segment.
#
# This lesson answers five questions:
#
# 1. How is a named and numbered highway selected without guessing feature IDs?
# 2. Why does one road become many directed segment features?
# 3. How do connector IDs encode topology that geometry alone cannot prove?
# 4. How do `between` ranges place speed, surface, bridge, tunnel, level, access,
#    route, and source facts along a segment?
# 5. Why is the sum of Road 6 feature lengths roughly twice its corridor length?
#
# The lesson is read-only. It does not export derived files and makes no public
# network requests. Interactive maps embed their renderer locally and may use
# only the optional internal WMS configured for the lab.
#
# Model references: [transportation](https://docs.overturemaps.org/guides/transportation/),
# [segments and connectors](https://docs.overturemaps.org/guides/transportation/segments-and-connectors/),
# and [road rules](https://docs.overturemaps.org/guides/transportation/roads/).

# %%
import json
import math

import matplotlib.pyplot as plt
from matplotlib.lines import Line2D
import pandas as pd
import pydeck as pdk
from pyspark import StorageLevel
from pyspark.sql import functions as F

from overture_lab.catalog import schema_table
from overture_lab.config import load_settings
from overture_lab.regions import Bounds, bbox_overlap
from overture_lab.spark import create_sedona, read_type
from overture_lab.transportation_case import (
    _normalise_between,
    _route_topology,
    _rule_boundaries,
)
from overture_lab.visualize import (
    build_interactive_deck,
    collect_geodataframe,
    offline_deck_display,
)

settings = load_settings()
spark = create_sedona(settings, "12-road-6-transportation-model")

# This bbox is only a Parquet pruning window. Route membership is decided by
# the nested route identity below, never by the bbox or a road name.
ROAD_6_BOUNDS = Bounds(34.70, 30.70, 35.30, 33.00)
ROAD_6_REF = "6"
ROAD_6_WIKIDATA = "Q595131"
OFFICIAL_CORRIDOR_KM = 188.0
MAX_ROUTE_SEGMENTS = 5_000
MAX_CONNECTOR_REFERENCES = 25_000

display(
    {
        "release": settings.release,
        "release_uri": settings.release_uri,
        "route_ref": ROAD_6_REF,
        "route_wikidata": ROAD_6_WIKIDATA,
        "pruning_bounds": ROAD_6_BOUNDS.as_dict(),
        "map_feature_limit": settings.map_feature_limit,
        "wms_enabled": settings.wms is not None,
        "write_derived": settings.write_derived,
    }
)

# %% [markdown]
# ## 1. The two feature types: segments and connectors
#
# A segment is an oriented `LineString`. It carries route membership, names,
# class, rules, provenance, and references to connector IDs. A connector is a
# `Point` with common feature properties; it does not duplicate the road rules.
#
# Two line geometries that touch or cross are **not** necessarily connected.
# Overture topology exists only when the segments reference the same connector
# ID. Every official segment has connector references at its normalized start
# (`at=0`) and end (`at=1`); additional values between zero and one are routing
# decision points inside the segment.

# %%
segments_source = read_type(
    spark, settings, "transportation", "segment"
).drop("theme", "feature_type")
connectors_source = read_type(
    spark, settings, "transportation", "connector"
).drop("theme", "feature_type")

display(schema_table(segments_source))
display(schema_table(connectors_source))

# %% [markdown]
# ## 2. Select Road 6 by route identity
#
# The bbox predicate reduces the global Parquet scan. It does not define the
# road. The authoritative predicate searches every route rule for the exact
# combination `ref=6` and Wikidata entity `Q595131`. The Hebrew route name is
# useful for people but is deliberately not an identity key: names can be
# localized, absent, or changed.

# %%
regional_segments = (
    bbox_overlap(
        segments_source.where(F.col("subtype") == "road"),
        (ROAD_6_BOUNDS,),
    )
    .persist(StorageLevel.MEMORY_AND_DISK)
)
road_6 = (
    regional_segments.where(
        F.expr(
            "exists(routes, route -> "
            f"route.ref = '{ROAD_6_REF}' AND "
            f"route.wikidata = '{ROAD_6_WIKIDATA}')"
        )
    )
    .withColumn("full_length_m", F.expr("ST_LengthSpheroid(geometry)"))
    .persist(StorageLevel.MEMORY_AND_DISK)
)
route_segment_count = road_6.count()
if route_segment_count == 0:
    raise RuntimeError(
        "No Road 6 segments matched ref=6 and Wikidata Q595131 inside the "
        f"documented pruning bbox for release {settings.release}"
    )
if route_segment_count > MAX_ROUTE_SEGMENTS:
    raise RuntimeError(
        f"Road 6 contains {route_segment_count:,} segments, exceeding the "
        f"bounded topology limit {MAX_ROUTE_SEGMENTS:,}"
    )

route_identity = (
    road_6.select(F.explode("routes").alias("route"))
    .where(
        (F.col("route.ref") == ROAD_6_REF)
        & (F.col("route.wikidata") == ROAD_6_WIKIDATA)
    )
    .groupBy(
        "route.name",
        "route.network",
        "route.ref",
        "route.symbol",
        "route.wikidata",
    )
    .count()
    .orderBy(F.desc("count"))
)
display(route_identity.toPandas())

# %% [markdown]
# ## 3. Route rules and effective geometry
#
# `routes` is an array because a segment can participate in several named or
# numbered routes. Route membership itself is linearly referenced. A null
# `between` means the rule covers the complete segment; `[start, end]` limits it
# to that normalized part of the oriented geometry.
#
# The original segment remains intact. `ST_LineSubstring` below creates a
# presentation and measurement derivative for the matching route range only.

# %%
route_rules = (
    road_6.select(
        "id",
        "geometry",
        "full_length_m",
        F.explode("routes").alias("route"),
    )
    .where(
        (F.col("route.ref") == ROAD_6_REF)
        & (F.col("route.wikidata") == ROAD_6_WIKIDATA)
    )
    .persist(StorageLevel.MEMORY_AND_DISK)
)
invalid_route_ranges = route_rules.where(
    F.col("route.between").isNotNull()
    & (
        (F.size("route.between") != 2)
        | (F.col("route.between")[0] < 0.0)
        | (F.col("route.between")[1] > 1.0)
        | (F.col("route.between")[0] >= F.col("route.between")[1])
    )
).count()
if invalid_route_ranges:
    raise RuntimeError(
        f"Road 6 contains {invalid_route_ranges} invalid route ranges"
    )

route_scoped = (
    route_rules.select(
        "id",
        "full_length_m",
        F.col("route.between").alias("route_between"),
        F.when(F.col("route.between").isNull(), F.col("geometry"))
        .otherwise(
            F.expr(
                "ST_LineSubstring(geometry, "
                "route.between[0], route.between[1])"
            )
        )
        .alias("geometry"),
    )
    .withColumn("scoped_length_m", F.expr("ST_LengthSpheroid(geometry)"))
    .persist(StorageLevel.MEMORY_AND_DISK)
)
route_rule_count = route_rules.count()
partial_route_rule_count = route_rules.where(
    F.col("route.between").isNotNull()
).count()

display(
    route_rules.where(F.col("route.between").isNotNull())
    .select(
        "id",
        F.col("route.name").alias("route_name"),
        F.col("route.ref").alias("route_ref"),
        F.col("route.between").alias("between"),
        "full_length_m",
    )
    .toPandas()
)

# %% [markdown]
# ## 4. Why one highway becomes many segments
#
# `class` is a segment-level property: a class change forces a split. Many
# other facts can change inside a segment and therefore use `between` instead.
# The tables below quantify both segmentation and missing-versus-explicit data.
# A missing speed or access rule does not mean “unlimited” or “inaccessible”;
# applications must apply defaults from class and local rules.

# %%
attribute_columns = (
    "names",
    "speed_limits",
    "road_surface",
    "road_flags",
    "level_rules",
    "access_restrictions",
    "prohibited_transitions",
    "destinations",
    "sources",
)
coverage_rows = []
for column in attribute_columns:
    if column == "names":
        present = F.col(column).isNotNull()
    else:
        present = F.size(column) > 0
    count = road_6.agg(
        F.sum(F.when(present, 1).otherwise(0)).alias("count")
    ).first()["count"]
    coverage_rows.append(
        {
            "attribute": column,
            "segments_with_explicit_value": int(count),
            "coverage_percent": round(100.0 * count / route_segment_count, 1),
        }
    )
coverage_pdf = pd.DataFrame(coverage_rows)

segment_summary = (
    road_6.groupBy("class", "subclass")
    .agg(
        F.count("*").alias("segments"),
        F.round(F.sum("full_length_m") / 1000.0, 3).alias("feature_km"),
    )
    .orderBy(F.desc("segments"))
)
name_summary = (
    road_6.groupBy(F.coalesce("names.primary", F.lit("<missing>")).alias("name"))
    .count()
    .orderBy(F.desc("count"))
)
source_summary = (
    road_6.select(F.explode_outer("sources").alias("source"))
    .groupBy("source.dataset")
    .agg(
        F.count("*").alias("source_rules"),
        F.min("source.update_time").alias("earliest_update"),
        F.max("source.update_time").alias("latest_update"),
    )
    .orderBy(F.desc("source_rules"))
)
display(segment_summary.toPandas())
display(name_summary.limit(20).toPandas())
display(source_summary.toPandas())
display(coverage_pdf)

# %% [markdown]
# ## 5. Connector references are the graph
#
# We now expand each selected segment to `(segment_id, connector_id, at)`.
# Connector geometry is resolved by exact ID after the same bbox pruning. The
# checks prove that every referenced connector exists and lies on its segment.
# No spatial-nearness rule is used to manufacture graph edges.

# %%
segment_connectors = (
    road_6.select(
        F.col("id").alias("segment_id"),
        "geometry",
        F.expr("ST_Y(ST_StartPoint(geometry))").alias("start_lat"),
        F.expr("ST_Y(ST_EndPoint(geometry))").alias("end_lat"),
        F.explode("connectors").alias("connector"),
    )
    .select(
        "segment_id",
        "geometry",
        "start_lat",
        "end_lat",
        F.col("connector.connector_id").alias("connector_id"),
        F.col("connector.at").alias("at"),
    )
    .persist(StorageLevel.MEMORY_AND_DISK)
)
connector_reference_count = segment_connectors.count()
if connector_reference_count > MAX_CONNECTOR_REFERENCES:
    raise RuntimeError(
        f"Road 6 contains {connector_reference_count:,} connector references, "
        f"exceeding the bounded topology limit {MAX_CONNECTOR_REFERENCES:,}"
    )
invalid_connector_positions = segment_connectors.where(
    (F.col("at") < 0.0) | (F.col("at") > 1.0)
).count()
if invalid_connector_positions:
    raise RuntimeError(
        f"Road 6 contains {invalid_connector_positions} invalid connector positions"
    )

route_connector_ids = segment_connectors.select("connector_id").distinct()
connector_candidates = bbox_overlap(
    connectors_source, (ROAD_6_BOUNDS,)
)
route_connectors = (
    connector_candidates.alias("connector")
    .join(
        F.broadcast(route_connector_ids.alias("wanted")),
        F.col("connector.id") == F.col("wanted.connector_id"),
        "inner",
    )
    .select(
        F.col("connector.id").alias("connector_id"),
        F.col("connector.geometry").alias("connector_geometry"),
        F.col("connector.version").alias("connector_version"),
        F.col("connector.sources").alias("connector_sources"),
    )
    .persist(StorageLevel.MEMORY_AND_DISK)
)
unique_connector_count = route_connector_ids.count()
resolved_connector_count = route_connectors.count()
missing_connector_count = unique_connector_count - resolved_connector_count
if missing_connector_count:
    raise RuntimeError(
        f"Road 6 references {missing_connector_count} unresolved connectors"
    )

connector_qa = segment_connectors.join(
    F.broadcast(route_connectors), "connector_id", "left"
)
off_geometry_count = connector_qa.where(
    F.col("connector_geometry").isNull()
    | ~F.expr("ST_Intersects(geometry, connector_geometry)")
).count()
if off_geometry_count:
    raise RuntimeError(
        f"Road 6 contains {off_geometry_count} connector references off geometry"
    )

route_degrees = (
    segment_connectors.groupBy("connector_id")
    .agg(F.countDistinct("segment_id").alias("route_segment_degree"))
    .persist(StorageLevel.MEMORY_AND_DISK)
)
regional_incidents = (
    regional_segments.select(
        "id",
        "names",
        "class",
        "subclass",
        "routes",
        F.explode("connectors").alias("connector"),
    )
    .select(
        "id",
        "names",
        "class",
        "subclass",
        "routes",
        F.col("connector.connector_id").alias("connector_id"),
        F.col("connector.at").alias("at"),
    )
    .join(F.broadcast(route_connector_ids), "connector_id", "inner")
    .withColumn(
        "is_road_6",
        F.coalesce(
            F.expr(
                "exists(routes, route -> "
                f"route.ref = '{ROAD_6_REF}' AND "
                f"route.wikidata = '{ROAD_6_WIKIDATA}')"
            ),
            F.lit(False),
        ),
    )
    .persist(StorageLevel.MEMORY_AND_DISK)
)
total_incident_degrees = regional_incidents.groupBy("connector_id").agg(
    F.countDistinct("id").alias("total_incident_road_degree")
)
connector_graph_qa = route_degrees.join(
    total_incident_degrees, "connector_id", "left"
).fillna(0, subset=["total_incident_road_degree"])
endpoint_connector_ids = segment_connectors.where(
    (F.col("at") == 0.0) | (F.col("at") == 1.0)
).select("connector_id").distinct()
route_endpoint_count = connector_graph_qa.join(
    endpoint_connector_ids, "connector_id", "inner"
).where(F.col("route_segment_degree") == 1).count()
route_junction_count = connector_graph_qa.where(
    F.col("total_incident_road_degree") > F.col("route_segment_degree")
).count()
intermediate_connector_count = segment_connectors.where(
    (F.col("at") > 0.0) & (F.col("at") < 1.0)
).select("connector_id").distinct().count()
connector_count_distribution = (
    road_6.select(F.size("connectors").alias("connectors_per_segment"))
    .groupBy("connectors_per_segment")
    .count()
    .orderBy("connectors_per_segment")
)
route_degree_distribution = (
    route_degrees.groupBy("route_segment_degree")
    .count()
    .orderBy("route_segment_degree")
)
display(connector_count_distribution.toPandas())
display(route_degree_distribution.toPandas())
display(
    connector_graph_qa.groupBy(
        "route_segment_degree", "total_incident_road_degree"
    ).count().orderBy(
        "route_segment_degree", "total_incident_road_degree"
    ).toPandas()
)
display(
    {
        "route_endpoints": route_endpoint_count,
        "intermediate_connector_ids": intermediate_connector_count,
        "connectors_with_external_incident_roads": route_junction_count,
    }
)

# %% [markdown]
# ## 6. Directional components and route order
#
# The connector reference set is small only because Road 6 has already been
# selected exactly. It is now safe to collect this bounded graph. Components
# are built from shared connector IDs. Directed order uses only `at=0` start
# connectors and `at=1` end connectors. Direction labels come from the net
# latitude change of the oriented segment geometries, never from hard-coded IDs.

# %%
topology_input = [
    row.asDict(recursive=True)
    for row in segment_connectors.select(
        "segment_id", "connector_id", "at", "start_lat", "end_lat"
    ).collect()
]
topology = _route_topology(topology_input)
topology_assignments = spark.createDataFrame(list(topology.assignments))
topology_diagnostics_pdf = pd.DataFrame(topology.components)
road_6_ordered = (
    road_6.join(
        F.broadcast(topology_assignments),
        road_6.id == topology_assignments.segment_id,
        "inner",
    )
    .drop("segment_id")
    .persist(StorageLevel.MEMORY_AND_DISK)
)
route_scoped_ordered = route_scoped.join(
    F.broadcast(topology_assignments),
    route_scoped.id == topology_assignments.segment_id,
    "inner",
).drop("segment_id")

component_summary = (
    road_6_ordered.groupBy("component_id", "direction")
    .agg(
        F.count("*").alias("segments"),
        F.round(F.sum("full_length_m") / 1000.0, 3).alias("feature_km"),
        F.min("route_order").alias("first_order"),
        F.max("route_order").alias("last_order"),
    )
    .orderBy("direction")
)
one_way_backward_denials = road_6.where(
    F.expr(
        "exists(access_restrictions, rule -> "
        "rule.access_type = 'denied' AND rule.when.heading = 'backward')"
    )
).count()
display(topology_diagnostics_pdf)
display(component_summary.toPandas())
display(
    {
        "expected_two_directed_chains": (
            len(topology.components) == 2
            and all(item["directed_path"] for item in topology.components)
        ),
        "branches": sum(item["branch_count"] for item in topology.components),
        "cycles": sum(item["cycle_detected"] for item in topology.components),
        "segments_with_backward_travel_denied": one_way_backward_denials,
        "route_segments": route_segment_count,
        "interpretation": (
            "When the counts match, every selected centerline is explicitly "
            "one-way in its forward geometry heading."
        ),
    }
)

# %% [markdown]
# ## 7. Feature-km is not corridor-km
#
# An official [State Comptroller report](https://library.mevaker.gov.il/sites/DigitalLibrary/Pages/Reports/7845-7.aspx)
# reports approximately 188 km for the northern, central, and southern Road 6
# sections. That is a corridor measure. Overture
# represents the two one-way carriageways as separate directed feature chains,
# so adding their geometry naturally approaches twice the corridor length.
#
# The comparison also separates full segment geometry from route-scoped
# geometry. The difference is caused by the route rule whose `between` covers
# only part of its source segment—not by clipping the analytical source row.

# %%
lengths = road_6.agg(
    F.sum("full_length_m").alias("full_m"),
    F.avg("full_length_m").alias("mean_m"),
    F.min("full_length_m").alias("min_m"),
    F.max("full_length_m").alias("max_m"),
    F.expr(
        "percentile_approx(full_length_m, array(0.25, 0.5, 0.75, 0.95))"
    ).alias("percentiles_m"),
).first()
scoped_length_m = route_scoped.agg(
    F.sum("scoped_length_m").alias("value")
).first()["value"]
full_feature_km = float(lengths["full_m"]) / 1000.0
scoped_feature_km = float(scoped_length_m) / 1000.0

kpi_rows = [
        ("Route segments", route_segment_count, "features"),
        ("Matching route rules", route_rule_count, "rules"),
        ("Partial route rules", partial_route_rule_count, "rules"),
        ("Full feature length", round(full_feature_km, 3), "km"),
        ("Route-scoped feature length", round(scoped_feature_km, 3), "km"),
        ("Official corridor context", OFFICIAL_CORRIDOR_KM, "km"),
        ("Directional components", len(topology.components), "components"),
        ("Connector references", connector_reference_count, "references"),
        ("Unique connectors", unique_connector_count, "connectors"),
        ("Route endpoints", route_endpoint_count, "connectors"),
        (
            "Intermediate decision points",
            intermediate_connector_count,
            "connectors",
        ),
        ("External-road junctions", route_junction_count, "connectors"),
        (
            "Missing/off-geometry connectors",
            missing_connector_count + off_geometry_count,
            "references",
        ),
]
kpi_rows.extend(
    (
        f"Missing {row.attribute}",
        round(100.0 - row.coverage_percent, 1),
        "% of segments",
    )
    for row in coverage_pdf.itertuples(index=False)
)
kpi_pdf = pd.DataFrame(kpi_rows, columns=["metric", "value", "unit"])
display(kpi_pdf)
display(
    {
        "mean_segment_m": round(float(lengths["mean_m"]), 3),
        "min_segment_m": round(float(lengths["min_m"]), 3),
        "max_segment_m": round(float(lengths["max_m"]), 3),
        "p25_p50_p75_p95_m": [round(value, 3) for value in lengths["percentiles_m"]],
        "directional_to_corridor_ratio": round(
            scoped_feature_km / OFFICIAL_CORRIDOR_KM, 3
        ),
    }
)

# %% [markdown]
# ## 8. Statistical charts
#
# These charts collect only the 124 selected Road 6 rows or already-aggregated
# tables. The logarithmic histogram exposes a long-tailed segment-length
# distribution; coverage distinguishes explicit attributes from implied
# defaults; connector charts show how graph detail varies by segment.

# %%
length_pdf = road_6.select("id", "full_length_m").toPandas()
connector_count_pdf = connector_count_distribution.toPandas()
degree_pdf = route_degree_distribution.toPandas()

figure, axes = plt.subplots(2, 2, figsize=(16, 11))
axes[0, 0].hist(length_pdf["full_length_m"], bins=24, color="#2563eb")
axes[0, 0].set_xscale("log")
axes[0, 0].set_title("Road 6 segment-length distribution")
axes[0, 0].set_xlabel("segment length (metres, log scale)")
axes[0, 0].set_ylabel("segments")

coverage_sorted = coverage_pdf.sort_values("coverage_percent")
axes[0, 1].barh(
    coverage_sorted["attribute"],
    coverage_sorted["coverage_percent"],
    color="#0f766e",
)
axes[0, 1].set_xlim(0, 100)
axes[0, 1].set_title("Segments with explicit attribute data")
axes[0, 1].set_xlabel("coverage (%)")
axes[0, 1].set_ylabel("attribute")

axes[1, 0].bar(
    connector_count_pdf["connectors_per_segment"].astype(str),
    connector_count_pdf["count"],
    color="#7c3aed",
)
axes[1, 0].set_title("Connector references per segment")
axes[1, 0].set_xlabel("connector references")
axes[1, 0].set_ylabel("segments")

axes[1, 1].bar(
    degree_pdf["route_segment_degree"].astype(str),
    degree_pdf["count"],
    color="#c2410c",
)
axes[1, 1].set_title("Route-only segment degree at connectors")
axes[1, 1].set_xlabel("Road 6 segments sharing connector")
axes[1, 1].set_ylabel("connectors")
figure.tight_layout()
plt.show()

# %% [markdown]
# ## 9. Ordered speed and structure strip
#
# A segment may hold several speed rules. Every line below uses the rule's real
# normalized start/end within its connector-derived segment order. Bridge and
# tunnel intervals are offset from the speed lane. Gaps mean no explicit rule;
# they are not silently filled from a guessed default.

# %%
speed_ranges = (
    road_6_ordered.select(
        "id",
        "direction",
        "route_order",
        F.explode_outer("speed_limits").alias("speed_rule"),
    )
    .where(F.col("speed_rule.max_speed.value").isNotNull())
    .select(
        "id",
        "direction",
        "route_order",
        F.col("speed_rule.max_speed.value").alias("max_speed_kmh"),
        F.coalesce(F.col("speed_rule.between")[0], F.lit(0.0)).alias("start"),
        F.coalesce(F.col("speed_rule.between")[1], F.lit(1.0)).alias("end"),
    )
)
structure_ranges = (
    road_6_ordered.select(
        "id",
        "direction",
        "route_order",
        F.explode_outer("road_flags").alias("flag_rule"),
    )
    .select(
        "id",
        "direction",
        "route_order",
        F.explode_outer("flag_rule.values").alias("structure"),
        F.coalesce(F.col("flag_rule.between")[0], F.lit(0.0)).alias("start"),
        F.coalesce(F.col("flag_rule.between")[1], F.lit(1.0)).alias("end"),
    )
    .where(F.col("structure").isin("is_bridge", "is_tunnel"))
)
speed_range_pdf = speed_ranges.orderBy("direction", "route_order").toPandas()
structure_range_pdf = structure_ranges.orderBy(
    "direction", "route_order", "structure"
).toPandas()

figure, axis = plt.subplots(figsize=(18, 6))
directions = sorted(speed_range_pdf["direction"].unique())
direction_lanes = {direction: index for index, direction in enumerate(directions)}
speed_min = float(speed_range_pdf["max_speed_kmh"].min())
speed_max = float(speed_range_pdf["max_speed_kmh"].max())
speed_norm = plt.Normalize(speed_min, speed_max)
speed_colour_map = plt.get_cmap("viridis")
for row in speed_range_pdf.itertuples(index=False):
    start_x = row.route_order - 1 + row.start
    end_x = row.route_order - 1 + row.end
    axis.plot(
        [start_x, end_x],
        [direction_lanes[row.direction]] * 2,
        color=speed_colour_map(speed_norm(row.max_speed_kmh)),
        linewidth=7,
        solid_capstyle="butt",
    )
structure_styles = {
    "is_bridge": (0.16, "#16a34a", "bridge range"),
    "is_tunnel": (-0.16, "#7e22ce", "tunnel range"),
}
for row in structure_range_pdf.itertuples(index=False):
    offset, colour, _ = structure_styles[row.structure]
    start_x = row.route_order - 1 + row.start
    end_x = row.route_order - 1 + row.end
    lane = direction_lanes[row.direction] + offset
    axis.plot([start_x, end_x], [lane, lane], color=colour, linewidth=3)
axis.set_title("Explicit speed, bridge and tunnel ranges in connector-derived order")
axis.set_xlabel("segment order within directional component")
axis.set_yticks(list(direction_lanes.values()), labels=directions)
axis.set_ylabel("directional component")
axis.grid(axis="x", alpha=0.15)
axis.legend(
    handles=[
        Line2D([0], [0], color=colour, linewidth=3, label=label)
        for _, colour, label in structure_styles.values()
    ],
    loc="upper right",
)
figure.colorbar(
    plt.cm.ScalarMappable(norm=speed_norm, cmap=speed_colour_map),
    ax=axis,
    label="explicit maximum speed (km/h)",
    pad=0.01,
)
plt.show()

# %% [markdown]
# ## 10. Normalize rules without destroying their ranges
#
# The normalized table is a teaching projection. Each row retains its property,
# human-readable value, and exact `between`. Null ranges are interpreted as the
# full `[0, 1]` interval only in the presentation. Destinations are reported
# separately because the release schema models transitions/signposts rather
# than a direct segment `between` range.

# %%
rule_frames = [
    road_6.select("id", F.explode_outer("routes").alias("rule")).select(
        "id",
        F.lit("route").alias("property"),
        F.concat_ws(" / ", "rule.ref", "rule.wikidata", "rule.name").alias("value"),
        F.col("rule.between").alias("between"),
    ),
    road_6.select("id", F.explode_outer("speed_limits").alias("rule")).select(
        "id",
        F.lit("speed_limit").alias("property"),
        F.concat_ws(
            " ",
            F.col("rule.max_speed.value").cast("string"),
            F.col("rule.max_speed.unit"),
        ).alias("value"),
        F.col("rule.between").alias("between"),
    ),
    road_6.select("id", F.explode_outer("road_surface").alias("rule")).select(
        "id",
        F.lit("surface").alias("property"),
        F.col("rule.value").alias("value"),
        F.col("rule.between").alias("between"),
    ),
    road_6.select("id", F.explode_outer("road_flags").alias("rule")).select(
        "id",
        F.lit("road_flags").alias("property"),
        F.concat_ws(", ", "rule.values").alias("value"),
        F.col("rule.between").alias("between"),
    ),
    road_6.select("id", F.explode_outer("level_rules").alias("rule")).select(
        "id",
        F.lit("level").alias("property"),
        F.col("rule.value").cast("string").alias("value"),
        F.col("rule.between").alias("between"),
    ),
    road_6.select(
        "id", F.explode_outer("access_restrictions").alias("rule")
    ).select(
        "id",
        F.lit("access").alias("property"),
        F.concat_ws(
            " / ",
            "rule.access_type",
            "rule.when.heading",
            F.to_json("rule.when.mode"),
            F.to_json("rule.when.using"),
        ).alias("value"),
        F.col("rule.between").alias("between"),
    ),
    road_6.select("id", F.explode_outer("sources").alias("rule")).select(
        "id",
        F.lit("source").alias("property"),
        F.concat_ws(" / ", "rule.dataset", "rule.record_id").alias("value"),
        F.col("rule.between").alias("between"),
    ),
]
normalized_rules = rule_frames[0]
for frame in rule_frames[1:]:
    normalized_rules = normalized_rules.unionByName(frame)
normalized_rules = normalized_rules.where(F.col("value").isNotNull()).persist(
    StorageLevel.MEMORY_AND_DISK
)

destination_summary = (
    road_6.select("id", F.explode_outer("destinations").alias("destination"))
    .where(F.col("destination").isNotNull())
    .select(
        "id",
        "destination.from_connector_id",
        "destination.to_segment_id",
        "destination.to_connector_id",
        "destination.final_heading",
        F.to_json("destination.labels").alias("labels"),
        F.to_json("destination.symbols").alias("symbols"),
    )
)
display(
    normalized_rules.groupBy("property")
    .agg(
        F.count("*").alias("rules"),
        F.sum(F.when(F.col("between").isNotNull(), 1).otherwise(0)).alias(
            "partial_rules"
        ),
    )
    .orderBy("property")
    .toPandas()
)
display(
    normalized_rules.groupBy("property", "value")
    .count()
    .orderBy("property", F.desc("count"), "value")
    .toPandas()
)
display(destination_summary.limit(30).toPandas())

# %% [markdown]
# ## 11. Deterministic linear-reference case
#
# The focus segment is selected by the number of distinct rule cut positions,
# with ID as a stable tie-breaker. It is not a hand-picked feature. Connector
# positions are then added to its presentation slices. The original Overture
# segment and nested arrays remain unchanged.

# %%
rule_positions = (
    normalized_rules.where(F.col("between").isNotNull())
    .select("id", F.explode("between").alias("position"))
)
connector_positions = segment_connectors.select(
    F.col("segment_id").alias("id"), F.col("at").alias("position")
)
endpoint_positions = road_6.select("id", F.lit(0.0).alias("position")).unionByName(
    road_6.select("id", F.lit(1.0).alias("position"))
)
position_counts = (
    rule_positions.unionByName(endpoint_positions)
    .distinct()
    .groupBy("id")
    .count()
)
focus_segment_id = position_counts.orderBy(F.desc("count"), "id").first()["id"]
focus_rule_rows = [
    row.asDict(recursive=True)
    for row in normalized_rules.where(F.col("id") == focus_segment_id)
    .orderBy("property", "value")
    .collect()
]
focus_connector_positions = [
    row["at"]
    for row in segment_connectors.where(
        F.col("segment_id") == focus_segment_id
    ).select("at").collect()
]
focus_boundaries = _rule_boundaries(
    [row["between"] for row in focus_rule_rows],
    focus_connector_positions,
)

def applicable_rule_values(property_name: str, position: float) -> list[str]:
    values = []
    for row in focus_rule_rows:
        if row["property"] != property_name:
            continue
        start, end = _normalise_between(row["between"])
        if start <= position <= end:
            values.append(row["value"])
    return sorted(set(values))


slice_metadata = []
for index, (start, end) in enumerate(
    zip(focus_boundaries, focus_boundaries[1:]), start=1
):
    midpoint = (start + end) / 2.0
    speeds = applicable_rule_values("speed_limit", midpoint)
    numeric_speeds = []
    for value in speeds:
        try:
            numeric_speeds.append(int(value.split()[0]))
        except (ValueError, IndexError):
            pass
    slice_metadata.append(
        {
            "slice_number": index,
            "start": start,
            "end": end,
            "max_speed_kmh": max(numeric_speeds) if numeric_speeds else None,
            "flags": ", ".join(applicable_rule_values("road_flags", midpoint)),
            "level": ", ".join(applicable_rule_values("level", midpoint)),
            "access": ", ".join(applicable_rule_values("access", midpoint)),
        }
    )
slice_metadata_df = spark.createDataFrame(slice_metadata)
focus_geometry = road_6.where(F.col("id") == focus_segment_id).select(
    "id", "geometry"
)
focus_slices = (
    slice_metadata_df.crossJoin(F.broadcast(focus_geometry))
    .select(
        "slice_number",
        "start",
        "end",
        "max_speed_kmh",
        "flags",
        "level",
        "access",
        F.expr("ST_LineSubstring(geometry, start, end)").alias("geometry"),
    )
    .orderBy("slice_number")
)
focus_connectors = (
    segment_connectors.where(F.col("segment_id") == focus_segment_id)
    .select("connector_id", "at")
    .join(F.broadcast(route_connectors), "connector_id", "inner")
    .select(
        "connector_id",
        "at",
        F.col("connector_geometry").alias("geometry"),
    )
)
display(
    {
        "focus_segment_id": focus_segment_id,
        "cut_positions": list(focus_boundaries),
        "slice_count": len(slice_metadata),
    }
)
display(pd.DataFrame(focus_rule_rows))
display(focus_slices.drop("geometry").toPandas())

# %% [markdown]
# ## 12. Deterministic interchange case
#
# For every Road 6 connector, the regional graph is searched for all incident
# road segments. The selected connector prefers two Road 6 references plus a
# named, non-link external road. This exposes the difference between the route
# chain, connected ramps/cross-roads, and nearby geometry with no shared
# connector.

# %%
interchange_scores = (
    regional_incidents.groupBy("connector_id")
    .agg(
        F.countDistinct("id").alias("all_road_degree"),
        F.countDistinct(
            F.when(F.col("is_road_6"), F.col("id"))
        ).alias("road_6_degree"),
        F.countDistinct(
            F.when(~F.col("is_road_6"), F.col("id"))
        ).alias("external_degree"),
        F.max(
            F.when(
                ~F.col("is_road_6")
                & F.col("names.primary").isNotNull()
                & (F.coalesce("subclass", F.lit("")) != "link"),
                1,
            ).otherwise(0)
        ).alias("has_named_non_link_external"),
    )
    .where(F.col("external_degree") > 0)
    .orderBy(
        F.when(F.col("road_6_degree") == 2, 1).otherwise(0).desc(),
        F.desc("has_named_non_link_external"),
        F.desc("external_degree"),
        F.desc("all_road_degree"),
        "connector_id",
    )
)
focus_interchange = interchange_scores.first()
if focus_interchange is None:
    raise RuntimeError("No Road 6 connector has an incident external road")
focus_connector_id = focus_interchange["connector_id"]
focus_connector_row = (
    route_connectors.where(F.col("connector_id") == focus_connector_id)
    .select(
        "connector_id",
        F.expr("ST_X(connector_geometry)").alias("longitude"),
        F.expr("ST_Y(connector_geometry)").alias("latitude"),
    )
    .first()
)
focus_longitude = float(focus_connector_row["longitude"])
focus_latitude = float(focus_connector_row["latitude"])
focus_incident_ids = [
    row["id"]
    for row in regional_incidents.where(
        F.col("connector_id") == focus_connector_id
    ).select("id").distinct().collect()
]
focus_direction_rows = (
    regional_incidents.where(
        (F.col("connector_id") == focus_connector_id) & F.col("is_road_6")
    )
    .select(F.col("id").alias("segment_id"))
    .join(F.broadcast(topology_assignments), "segment_id", "inner")
    .select("direction")
    .distinct()
    .collect()
)
if len(focus_direction_rows) != 1:
    raise RuntimeError(
        "The selected connector must resolve to exactly one Road 6 direction; "
        f"found {[row['direction'] for row in focus_direction_rows]}"
    )
focus_direction = focus_direction_rows[0]["direction"]
detail_route_directions = topology_assignments.select(
    F.col("segment_id").alias("road_6_segment_id"), "direction"
)
DETAIL_PADDING_DEGREES = 0.025
detail_envelope = (
    focus_longitude - DETAIL_PADDING_DEGREES,
    focus_latitude - DETAIL_PADDING_DEGREES,
    focus_longitude + DETAIL_PADDING_DEGREES,
    focus_latitude + DETAIL_PADDING_DEGREES,
)
detail_segments = (
    regional_segments.where(
        (F.col("bbox.xmax") >= detail_envelope[0])
        & (F.col("bbox.xmin") <= detail_envelope[2])
        & (F.col("bbox.ymax") >= detail_envelope[1])
        & (F.col("bbox.ymin") <= detail_envelope[3])
        & F.col("class").isin("motorway", "trunk", "primary", "secondary")
    )
    .where(
        F.expr(
            "ST_Intersects(geometry, ST_MakeEnvelope("
            f"{detail_envelope[0]}, {detail_envelope[1]}, "
            f"{detail_envelope[2]}, {detail_envelope[3]}))"
        )
    )
    .select(
        "id",
        "class",
        "subclass",
        F.coalesce("names.primary", F.lit("<unnamed>")).alias("name"),
        F.col("id").isin(focus_incident_ids).alias("connected_to_focus"),
        F.coalesce(
            F.expr(
                "exists(routes, route -> "
                f"route.ref = '{ROAD_6_REF}' AND "
                f"route.wikidata = '{ROAD_6_WIKIDATA}')"
            ),
            F.lit(False),
        ).alias("is_road_6"),
        "geometry",
    )
    .join(
        F.broadcast(detail_route_directions),
        F.col("id") == F.col("road_6_segment_id"),
        "left",
    )
    .drop("road_6_segment_id")
    .withColumn(
        "direction",
        F.coalesce("direction", F.lit("not Road 6")),
    )
    .withColumn(
        "is_focus_direction",
        F.col("is_road_6") & (F.col("direction") == focus_direction),
    )
    .orderBy(
        F.desc("connected_to_focus"),
        F.desc("is_road_6"),
        F.xxhash64("id"),
    )
    .limit(settings.map_feature_limit)
)
display({**focus_interchange.asDict(), "focus_direction": focus_direction})
display(
    regional_incidents.where(F.col("connector_id") == focus_connector_id)
    .select(
        "id", "names.primary", "class", "subclass", "is_road_6", "at"
    )
    .orderBy(F.desc("is_road_6"), "class", "id")
    .toPandas()
)

# %% [markdown]
# ## 13. Large offline static overview
#
# The complete analytical route is retained in Spark. Because the checked Road
# 6 row count is below `MAP_FEATURE_LIMIT`, every selected segment reaches this
# map. If a future release exceeds the cap, each directional component is
# unioned for the overview while detailed maps remain strictly bounded.

# %%
if route_segment_count <= settings.map_feature_limit:
    route_map_df = road_6_ordered.select(
        "id",
        "component_id",
        "direction",
        "route_order",
        F.round("full_length_m", 1).alias("length_m"),
        F.coalesce("names.primary", F.lit("<missing>")).alias("name"),
        F.size("connectors").alias("connector_count"),
        F.expr(
            "concat_ws(', ', transform(filter(routes, route -> "
            f"route.ref = '{ROAD_6_REF}' AND "
            f"route.wikidata = '{ROAD_6_WIKIDATA}'), route -> "
            "coalesce(to_json(route.between), '[0.0,1.0]')))"
        ).alias("route_range"),
        F.concat_ws(
            ", ",
            F.transform(
                "speed_limits",
                lambda rule: F.concat_ws(
                    " ",
                    rule.max_speed.value.cast("string"),
                    rule.max_speed.unit,
                ),
            ),
        ).alias("speed_summary"),
        F.concat_ws(
            ", ",
            F.flatten(F.transform("road_flags", lambda rule: rule.values)),
        ).alias("flag_summary"),
        F.concat_ws(
            ", ", F.transform("sources", lambda rule: rule.record_id)
        ).alias("source_records"),
        "geometry",
    )
    overview_mode = "individual segments"
else:
    route_map_df = (
        road_6_ordered.groupBy("component_id", "direction")
        .agg(
            F.round(F.sum("full_length_m"), 1).alias("length_m"),
            F.sum(F.size("connectors")).alias("connector_count"),
            F.expr("ST_LineMerge(ST_Union_Agg(geometry))").alias("geometry"),
        )
        .select(
            F.concat(F.lit("aggregate-"), "component_id").alias("id"),
            "component_id",
            "direction",
            F.lit(None).cast("int").alias("route_order"),
            "length_m",
            F.lit("Road 6 component overview").alias("name"),
            "connector_count",
            F.lit("aggregated").alias("route_range"),
            F.lit("aggregated").alias("speed_summary"),
            F.lit("aggregated").alias("flag_summary"),
            F.lit("aggregated").alias("source_records"),
            "geometry",
        )
    )
    overview_mode = "component aggregates"

route_map_gdf = collect_geodataframe(
    route_map_df,
    limit=settings.map_feature_limit,
    columns=[
        "id",
        "component_id",
        "direction",
        "route_order",
        "length_m",
        "name",
        "connector_count",
        "route_range",
        "speed_summary",
        "flag_summary",
        "source_records",
        "geometry",
    ],
)
connector_map_df = (
    route_connectors.select(
        "connector_id",
        F.col("connector_geometry").alias("geometry"),
    )
    if unique_connector_count <= settings.map_feature_limit
    else route_connectors.orderBy(F.xxhash64("connector_id")).limit(
        settings.map_feature_limit
    ).select("connector_id", F.col("connector_geometry").alias("geometry"))
)
connector_map_gdf = collect_geodataframe(
    connector_map_df,
    limit=settings.map_feature_limit,
    columns=["connector_id", "geometry"],
)

division_areas = read_type(
    spark, settings, "divisions", "division_area"
)
context_boundary = bbox_overlap(
    division_areas.where(
        (F.col("country") == "IL")
        & (F.col("subtype") == "country")
        & F.col("is_land")
    ),
    (ROAD_6_BOUNDS,),
)
context_gdf = collect_geodataframe(
    context_boundary,
    limit=10,
    columns=["country", "geometry"],
)

direction_palette = {
    "northbound": "#2563eb",
    "southbound": "#dc2626",
}
_, axis = plt.subplots(figsize=(18, 12))
if not context_gdf.empty:
    context_gdf.boundary.plot(
        ax=axis, color="#52525b", linewidth=1.0, zorder=1
    )
for direction, group in route_map_gdf.groupby("direction"):
    group.plot(
        ax=axis,
        color=direction_palette.get(direction, "#7c3aed"),
        linewidth=2.0,
        label=direction,
        zorder=3,
    )
if not connector_map_gdf.empty:
    connector_map_gdf.plot(
        ax=axis,
        color="#111827",
        markersize=7,
        alpha=0.55,
        label="connector",
        zorder=4,
    )
axis.set_title(
    "Road 6 as Overture directional segments and connector points\n"
    f"release {settings.release}; overview mode: {overview_mode}"
)
axis.set_xlabel("longitude")
axis.set_ylabel("latitude")
axis.set_aspect("equal")
axis.legend()
plt.show()

# %% [markdown]
# ## 14. Offline interactive route map
#
# Pan and zoom through the same bounded data. Tooltips expose segment identity,
# component/direction, connector count, speed/flag summaries, and provenance.
# `map_style=None` prevents public tile access; only the optional configured
# internal WMS can add a background.

# %%
map_colours = {
    "northbound": [37, 99, 235, 230],
    "southbound": [220, 38, 38, 230],
}
route_map_gdf["_display_color"] = route_map_gdf["direction"].map(
    lambda value: map_colours.get(value, [124, 58, 237, 230])
)
minx, miny, maxx, maxy = route_map_gdf.total_bounds
span = max(maxx - minx, maxy - miny, 0.01)
initial_zoom = max(5.0, min(12.0, math.log2(360.0 / span) - 1.0))

route_layer = pdk.Layer(
    "GeoJsonLayer",
    route_map_gdf.__geo_interface__,
    pickable=True,
    stroked=True,
    filled=False,
    get_line_color="properties._display_color",
    line_width_min_pixels=3,
)
connector_layer = pdk.Layer(
    "GeoJsonLayer",
    connector_map_gdf.__geo_interface__,
    pickable=True,
    stroked=True,
    filled=True,
    get_fill_color=[17, 24, 39, 190],
    get_line_color=[255, 255, 255, 220],
    get_point_radius=35,
    point_radius_min_pixels=2,
    point_radius_max_pixels=6,
)
overview_layers = []
if not context_gdf.empty:
    overview_layers.append(
        pdk.Layer(
            "GeoJsonLayer",
            context_gdf.__geo_interface__,
            pickable=False,
            stroked=True,
            filled=False,
            get_line_color=[82, 82, 91, 180],
            line_width_min_pixels=1,
        )
    )
overview_layers.extend([route_layer, connector_layer])
overview_deck = build_interactive_deck(
    overview_layers,
    pdk.ViewState(
        longitude=(minx + maxx) / 2.0,
        latitude=(miny + maxy) / 2.0,
        zoom=initial_zoom,
    ),
    wms=settings.wms,
    tooltip={
        "html": (
            "<b>{name}</b><br/>"
            "segment: {id}<br/>direction: {direction}<br/>"
            "order: {route_order}<br/>length: {length_m} m<br/>"
            "route range: {route_range}<br/>"
            "connectors: {connector_count}<br/>speed: {speed_summary}<br/>"
            "flags: {flag_summary}<br/>sources: {source_records}<br/>"
            "connector: {connector_id}"
        )
    },
)
offline_deck_display(overview_deck, height=720)

# %% [markdown]
# ## 15. Interchange close-up: connected is not merely nearby
#
# The thick blue carriageway is the Road 6 directional component containing the
# selected connector. The opposite carriageway is deliberately thinner and
# amber so it remains useful context without competing for attention. Green
# lines are external roads that share the connector; grey lines are merely
# nearby. The red point is the topological evidence.

# %%
detail_gdf = collect_geodataframe(
    detail_segments,
    limit=settings.map_feature_limit,
    columns=[
        "id",
        "class",
        "subclass",
        "name",
        "connected_to_focus",
        "is_road_6",
        "direction",
        "is_focus_direction",
        "geometry",
    ],
)
focus_connector_gdf = collect_geodataframe(
    route_connectors.where(F.col("connector_id") == focus_connector_id).select(
        "connector_id", F.col("connector_geometry").alias("geometry")
    ),
    limit=1,
    columns=["connector_id", "geometry"],
)

def detail_colour(row):
    if row["is_focus_direction"]:
        return [37, 99, 235, 235]
    if row["is_road_6"]:
        return [245, 158, 11, 205]
    if row["connected_to_focus"]:
        return [22, 163, 74, 235]
    return [113, 113, 122, 150]


def detail_width(row):
    if row["is_focus_direction"]:
        return 5.0
    if row["is_road_6"]:
        return 1.5
    if row["connected_to_focus"]:
        return 3.0
    return 1.0


detail_gdf["_display_color"] = detail_gdf.apply(detail_colour, axis=1)
detail_gdf["_display_width"] = detail_gdf.apply(detail_width, axis=1)
_, axis = plt.subplots(figsize=(12, 10))
for label, mask, colour, width in (
    (
        "nearby, no focus connector",
        ~detail_gdf["connected_to_focus"] & ~detail_gdf["is_road_6"],
        "#71717a",
        1.0,
    ),
    (
        "connected external road",
        detail_gdf["connected_to_focus"] & ~detail_gdf["is_road_6"],
        "#16a34a",
        2.5,
    ),
    (
        "Road 6 opposite direction",
        detail_gdf["is_road_6"] & ~detail_gdf["is_focus_direction"],
        "#f59e0b",
        1.4,
    ),
    (
        f"Road 6 {focus_direction}: connector direction",
        detail_gdf["is_focus_direction"],
        "#2563eb",
        4.0,
    ),
):
    subset = detail_gdf[mask]
    if not subset.empty:
        subset.plot(ax=axis, color=colour, linewidth=width, label=label)
focus_connector_gdf.plot(
    ax=axis,
    color="#dc2626",
    edgecolor="#111827",
    markersize=90,
    label="selected shared connector",
    zorder=5,
)
axis.set_title(f"Road 6 connector topology close-up: {focus_connector_id}")
axis.set_xlabel("longitude")
axis.set_ylabel("latitude")
axis.legend()
plt.show()

detail_layer = pdk.Layer(
    "GeoJsonLayer",
    detail_gdf.__geo_interface__,
    pickable=True,
    stroked=True,
    filled=False,
    get_line_color="properties._display_color",
    get_line_width="properties._display_width",
    line_width_units="pixels",
    line_width_min_pixels=1,
)
focus_connector_layer = pdk.Layer(
    "GeoJsonLayer",
    focus_connector_gdf.__geo_interface__,
    pickable=True,
    filled=True,
    stroked=True,
    get_fill_color=[220, 38, 38, 240],
    get_line_color=[17, 24, 39, 255],
    get_point_radius=60,
    point_radius_min_pixels=7,
)
detail_deck = build_interactive_deck(
    [detail_layer, focus_connector_layer],
    pdk.ViewState(
        longitude=focus_longitude,
        latitude=focus_latitude,
        zoom=13.5,
    ),
    wms=settings.wms,
    tooltip={
        "html": (
            "<b>{name}</b><br/>segment: {id}<br/>class: {class}<br/>"
            "Road 6: {is_road_6}<br/>direction: {direction}<br/>"
            "connector direction: {is_focus_direction}<br/>shares connector: "
            "{connected_to_focus}<br/>connector: {connector_id}"
        )
    },
)
offline_deck_display(detail_deck, height=620)

# %% [markdown]
# ## 16. Linear-reference close-up
#
# Each color represents an explicit maximum speed on a presentation slice.
# Square markers locate connector references. The accompanying table carries
# bridge/tunnel flags, level, and access semantics so color is not the only
# encoding. Missing speed remains visibly missing rather than being invented.

# %%
focus_slice_gdf = collect_geodataframe(
    focus_slices,
    limit=settings.map_feature_limit,
    columns=[
        "slice_number",
        "start",
        "end",
        "max_speed_kmh",
        "flags",
        "level",
        "access",
        "geometry",
    ],
)
focus_connector_map_gdf = collect_geodataframe(
    focus_connectors,
    limit=settings.map_feature_limit,
    columns=["connector_id", "at", "geometry"],
)
_, axis = plt.subplots(figsize=(13, 9))
focus_slice_gdf.plot(
    ax=axis,
    column="max_speed_kmh",
    cmap="viridis",
    legend=True,
    linewidth=6,
    missing_kwds={"color": "#a1a1aa", "label": "no explicit speed"},
)
focus_connector_map_gdf.plot(
    ax=axis,
    color="#dc2626",
    marker="s",
    markersize=65,
    label="connector reference",
    zorder=4,
)
for _, row in focus_connector_map_gdf.iterrows():
    axis.annotate(
        f"at={row['at']:.3f}",
        (row.geometry.x, row.geometry.y),
        xytext=(5, 5),
        textcoords="offset points",
    )
axis.set_title(
    "Presentation-only linear-reference slices\n"
    f"segment {focus_segment_id}"
)
axis.set_xlabel("longitude")
axis.set_ylabel("latitude")
axis.legend()
plt.show()

# %% [markdown]
# ## 17. Interpretation and quality boundaries
#
# - Road 6 is selected by route identity, not by name, geometry, or a guessed
#   list of segment IDs.
# - The two main components are separate directional carriageways. Their summed
#   feature length is not the physical corridor length.
# - Shared connector IDs prove topology. A crossing without a shared connector
#   is not a routable transition.
# - `at` and `between` are normalized positions along the oriented geometry.
#   They let connectors and properties change inside a segment without always
#   forcing another source feature split.
# - Missing explicit rules require application-specific defaults. The notebook
#   never treats null as zero, unrestricted, disconnected, or unknown geometry.
# - IDs, counts, components, and attribute coverage are release-specific. This
#   notebook recomputes them and labels every result with the configured release.
#
# A useful data-quality counterexample is Road 90 in this checked release: much
# of its geometry and rules exist, but its Road 90 identity is not consistently
# populated in `routes`. This lesson therefore uses Road 6, whose nested route
# identity is complete enough to demonstrate the intended Overture model without
# an external reference dataset.

# %%
normalized_rules.unpersist()
regional_incidents.unpersist()
route_degrees.unpersist()
route_connectors.unpersist()
segment_connectors.unpersist()
route_scoped.unpersist()
route_rules.unpersist()
road_6_ordered.unpersist()
road_6.unpersist()
regional_segments.unpersist()
spark.stop()
