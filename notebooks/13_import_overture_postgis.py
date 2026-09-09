# %% [markdown]
# # 13 — Import a small Overture region into existing PostGIS
#
# **Engine:** Apache Sedona 1.9.0 / Spark. **Destination:** an existing database
# with PostGIS enabled. This notebook and the console script share the same
# importer. No query-agent, DuckDB, database provisioner, or LLM is needed.
#
# The workflow reads GeoParquet, keeps whole intersecting features, prepares a
# checksummed normalized snapshot, then bulk-loads it in one database transaction.
# Follow `docs/import-overture-postgis.md` to prepare the offline client image
# and a connection file. Paths below are paths **inside the lab container**.

# %%
from pathlib import Path
from overture_lab.config import load_settings
from overture_lab.spark import create_sedona
from overture_lab.postgis_import import prepare, verify_snapshot, load, verify

settings = load_settings()
spark = create_sedona(settings, "13-import-overture-postgis")

# %% [markdown]
# ## Choose a deliberately small region
#
# Coordinates are west, south, east, north in longitude/latitude order. This
# example covers part of Rishon LeZion. Change it to match your supplied source.
# The schema version must match the release; its label is recorded alongside
# the inspected physical Parquet schemas. It is not an automatic schema upgrade.
#
# The guard checks the full selection and refuses more than 10,000 features.
# It never silently truncates the import. Narrow the bbox or types if necessary.
# Production imports use the CLI without this teaching guard.

# %%
BBOX = [34.76, 31.96, 34.80, 32.00]
TYPES = ["places/place", "buildings/building"]
SCHEMA_VERSION = "v1.18.0"
DATASET = Path(settings.scratch_dir) / "postgis-small-v1"
CONNECTIONS = Path("/workspace/.artifacts/postgis-connections.json")
ENABLE_DATABASE_WRITES = False
MAX_FEATURES = 10_000

# %% [markdown]
# ## Prepare and explain the normalized snapshot
#
# Sedona applies the source bbox filter and exact intersection. It retains the
# complete source geometry, including portions outside the region. Names,
# addresses, categories, and references become child tables joined on both
# `(relation,id)`; ordinal columns preserve repeated values and their order.
# `raw_json` retains source non-geometry fields as text.
#
# Geometry stays in EPSG:4326. Each valid, nonempty feature within UTM's latitude
# limits (-80 to 84 degrees) gets a WGS84 UTM projection selected from a point on
# its surface. `geometry_m_srid` identifies that feature's zone and hemisphere.
# Transformers are cached in each Spark worker and PROJ networking is disabled.
#
# A bbox can span several zones: features keep their own SRIDs. A feature crossing
# a zone boundary or the equator is projected whole and flagged with
# `utm_crosses_zone=True`. Nothing is split or duplicated. Large crossing features
# may have substantial planar distortion; use geography for distance queries.
# Polar, invalid, empty, or unprojectable features retain their WGS84 geometry;
# `geometry_m` is null and `metric_status` explains why. Centroids are not entrances.
#
# If `divisions/division` is selected, all its records remain available;
# out-of-region references have `reference_only=true` and count toward the guard.
# This example selects only places and buildings, so other feature types are absent.
#
# Use a fresh dataset path for every preparation. A valid final manifest marks
# completion; an interrupted directory must not be resumed or treated as a snapshot.

# %%
manifest = prepare(spark, settings, DATASET, BBOX, schema_version=SCHEMA_VERSION,
                   types=TYPES, max_features=MAX_FEATURES)
print({table: info["rows"] for table, info in manifest["tables"].items()})
print("BBox UTM SRIDs:", manifest["bbox_utm_srids"])
print("Actual UTM SRIDs (including division references):", manifest["metric_srids_present"])
print("Metric status counts:", manifest["metric_status_counts"])
print("Features crossing UTM boundaries:", manifest["utm_crossing_features"])

