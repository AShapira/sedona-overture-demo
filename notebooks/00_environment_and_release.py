# %% [markdown]
# # 00 — Environment and complete release inventory
#
# **Execution engine:** Python/PyArrow reads Parquet footers for the inventory;
# SedonaSpark is started only for the runtime check.
#
# This lesson answers three questions before any analysis begins:
#
# 1. Which exact Overture release are we using?
# 2. Which themes and feature types are physically present?
# 3. How large are they in files, compressed bytes, and rows?
#
# Footer metadata is substantially cheaper than scanning feature columns. For
# S3, create the same manifest during ingestion rather than opening hundreds of
# remote footers every time a notebook starts.

# %%
from overture_lab.config import load_settings

settings = load_settings()
settings.public_dict()

# %% [markdown]
# ## Inventory the raw immutable release
#
# Overture uses Hive-style directory partitions (`theme=.../type=...`). A
# partition is the first unit to select: do not begin by reading the entire
# 569 GiB tree as one undifferentiated DataFrame.

# %%
from overture_lab.catalog import local_release_inventory

inventory = local_release_inventory(settings.release_uri)
display(inventory)
display(
    inventory.groupby("theme", as_index=False)
    .agg(types=("type", "count"), files=("files", "sum"), rows=("rows", "sum"), compressed_gib=("compressed_gib", "sum"))
    .sort_values("compressed_gib", ascending=False)
)

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
# ## Start the configured SedonaSpark engine
#
# The lab uses local Spark inside the container. CPU, memory, shuffle
# partitions, and scratch storage all come from environment variables. A fresh
# kernel is required after changing driver memory or core count.

# %%
from overture_lab.spark import create_sedona

spark = create_sedona(settings, "00-environment-and-release")
{
    "spark_version": spark.version,
    "master": spark.sparkContext.master,
    "driver_memory": spark.conf.get("spark.driver.memory"),
    "shuffle_partitions": spark.conf.get("spark.sql.shuffle.partitions"),
    "default_parallelism": spark.sparkContext.defaultParallelism,
}

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
