# %% [markdown]
# # 08 — Cross-theme ETL: places associated with building footprints
#
# **Execution engine:** SedonaSpark.
# **Inputs:** `places/place`, `buildings/building`, and the Ashdod
# `divisions/division_area`.
# **Output model:** one row per place/building spatial association.
#
# This lesson separates a reusable ETL pipeline from presentation. It projects
# only required fields, applies bbox pruning and exact locality filtering, then
# performs a spatial join. A place can match zero, one, or multiple footprints;
# the relationship is derived and must not be presented as an Overture source
# identifier.

# %%
from pyspark.sql import functions as F
from overture_lab.config import load_settings
from overture_lab.outputs import write_derived
from overture_lab.spark import create_sedona, read_type
from overture_lab.regions import resolve_focus_regions, bounded_sample

settings = load_settings()
spark = create_sedona(settings, "08-cross-theme-etl")
regions = resolve_focus_regions(spark, settings)

# %% [markdown]
# ## Read, project, and bound each input
#
# Projection happens before the join so nested contact and cartographic fields
# that are irrelevant to this product do not travel through the shuffle.

# %%
places_raw = read_type(spark, settings, "places", "place").select(
    "id", "names", "categories", "confidence", "sources", "bbox", "geometry"
)
buildings_raw = read_type(spark, settings, "buildings", "building").select(
    "id", "class", "height", "num_floors", "sources", "bbox", "geometry"
)

places = bounded_sample(
    places_raw,
    regions.locality,
    regions.locality_bounds,
    settings.locality_sample_limit,
).alias("p")
buildings = bounded_sample(
    buildings_raw,
    regions.locality,
    regions.locality_bounds,
    settings.locality_sample_limit,
).alias("b")

# %% [markdown]
# ## Spatial association
#
# `ST_Covers` includes a point on the polygon boundary; `ST_Contains` would not.
# The choice is a product rule and is therefore documented here. Sedona plans a
# spatial join rather than a Python loop.

# %%
associated = (
    buildings.join(
        places,
        F.expr("ST_Covers(b.geometry, p.geometry)"),
        "inner",
    )
    .select(
        F.col("p.id").alias("place_id"),
        F.col("p.names.primary").alias("place_name"),
        F.col("p.categories.primary").alias("place_category"),
        F.col("p.confidence").alias("place_confidence"),
        F.col("b.id").alias("building_id"),
        F.col("b.class").alias("building_class"),
        F.col("b.height").alias("building_height"),
        F.col("b.num_floors").alias("building_floors"),
        F.size("p.sources").alias("place_source_items"),
        F.size("b.sources").alias("building_source_items"),
        F.col("p.geometry").alias("geometry"),
    )
)
display(associated.limit(30).toPandas())

# %% [markdown]
# ## Inspect the physical plan
#
# Look for Sedona's spatial-join operator and verify that no accidental Python
# UDF or Cartesian product replaced it.

# %%
associated.explain(mode="formatted")

# %% [markdown]
# ## Quality checks for a derived product

# %%
quality = associated.agg(
    F.count("*").alias("associations"),
    F.countDistinct("place_id").alias("matched_places"),
    F.countDistinct("building_id").alias("matched_buildings"),
    F.sum(F.col("geometry").isNull().cast("int")).alias("null_geometries"),
)
display(quality.toPandas())

# %% [markdown]
# ## Optional write
#
# Writes are off by default so opening a lesson does not mutate project data.
# When enabled, the helper probes the configured derived S3 prefix, writes a
# new run-specific directory, and verifies it by reading the row count back.
# If the probe is denied before a data write begins, it may fall back to the
# bounded `/scratch/derived` area. A started or ambiguous S3 failure never
# triggers a second local write.

# %%
write_result = write_derived(
    associated,
    spark,
    settings,
    dataset_name="ashdod_place_building",
)
write_result.as_dict()
