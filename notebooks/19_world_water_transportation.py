# %% [markdown]
# # 19 — Worldwide water transportation
#
# Select **every** `transportation/segment` feature with `subtype='water'`
# from the configured Overture release, export one full-resolution GeoParquet,
# and explore the result in an interactive world map.
#
# Overture water transportation includes mapped shipping lanes and ferry routes.
# These source segments are not a complete inventory of scheduled cargo services
# or observed vessel tracks. Regional presets, country boundaries, and sample
# limits do not restrict the selection. Original vertices, IDs, names, connector
# references, and attribution fields are retained without clipping or merging.
# [Overture segment definitions](https://docs.overturemaps.org/guides/transportation/segments-and-connectors/)
#
# Prepared by Codex

# %% [markdown]
# ## 1. Configure export and display
#
# Export is **enabled by default**, independently of other lessons' WRITE_DERIVED
# flag. With no S3 destination configured, output goes to the lab's local derived
# directory. Set `OUTPUT_MODE="s3"` and `S3_OUTPUT_URI` to export to S3 instead.
# An explicitly selected S3 destination must be configured; failures never switch
# destinations. Keep endpoint credentials in the lab environment.
#
# Local output uses `DERIVED_LOCAL_FALLBACK_DIR` inside `SEDONA_SCRATCH_DIR`.
# These are persistent host mounts in the supplied lab configurations. Each run
# gets a unique output folder, so rerunning does not replace previous exports.
# The notebook's map budgets are independent of the regional sample settings.
# `BASEMAP_MODE="none"` uses offline country polygons; `configured` uses the
# lab WMS, and `public_osm` explicitly enables public browser imagery requests.

# %%
import os

from pyspark import StorageLevel
from overture_lab.config import load_settings
from overture_lab.countries import select_world_countries, country_context_frame
from overture_lab.outputs import write_single_geoparquet
from overture_lab.region_overview import overview_basemap
from overture_lab.spark import create_sedona, read_type
from overture_lab.visualize import offline_deck_display
from overture_lab.water_transportation import (
    select_world_water_transportation, validate_water_transportation,
    water_transportation_display_frame, water_transportation_map,
)

WRITE_WATER = True
S3_OUTPUT_URI = os.getenv("DERIVED_OUTPUT_URI", "")
OUTPUT_MODE = os.getenv("DERIVED_OUTPUT_MODE", "s3") if S3_OUTPUT_URI else "local"
MAP_FEATURE_LIMIT = 100_000
MAP_COORDINATE_LIMIT = 2_000_000
MAP_SIMPLIFY_TOLERANCE = 0.001  # degrees; display only; 0 keeps every vertex
SHOW_COUNTRIES = True
COUNTRY_MAP_FEATURE_LIMIT = 2_000
COUNTRY_MAP_COORDINATE_LIMIT = 750_000
COUNTRY_MAP_TOLERANCE = 0.05  # degrees; context polygons only
BASEMAP_MODE = "none"  # "none", "configured", or "public_osm"
CONFIGURED_WMS_ATTRIBUTION = ""

os.environ.update(
    DERIVED_OUTPUT_MODE=OUTPUT_MODE,
    DERIVED_OUTPUT_URI=S3_OUTPUT_URI if OUTPUT_MODE == "s3" else "",
    WRITE_DERIVED=str(WRITE_WATER).lower(), ALLOW_LOCAL_DERIVED_FALLBACK="false",
)
settings = load_settings()
wms, background_attribution = overview_basemap(
    BASEMAP_MODE, settings.wms, CONFIGURED_WMS_ATTRIBUTION,
)
spark = create_sedona(settings, "19-world-water-transportation")
display({"release": settings.release, "scope": "world", "subtype": "water",
         "export_enabled": WRITE_WATER, "output_mode": settings.derived_output_mode,
         "output_root": settings.derived_output_uri if OUTPUT_MODE == "s3"
                        else settings.derived_local_fallback_dir,
         "map_feature_limit": MAP_FEATURE_LIMIT, "map_coordinate_limit": MAP_COORDINATE_LIMIT})

# %% [markdown]
# ## 2. Select and validate all water segments
#
# The subtype filter runs in Spark before collection. The complete result is
# cached on disk for export and mapping. Validation rejects missing IDs and
# missing, empty, invalid, non-line, or non-WGS84 geometry. A release with no
# matching water segments stops with an explicit error.

