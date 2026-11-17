# %% [markdown]
# # 20 — Worldwide inferred flight connections · PlaneQuery · 2026 Q3
#
# Build a world flight-connection layer from **July 1–September 30, 2026**, export
# every valid directed airport pair to GeoParquet, and explore recurring
# connections on an interactive map. Runnable cells use **already downloaded
# local files or internal S3**. Overture supplies optional country context only.
#
# [PlaneQuery](https://huggingface.co/datasets/ggman12/planequery-data-flights)
# infers takeoff/landing airports from ADSB.lol observations. This includes
# general aviation and other aircraft categories, with uneven receiver coverage
# and possible endpoint inference errors. The source card flags reduced counts
# on July 4, August 1, and August 9 within this quarter. It is **not a complete scheduled airline
# network**. Counts represent source observations, not guaranteed unique flights,
# passenger volumes, or service frequency. Repeated source records remain counted.
#
# Airport coordinates come from a pinned OurAirports reference. Lines are modeled
# **WGS84 shortest geodesics**, split at the antimeridian in the exported geometry;
# they are not recorded aircraft tracks or airways. The map shows pairs observed
# on at least **14 distinct days** by default; the export includes all valid
# pairs regardless of recurrence. Recurrence reduces one-off noise but does not
# establish that an inferred airport connection is correct.
#
# Prepared by Codex

# %% [markdown]
# ## 1. Source preparation — OPEN NETWORK ONLY (remarks, not executed cells)
#
# On a connected preparation machine with Python 3 and this repository, run:
#
# ```bash
# python3 scripts/download-planequery.py --output /staging/planequery/2026-Q3
# # If interrupted, repeat the command with --resume.
# ```
#
# This stdlib-only helper needs no account, API key, or package installation.
# It pins the [PlaneQuery dataset revision
# fe8fc37a34bf5bd4b0221013b3c8fa9bbdd4cae2](https://huggingface.co/datasets/ggman12/planequery-data-flights/tree/fe8fc37a34bf5bd4b0221013b3c8fa9bbdd4cae2).
# It downloads **all 92 daily Parquet partitions**, 935,155,300 bytes in total,
# from `source=algorithm-nn/adsb_source=adsblol/version=4`, plus each day's
# `airport_catalog.json` and/or `flight_manifest.json` and the dataset card.
# An example immutable data URL is:
#
# ```text
# https://huggingface.co/datasets/ggman12/planequery-data-flights/resolve/fe8fc37a34bf5bd4b0221013b3c8fa9bbdd4cae2/source=algorithm-nn/adsb_source=adsblol/version=4/year=2026/month=07/day=01/data.parquet
# ```
#
# The download also pins OurAirports `airports.csv` to the **2026-10-06** commit
# [bc63f66786d68f639111c99711b4a3d0c0685a90](https://github.com/davidmegginson/ourairports-data/tree/bc63f66786d68f639111c99711b4a3d0c0685a90),
# the knowledge snapshot referenced by PlaneQuery's September 30 manifest.
# Airport IDs are **OurAirports IDs**. Geometry uses this single fixed reference
# for consistent quarterly aggregation; it does not reconstruct each day's
# historical airport positions or aliases. Original daily catalog provenance is
# retained so this choice can be inspected. Airport-ident disagreements are counted.
#
# Preparation checks completeness, byte lengths, upstream LFS SHA-256 for Parquet
# and Git blob digests for small source metadata, then records SHA-256 for every
# staged input. `manifest.json` records exact URLs, revisions, periods, reference
# date, lengths, hashes, and actual UTC download time. The complete bundle is
# published only after successful checks; a resumable `.partial` folder is not
# valid notebook input. Existing complete destinations are never overwritten.
#
# Transfer the **entire bundle**, including provenance, documentation, manifest,
# `SHA256SUMS`, and `README.txt`, using your approved transfer process. Suggested
# placement beside the Overture data:
#
# ```text
# <overture-release-root>/
#   theme=divisions/...
#   theme=transportation/...
#   external_sources/planequery/2026-Q3/
#     manifest.json
#     airports.csv
#     flights/date=2026-07-01/data.parquet
#     flights/date=2026-07-01/airport_catalog.json
#     ... all 92 days ...
#     flights/date=2026-09-30/flight_manifest.json
#     SHA256SUMS
#     README.txt
#     planequery-README.md
#     ourairports-README.md
# ```
#
# On an air-gapped staging machine, upload that folder to **internal** S3 if needed:
#
# ```bash
# aws --endpoint-url https://s3.airgap.example s3 cp /transfer/planequery/2026-Q3/ \
#   s3://geodata/overture/release/2026-07-22.0/external_sources/planequery/2026-Q3/ --recursive
# ```
#
# `FLIGHT_ROUTES_URI` accepts an absolute local path, `file:///` path, or
# `s3a://bucket/prefix` directory. Empty defaults to
# `<OVERTURE_RELEASE_URI>/external_sources/planequery/2026-Q3`, using the same
# storage and S3 credentials as Overture. With the existing local Compose mount,
# this is `/data/overture/external_sources/planequery/2026-Q3`. A separate local
# folder requires a read-only container mount: configure the **container path**,
# not the host or Windows path. Set the variable in `.env` or the airgap env file
# before creating the lab container. No cell downloads a missing source file.
#
# Data attribution: **PlaneQuery / ADSB.lol**, [ODbL 1.0](https://opendatacommons.org/licenses/odbl/1-0/).
# Retain attribution and applicable share-alike terms when redistributing derived
# databases. [OurAirports data](https://ourairports.com/data/) is public domain.
# Software licensing does not replace the data license. Keep provenance with exports.

