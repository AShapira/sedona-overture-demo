# %% [markdown]
# # 10 — Standalone regional SedonaSpark road clipping
#
# **Execution engine:** SedonaSpark.
# **Inputs:** raw `divisions/division_area` and `transportation/segment`
# GeoParquet from the configured Overture release.
# **Outputs:** exactly one `roads.geoparquet` object and one `roads.csv` object
# below a unique derived S3 run prefix when writing is enabled.
#
# This lesson is independent of earlier notebook outputs. It clips broad
# drivable road classes to the union of the land-country areas named by
# `MEDIUM_STATE_CODES`. The configured codes are source-data identifiers, not
# geopolitical assertions.

# %%
import math
import time

from pyspark import StorageLevel
from pyspark.sql import Window
from pyspark.sql import functions as F

from overture_lab.config import load_settings
from overture_lab.outputs import write_single_file_exports
from overture_lab.regions import Bounds, bbox_overlap
from overture_lab.spark import create_sedona, read_type

settings = load_settings()
spark = create_sedona(settings, "10-standalone-regional-road-clipping")

ROAD_CLASSES = (
    "motorway",
    "trunk",
    "primary",
    "secondary",
    "tertiary",
    "unclassified",
    "residential",
    "living_street",
    "service",
    "track",
)
metrics: list[dict[str, int | float | str]] = []


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
        "medium_state_codes": list(settings.medium_state_codes),
        "road_classes": list(ROAD_CLASSES),
        "local_cores": settings.local_cores,
        "driver_memory": settings.driver_memory,
        "shuffle_partitions": settings.shuffle_partitions,
        "map_feature_limit": settings.map_feature_limit,
        "write_derived": settings.write_derived,
        "derived_output_uri": settings.derived_output_uri,
    }
)

# %% [markdown]
# ## 1. Resolve and union the configured country boundaries
#
# The notebook reads the immutable division-area source directly. Every
# configured state code must resolve to at least one land-country area. Keeping
# the individual source bboxes permits Parquet-friendly pruning before the
# exact union-boundary operation.

# %%
started = time.perf_counter()
division_areas = read_type(
    spark, settings, "divisions", "division_area"
)
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
    selected_regions.agg(
        F.expr("ST_Union_Agg(geometry)").alias("boundary_geometry")
    )
    .persist(StorageLevel.MEMORY_AND_DISK)
)
if boundary.count() != 1:
    raise RuntimeError("The configured union boundary must contain one row")
boundary_summary = boundary.selectExpr(
    "ST_XMin(boundary_geometry) AS xmin",
    "ST_YMin(boundary_geometry) AS ymin",
    "ST_XMax(boundary_geometry) AS xmax",
    "ST_YMax(boundary_geometry) AS ymax",
).first().asDict()
record_metric("boundary selection and union", selected_region_count, started)
display(
    {
        "resolved_codes": sorted(actual_codes),
        "source_boundary_rows": selected_region_count,
        "boundary_bounds": boundary_summary,
    }
)

# %% [markdown]
# ## 2. Prune the global transportation scan
#
# Projection and road-class filtering happen before the spatial work. Four
# scalar bbox-overlap comparisons are ORed across the configured country-area
# bboxes. These comparisons remove obvious global misses but do not replace an
# exact geometry predicate.

# %%
started = time.perf_counter()
segments = read_type(
    spark, settings, "transportation", "segment"
).select("id", "class", "subtype", "bbox", "geometry")
candidates = (
    bbox_overlap(
        segments.where(
            (F.col("subtype") == "road")
            & F.col("class").isin(*ROAD_CLASSES)
        ),
        region_bounds,
    )
    .repartition(settings.shuffle_partitions)
    .persist(StorageLevel.MEMORY_AND_DISK)
)
candidate_count = candidates.count()
record_metric("bbox filtering and repartitioning", candidate_count, started)
display({"bbox_candidates": candidate_count})

# %% [markdown]
# ## 3. Clip exactly and expand line components
#
# The single union boundary is broadcast to every task. `ST_Intersects`
# rejects bbox false positives and `ST_Intersection` clips crossing segments.
# Intersection may create collections or multipart lines, so line components
# are extracted and dumped to one valid LineString per output row.

