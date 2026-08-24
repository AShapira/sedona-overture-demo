# %% [markdown]
# # 04 — Buildings theme
#
# **Feature types:** `building`, `building_part`.
#
# A building is the overall footprint/entity. A building part represents a
# component and references its parent through `building_id`. Physical fields
# such as height or floor count are optional observations, not guaranteed
# measurements.

# %%
from pyspark.sql import functions as F
from overture_lab.config import load_settings
from overture_lab.spark import create_sedona
from overture_lab.regions import resolve_scale_regions
from overture_lab.lesson import inspect_type

settings = load_settings()
spark = create_sedona(settings, "04-buildings")
regions = resolve_scale_regions(spark, settings)

buildings = inspect_type(
    spark,
    settings,
    regions,
    "buildings",
    "building",
    ["id", "names", "subtype", "class", "height", "num_floors", "has_parts", "sources", "geometry"],
)
parts = inspect_type(
    spark,
    settings,
    regions,
    "buildings",
    "building_part",
    ["id", "building_id", "height", "num_floors", "sources", "geometry"],
)
display(buildings["schema"])
display(parts["schema"])

# %% [markdown]
# ## Attribute availability
#
# The percentages below describe only the configured medium teaching sample.
# Missing height does not mean zero height; missing floors does not mean a
# single-storey building.

# %%
display(
    buildings["medium"].agg(
        F.count("*").alias("sample_rows"),
        F.count("height").alias("with_height"),
        F.count("num_floors").alias("with_floor_count"),
        F.sum(F.col("has_parts").cast("int")).alias("marked_has_parts"),
        F.countDistinct("class").alias("distinct_classes"),
    ).toPandas()
)

# %% [markdown]
# ## Common building classes and heights

# %%
display(
    buildings["medium"]
    .groupBy("class")
    .agg(F.count("*").alias("rows"), F.expr("percentile_approx(height, 0.5)").alias("median_height"))
    .orderBy(F.desc("rows"))
    .limit(20)
    .toPandas()
)

# %% [markdown]
# ## Building-part relationship
#
# The join is an identifier join, not a spatial guess. Capped samples can omit
# a parent or child, so unmatched rows here do not imply broken source data.

# %%
part_relationships = (
    parts["small"].alias("p")
    .join(
        buildings["small"].select("id", "has_parts").alias("b"),
        F.col("p.building_id") == F.col("b.id"),
        "left",
    )
    .select(
        F.col("p.id").alias("part_id"),
        "p.building_id",
        F.col("b.id").alias("parent_in_sample"),
        "p.height",
        "p.num_floors",
    )
    .limit(25)
)
display(part_relationships.toPandas())

# %% [markdown]
# ## Configured small-area footprints
#
# Polygon rendering is capped. For citywide or national display, use the
# aggregation and simplification patterns in notebook 09 rather than raising
# the browser limit indefinitely.

# %%
from overture_lab.visualize import static_geometry_plot

mapped, axis = static_geometry_plot(
    buildings["small"],
    limit=settings.map_feature_limit,
    columns=["class", "height", "geometry"],
    column="class",
    title=f"Building footprints in configured cities: {settings.small_city_label}",
)