# %% [markdown]
# ## 2. Configure offline input, export, and map
#
# Export is enabled by default, using local persistent storage unless
# `DERIVED_OUTPUT_URI` selects S3. Each run gets its own folder; failures never
# silently switch destination. `MAX_SEGMENT_KM` controls geometric vertex spacing,
# not source accuracy. The default map embeds JavaScript and country polygons
# without external requests. Public imagery is an explicit opt-in.

# %%
import os
from dataclasses import replace

from pyspark import StorageLevel
from pyspark.sql import functions as F
from overture_lab.config import load_settings
from overture_lab.countries import select_world_countries, country_context_frame
from overture_lab.flight_routes import validate_flight_routes, flight_routes_map
from overture_lab.planequery import (
    planequery_source_uri, read_planequery_bundle, build_connections,
    connection_display_frame, write_connection_audit,
)
from overture_lab.outputs import write_single_geoparquet
from overture_lab.region_overview import overview_basemap
from overture_lab.spark import create_sedona, read_type
from overture_lab.visualize import offline_deck_display

FLIGHT_ROUTES_URI = os.getenv("FLIGHT_ROUTES_URI", "")  # empty = alongside Overture
WRITE_FLIGHTS = True
S3_OUTPUT_URI = os.getenv("DERIVED_OUTPUT_URI", "")
OUTPUT_MODE = os.getenv("DERIVED_OUTPUT_MODE", "s3") if S3_OUTPUT_URI else "local"
MAX_SEGMENT_KM = 200.0
MAP_MIN_ACTIVE_DAYS = 14
MAP_FEATURE_LIMIT = 100_000
MAP_COORDINATE_LIMIT = 2_000_000
SHOW_COUNTRIES = True
COUNTRY_MAP_FEATURE_LIMIT = 2_000
COUNTRY_MAP_COORDINATE_LIMIT = 750_000
COUNTRY_MAP_TOLERANCE = 0.05
BASEMAP_MODE = "none"  # "none", "configured", or explicitly online "public_osm"
CONFIGURED_WMS_ATTRIBUTION = ""