# %%
started = time.perf_counter()
clipped = (
    candidates.crossJoin(F.broadcast(boundary))
    .where(F.expr("ST_Intersects(geometry, boundary_geometry)"))
    .select(
        F.col("id").alias("source_segment_id"),
        F.col("class").alias("road_class"),
        F.expr(
            "ST_CollectionExtract("
            "ST_Intersection(geometry, boundary_geometry), 2)"
        ).alias("clipped_geometry"),
    )
)
roads = (
    clipped.selectExpr(
        "source_segment_id",
        "road_class",
        "posexplode(ST_Dump(clipped_geometry)) "
        "AS (part_number, geometry)",
    )
    .where(
        "geometry IS NOT NULL "
        "AND NOT ST_IsEmpty(geometry) "
        "AND ST_IsValid(geometry) "
        "AND GeometryType(geometry) = 'LINESTRING' "
        "AND ST_Length(geometry) > 0"
    )
    .select(
        F.concat_ws(
            "#", F.col("source_segment_id"), F.col("part_number")
        ).alias("road_id"),
        "source_segment_id",
        "road_class",
        F.expr("ST_SetSRID(geometry, 4326)").alias("geometry"),
    )
    .persist(StorageLevel.MEMORY_AND_DISK)
)
road_count = roads.count()
record_metric("exact clipping and LineString expansion", road_count, started)
candidates.unpersist()

quality = roads.agg(
    F.count("*").alias("rows"),
    F.countDistinct("road_id").alias("distinct_road_ids"),
    F.sum(
        F.when(
            F.expr(
                "geometry IS NULL "
                "OR ST_IsEmpty(geometry) "
                "OR NOT ST_IsValid(geometry) "
                "OR GeometryType(geometry) <> 'LINESTRING' "
                "OR ST_Length(geometry) <= 0 "
                "OR ST_SRID(geometry) <> 4326"
            ),
            1,
        ).otherwise(0)
    ).alias("invalid_rows"),
).first()
if quality.rows != quality.distinct_road_ids:
    raise RuntimeError("Clipped road_id values are not unique")
if int(quality.invalid_rows or 0) != 0:
    raise RuntimeError(
        f"Clipping validation found {quality.invalid_rows} invalid rows"
    )
display(quality.asDict())

# %% [markdown]
# ## 4. Optionally write exactly two named S3 objects
#
# `WRITE_DERIVED=false` keeps this cell read-only. When enabled, the writer
# probes `DERIVED_OUTPUT_URI`, creates a unique run, serialises only the final
# output stage, promotes Spark's part files to `roads.geoparquet` and
# `roads.csv`, removes staging metadata, and reads both objects back. The CSV
# represents geometry as quoted WKT. A denied probe or partial write never
# falls back to local storage.

# %%
started = time.perf_counter()
export_result = write_single_file_exports(
    roads,
    spark,
    settings,
    dataset_name="clipped_roads",
)
if export_result.status == "written":
    record_metric("single-file S3 exports", road_count, started)
display(export_result.as_dict())

# %% [markdown]
# ## 5. Prepare a bounded, geographically distributed display sample
#
# A browser is not a distributed spatial engine. Each 0.1-degree display cell
# and road class contributes at most one hash-selected representative. A final
# deterministic hash ordering enforces `MAP_FEATURE_LIMIT`. Simplification is
# applied only to this visual derivative; analytical and exported geometries
# remain unchanged.

