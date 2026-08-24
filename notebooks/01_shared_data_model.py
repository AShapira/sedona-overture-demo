# %% [markdown]
# # 01 — Shared Overture data model
#
# **Execution engine:** SedonaSpark SQL and Python DataFrame API.
#
# Themes have different domain fields, but most Overture features share a core:
# `id`, `geometry`, `bbox`, `sources`, and `version`; many also have `names`.
# This notebook uses Places as a compact example and filters in two stages:
# configured medium sample, then an exact configured small sample.

# %%
from pyspark.sql import functions as F
from overture_lab.config import load_settings
from overture_lab.spark import create_sedona
from overture_lab.regions import resolve_scale_regions
from overture_lab.lesson import inspect_type

settings = load_settings()
spark = create_sedona(settings, "01-shared-data-model")
regions = resolve_scale_regions(spark, settings)
{
    "medium_bounds": [item.as_dict() for item in regions.medium_bounds],
    "small_bounds": [item.as_dict() for item in regions.small_bounds],
    "small_division_ids": regions.small_division_ids,
}

# %% [markdown]
# ## Physical and logical schema
#
# `geometry` is GeoParquet geometry, `bbox` is a plain nested struct useful for
# Parquet predicate pushdown, and `sources` is an array of provenance records.
# The bbox is an accelerator; exact spatial truth still comes from geometry.

# %%
lesson = inspect_type(
    spark,
    settings,
    regions,
    "places",
    "place",
    ["id", "names", "categories", "confidence", "sources", "version", "geometry"],
)
display(lesson["schema"])

# %% [markdown]
# ## Nested names and scalar projections
#
# SQL is particularly readable for selecting nested values. `names.primary`
# is not guaranteed to be English; `element_at(names.common, 'en')` asks for a
# specific language without discarding the rest of the multilingual object.

# %%
lesson["small"].createOrReplaceTempView("small_places_shared")
display(
    spark.sql(
        """
        SELECT
          id,
          names.primary AS primary_name,
          element_at(names.common, 'en') AS english_name,
          categories.primary AS category,
          confidence,
          size(sources) AS source_items,
          version,
          ST_GeometryType(geometry) AS geometry_type
        FROM small_places_shared
        LIMIT 20
        """
    ).toPandas()
)

# %% [markdown]
# ## Provenance is property-aware
#
# A source item with an empty `property` applies at feature level. A value such
# as `/properties/height` attributes only that property. For provenance
# analysis, `(dataset, property)` is the meaningful identity; license and
# record metadata describe that identity rather than replacing it.

# %%
source_summary = (
    lesson["medium"]
    .select(F.explode_outer("sources").alias("source"))
    .groupBy("source.dataset", "source.property", "source.license")
    .count()
    .orderBy(F.desc("count"))
    .limit(25)
)
display(source_summary.toPandas())

# %% [markdown]
# ## Geometry types and a bounded offline map
#
# A map is a driver/browser operation. Only the small sample, capped again by
# `MAP_FEATURE_LIMIT`, crosses that boundary. The static renderer makes no
# network request and therefore behaves the same in the air gap.

# %%
display(
    lesson["medium"]
    .groupBy(F.expr("ST_GeometryType(geometry)").alias("geometry_type"))
    .count()
    .toPandas()
)

from overture_lab.visualize import static_geometry_plot

mapped, axis = static_geometry_plot(
    lesson["small"],
    limit=settings.map_feature_limit,
    columns=["id", "basic_category", "geometry"],
    column="basic_category",
    title=f"Places in configured cities: {settings.small_city_label}",
)
