# %% [markdown]
# # 17 — Reconstructing major roads
#
# A road is not a single Overture segment. This lesson contracts the complete
# **medium-region motorway, trunk, and primary graph** into connected
# carriageways, preserving source vertices and excluding interchange links.
# Road 6 is the acceptance example: one northbound and one southbound road.
#
# This is an analytical/cartographic derivative. Detailed speeds, lanes,
# surfaces, access, and turn restrictions are not retained in the roads table;
# it must not be used as a routing network or as proof a road is open to traffic.
# The separate membership table preserves source IDs, intervals and order.
#
# References: [connectors](https://docs.overturemaps.org/guides/transportation/segments-and-connectors/),
# [WGS84 linear references](https://docs.overturemaps.org/guides/transportation/linear-referencing/),
# [ordered rules](https://docs.overturemaps.org/guides/transportation/scoping-and-travel-modes/).

# %%
import json
import math
import os
from pathlib import Path

import pandas as pd
import pydeck as pdk
from pyspark import StorageLevel
from pyspark.sql import functions as F

from overture_lab.config import load_settings
from overture_lab.outputs import write_single_geoparquet
from overture_lab.regions import Bounds, bbox_overlap, select_country_areas
from overture_lab.road_reconstruction import ReconstructionLimits, reconstruct_major_roads
from overture_lab.spark import create_sedona, read_type
from overture_lab.visualize import build_interactive_deck, collect_geodataframe, offline_deck_display

REGION_PRESET = "medium"
INCLUDE_TERRITORIAL_WATERS = True
WRITE_ROADS = False  # Explicit opt-in; validation enables a local export.
VERIFY_DETERMINISM = True
GRAPH_LIMITS = ReconstructionLimits(segments=200_000, connector_references=1_000_000,
                                    vertices=2_000_000, pieces=400_000)
settings = load_settings(region_preset=REGION_PRESET,
                         include_territorial_waters=INCLUDE_TERRITORIAL_WATERS)
spark = create_sedona(settings, "17-reconstructing-major-roads")
display({"release": settings.release, "region_preset": REGION_PRESET,
         "country_codes": settings.region_state_codes,
         "extent": settings.region_extent_label, "sampling": "none",
         "graph_limits": GRAPH_LIMITS.__dict__, "map_feature_limit": settings.map_feature_limit})

# %% [markdown]
# ## 1. Select full source segments, then reconstruct
#
# Bounding boxes prune the scan; exact country-area intersections select the
# complete input. Whole intersecting segments are retained, so some endpoints
# lie outside the selected region. Such roads are flagged `region_limited`;
# we do not follow them indefinitely outside the region or claim national-route
# completeness. The graph limits fail explicitly rather than silently sampling.
#
# Connector positions and partial route, subclass, and heading rules produce
# internal pieces. Connector cuts use exact source vertices; other necessary
# cuts use WGS84 interpolation along the original edge. No original shape
# vertices are simplified. Only duplicated joining endpoints are removed.
#
# Identities use Wikidata, network/ref, country-scoped ref, then normalized
# primary names. Concurrent route memberships stay on one physical feature;
# a membership-set change stops merging. Unnamed roads continue only through
# unambiguous nodes of the same class. Equal coordinates alone never connect.

# %%
areas = select_country_areas(read_type(spark, settings, "divisions", "division_area"),
    settings.region_state_codes, include_territorial_waters=INCLUDE_TERRITORIAL_WATERS)
segments = read_type(spark, settings, "transportation", "segment")
connectors = read_type(spark, settings, "transportation", "connector")
reconstruction = reconstruct_major_roads(spark, segments, connectors, areas,
    release=settings.release, limits=GRAPH_LIMITS, verify_determinism=VERIFY_DETERMINISM)
roads = reconstruction.roads.persist(StorageLevel.MEMORY_AND_DISK)
membership = reconstruction.membership.persist(StorageLevel.MEMORY_AND_DISK)
diagnostics = reconstruction.diagnostics.persist(StorageLevel.MEMORY_AND_DISK)
display(reconstruction.summary)
display(roads.groupBy("road_class", "identity_basis", "direction").agg(
    F.count("*").alias("roads"), F.round(F.sum("length_m") / 1000, 3).alias("km")
).orderBy("road_class", "identity_basis", "direction").toPandas())
display(diagnostics.groupBy("kind").count().orderBy(F.desc("count")).toPandas())

# %% [markdown]
# ## 2. What does direction mean?
#
# Forward/backward restriction headings refer to source geometry, not compass
# directions. Ordered, applicable motor-car heading rules orient one-way pieces.
# No heading restriction means **assumed bidirectional**, retained as one road.
# Conditional or contradictory direction is `unknown` and does not merge.
# Other restrictions (including closures) are not evidence of one-way travel.
# Unscoped conditional access such as height limits or private access is dropped
# with the detailed road rules; it does not fragment a physical carriageway.
# Unconditional blanket overrides do participate in ordered heading evaluation.
#
# Compass labels describe the overall endpoint bearing, not every local bend.
# Closed chains are labelled `loop`; source traffic-direction evidence remains
# available in membership. At branches we stop rather than guess a straight
# continuation. Thus a named real-world road may legitimately have many outputs.