# %%
DISPLAY_CELL_DEGREES = 0.1
cell_representatives = (
    roads.select(
        "road_id",
        "source_segment_id",
        "road_class",
        "geometry",
        F.floor(
            (
                F.expr("ST_XMin(geometry)")
                + F.expr("ST_XMax(geometry)")
            )
            / (2 * DISPLAY_CELL_DEGREES)
        ).alias("cell_x"),
        F.floor(
            (
                F.expr("ST_YMin(geometry)")
                + F.expr("ST_YMax(geometry)")
            )
            / (2 * DISPLAY_CELL_DEGREES)
        ).alias("cell_y"),
    )
    .withColumn(
        "cell_rank",
        F.row_number().over(
            Window.partitionBy("cell_x", "cell_y", "road_class").orderBy(
                F.xxhash64("road_id")
            )
        ),
    )
    .where(F.col("cell_rank") == 1)
)
map_roads = (
    cell_representatives.orderBy(
        F.xxhash64("cell_x", "cell_y", "road_class")
    )
    .limit(settings.map_feature_limit)
    .select(
        "road_id",
        "source_segment_id",
        "road_class",
        F.expr(
            "ST_SimplifyPreserveTopology(geometry, 0.00005)"
        ).alias("geometry"),
    )
)

from overture_lab.visualize import collect_geodataframe

map_gdf = collect_geodataframe(
    map_roads,
    limit=settings.map_feature_limit,
    columns=["road_id", "source_segment_id", "road_class", "geometry"],
)
boundary_gdf = collect_geodataframe(
    boundary.select(
        F.col("boundary_geometry").alias("geometry")
    ),
    limit=1,
    columns=["geometry"],
)
display(
    {
        "map_rows": len(map_gdf),
        "map_cap": settings.map_feature_limit,
        "display_cell_degrees": DISPLAY_CELL_DEGREES,
    }
)

# %% [markdown]
# ## 6. Large offline static map

# The 18×12-inch figure is suitable for notebook inspection or local export.
# It uses no remote basemap and clearly labels the bounded representative
# sample rather than implying that every clipped feature reached the browser.

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
    axis.text(0.5, 0.5, "No roads in configured scope", ha="center")
else:
    map_gdf.plot(
        ax=axis,
        column="road_class",
        categorical=True,
        legend=True,
        linewidth=0.7,
        alpha=0.85,
        zorder=3,
    )
axis.set_title(
    "Configured regional roads — deterministic bounded display sample\n"
    f"{settings.medium_state_label}; at most "
    f"{settings.map_feature_limit:,} clipped LineStrings"
)
axis.set_xlabel("longitude")
axis.set_ylabel("latitude")
axis.set_aspect("equal")
plt.show()

# %% [markdown]
# ## 7. Offline interactive map
#
# The same bounded sample is rendered with pan, zoom, class colours, and
# tooltips. The initial zoom is derived from the configured boundary extent;
# `map_style=None` prevents network basemap requests.

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
    [188, 189, 34, 220],
    [23, 190, 207, 220],
)
class_colors = {
    name: list(palette[index % len(palette)])
    for index, name in enumerate(sorted(map_gdf["road_class"].unique()))
}
map_gdf["_display_color"] = map_gdf["road_class"].map(class_colors)
minx, miny, maxx, maxy = boundary_gdf.total_bounds
span = max(maxx - minx, maxy - miny, 0.01)
initial_zoom = max(2.0, min(12.0, math.log2(360.0 / span) - 1.0))

road_layer = pdk.Layer(
    "GeoJsonLayer",
    map_gdf.__geo_interface__,
    pickable=True,
    stroked=True,
    filled=False,
    get_line_color="properties._display_color",
    line_width_min_pixels=1,
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
deck = pdk.Deck(
    layers=[boundary_layer, road_layer],
    initial_view_state=pdk.ViewState(
        longitude=(minx + maxx) / 2,
        latitude=(miny + maxy) / 2,
        zoom=initial_zoom,
    ),
    tooltip={
        "html": (
            "<b>{road_class}</b><br/>"
            "road: {road_id}<br/>source: {source_segment_id}"
        )
    },
    map_style=None,
)
display(deck)

# %% [markdown]
# ## Performance summary
#
# These action timings depend on the selected region, release, resources, S3
# implementation, and object sizes. The two single-file exports are expected
# to be slower than normal parallel Spark output because each final format is
# intentionally reduced to one object.

# %%
spark.createDataFrame(metrics).orderBy("sequence").select(
    "step", "rows", "seconds"
).show(truncate=False)

roads.unpersist()
boundary.unpersist()
selected_regions.unpersist()
spark.stop()
