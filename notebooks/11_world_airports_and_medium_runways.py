# %% [markdown]
# # 11 — Worldwide airports and configured-region runways
#
# **Execution engine:** SedonaSpark.
# **Inputs:** raw `base/infrastructure` and `divisions/division_area`
# GeoParquet from the configured Overture release.
# **Outputs:** one named GeoParquet object for all worldwide airport-scale
# infrastructure features and
# one named GeoParquet object for complete runway geometries intersecting the
# land-country areas in `MEDIUM_STATE_CODES`, when writing is enabled.
#
# The worldwide airport predicate selects airport-scale infrastructure classes
# and deliberately excludes related components such as terminals, runways,
# taxiways, aprons, gates, heliports, and airstrips.

# %%
import math
import time

from pyspark import StorageLevel
from pyspark.sql import functions as F

from overture_lab.config import load_settings
from overture_lab.outputs import write_single_geoparquet
from overture_lab.regions import Bounds, bbox_overlap, exact_intersection
from overture_lab.spark import create_sedona, read_type

settings = load_settings()
spark = create_sedona(settings, "11-world-airports-and-medium-runways")
metrics: list[dict[str, int | float | str]] = []
AIRPORT_CLASSES = (
    "airport",
    "international_airport",
    "regional_airport",
    "municipal_airport",
    "military_airport",
    "private_airport",
    "seaplane_airport",
)


def record_metric(step: str, rows: int, started: float) -> None:
    metrics.append(
        {
            "sequence": len(metrics) + 1,
            "step": step,
            "rows": int(rows),
            "seconds": round(time.perf_counter() - started, 3),
        }
    )


display(
    {
        "release": settings.release,
        "release_uri": settings.release_uri,
        "airport_predicate": (
            f"subtype = 'airport' AND class IN {AIRPORT_CLASSES}"
        ),
        "runway_predicate": "subtype = 'airport' AND class = 'runway'",
        "medium_state_codes": list(settings.medium_state_codes),
        "map_feature_limit": settings.map_feature_limit,
        "write_derived": settings.write_derived,
        "derived_output_uri": settings.derived_output_uri,
    }
)

# %% [markdown]
# ## 1. Select every worldwide airport-scale feature
#
# The Infrastructure class allowlist represents complete airports rather than
# related Places or component infrastructure. The result keeps the complete
# source schema, including names, source provenance and tags, class, subtype,
# surface, feature version, source bbox, and the helper theme/type columns
# added by this lab.

# %%
started = time.perf_counter()
infrastructure = read_type(spark, settings, "base", "infrastructure")
airports = (
    infrastructure.where(
        (F.col("subtype") == "airport")
        & F.col("class").isin(*AIRPORT_CLASSES)
    )
    .select(
        *[
            F.expr("ST_SetSRID(geometry, 4326)").alias("geometry")
            if column == "geometry"
            else F.col(column)
            for column in infrastructure.columns
        ]
    )
    .persist(StorageLevel.MEMORY_AND_DISK)
)
airport_quality = airports.agg(
    F.count("*").alias("airport_rows"),
    F.countDistinct("id").alias("distinct_airport_ids"),
    F.sum(
        F.when(
            F.expr(
                "geometry IS NULL "
                "OR ST_IsEmpty(geometry) "
                "OR NOT ST_IsValid(geometry) "
                "OR ST_SRID(geometry) <> 4326"
            ),
            1,
        ).otherwise(0)
    ).alias("invalid_geometry_rows"),
).first()
airport_count = int(airport_quality.airport_rows)
if airport_count != int(airport_quality.distinct_airport_ids):
    raise RuntimeError("Worldwide airport infrastructure IDs are not unique")
if int(airport_quality.invalid_geometry_rows or 0) != 0:
    raise RuntimeError(
        "Worldwide airport selection contains "
        f"{airport_quality.invalid_geometry_rows} invalid geometries"
    )