# %%
display(membership.groupBy("direction_status").count().orderBy("direction_status").toPandas())
display(membership.orderBy("road_id", "piece_order").limit(12).toPandas())

# %% [markdown]
# ## 3. Road 6: the exact two-carriageway acceptance case
#
# Select by the route's Wikidata identity. For release `2026-07-22.0`, removing
# its one link leaves 63 northbound source segments (193.255 km) and 60 southbound
# source segments (194.204 km). Internal connectors do not fragment either
# main carriageway. Counts are source segments, not the temporary atomic pieces.

# %%
road6 = roads.where(F.array_contains("route_ids", "wikidata:Q595131"))
road6_report = road6.select("road_id", "direction", "source_segment_count", "length_m").orderBy("direction").toPandas()
display(road6_report)
reference_region = {"IL", "XW", "XG", "XH", "XZ", "LB", "SY", "JO"}
if settings.release == "2026-07-22.0" and reference_region.issubset(settings.region_state_codes):
    expected = {"northbound": (63, 193255.06070634), "southbound": (60, 194203.96705024)}
    assert len(road6_report) == 2, "Road 6 must reconstruct to exactly two carriageways"
    for row in road6_report.itertuples():
        count, length = expected[row.direction]
        assert row.source_segment_count == count
        assert abs(row.length_m - length) < 0.01
    assert road6.where("ST_GeometryType(geometry) <> 'ST_LineString'").count() == 0
    reconstruction.summary["road6_acceptance_passed"] = True
else:
    display({"road6_acceptance": "Reference-release assertions apply only when the complete reference region is selected."})

# %% [markdown]
# ## 4. Before and after, with the same source shape
#
# The first map shows each retained Road 6 source segment in a different color;
# the second shows just the two reconstructed carriageways. Zoom in to inspect
# the parallel lines using the **carriageway detail** button. The reconstructed
# map also has separate northbound/southbound toggles. Rendering is offline and
# preserves full coordinates.

# %%
PALETTE = [[27, 158, 119], [217, 95, 2], [117, 112, 179], [231, 41, 138],
           [65, 105, 225], [230, 171, 2], [166, 118, 29], [0, 130, 170]]


def road_map(frame, *, layer_id, title, limit, zoom=None, source_total=None,
             detail_focus=None, direction_layers=False):
    """Explicitly bounded display only; reconstruction and export stay complete."""
    total = frame.count() if source_total is None else source_total
    mapped = collect_geodataframe(frame.orderBy("road_id"), limit=limit,
        columns=["road_id", "name", "direction", "length_m", "geometry"])
    if mapped.empty:
        display({"map": title, "shown": 0, "total": total})
        return
    mapped["color"] = [PALETTE[i % len(PALETTE)] for i in range(len(mapped))]
    mapped["name"] = mapped["name"].fillna("Unnamed carriageway")
    mapped["length_km"] = (mapped.length_m / 1000).round(3)
    minx, miny, maxx, maxy = mapped.total_bounds
    center = ((minx + maxx) / 2, (miny + maxy) / 2)
    span = max(maxx - minx, (maxy - miny) * 1.4, 0.01)
    view = pdk.ViewState(longitude=center[0], latitude=center[1],
                         zoom=zoom if zoom is not None else max(3, min(14, math.log2(360 / span) - 1.1)))
    layers, groups = [], []
    categories = list(mapped.direction.unique()) if direction_layers else [None]
    for category in categories:
        subset = mapped[mapped.direction == category] if category else mapped
        identifier = f"{layer_id}-{category}" if category else layer_id
        layers.append(pdk.Layer("GeoJsonLayer", subset.__geo_interface__,
            id=identifier, pickable=True, auto_highlight=True, get_line_color="properties.color",
            line_width_min_pixels=2.5))
        groups.append({"id": identifier, "label": category or title,
                       "layer_ids": [identifier], "color": subset.iloc[0]["color"]})
    controls = None
    if detail_focus:
        x, y = detail_focus
        controls = {"groups": groups, "cities": [], "views": {
            "whole road": [[float(minx), float(miny)], [float(maxx), float(maxy)]],
            "carriageway detail": [[x-0.015, y-0.015], [x+0.015, y+0.015]]},
            "description": "Compare the source segments with the two reconstructed directions; use the same detail view on both maps."}
    deck = build_interactive_deck(layers, view,
        tooltip={"text": "{name}\n{road_id}\n{direction}\n{length_km} km"})
    display({"map": title, "shown": len(mapped), "total": total, "display_limited": len(mapped) < total})
    display(offline_deck_display(deck, height=650, controls=controls,
        attribution=f"Overture Maps — {settings.release}; {title}; analytical derivative"))