# %%
segments = read_type(spark, settings, "transportation", "segment")
water = select_world_water_transportation(segments).persist(StorageLevel.DISK_ONLY)
water_report = validate_water_transportation(water)
display(water_report)
water.select("id", "names", "subtype").show(20, truncate=False)

# %% [markdown]
# ## 3. Export one complete GeoParquet file
#
# Export happens **before** any map collection. The file contains water segments
# only; country polygons are display context. No regional clipping, sampling,
# simplification, deduplication, or route reconstruction affects the export.
# Lab-only reader columns `theme` and `feature_type` are omitted.
#
# The writer creates `world_water_transportation.geoparquet` beneath
# `world-water-transportation/release=<release>/run=<unique-id>/`. It uses
# GeoParquet 1.1, Zstandard compression, WGS84 geometry, and a fresh
# `geometry_bbox` covering column. It verifies the schema, row count, geometry,
# metadata, and single-file inventory, then prints the exact saved URI.

# %%
water_export = write_single_geoparquet(
    water, spark, settings, dataset_name="world-water-transportation",
    object_name="world_water_transportation.geoparquet",
).as_dict()
display(water_export)

# %% [markdown]
# ## 4. Explore the interactive world map
#
# Pan, zoom, toggle water/country layers, return to the world view, and hover
# over a water segment to see its name and source ID. The renderer and country
# context are embedded locally; the default map needs no external network.
# Countries follow Overture's source representations and are not a political
# filter on water routes. Set `SHOW_COUNTRIES=False` to omit this context scan.
#
# Every water segment appears in the preview. A small angular simplification
# reduces browser work; set `MAP_SIMPLIFY_TOLERANCE=0` for original vertices.
# Invalid or empty simplified lines fall back to their original geometry.
# Neither simplification nor map controls change the exported layer. The renderer
# wraps lines at the antimeridian so a short crossing does not span the map.
# Country context is generalized more strongly and may omit tiny islands/holes;
# a country that would disappear entirely retains its original preview geometry.
# This background is only for orientation. Web Mercator limits the visible polar
# extent; the export retains all coordinates. Display budgets are checked before
# collection against the full source lines and fail instead of sampling; if exceeded, the
# export above remains complete. Increase the named budget and rerun this section.

# %%
water_map_frame = water_transportation_display_frame(
    water, feature_limit=MAP_FEATURE_LIMIT, coordinate_limit=MAP_COORDINATE_LIMIT,
    tolerance=MAP_SIMPLIFY_TOLERANCE,
)
country_map_frame = None
if SHOW_COUNTRIES:
    country_map_frame = country_context_frame(
        select_world_countries(read_type(spark, settings, "divisions", "division_area")),
        feature_limit=COUNTRY_MAP_FEATURE_LIMIT, tolerance=COUNTRY_MAP_TOLERANCE,
        coordinate_limit=COUNTRY_MAP_COORDINATE_LIMIT,
    )
    # The context can omit tiny islands/holes at world scale; all country rows
    # remain, including small countries which would otherwise become empty.
    simplified_context = country_map_frame.geometry.simplify(
        COUNTRY_MAP_TOLERANCE, preserve_topology=False,
    )
    usable_context = ~simplified_context.is_empty & simplified_context.is_valid
    country_map_frame.geometry = simplified_context.where(usable_context, country_map_frame.geometry)
deck, controls = water_transportation_map(water_map_frame, countries=country_map_frame, wms=wms)
display({"mapped_water_segments": len(water_map_frame),
         "source_water_segments": water_report["features"],
         "display_tolerance_degrees": MAP_SIMPLIFY_TOLERANCE,
         "mapped_country_features": 0 if country_map_frame is None else len(country_map_frame)})
attribution = f"Overture Maps {settings.release}; © OpenStreetMap contributors; ODbL."
if background_attribution:
    attribution += " " + background_attribution
display(offline_deck_display(deck, height=760, controls=controls, attribution=attribution))

# %% [markdown]
# ## 5. Reload the saved layer
#
# Use the printed URI in a later session to avoid rescanning the full transport
# theme. Nested source attributes and connector references remain available.

# %%
if water_export["status"] == "written":
    restored_water = spark.read.format("geoparquet").load(water_export["geoparquet_uri"])
    display(validate_water_transportation(restored_water))
water.unpersist()
# Keep the Spark context available for further notebook analysis.