record_metric("worldwide airport selection", airport_count, started)
display(airport_quality.asDict())
display({"retained_columns": airports.columns})

# %% [markdown]
# ## 2. Summarise classes, names, and geometry
#
# The tables below validate that only complete-airport classes remain and
# expose name coverage and geometry types without narrowing the export.

# %%
airports.groupBy("class").agg(
    F.count("*").alias("airports")
).orderBy(F.desc("airports"), "class").show(30, truncate=False)

airports.select(
    F.when(F.col("names.primary").isNull(), "unnamed")
    .otherwise("named")
    .alias("name_status")
).groupBy("name_status").agg(
    F.count("*").alias("airports")
).orderBy("name_status").show(truncate=False)

airports.groupBy(F.expr("GeometryType(geometry)").alias("geometry_type")).agg(
    F.count("*").alias("airports")
).orderBy(F.desc("airports"), "geometry_type").show(truncate=False)

# %% [markdown]
# ## 3. Optionally export one worldwide-airports GeoParquet object
#
# With `WRITE_DERIVED=false`, this is a no-write dry run. When enabled,
# `DERIVED_OUTPUT_URI` is mandatory. The helper creates a unique run prefix,
# writes one Zstandard GeoParquet 1.1 object named `airports.geoparquet`, and
# validates the full schema, row count, geometry/SRID, bbox covering metadata,
# and exact one-object inventory. There is no local fallback.

# %%
started = time.perf_counter()
airport_export = write_single_geoparquet(
    airports,
    spark,
    settings,
    dataset_name="world_airports",
    object_name="airports.geoparquet",
)
if airport_export.status == "written":
    record_metric("worldwide airport GeoParquet export", airport_count, started)
display(airport_export.as_dict())

# %% [markdown]
# ## 4. Resolve the configured medium-region boundary
#
# Every configured code must match at least one land-country division area.
# Individual source bboxes support Parquet-friendly infrastructure pruning;
# their union is used only for display.

# %%
started = time.perf_counter()
division_areas = read_type(spark, settings, "divisions", "division_area")
selected_regions = (
    division_areas.where(
        F.col("country").isin(*settings.medium_state_codes)
        & (F.col("subtype") == "country")
        & F.col("is_land")
    )
    .select(
        "country",
        "bbox",
        F.expr("ST_SetSRID(geometry, 4326)").alias("geometry"),
    )
    .persist(StorageLevel.MEMORY_AND_DISK)
)
selected_region_count = selected_regions.count()
actual_codes = {
    row.country
    for row in selected_regions.select("country").distinct().collect()
}
missing_codes = set(settings.medium_state_codes) - actual_codes
if missing_codes:
    raise RuntimeError(
        "No land-country division area found for configured codes: "
        f"{sorted(missing_codes)}"
    )
region_bounds = tuple(
    Bounds(row.xmin, row.ymin, row.xmax, row.ymax)
    for row in selected_regions.select(
        "bbox.xmin", "bbox.ymin", "bbox.xmax", "bbox.ymax"
    ).collect()
)
boundary = (
    selected_regions.agg(F.expr("ST_Union_Agg(geometry)").alias("geometry"))
    .persist(StorageLevel.MEMORY_AND_DISK)
)
boundary_summary = boundary.selectExpr(
    "ST_XMin(geometry) AS xmin",
    "ST_YMin(geometry) AS ymin",
    "ST_XMax(geometry) AS xmax",
    "ST_YMax(geometry) AS ymax",
).first().asDict()
record_metric("configured boundary selection", selected_region_count, started)
display(
    {
        "resolved_codes": sorted(actual_codes),
        "source_boundary_rows": selected_region_count,
        "boundary_bounds": boundary_summary,
    }
)

