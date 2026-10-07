# %% [markdown]
# # 15 — Worldwide country polygons
#
# Display and export all **land-only country areas** in the configured Overture
# release: `divisions/division_area`, `subtype='country' AND is_land=true`.
# Regional presets and sample limits do not restrict this dataset.
#
# Country-level territories and disputed representations follow the source
# release; feature and distinct country-code counts are not a sovereign-state
# census. Source IDs, attribution, political perspectives, holes, and multipart
# geometry remain intact. We neither dissolve features nor select a political
# perspective. Territorial-sea-only rows are excluded; dual-flag rows occur once.

# %%
import os

from pyspark import StorageLevel
from overture_lab.config import load_settings
from overture_lab.countries import (
    select_world_countries, validate_countries, country_display_frame,
)
from overture_lab.spark import create_sedona, read_type
from overture_lab.outputs import write_single_geoparquet

WRITE_COUNTRIES = os.getenv("WRITE_DERIVED", "false").lower() == "true"  # set True to export
S3_OUTPUT_URI = os.getenv("DERIVED_OUTPUT_URI", "")  # e.g. "s3a://bucket/derived"
OUTPUT_MODE = os.getenv("DERIVED_OUTPUT_MODE", "s3")  # "s3" or "local"
MAP_TOLERANCE = 0.01  # degrees; display copies only
MAP_COORDINATE_LIMIT = 750_000

# Configure S3_ENDPOINT, S3_REGION, S3_ACCESS_KEY, S3_SECRET_KEY and transport
# settings in the lab environment, never in notebook source or saved outputs.
# Restart the kernel after changing the endpoint, credentials, or destination.
# Apply these non-secret settings to this kernel, then use the shared validator
# (including its protection against writing into the source release prefix).
os.environ.update(DERIVED_OUTPUT_MODE=OUTPUT_MODE, DERIVED_OUTPUT_URI=S3_OUTPUT_URI if OUTPUT_MODE == "s3" else "",
                  WRITE_DERIVED=str(WRITE_COUNTRIES and (OUTPUT_MODE == "local" or bool(S3_OUTPUT_URI))).lower(),
                  ALLOW_LOCAL_DERIVED_FALLBACK="false")
settings = load_settings(include_territorial_waters=False)
spark = create_sedona(settings, "15-world-countries")
display({"release": settings.release, "extent": "land only", "scope": "world",
         "export_enabled": WRITE_COUNTRIES, "output_mode": settings.derived_output_mode,
         "s3_destination_configured": bool(settings.derived_output_uri)})

# %% [markdown]
# ## Select and validate the complete dataset
#
# Distributed validation stops on missing, empty, invalid, or non-polygon
# geometry. Coordinates stay in the release's WGS84 CRS. The source schema is
# retained, excluding the reader's lab-only `theme` and `feature_type` columns.

# %%
areas = read_type(spark, settings, "divisions", "division_area")
countries = select_world_countries(areas).persist(StorageLevel.DISK_ONLY)
country_report = validate_countries(countries)
display(country_report)
countries.groupBy("country").count().orderBy("country").show(300, truncate=False)

# %% [markdown]
# ## Interactive world map
#
# Pan, zoom, and hover to inspect country names, codes, and source feature IDs.
# The renderer is embedded locally; no external basemap or CDN is required.
# Colors distinguish codes and do not indicate sovereignty or recognition.
#
# Topology-preserving simplification affects **only this preview**. If it creates
# invalid geometry, that feature uses its original geometry in the preview, and
# the summary reports how many features required that fallback. The feature
# and coordinate budgets are checked before driver collection. An oversized map
# fails explicitly: raise `MAP_FEATURE_LIMIT` in the lab environment (and its
# enclosing sample limits), or adjust the display tolerance/coordinate budget.
# No country is silently dropped. The export cell can run independently of map
# preparation if the preview budget is exceeded. The web map projection clips
# the polar extremes visually; the export retains them and all source vertices.