os.environ.update(
    DERIVED_OUTPUT_MODE=OUTPUT_MODE,
    DERIVED_OUTPUT_URI=S3_OUTPUT_URI if OUTPUT_MODE == "s3" else "",
    WRITE_DERIVED=str(WRITE_FLIGHTS).lower(), ALLOW_LOCAL_DERIVED_FALLBACK="false",
)
settings = load_settings()
source_uri = planequery_source_uri(settings.release_uri, FLIGHT_ROUTES_URI)
wms, background_attribution = overview_basemap(BASEMAP_MODE, settings.wms, CONFIGURED_WMS_ATTRIBUTION)
spark = create_sedona(settings, "20-world-flight-routes", input_uris=(source_uri,))
spark.conf.set("spark.sql.session.timeZone", "UTC")
display({"flight_source_folder": source_uri, "scope": "world", "observation_period": "2026-07-01 through 2026-09-30 UTC",
         "export_enabled": WRITE_FLIGHTS, "output_mode": OUTPUT_MODE,
         "output_root": settings.derived_output_uri if OUTPUT_MODE == "s3" else settings.derived_local_fallback_dir,
         "map_min_active_days": MAP_MIN_ACTIVE_DAYS, "max_geodesic_segment_km": MAX_SEGMENT_KM})

# %% [markdown]
# ## 3. Verify, classify observations, and build all directed pairs
#
# Verify completeness and **every staged input's byte length and SHA-256** through
# Hadoop local/S3A. Hashes run on executors; only metadata reaches the driver.
# Observations stay in Spark; there is no driver collection of the quarterly data.
#
# Join endpoints by OurAirports ID only. A row gets one exclusion reason, in this
# order: missing/invalid times (landing must follow takeoff), takeoff outside the
# quarter, missing endpoint ID, unknown ID, invalid coordinates, same airport, or
# effectively coincident endpoints (within about one metre). Airport-ident and
# partition-date disagreements are retained as flags. All airport facility types
# are retained, including currently closed facilities that could have been in use
# during the period. No commercial-service or aircraft-category filter is inferred.
#
# Valid observations are grouped by **directed airport ID pair**. Each exported
# feature includes total observations, distinct active UTC takeoff days, monthly
# counts, first/last observation time, disagreement counts, endpoint reference
# coordinates, source period/revisions, license, and geometry method. Reverse
# directions remain distinct. All excluded source rows and their reason remain
# in a separate audit Parquet dataset. Raw downloaded partitions remain untouched.

# %%
source_manifest, observations, airports = read_planequery_bundle(spark, source_uri)
display({key: source_manifest[key] for key in (
    "revision", "downloaded_at_utc", "period_start", "period_end_exclusive", "days",
    "airport_revision", "airport_reference_date",
)})
flights, classified_observations, quality_report = build_connections(
    observations, airports, source_manifest, max_segment_km=MAX_SEGMENT_KM,
)
flights = flights.persist(StorageLevel.DISK_ONLY)
geometry_report = validate_flight_routes(flights)
route_totals = flights.agg(F.sum("observation_count").alias("observations"),
    F.sum("ident_disagreement_count").alias("ident_disagreements"),
    F.sum("partition_day_disagreement_count").alias("partition_day_disagreements")).first().asDict()
assert route_totals["observations"] == quality_report["accepted_observations"]
quality_report.update(geometry=geometry_report, route_totals=route_totals,
                      map_min_active_days=MAP_MIN_ACTIVE_DAYS)
display(quality_report)
flights.select("origin_ident", "destination_ident", "observation_count", "active_days", "distance_km").orderBy(
    F.desc("observation_count")).show(20)

# %% [markdown]
# ## 4. Export every valid directed pair and its audit
#
# One `world_flight_routes.geoparquet` contains **all valid directed pairs**,
# including connections seen on fewer than 14 days. It uses WGS84, Zstandard,
# GeoParquet 1.1, and a bounding-box covering column. Export runs before browser
# collection, independently of map limits and recurrence settings.
# Output is under `world-flight-routes/release=planequery-2026Q3-<revision>/run=<id>/`.
# The release label identifies PlaneQuery, independently of Overture country context.
#
# Keep `source-manifest.json`, `route-quality.json`, and `excluded-observations/`
# beside the export. Quality totals account for every input observation, including
# exclusions; daily input counts disclose variation in source coverage. Exclusion
# files use ordinary Parquet and include original observation fields, joined
# endpoint metadata, source partition/file, and the assigned reason.