# %% [markdown]
# ## 5. Find all airport runways intersecting the configured region
#
# The infrastructure scan first applies the semantic runway predicate and
# scalar bbox overlap. A broadcast exact left-semi spatial join then removes
# bbox false positives without duplicating features that intersect more than
# one configured boundary. Unlike the road-clipping lesson, runway geometries
# are retained whole: a runway is selected by intersection, not clipped.

# %%
started = time.perf_counter()
runway_candidates = bbox_overlap(
    infrastructure.where(
        (F.col("subtype") == "airport") & (F.col("class") == "runway")
    ),
    region_bounds,
).repartition(settings.shuffle_partitions)
runways = (
    exact_intersection(runway_candidates, selected_regions)
    .select(
        *[
            F.expr("ST_SetSRID(geometry, 4326)").alias("geometry")
            if column == "geometry"
            else F.col(column)
            for column in infrastructure.columns
        ]
    )
    .persist(StorageLevel.MEMORY_AND_DISK)
)
runway_quality = runways.agg(
    F.count("*").alias("runway_rows"),
    F.countDistinct("id").alias("distinct_runway_ids"),
    F.sum(
        F.when(
            F.expr(
                "geometry IS NULL "
                "OR ST_IsEmpty(geometry) "
                "OR NOT ST_IsValid(geometry) "
                "OR ST_SRID(geometry) <> 4326"
            ),
            1,
        ).otherwise(0)
    ).alias("invalid_geometry_rows"),
).first()
runway_count = int(runway_quality.runway_rows)
if runway_count != int(runway_quality.distinct_runway_ids):
    raise RuntimeError("Configured-region runway IDs are not unique")
if int(runway_quality.invalid_geometry_rows or 0) != 0:
    raise RuntimeError(
        "Configured-region runway selection contains "
        f"{runway_quality.invalid_geometry_rows} invalid geometries"
    )
record_metric("bbox and exact runway selection", runway_count, started)
display(runway_quality.asDict())
display({"retained_columns": runways.columns})

runways.groupBy(
    F.expr("GeometryType(geometry)").alias("geometry_type"),
    F.coalesce(F.col("surface"), F.lit("<missing>")).alias("surface"),
).agg(F.count("*").alias("runways")).orderBy(
    "geometry_type", F.desc("runways"), "surface"
).show(100, truncate=False)

# %% [markdown]
# ## 6. Optionally export one configured-region runway GeoParquet object
#
# The complete, un-clipped infrastructure rows are written to one named object
# under a different unique dataset run. The same strict S3-only verification
# contract used for airports applies here.

# %%
started = time.perf_counter()
runway_export = write_single_geoparquet(
    runways,
    spark,
    settings,
    dataset_name="medium_state_runways",
    object_name="runways.geoparquet",
)
if runway_export.status == "written":
    record_metric("configured runway GeoParquet export", runway_count, started)
display(runway_export.as_dict())

# %% [markdown]
# ## 7. Prepare a deterministic, bounded runway map frame
#
# The export always contains the full regional result. Only the driver/browser
# visualization is hash-sampled to `MAP_FEATURE_LIMIT`. The selected geometry
# is not simplified or clipped, preserving the distinction between analytical
# output and display limits.

# %%
map_runways = (
    runways.orderBy(F.xxhash64("id"))
    .limit(settings.map_feature_limit)
    .select(
        "id",
        F.coalesce(F.col("names.primary"), F.lit("<unnamed>")).alias("name"),
        F.coalesce(F.col("surface"), F.lit("<missing>")).alias("surface"),
        F.expr("GeometryType(geometry)").alias("geometry_type"),
        "geometry",
    )
)

from overture_lab.visualize import (
    build_interactive_deck,
    collect_geodataframe,
    offline_deck_display,
)

map_gdf = collect_geodataframe(
    map_runways,
    limit=settings.map_feature_limit,
    columns=["id", "name", "surface", "geometry_type", "geometry"],
)
boundary_gdf = collect_geodataframe(
    boundary,
    limit=1,
    columns=["geometry"],
)
display(
    {
        "full_runway_rows": runway_count,
        "map_rows": len(map_gdf),
        "map_cap": settings.map_feature_limit,
    }
)

