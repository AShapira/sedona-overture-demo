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
from overture_lab.detailed_countries import (
    DetailedCountryOptions, build_detailed_countries, export_detailed_countries,
)

WRITE_COUNTRIES = os.getenv("WRITE_DERIVED", "false").lower() == "true"  # set True to export
S3_OUTPUT_URI = os.getenv("DERIVED_OUTPUT_URI", "")  # e.g. "s3a://bucket/derived"
OUTPUT_MODE = os.getenv("DERIVED_OUTPUT_MODE", "s3")  # "s3" or "local"
MAP_COORDINATE_LIMIT = 10_000_000
EXPORT_DETAILED_COUNTRIES = True  # experimental export only; also requires WRITE_COUNTRIES
DETAILED_COUNTRY_TILE_DEGREES = 0.5
DETAILED_COUNTRY_MAX_TILE_COORDINATES = 2_000_000

# Configure S3_ENDPOINT, S3_REGION, S3_ACCESS_KEY, S3_SECRET_KEY and transport
# settings in the lab environment, never in notebook source or saved outputs.
# Restart the kernel after changing the endpoint, credentials, or destination.
# Apply these non-secret settings to this kernel, then use the shared validator
# (including its protection against writing into the source release prefix).
os.environ.update(DERIVED_OUTPUT_MODE=OUTPUT_MODE, DERIVED_OUTPUT_URI=S3_OUTPUT_URI if OUTPUT_MODE == "s3" else "",
                  WRITE_DERIVED=str(WRITE_COUNTRIES and (OUTPUT_MODE == "local" or bool(S3_OUTPUT_URI))).lower(),
                  ALLOW_LOCAL_DERIVED_FALLBACK="false")
settings = load_settings(include_territorial_waters=False)
spark = create_sedona(settings, "15-world-countries", overlay_ng=True)
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
# Every original country geometry is displayed as supplied: no simplification,
# clipping, or sampling. The coordinate count includes ring-closing positions
# and duplicates, not individual x/y ordinates. The count is printed before
# rendering and remains visible above the map. Release 2026-07-22.0 contains
# 219 features and 5,944,875 coordinate positions. This can take time to render.
# Feature and coordinate budgets fail explicitly before collection; increase
# the named budget to display a larger release. No country is silently dropped.
# Export cells can run independently if the map exceeds its budget. Web Mercator
# visually clips polar extremes, but all source coordinates are supplied.

# %%
import pydeck as pdk
from overture_lab.visualize import build_interactive_deck, offline_deck_display, geometry_coordinate_count

map_gdf = country_display_frame(
    countries, feature_limit=settings.map_feature_limit,
    coordinate_limit=MAP_COORDINATE_LIMIT,
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
         "displayed_coordinate_positions": geometry_coordinate_count(map_gdf),
         "geometry_policy": "original source geometry; no simplification"})
display(offline_deck_display(deck, height=650, feature_count=len(map_gdf),
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
# Spark writer; display budgets do not affect the export.

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
# ## Experimental export: territorial country polygons intersect physical land
#
# `detailed country polygon = territorial country polygon ∩ physical land`
#
# Overture's original land-country polygon can have a coarse coastline even
# without display simplification (for example around Haifa). This experiment
# starts with `division_area`, `subtype='country' AND is_territorial=true`, matched
# to the displayed countries by `division_id`. Territorial geometry includes
# coastal waters and supplies the administrative extent. Intersecting it with
# `base/land`, `subtype='land' AND class='land'`, supplies the detailed coastline.
# Starting with the coarse land-country polygon would still cut off coastal
# features outside that polygon. Territorial source representations remain
# separate, including multiple representations with the same country code.
# Missing territorial matches are an error, never a silent omission.
#
# Sedona subdivides large inputs, clips them to globally aligned 0.5° tiles,
# dissolves physical land within each tile, then intersects it with each
# territorial representation. Tile boundaries partition the output; there is
# no worldwide dissolve or collection into Python. A tile operation exceeding
# the coordinate guard stops with diagnostics; reduce the tile size. OverlayNG
# and RelateNG run without simplification, precision reduction, buffering, or
# automatic repair. Start a fresh kernel if the current one uses older engines.
# Physical land is a coastline-based landmass layer: inland water is not
# separately subtracted. This is a derived experiment, not a correction to
# Overture's administrative data, and it inherits source coverage and disputes.
#
# The separate `detailed_countries_experimental.geoparquet` contains one nonempty
# Polygon/MultiPolygon per territorial source feature and tile. Rows carry a
# derived ID, country code/name, division ID, `territorial_area_id`, `tile_id`,
# release, geometry policy, and exact bbox. `territorial_sources` retains the
# source area's attribution; `land_sources` aggregates dataset/license pairs
# contributing to that tile's dissolved land, not individual output vertices.
# Rejoin `territorial_area_id` to the release for the complete source attributes.
# Empty territorial intersections are reported explicitly.
#
# This output is **never displayed on the map**. `EXPORT_DETAILED_COUNTRIES=False`
# skips it. Disabled writes or a missing destination skip the extra land scan
# and construction entirely. The separate export follows the existing local/S3
# destination, unique-run, no-fallback rules. Schema, metadata, geometry, bbox,
# row count, and complete row fingerprints are verified after reloading.

# %%
detailed_country_export = {}
if EXPORT_DETAILED_COUNTRIES and settings.write_derived:
    detailed_countries = None
    try:
        detailed_countries, detailed_country_report = build_detailed_countries(
            areas, countries, read_type(spark, settings, "base", "land"),
            release=settings.release, release_uri=settings.release_uri,
            options=DetailedCountryOptions(DETAILED_COUNTRY_TILE_DEGREES,
                                           DETAILED_COUNTRY_MAX_TILE_COORDINATES),
            progress=lambda event: print(event, flush=True),
        )
        display(detailed_country_report)
        detailed_country_export = export_detailed_countries(detailed_countries, spark, settings)
    finally:
        if detailed_countries is not None:
            detailed_countries.unpersist()
else:
    detailed_country_export = {
        "status": "disabled" if not EXPORT_DETAILED_COUNTRIES else "dry-run",
        "detail": "Enable EXPORT_DETAILED_COUNTRIES and WRITE_COUNTRIES with a configured destination; no overlay was built.",
    }
display(detailed_country_export)

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