# %%
export_settings = replace(settings, release=f"planequery-2026Q3-{source_manifest['revision'][:12]}")
flight_export = write_single_geoparquet(
    flights, spark, export_settings, dataset_name="world-flight-routes",
    object_name="world_flight_routes.geoparquet",
).as_dict()
display(flight_export)
if flight_export["status"] == "written":
    audit_files = write_connection_audit(
        spark, flight_export["run_prefix"], source_manifest, quality_report, classified_observations,
    )
    display(audit_files)

# %% [markdown]
# ## 5. Explore recurring connections on the interactive map
#
# Pan, zoom, toggle countries/connections, reset the world view, and hover for
# airport names, distance, observation counts, and active days. By default the map
# shows **all pairs with at least 14 active days**; change `MAP_MIN_ACTIVE_DAYS`
# to explore recurrence, or set it to 1 for all pairs if display budgets permit.
# At this pinned snapshot the 14-day threshold gives 88,163 pairs; seven days
# gives 161,686 and exceeds the default 100,000-feature browser budget.
# Opposite directions may overlap visually. Map budgets fail explicitly rather
# than sampling; increase the budgets or recurrence threshold if necessary.
#
# Country polygons are generalized context and may omit small islands or holes.
# They never filter flight data. Set `SHOW_COUNTRIES=False` to operate without
# Overture files. Web Mercator limits the visible polar extent; exports keep all
# route coordinates. The default renderer needs no tile server or CDN.

# %%
flight_map_frame = connection_display_frame(flights, min_active_days=MAP_MIN_ACTIVE_DAYS,
    feature_limit=MAP_FEATURE_LIMIT, coordinate_limit=MAP_COORDINATE_LIMIT)
country_map_frame = None
if SHOW_COUNTRIES:
    country_map_frame = country_context_frame(
        select_world_countries(read_type(spark, settings, "divisions", "division_area")),
        feature_limit=COUNTRY_MAP_FEATURE_LIMIT, tolerance=COUNTRY_MAP_TOLERANCE,
        coordinate_limit=COUNTRY_MAP_COORDINATE_LIMIT,
    )
    context_geometry = country_map_frame.geometry.simplify(COUNTRY_MAP_TOLERANCE, preserve_topology=False)
    usable = ~context_geometry.is_empty & context_geometry.is_valid
    country_map_frame.geometry = context_geometry.where(usable, country_map_frame.geometry)
deck, controls = flight_routes_map(flight_map_frame, countries=country_map_frame, wms=wms,
                                  observed=True, min_active_days=MAP_MIN_ACTIVE_DAYS)
display({"mapped_directed_airport_pairs": len(flight_map_frame), "map_min_active_days": MAP_MIN_ACTIVE_DAYS,
         "mapped_observations": int(flight_map_frame.observation_count.sum()),
         "exported_directed_airport_pairs": geometry_report["features"],
         "exported_observations": quality_report["accepted_observations"],
         "mapped_country_features": 0 if country_map_frame is None else len(country_map_frame)})
attribution = "Connections: PlaneQuery / ADSB.lol, ODbL; July–September 2026. Airports: OurAirports, public domain. Geometry: modeled WGS84 geodesics."
if SHOW_COUNTRIES:
    attribution += f" Country context: Overture Maps {settings.release}; © OpenStreetMap contributors; ODbL."
if background_attribution:
    attribution += " " + background_attribution
display(offline_deck_display(deck, height=760, controls=controls, attribution=attribution))

# %% [markdown]
# ## 6. Reload the saved GeoParquet
#
# Use the printed URI in a later session or GIS application. Provenance and counts
# travel with each feature. Keep the adjacent audit files and raw source bundle
# to investigate quality or choose a different recurrence policy later.

# %%
if flight_export["status"] == "written":
    restored_flights = spark.read.format("geoparquet").load(flight_export["geoparquet_uri"])
    display(validate_flight_routes(restored_flights))
    assert restored_flights.agg(F.sum("observation_count")).first()[0] == quality_report["accepted_observations"]
classified_observations.unpersist()
flights.unpersist()
# Keep Spark available for further analysis.