# %% [markdown]
# ## 8. Large offline static runway map
#
# The 18×12-inch Matplotlib view uses no remote tiles. Runways are styled by
# their reported surface while the configured boundary provides context.

# %%
import matplotlib.pyplot as plt

_, axis = plt.subplots(figsize=(18, 12))
boundary_gdf.boundary.plot(
    ax=axis,
    color="#111827",
    linewidth=1.5,
    zorder=2,
)
if map_gdf.empty:
    axis.text(0.5, 0.5, "No runways in configured scope", ha="center")
else:
    map_gdf.plot(
        ax=axis,
        column="surface",
        categorical=True,
        legend=True,
        linewidth=2.2,
        alpha=0.85,
        zorder=3,
    )
axis.set_title(
    "Airport runways intersecting the configured medium region\n"
    f"{settings.medium_state_label}; full result {runway_count:,}, "
    f"displayed at most {settings.map_feature_limit:,}"
)
axis.set_xlabel("longitude")
axis.set_ylabel("latitude")
axis.set_aspect("equal")
plt.show()

# %% [markdown]
# ## 9. Offline interactive runway map
#
# The same bounded frame supports pan, zoom, mixed line/polygon geometry,
# surface styling, and tooltips. Regional extent determines the initial zoom;
# The deck.gl renderer is embedded locally. The only optional network source is
# the configured internal WMS background.

# %%
import pydeck as pdk

palette = (
    [31, 119, 180, 220],
    [255, 127, 14, 220],
    [44, 160, 44, 220],
    [214, 39, 40, 220],
    [148, 103, 189, 220],
    [140, 86, 75, 220],
    [227, 119, 194, 220],
    [127, 127, 127, 220],
)
surface_colors = {
    surface: list(palette[index % len(palette)])
    for index, surface in enumerate(sorted(map_gdf["surface"].unique()))
}
map_gdf["_display_color"] = map_gdf["surface"].map(surface_colors)
minx, miny, maxx, maxy = boundary_gdf.total_bounds
span = max(maxx - minx, maxy - miny, 0.01)
initial_zoom = max(2.0, min(13.0, math.log2(360.0 / span) - 1.0))

runway_layer = pdk.Layer(
    "GeoJsonLayer",
    map_gdf.__geo_interface__,
    pickable=True,
    stroked=True,
    filled=True,
    get_line_color="properties._display_color",
    get_fill_color="properties._display_color",
    line_width_min_pixels=2,
    opacity=0.65,
)
boundary_layer = pdk.Layer(
    "GeoJsonLayer",
    boundary_gdf.__geo_interface__,
    pickable=False,
    stroked=True,
    filled=False,
    get_line_color=[17, 24, 39, 240],
    line_width_min_pixels=2,
)
deck = build_interactive_deck(
    [boundary_layer, runway_layer],
    pdk.ViewState(
        longitude=(minx + maxx) / 2,
        latitude=(miny + maxy) / 2,
        zoom=initial_zoom,
    ),
    wms=settings.wms,
    tooltip={
        "html": (
            "<b>{name}</b><br/>runway: {id}<br/>"
            "surface: {surface}<br/>geometry: {geometry_type}"
        )
    },
)
offline_deck_display(deck)

# %% [markdown]
# ## Performance summary
#
# Counts and summaries are distributed Spark actions. Each enabled single-file
# export intentionally introduces one serial final stage; map collection stays
# deterministically bounded.

# %%
spark.createDataFrame(metrics).orderBy("sequence").select(
    "step", "rows", "seconds"
).show(truncate=False)

airports.unpersist()
runways.unpersist()
boundary.unpersist()
selected_regions.unpersist()
spark.stop()
