# %% [markdown]
# # 02 — Addresses theme
#
# **Feature type:** `address`
# **Geometry:** point
# **Execution engine:** SedonaSpark SQL and Python.
#
# Address records model a location plus structured address components. Coverage
# is not uniform globally, so missing rows or fields must not be interpreted as
# proof that real-world addresses do not exist.

# %%
from pyspark.sql import functions as F
from overture_lab.config import load_settings
from overture_lab.spark import create_sedona
from overture_lab.regions import resolve_scale_regions
from overture_lab.lesson import inspect_type

settings = load_settings()
spark = create_sedona(settings, "02-addresses")
regions = resolve_scale_regions(spark, settings)
lesson = inspect_type(
    spark,
    settings,
    regions,
    "addresses",
    "address",
    ["id", "street", "number", "unit", "postcode", "postal_city", "address_levels", "country", "sources", "geometry"],
)
display(lesson["schema"])

# %% [markdown]
# ## Structured address components
#
# Keep individual components during ETL. Concatenating them too early loses the
# distinction between street, unit, postcode, postal city, and higher address
# levels.

# %%
lesson["small"].createOrReplaceTempView("small_addresses")
display(
    spark.sql(
        """
        SELECT id, street, number, unit, postcode, postal_city, country,
               transform(address_levels, x -> x.value) AS higher_levels,
               size(sources) AS source_items,
               ST_X(geometry) AS longitude,
               ST_Y(geometry) AS latitude
        FROM small_addresses
        LIMIT 25
        """
    ).toPandas()
)

# %% [markdown]
# ## Completeness is measured per field
#
# This is a profile of the configured medium sample, not a global or
# statistically representative quality score.

# %%
profile = lesson["medium"].agg(
    F.count("*").alias("sample_rows"),
    F.count("street").alias("with_street"),
    F.count("number").alias("with_number"),
    F.count("postcode").alias("with_postcode"),
    F.count("postal_city").alias("with_postal_city"),
    F.countDistinct("country").alias("countries_in_sample"),
)
display(profile.toPandas())

# %% [markdown]
# ## Source contribution

# %%
display(
    lesson["medium"]
    .select(F.explode_outer("sources").alias("source"))
    .groupBy("source.dataset")
    .count()
    .orderBy(F.desc("count"))
    .toPandas()
)

# %% [markdown]
# ## Address point map
#
# Points are collected only after exact intersection with the configured
# small areas and an explicit map cap.

# %%
from overture_lab.visualize import static_geometry_plot

mapped, axis = static_geometry_plot(
    lesson["small"],
    limit=settings.map_feature_limit,
    columns=["postcode", "geometry"],
    column="postcode",
    title=f"Address points in configured cities: {settings.small_city_label}",
)
