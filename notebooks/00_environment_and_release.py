# %% [markdown]
# # 00 — Environment and complete release inventory
#
# **Execution engine:** SedonaSpark configures the storage client. Local mode
# reads Parquet footers with PyArrow; S3 mode inventories objects through
# Hadoop S3A without copying the release to the container or Windows host.
#
# This lesson answers three questions before any analysis begins:
#
# 1. Which exact Overture release are we using?
# 2. Which themes and feature types are physically present?
# 3. How large are they in files, compressed bytes, and rows?
#
# S3 inventory lists object metadata and stores only a tiny aggregate JSON in
# scratch. Exact remote row counts are optional because they open every
# feature-type dataset; set `INVENTORY_INCLUDE_ROW_COUNTS=true` when required.

# %%
from overture_lab.config import load_settings
from overture_lab.scratch import scratch_status

settings = load_settings()
{
    "settings": settings.public_dict(),
    "scratch": scratch_status(settings).as_dict(),
}

# %% [markdown]
# ## Start the configured SedonaSpark engine
#
# Spark must exist before an S3A inventory because its Hadoop configuration
# owns the endpoint, credential provider, TLS, and path-style settings. A fresh
# kernel is required after changing driver memory, cores, or S3 settings.

# %%
from overture_lab.spark import create_sedona

spark = create_sedona(settings, "00-environment-and-release")
{
    "spark_version": spark.version,
    "master": spark.sparkContext.master,
    "storage_mode": settings.storage_mode,
    "driver_memory": spark.conf.get("spark.driver.memory"),
    "shuffle_partitions": spark.conf.get("spark.sql.shuffle.partitions"),
    "default_parallelism": spark.sparkContext.defaultParallelism,
}

# %% [markdown]
# ## Inventory the raw immutable release
#
# Overture uses Hive-style directory partitions (`theme=.../type=...`). A
# partition is the first unit to select: do not begin by reading the entire
# 569 GiB tree as one undifferentiated DataFrame.

# %%
from overture_lab.catalog import release_inventory, validate_curriculum_types

inventory = release_inventory(spark, settings)
validate_curriculum_types(inventory)
print(f"Inventory source: {inventory.attrs['source']}")
if inventory.attrs.get("cache_path"):
    print(f"Inventory cache: {inventory.attrs['cache_path']}")
display(inventory)
theme_inventory = (
    inventory.groupby("theme", as_index=False)
    .agg(
        types=("type", "count"),
        files=("files", "sum"),
        compressed_gib=("compressed_gib", "sum"),
    )
    .sort_values("compressed_gib", ascending=False)
)
if inventory["rows"].notna().all():
    row_totals = inventory.groupby("theme", as_index=False)["rows"].sum()
    theme_inventory = theme_inventory.merge(row_totals, on="theme")
display(theme_inventory)

# %% [markdown]
# ## Visualise scale before visualising geography
#
# This chart is deliberately not a map. Choosing the right physical partition
# and understanding cardinality is often more important than drawing features.

# %%
import matplotlib.pyplot as plt

axis = inventory.sort_values("compressed_gib").plot.barh(
    x="type", y="compressed_gib", figsize=(10, 7), legend=False
)
axis.set_title(f"Overture {settings.release}: compressed size by feature type")
axis.set_xlabel("GiB")
plt.tight_layout()

# %% [markdown]
# ## Reading rule used throughout the curriculum
#
# ```text
# choose theme/type → project needed columns → bbox overlap → exact geometry
# predicate → distributed aggregation → explicit bounded collection
# ```
#
# Spark transformations are lazy. `count`, `collect`, `toPandas`, display, and
# writes are actions. Treat every action as an intentional cost boundary.