# %%
import pydeck as pdk
from overture_lab.visualize import build_interactive_deck, offline_deck_display

map_gdf = country_display_frame(
    countries, feature_limit=settings.map_feature_limit,
    tolerance=MAP_TOLERANCE, coordinate_limit=MAP_COORDINATE_LIMIT,
).rename(columns={"id": "source_id"})  # avoid GeoJSON's top-level numeric feature id
palette = ([31, 119, 180], [255, 127, 14], [44, 160, 44], [214, 39, 40],
           [148, 103, 189], [140, 86, 75], [227, 119, 194], [188, 189, 34])
color_keys = map_gdf["country"].fillna("Unknown")
colors = {code: palette[index % len(palette)]
          for index, code in enumerate(sorted(color_keys.unique()))}
map_gdf["color"] = color_keys.map(colors)
deck = build_interactive_deck(
    [pdk.Layer("GeoJsonLayer", map_gdf.__geo_interface__, id="world-countries",
               pickable=True, auto_highlight=True, filled=True, stroked=True,
               get_fill_color="properties.color", get_line_color=[40, 45, 55],
               line_width_min_pixels=0.6, opacity=0.65)],
    pdk.ViewState(longitude=0, latitude=15, zoom=0.5),
    tooltip={"text": "{name}\nCountry: {country}\nSource ID: {source_id}"},
)
display({"mapped_features": len(map_gdf), "source_features": country_report["features"],
         "full_resolution_preview_features": int(map_gdf.full_resolution_preview.sum()),
         "display_tolerance_degrees": MAP_TOLERANCE})
display(offline_deck_display(deck, height=650,
                            attribution=f"Overture Maps — {settings.release}; land-country areas"))

# %% [markdown]
# ## Export one full-resolution GeoParquet file locally or to S3
#
# Set `S3_OUTPUT_URI` (or environment `DERIVED_OUTPUT_URI`) and enable
# `WRITE_COUNTRIES` (or `WRITE_DERIVED=true`) before running the configuration
# cell. Missing configuration leaves the map usable and explains why no export
# was made. A successful run prints the verified URI and row count.
# For local storage, set `OUTPUT_MODE="local"` (or `DERIVED_OUTPUT_MODE=local`)
# and `WRITE_COUNTRIES=True`. Files use `DERIVED_LOCAL_FALLBACK_DIR`, which must
# be inside `SEDONA_SCRATCH_DIR`; both should point to persistent host mounts.
#
# Each run creates a unique prefix with exactly one `countries.geoparquet`:
# GeoParquet 1.1, Zstandard compression, WGS84 geometry, and a `geometry_bbox`
# covering column. All source rows, fields, and geometry coordinates are retained.
# The writer verifies schema, row count, geometry, metadata, and final inventory.
# It never overwrites a previous run or switches destinations after a failure.
# Failed writes report the partial prefix. Single-file output uses one final
# Spark writer; display simplification and budgets do not affect the export.

# %%
if not WRITE_COUNTRIES:
    country_export = {"status": "dry-run", "detail": "Choose OUTPUT_MODE and set WRITE_COUNTRIES=True to export."}
elif settings.derived_output_mode == "s3" and not S3_OUTPUT_URI:
    country_export = {"status": "not-configured", "detail": "Set S3_OUTPUT_URI to an s3a://bucket/prefix and rerun from the configuration cell."}
else:
    country_export = write_single_geoparquet(
        countries, spark, settings, dataset_name="world-countries",
        object_name="countries.geoparquet",
    ).as_dict()
display(country_export)

# %% [markdown]
# ## Reload the exported data
#
# The printed URI can be loaded in a later session without scanning the source
# release. Source attribution and perspective fields remain available for analysis.

# %%
if country_export["status"] == "written":
    restored = spark.read.format("geoparquet").load(country_export["geoparquet_uri"])
    display(validate_countries(restored))
countries.unpersist()
# Keep the shared Spark context available for further notebook analysis.
