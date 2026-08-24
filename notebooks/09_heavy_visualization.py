# %% [markdown]
# # 09 — Visualising heavy spatial data safely
#
# **Execution engine:** SedonaSpark for reduction; GeoPandas/Matplotlib or
# pydeck only after a strict collection cap.
#
# A browser is not a distributed spatial engine. “Visualise all buildings” is
# therefore reformulated into products appropriate to scale:
#
# 1. exact tabular aggregates;
# 2. deterministic spatial bins or density rasters;
# 3. simplified geometry by display scale;
# 4. bounded feature inspection;
# 5. pre-generated vector tiles for very large interactive products.

# %%
from pyspark.sql import functions as F
from overture_lab.config import load_settings
from overture_lab.spark import create_sedona, read_type
from overture_lab.regions import resolve_scale_regions, bbox_overlap, exact_intersection

settings = load_settings()
spark = create_sedona(settings, "09-heavy-visualization")
regions = resolve_scale_regions(spark, settings)

raw = read_type(spark, settings, "buildings", "building")
candidates = bbox_overlap(raw, regions.small_bounds)
small_buildings = exact_intersection(candidates, regions.small).limit(
    settings.small_sample_limit
)

# %% [markdown]
# ## The unsafe boundary
#
# Never call `raw.toPandas()` or send an unbounded DataFrame to a map wrapper.
# Collection belongs in a helper whose limit is visible in code review.

# %%
{
    "raw_input": settings.type_uri("buildings", "building"),
    "small_sample_cap": settings.small_sample_limit,
    "map_feature_cap": settings.map_feature_limit,
    "small_bboxes": [item.as_dict() for item in regions.small_bounds],
}

# %% [markdown]
# ## Strategy 1: distributed summaries
#
# This bar chart transfers only one row per class, not one row per building.

# %%
class_counts = (
    small_buildings.groupBy(F.coalesce("class", F.lit("<missing>")).alias("class"))
    .count()
    .orderBy(F.desc("count"))
)
class_pdf = class_counts.toPandas()
display(class_pdf)
class_pdf.head(20).sort_values("count").plot.barh(
    x="class", y="count", figsize=(9, 6), legend=False, title="Building classes in configured small sample"
)

# %% [markdown]
# ## Strategy 2: aggregate to display cells
#
# For a pedagogical city map, a 0.005-degree grid is sufficient to demonstrate
# reduction. Production tiling should use a projected grid, H3/S2 where its
# semantics fit, or the target vector-tile pyramid. Bbox centres are used here
# because they are cheap and already present in Parquet.

# %%
CELL_DEGREES = 0.005
gridded = (
    small_buildings.select(
        F.floor(((F.col("bbox.xmin") + F.col("bbox.xmax")) / 2) / CELL_DEGREES).alias("cell_x"),
        F.floor(((F.col("bbox.ymin") + F.col("bbox.ymax")) / 2) / CELL_DEGREES).alias("cell_y"),
    )
    .groupBy("cell_x", "cell_y")
    .count()
    .select(
        "count",
        F.expr(
            f"ST_MakeEnvelope(cell_x * {CELL_DEGREES}, cell_y * {CELL_DEGREES}, "
            f"(cell_x + 1) * {CELL_DEGREES}, (cell_y + 1) * {CELL_DEGREES})"
        ).alias("geometry"),
    )
)
display(gridded.orderBy(F.desc("count")).limit(20).toPandas())

# %% [markdown]
# ## Strategy 3: simplified individual geometry
#
# Simplification tolerance is a display-scale decision. Keep the original
# geometry for analysis and write a separate visual derivative.

# %%
simplified = small_buildings.select(
    "id",
    "class",
    F.expr("ST_SimplifyPreserveTopology(geometry, 0.00005)").alias("geometry"),
)

# %% [markdown]
# ## Compare cell density and bounded footprints
#
# Both renderers are offline. The grid may contain far fewer rows than the raw
# footprint set while communicating city-scale density more effectively.

# %%
from overture_lab.visualize import static_geometry_plot

grid_map, grid_axis = static_geometry_plot(
    gridded,
    limit=settings.map_feature_limit,
    columns=["count", "geometry"],
    column="count",
    title=f"Building density in configured cities: {settings.small_city_label}",
)

footprint_map, footprint_axis = static_geometry_plot(
    simplified,
    limit=settings.map_feature_limit,
    columns=["class", "geometry"],
    column="class",
    title=f"Simplified building sample: {settings.small_city_label}",
)

# %% [markdown]
# ## Choosing the product
#
# | Need | Appropriate representation |
# |---|---|
# | Verify individual records | Small bounded geometry sample |
# | Compare category totals | Distributed aggregate + chart |
# | See national density | Grid/H3/S2 aggregate or raster |
# | Pan/zoom through millions | Pre-generated vector tiles/PMTiles |
# | Perform exact analysis | Original GeoParquet in Sedona |
#
# The visual derivative is allowed to simplify or aggregate only when its
# manifest states how it differs from the analytical source.
