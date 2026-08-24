# %% [markdown]
# # 03 — Base theme
#
# **Feature types:** `bathymetry`, `infrastructure`, `land`, `land_cover`,
# `land_use`, and `water`.
#
# “Base” is a family of cartographic and physical-world layers, not one uniform
# entity table. Geometry, subtype vocabulary, density, and useful attributes
# differ by feature type. ETL should retain `feature_type` when combining them.

# %%
from functools import reduce
from pyspark.sql import functions as F
from overture_lab.config import load_settings
from overture_lab.spark import create_sedona
from overture_lab.regions import resolve_scale_regions
from overture_lab.lesson import inspect_type

settings = load_settings()
spark = create_sedona(settings, "03-base")
regions = resolve_scale_regions(spark, settings)

BASE_TYPES = [
    "bathymetry",
    "infrastructure",
    "land",
    "land_cover",
    "land_use",
    "water",
]
lessons = {
    feature_type: inspect_type(
        spark,
        settings,
        regions,
        "base",
        feature_type,
        ["id", "names", "subtype", "class", "level", "cartography", "depth", "surface", "is_intermittent", "is_salt", "sources", "geometry"],
    )
    for feature_type in BASE_TYPES
}

# %% [markdown]
# ## Compare the six schemas
#
# Shared column names do not imply identical semantics. Bathymetry carries
# depth; water carries intermittent/salt flags; land-cover uses a compact
# subtype plus cartographic hints; land, land-use, and infrastructure have
# richer names/classes.

# %%
for feature_type, item in lessons.items():
    print(f"\n### base/{feature_type}")
    display(item["schema"])

# %% [markdown]
# ## Which types intersect the configured small areas?
#
# A zero is a valid result for this scope—bathymetry, for example, need not
# intersect the configured land areas. Each count is capped at
# `SMALL_SAMPLE_LIMIT` and
# therefore reads “rows retained in the teaching sample,” not total rows.

# %%
sample_summary = []
for feature_type, item in lessons.items():
    sample_summary.append(
        {
            "type": feature_type,
            "sample_rows": item["small"].count(),
            "geometry_types": [
                row.geometry_type
                for row in item["small"]
                .select(F.expr("ST_GeometryType(geometry)").alias("geometry_type"))
                .distinct()
                .collect()
            ],
        }
    )
display(spark.createDataFrame(sample_summary).toPandas())

# %% [markdown]
# ## Subtype/class distributions

# %%
for feature_type, item in lessons.items():
    group_columns = [name for name in ["subtype", "class"] if name in item["raw"].columns]
    if group_columns:
        print(f"\n### {feature_type}")
        display(
            item["medium"].groupBy(*group_columns).count().orderBy(F.desc("count")).limit(15).toPandas()
        )

# %% [markdown]
# ## Combined map with type retained
#
# We harmonise only the fields needed for this visual product. This is a
# projection for display, not a replacement for the six source schemas.

# %%
map_frames = []
for feature_type, item in lessons.items():
    map_frames.append(
        item["small"].select(
            F.lit(feature_type).alias("base_type"),
            F.col("subtype") if "subtype" in item["raw"].columns else F.lit(None).cast("string").alias("subtype"),
            "geometry",
        )
    )
combined = reduce(lambda left, right: left.unionByName(right), map_frames)

from overture_lab.visualize import static_geometry_plot

mapped, axis = static_geometry_plot(
    combined,
    limit=settings.map_feature_limit,
    columns=["base_type", "subtype", "geometry"],
    column="base_type",
    title=f"Base-theme features in configured cities: {settings.small_city_label}",
)
