# %% [markdown]
# # 07 — Transportation theme
#
# **Feature types:** `segment`, `connector`.
#
# Segments carry linear geometry and rules. Connectors are point nodes used to
# express connectivity and positions along segments. An H3 or other spatial
# cell can accelerate search, but it does not replace connector topology.

# %%
from pyspark.sql import functions as F
from overture_lab.config import load_settings
from overture_lab.spark import create_sedona
from overture_lab.regions import resolve_focus_regions
from overture_lab.lesson import inspect_type

settings = load_settings()
spark = create_sedona(settings, "07-transportation")
regions = resolve_focus_regions(spark, settings)

segments = inspect_type(
    spark,
    settings,
    regions,
    "transportation",
    "segment",
    ["id", "names", "subtype", "class", "subclass", "connectors", "road_surface", "road_flags", "access_restrictions", "speed_limits", "routes", "sources", "geometry"],
)
connectors = inspect_type(
    spark,
    settings,
    regions,
    "transportation",
    "connector",
    ["id", "sources", "geometry"],
)
display(segments["schema"])
display(connectors["schema"])

# %% [markdown]
# ## Segment types and classes

# %%
display(
    segments["country"]
    .groupBy("subtype", "class", "subclass")
    .count()
    .orderBy(F.desc("count"))
    .limit(30)
    .toPandas()
)

# %% [markdown]
# ## Linear referencing with `between`
#
# Many attributes are arrays of rules. `between` describes the portion of the
# normalised segment length to which a value applies. Exploding a rule without
# retaining `between` destroys where that rule applies.

# %%
display(
    segments["locality"].select(
        "id",
        "class",
        F.explode_outer("road_surface").alias("surface_rule"),
    ).select(
        "id",
        "class",
        F.col("surface_rule.value").alias("surface"),
        F.col("surface_rule.between").alias("between"),
    ).limit(30).toPandas()
)

# %% [markdown]
# ## Connector references define graph structure
#
# `at` is a normalised position along the segment. Endpoints are usually at 0
# or 1, while intermediate connectors can represent intersections or topology
# changes.

# %%
segment_connectors = segments["locality"].select(
    "id",
    F.posexplode_outer("connectors").alias("connector_order", "connector"),
).select(
    F.col("id").alias("segment_id"),
    "connector_order",
    F.col("connector.connector_id").alias("connector_id"),
    F.col("connector.at").alias("at"),
)
display(segment_connectors.limit(30).toPandas())

# %% [markdown]
# ## Connector presence in the bounded sample
#
# This left join is intentionally diagnostic. A missing match can simply mean
# the independently capped connector sample did not retain that node.

# %%
display(
    segment_connectors.alias("sc")
    .join(connectors["locality"].select("id").alias("c"), F.col("sc.connector_id") == F.col("c.id"), "left")
    .select("segment_id", "connector_order", "connector_id", "at", F.col("c.id").isNotNull().alias("connector_in_sample"))
    .limit(30)
    .toPandas()
)

# %% [markdown]
# ## Transportation map

# %%
from overture_lab.visualize import static_geometry_plot

mapped, axis = static_geometry_plot(
    segments["locality"],
    limit=settings.map_feature_limit,
    columns=["class", "subtype", "geometry"],
    column="class",
    title=f"Transportation segments intersecting {settings.locality_name_en}",
)