# %% [markdown]
# ## Verify before connecting to PostgreSQL
#
# Verification checks file checksums, column types, feature uniqueness, child
# keys and joins, and counts. Its feature-key index lives on disk, so complete
# identifier validation does not grow a Python set with the dataset size.
# Retain the snapshot for database retries and subsequent content verification.

# %%
verified_snapshot = verify_snapshot(DATASET)
print("Verified snapshot:", verified_snapshot["fingerprint"])

# %% [markdown]
# ## Load the existing server
#
# Set `ENABLE_DATABASE_WRITES=True` only after choosing the connection file and
# a fresh destination schema. Opening/running the default notebook prepares local
# data but does not write to PostgreSQL. The password stays in a separate 0600
# file. Never paste passwords or connection objects into output cells.
#
# The importer uses bulk COPY and explicitly typed PostGIS columns, creates
# spatial and lookup indexes and relation views, then checks the complete data.
# It commits only after verification; an error rolls back the schema and tables.
# Existing schemas are refused. If the connection is lost during commit, run
# verification to determine whether it completed before retrying.

# %%
if ENABLE_DATABASE_WRITES:
    load_report = load(DATASET, CONNECTIONS)
    print("Committed schema:", load_report["schema"])
else:
    print("Database writes disabled. Snapshot is ready for later loading.")

# %% [markdown]
# ## Verify the committed database
#
# A new read-only transaction checks every feature key, scalar/JSON field,
# repeated child row, and the geometry EWKB including SRID. This confirms data
# transport; source accuracy and real-world coverage remain separate questions.
# An administrator can grant SELECT access to the existing reader afterwards.

# %%
if ENABLE_DATABASE_WRITES:
    verification_report = verify(DATASET, CONNECTIONS)
    print(verification_report)

# %% [markdown]
# ## Measure across zones with geography
#
# PostGIS derives `geometry_geog` from valid, nonempty WGS84 geometry and indexes
# it with GiST. Geography `ST_DWithin` and `ST_Distance` use metres and work across
# UTM zones, hemispheres, and polar regions. Invalid or empty geometries have null
# geography. The query below finds whole features within 1 km of the bbox centre.
#
# Never compare mixed-SRID `geometry_m` values directly. For a deliberately local
# planar query, transform the query point into a chosen UTM SRID and guard the
# geometry argument with CASE; the manual provides an example. A separate WHERE
# SRID filter alone does not guarantee PostgreSQL's function evaluation order.

# %%
if ENABLE_DATABASE_WRITES:
    from psycopg import sql
    from overture_lab.postgis_import.database import connection, read_connections

    config = read_connections(CONNECTIONS)
    longitude, latitude = (BBOX[0] + BBOX[2]) / 2, (BBOX[1] + BBOX[3]) / 2
    with connection(config) as conn:
        nearby = conn.execute(sql.SQL("""
            WITH q AS (
                SELECT ST_SetSRID(ST_MakePoint(%s,%s),4326)::geography AS point
            )
            SELECT relation, id, name,
                   ST_Distance(geometry_geog,q.point) AS distance_m
            FROM {}.features CROSS JOIN q
            WHERE NOT reference_only AND ST_DWithin(geometry_geog,q.point,%s)
            ORDER BY distance_m, relation, id LIMIT 20
        """).format(sql.Identifier(config["schema"])), (longitude, latitude, 1000)).fetchall()
    for feature in nearby:
        print(feature)

# %% [markdown]
# ## Move to the console
#
# Run `python3 scripts/import_overture_postgis.py run --dataset ... --bbox ...
# --schema-version v1.18.0 --connections ... --report ...` inside the same
# configured container. Use `prepare`, `load`, and `verify` separately when
# retaining snapshots between stages. See the manual for full commands, storage
# budgeting, server permissions, TLS, and offline image preparation.
#
# Keep the snapshot until your retention policy allows removal. `_parts` is
# intermediate normalized data and can be removed explicitly after successful
# snapshot verification. There is no automatic cleanup of host-mounted data.

# %%
spark.stop()
