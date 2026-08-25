# %% [markdown]
# # 06 — Places theme
#
# **Feature type:** `place`
# **Geometry:** point.
#
# A place represents a real-world entity such as a business, institution,
# landmark, or geographic feature. Categories, confidence, brand, contact
# arrays, addresses, names, status, and provenance are distinct concepts; ETL
# should not flatten them into one untyped label.

# %%
from pyspark.sql import functions as F
from overture_lab.config import load_settings
from overture_lab.spark import create_sedona
from overture_lab.regions import resolve_scale_regions
from overture_lab.lesson import inspect_type

settings = load_settings()
spark = create_sedona(settings, "06-places")
regions = resolve_scale_regions(spark, settings)
places = inspect_type(
    spark,
    settings,
    regions,
    "places",
    "place",
    ["id", "names", "categories", "basic_category", "taxonomy", "confidence", "brand", "addresses", "websites", "phones", "operating_status", "sources", "geometry"],
)
display(places["schema"])

# %% [markdown]
# ## Category model
#
# `categories.primary` is the detailed primary category;
# `categories.alternate` carries alternatives; `basic_category` is a broader
# simplified category; `taxonomy` retains a hierarchy.

# %%
display(
    places["medium"]
    .groupBy("basic_category", "categories.primary")
    .count()
    .orderBy(F.desc("count"))
    .limit(30)
    .toPandas()
)

# %% [markdown]
# ## Inspect nested records without losing arrays

# %%
display(
    places["small"].select(
        "id",
        F.col("names.primary").alias("primary_name"),
        F.element_at("names.common", F.lit("en")).alias("english_name"),
        F.col("categories.primary").alias("primary_category"),
        "basic_category",
        "confidence",
        F.col("brand.names.primary").alias("brand_name"),
        F.element_at("addresses", 1).alias("first_address"),
        F.size("websites").alias("website_count"),
        F.size("phones").alias("phone_count"),
        "operating_status",
    ).limit(25).toPandas()
)

# %% [markdown]
# ## Confidence distribution
#
# Null confidence means “no confidence information,” not zero confidence.

# %%
display(
    places["medium"].select(
        F.when(F.col("confidence").isNull(), "missing")
        .when(F.col("confidence") < 0.5, "below_0.5")
        .when(F.col("confidence") < 0.8, "0.5_to_0.8")
        .otherwise("0.8_to_1.0")
        .alias("confidence_band")
    ).groupBy("confidence_band").count().orderBy("confidence_band").toPandas()
)

# %% [markdown]
# ## Place map by broad category

# %%
from overture_lab.visualize import static_geometry_plot, interactive_geometry_map

mapped, axis = static_geometry_plot(
    places["small"],
    limit=settings.map_feature_limit,
    columns=["basic_category", "confidence", "geometry"],
    column="basic_category",
    title=f"Places in configured cities by category: {settings.small_city_label}",
)

# The renderer is embedded locally. When configured, the browser requests only
# the approved internal WMS; otherwise the background remains blank.
interactive_geometry_map(
    places["small"],
    limit=min(settings.map_feature_limit, 500),
    columns=["basic_category", "confidence", "geometry"],
    wms=settings.wms,
)