road6_ids = membership.join(road6.select("road_id"), "road_id").select(
    F.col("source_segment_id").alias("id")).distinct()
# Prune the repeated source scan using the reconstructed route's actual bounds.
road6_bounds = road6.agg(*[
    (F.min(F.expr(f"ST_{axis}Min(geometry)")) if end == "min" else F.max(F.expr(f"ST_{axis}Max(geometry)"))).alias(axis.lower() + end)
    for axis in ("X", "Y") for end in ("min", "max")
]).first()
road6_source = bbox_overlap(segments, Bounds(road6_bounds.xmin, road6_bounds.ymin,
    road6_bounds.xmax, road6_bounds.ymax)) if road6_bounds.xmin is not None else segments.where("false")
road6_before = road6_source.join(F.broadcast(road6_ids), "id").select(
    F.col("id").alias("road_id"), F.col("names.primary").alias("name"),
    F.lit("source segment").alias("direction"),
    F.expr("ST_LengthSpheroid(geometry)").alias("length_m"), "geometry")
focus_frame = collect_geodataframe(road6.orderBy("direction"), limit=2, columns=["road_id", "geometry"])
focus_coordinates = list(focus_frame.geometry.iloc[0].coords) if not focus_frame.empty else []
road6_focus = focus_coordinates[len(focus_coordinates)//2] if focus_coordinates else None
road_map(road6_before, layer_id="road6-before", title="Road 6 source segments", limit=5000,
         detail_focus=road6_focus)
road_map(road6, layer_id="road6-after", title="Road 6 reconstructed carriageways", limit=5000,
         detail_focus=road6_focus, direction_layers=True)

# %% [markdown]
# ## 5. Medium-region overview and cases that remain separate
#
# The overview displays the longest reconstructed roads, up to the configured
# map feature limit. The shown/total counts make display truncation explicit.
# Statistics, membership, diagnostics, and export always include the full graph.
# Route metadata is sparse in this release: many roads are named chains or
# unnamed topology chains, not an identified national route.

# %%
display({"retained_segments": reconstruction.summary["retained_source_segments"],
         "reconstructed_roads": reconstruction.summary["reconstructed_roads"],
         "reduction_percent": round(100 * (1 - reconstruction.summary["reconstructed_roads"] /
                                          reconstruction.summary["retained_source_segments"]), 2)})
overview = roads.orderBy(F.desc("length_m"), "road_id").limit(settings.map_feature_limit)
display({"overview_total_roads": reconstruction.summary["reconstructed_roads"],
         "overview_display_limit": settings.map_feature_limit})
road_map(overview, layer_id="regional-reconstruction", title="Longest medium-region carriageways",
         limit=settings.map_feature_limit, source_total=reconstruction.summary["reconstructed_roads"])
for kind in ("ambiguous_branch", "unresolved_direction", "region_limited"):
    display(diagnostics.where(F.col("kind") == kind).orderBy("source_segment_id", "road_id").limit(8).toPandas())
display(roads.where("identity_basis = 'topology'").orderBy(F.desc("length_m"), "road_id").limit(8).toPandas().drop(columns="geometry"))

# %% [markdown]
# ## 6. Optional verified GeoParquet export
#
# `WRITE_ROADS=False` by default. To export, set it to True and configure the
# existing `WRITE_DERIVED=true` and `DERIVED_OUTPUT_MODE` settings. Local runs
# use the configured persistent scratch destination; S3 uses a runtime-provided
# destination. The writer creates a unique run prefix, verifies read-back and
# GeoParquet 1.1 metadata, and generates fresh `geometry_bbox` covering values.
# The roads table contains basic fields only; membership and diagnostics remain
# separate analytical tables. Keep Overture attribution with downstream uses.

# %%
road_export = {"status": "dry-run", "detail": "Set WRITE_ROADS=True and configure WRITE_DERIVED to export."}
if WRITE_ROADS:
    road_export = write_single_geoparquet(roads, spark, settings,
        dataset_name="reconstructed-major-roads", object_name="reconstructed_major_roads.geoparquet").as_dict()
display(road_export)

# A validation run can retain the three-table evidence without changing sources.
evidence_dir = os.getenv("ROAD_RECONSTRUCTION_EVIDENCE_DIR")
if evidence_dir:
    evidence = Path(evidence_dir)
    evidence.mkdir(parents=True, exist_ok=True)
    (evidence / "reconstruction-summary.json").write_text(json.dumps(
        dict(reconstruction.summary, road6=road6_report.to_dict(orient="records"), export=road_export), indent=2))
    membership.write.mode("errorifexists").parquet(str(evidence / "membership.parquet"))
    diagnostics.write.mode("errorifexists").parquet(str(evidence / "diagnostics.parquet"))

roads.unpersist()
membership.unpersist()
diagnostics.unpersist()
