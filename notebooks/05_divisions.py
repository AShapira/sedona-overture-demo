# %% [markdown]
# # 05 — Divisions theme
#
# **Feature types:** `division`, `division_area`, `division_boundary`.
#
# These are complementary representations:
#
# - `division` is a labelled point/entity with hierarchy and population fields.
# - `division_area` is a polygon linked by `division_id`.
# - `division_boundary` is a line shared by one or more `division_ids`.
#
# Administrative, territorial, maritime, and perspective fields must be
# retained. Do not silently reduce every boundary to one supposedly universal
# political view.

# %%
from pyspark.sql import functions as F
from overture_lab.config import load_settings
from overture_lab.spark import create_sedona, read_type
from overture_lab.regions import resolve_scale_regions, bbox_overlap, exact_intersection
from overture_lab.catalog import schema_table

settings = load_settings()
spark = create_sedona(settings, "05-divisions")
regions = resolve_scale_regions(spark, settings)

division = read_type(spark, settings, "divisions", "division")
area = read_type(spark, settings, "divisions", "division_area")
boundary = read_type(spark, settings, "divisions", "division_boundary")
display(schema_table(division))
display(schema_table(area))
display(schema_table(boundary))

# %% [markdown]
# ## Data-driven scale resolution
#
# The code resolves every configured city by exact English common name and
# state code, then loads its authoritative land `division_area`. This avoids
# hand-drawn rectangles and makes the chosen source semantics inspectable.

# %%
display(
    regions.small.select(
        "id",
        "division_id",
        F.col("names.primary").alias("primary_name"),
        F.element_at("names.common", F.lit("en")).alias("english_name"),
        "bbox",
        F.expr("ST_GeometryType(geometry)").alias("geometry_type"),
    ).toPandas()
)
{
    "medium_bounds": [item.as_dict() for item in regions.medium_bounds],
    "small_bounds": [item.as_dict() for item in regions.small_bounds],
    "small_division_ids": regions.small_division_ids,
}

# %% [markdown]
# ## Entity, area, and hierarchy

# %%
small_entities = division.where(F.col("id").isin(*regions.small_division_ids))
display(
    small_entities.select(
        "id",
        "country",
        "subtype",
        "class",
        "admin_level",
        F.col("names.primary").alias("primary_name"),
        F.element_at("names.common", F.lit("en")).alias("english_name"),
        "parent_division_id",
        "hierarchies",
        "population",
        "version",
    ).toPandas()
)

# %% [markdown]
# ## Boundaries intersecting configured small areas
#
# Bbox overlap prunes row groups; `ST_Intersects` supplies exact geometry
# semantics. Boundary rows can reference more than one division.

# %%
small_boundaries = exact_intersection(
    bbox_overlap(boundary, regions.small_bounds), regions.small
).limit(settings.small_sample_limit)
display(
    small_boundaries.select(
        "id",
        "division_ids",
        "subtype",
        "class",
        "is_disputed",
        "is_land",
        "is_territorial",
        "perspectives",
    ).limit(25).toPandas()
)

# %% [markdown]
# ## Area and boundary map
#
# First map the authoritative area object used by all other lessons; then add
# intersecting boundary lines as a separate layer if desired.

# %%
from overture_lab.visualize import static_geometry_plot

mapped, axis = static_geometry_plot(
    regions.small,
    limit=settings.map_feature_limit,
    columns=["division_id", "geometry"],
    title=f"Configured small division areas: {settings.small_city_label}",
)
