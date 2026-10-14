# %% [markdown]
# # 14 — Physical landmass and ocean surfaces
#
# Use coastline-derived **landmass** (`base/land`, subtype/class `land`) and
# **ocean** (`base/water`, subtype `ocean`). Inland lakes and rivers remain
# within the landmass classification. Ocean/sea labels, forests, land cover,
# and country territories do not define these physical surfaces.
# See the [Overture water schema](https://docs.overturemaps.org/schema/reference/base/water/).
#
# The world result retains native polygon pieces and every coordinate. Derived
# bboxes are recomputed because source pruning boxes are rounded outward. The
# regional result clips those same surfaces to the combined rectangle of the
# configured country extents, including intervening sea and neighboring land.
# This is not a country-ownership mask. Exact outputs retain native pieces;
# optional GeoPackages add tiled, dissolved presentation layers for GeoServer.

# %%
import time

from pyspark import StorageLevel
from pyspark.sql import functions as F

from overture_lab.config import load_settings
from overture_lab.regions import Bounds, select_country_areas
from overture_lab.spark import create_sedona, read_type
from overture_lab.geopackage import (
    GeneralizationOptions, check_geopackage_dependencies, export_surface_geopackage,
)
from overture_lab.surfaces import (
    SURFACE_FILTERS, regional_bounds, source_classification_counts,
    select_world_surfaces, validate_surfaces, clip_surfaces, coverage_report,
    display_surfaces, surface_grid, export_surfaces,
)

REGION_PRESET = "medium"  # "medium" or "large"
INCLUDE_TERRITORIAL_WATERS = True  # affects only the regional rectangle
WORLD_GRID_DEGREES = 2.0  # classify 16,200 cell centers; display only
REGIONAL_MAP_TOLERANCE = 0.001
QA_WINDOWS = []  # optional Bounds(xmin, ymin, xmax, ymax), <= 1 degree per side
EXPORT_GEOPACKAGE = True  # still gated by WRITE_DERIVED; False keeps the original workflow
GPKG_SCOPES = ("world", "regional")  # use ("regional",) for a smaller first run
GPKG_LEVELS = {"fine": 0.001, "medium": 0.01, "coarse": 0.05}  # angular degrees
GPKG_TILE_DEGREES = 2.0  # globally aligned; must divide 180 exactly
GPKG_MAX_TILE_COORDINATES = 2_000_000  # reduce tile size if the guard fires
GPKG_PRECISION_GRID_DEGREES = None  # opt-in: e.g. 1e-10 for numerical coastline mismatches

settings = load_settings(region_preset=REGION_PRESET,
                         include_territorial_waters=INCLUDE_TERRITORIAL_WATERS)
gpkg_options = GeneralizationOptions(GPKG_LEVELS, GPKG_TILE_DEGREES,
                                    GPKG_MAX_TILE_COORDINATES, GPKG_PRECISION_GRID_DEGREES)
gpkg_options.validate()
if not GPKG_SCOPES or set(GPKG_SCOPES) - {"world", "regional"}:
    raise ValueError("GPKG_SCOPES must select world and/or regional")
if EXPORT_GEOPACKAGE and settings.write_derived:
    display(check_geopackage_dependencies())  # fail before expensive source scans
spark = create_sedona(settings, "14-landmass-and-oceans")
started = time.perf_counter()
display({"release": settings.release, "filters": SURFACE_FILTERS,
         "region_preset": settings.region_preset,
         "write_derived": settings.write_derived,
         "output_mode": settings.derived_output_mode})

# %% [markdown]
# ## Inspect the release before selecting its surfaces
#
# Classification counts scan only small scalar columns. Geometry validation
# below scans every selected surface; missing classes or invalid geometry stop
# processing, with no country-boundary substitute or automatic repair.
# Null source attribution is counted and retained as missing, never invented.

# %%
land = read_type(spark, settings, "base", "land")
water = read_type(spark, settings, "base", "water")
for name, source in (("land", land), ("water", water)):
    print(f"base/{name}")
    source.printSchema()
    source_classification_counts(source).show(200, truncate=False)

world_surfaces = select_world_surfaces(
    land, water, release=settings.release, release_uri=settings.release_uri,
).persist(StorageLevel.DISK_ONLY)
world_report = validate_surfaces(world_surfaces, require_both=True)
display(world_report)

# %% [markdown]
# ## Derive an exact regional extract
#
# Bbox pruning reduces the candidates; `ST_Intersection` does the actual clip.
# Boundary-only contacts have no surface area and are removed. Polygon holes
# and multipart geometry remain intact. Wrapped regional rectangles are rejected;
# split such requests into separate east/west extents explicitly.

# %%
countries = select_country_areas(
    read_type(spark, settings, "divisions", "division_area"),
    settings.region_state_codes,
    include_territorial_waters=settings.include_territorial_waters,
)
country_boxes = tuple(Bounds(r.xmin, r.ymin, r.xmax, r.ymax) for r in countries.select(
    "bbox.xmin", "bbox.ymin", "bbox.xmax", "bbox.ymax").collect())
region_bounds = regional_bounds(country_boxes)
regional_surfaces = clip_surfaces(world_surfaces, region_bounds).persist(StorageLevel.DISK_ONLY)
regional_report = validate_surfaces(regional_surfaces)
display({"regional_rectangle": region_bounds.as_dict(), "surfaces": regional_report})

# %% [markdown]
# ## Check small windows for overlaps and uncovered areas
#
# These are exact planar topology diagnostics in **square degrees**, not land
# area measurements. Zero is ideal; any nonzero discrepancy is reported without
# filling it. The default window is around the regional rectangle's center;
# set `QA_WINDOWS` to inspect particular coasts or islands. Window and vertex
# guards prevent an accidental worldwide union. Passing these checks does not
# certify global completeness. Use geodesic area or a suitable equal-area CRS
# for later physical area analysis.

# %%
center_x = (region_bounds.xmin + region_bounds.xmax) / 2
center_y = (region_bounds.ymin + region_bounds.ymax) / 2
half_x = min(0.1, (region_bounds.xmax - region_bounds.xmin) / 2)
half_y = min(0.1, (region_bounds.ymax - region_bounds.ymin) / 2)
qa_windows = QA_WINDOWS or [Bounds(center_x-half_x, center_y-half_y,
                                   center_x+half_x, center_y+half_y)]
qa_reports = [coverage_report(world_surfaces, bounds) for bounds in qa_windows]
display(qa_reports)

# %% [markdown]
# ## Offline previews, separate from analytical geometry
#
# The world overview classifies a bounded grid of cell centers in Sedona and
# collects only scalar labels (16,200 cells at 2 degrees). A cell color describes
# its center, not the whole cell: small islands and narrow waterways may disappear.
# Uncovered and ambiguous centers remain visible. This is a display approximation.
#
# The regional preview caps pieces at `MAP_FEATURE_LIMIT`, simplifies only display
# copies, and uses a 300,000-coordinate budget. Oversized display features are
# omitted. White areas in an incomplete regional preview are not missing-source
# evidence. Analytical geometry and GeoParquet exports remain exact; the new
# GeoPackage section separately creates complete generalized presentation layers.

# %%
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from matplotlib.patches import Patch
from overture_lab.visualize import collect_geodataframe

grid = surface_grid(world_surfaces, cell_degrees=WORLD_GRID_DEGREES).toPandas()
colors = {"ocean": "#78bce0", "landmass": "#cfbd8a", "uncovered": "#ffffff", "ambiguous": "#b44477"}
codes = {name: index for index, name in enumerate(colors)}
pixels = grid.surface.map(codes).to_numpy().reshape(int(grid.row.max()) + 1, int(grid.column.max()) + 1)
_, axis = plt.subplots(figsize=(18, 9))
axis.imshow(pixels, origin="lower", extent=(-180, 180, -90, 90),
            interpolation="nearest", cmap=ListedColormap(list(colors.values())), vmin=0, vmax=3)
axis.set_title(f"World: {WORLD_GRID_DEGREES:g}° cell-center overview — display approximation")
axis.set_xlabel("longitude")
axis.set_ylabel("latitude")
axis.legend(handles=[Patch(facecolor=color, edgecolor="gray", label=name) for name, color in colors.items()], loc="lower left")
plt.show()
display({"world_grid_cells": len(grid), "center_classifications": grid.surface.value_counts().to_dict()})

for scope, frame, report, tolerance in (
    ("regional", regional_surfaces, regional_report, REGIONAL_MAP_TOLERANCE),
):
    preview = display_surfaces(frame, limit=settings.map_feature_limit, tolerance=tolerance)
    gdf = collect_geodataframe(preview, limit=settings.map_feature_limit,
                              columns=["surface", "source_id", "geometry"])
    total = sum(row["rows"] for row in report)
    display({"scope": scope, "analytical_rows": total, "displayed_rows": len(gdf),
             "incomplete_preview": len(gdf) < total, "display_tolerance_degrees": tolerance})
    _, axis = plt.subplots(figsize=(18, 12))
    for surface, color in (("ocean", "#78bce0"), ("landmass", "#cfbd8a")):
        subset = gdf[gdf.surface == surface]
        if not subset.empty:
            subset.plot(ax=axis, color=color, linewidth=0)
    bounds = Bounds(-180, -90, 180, 90) if scope == "world" else region_bounds
    axis.set_xlim(bounds.xmin, bounds.xmax)
    axis.set_ylim(bounds.ymin, bounds.ymax)
    axis.set_xlabel("longitude")
    axis.set_ylabel("latitude")
    axis.set_title(f"{scope}: {'INCOMPLETE preview' if len(gdf) < total else 'simplified preview'} — "
                   f"{len(gdf):,} of {total:,} pieces; tan landmass / blue ocean")
    plt.show()

# %% [markdown]
# ## Optional exact GeoParquet exports
#
# Enable `WRITE_DERIVED=true` to save. S3 is the default and requires
# `DERIVED_OUTPUT_URI`; select `DERIVED_OUTPUT_MODE=local` explicitly for local
# output. Each scope receives its own unique release/run directory containing
# exactly one named GeoParquet 1.1 file with Zstandard compression and bbox
# covering metadata. Source attribution, selection filters, release, extent,
# and geometry policy travel inside every row, without a separate sidecar.
#
# All pieces are exported, with no display cap or simplification. A single file
# requires a serial final writer: budget disk and time for the worldwide result.
# Validation reloads the file and checks geometry, bbox, schema, counts, and all
# row fingerprints. A failed write reports its partial prefix; it never switches
# destinations. Exports and caches remain separate from the immutable source.

# %%
world_export = export_surfaces(world_surfaces, spark, settings, scope="world")
display(world_export)
regional_export = export_surfaces(regional_surfaces, spark, settings, scope="regional")
display(regional_export)

# %% [markdown]
# ## GeoPackages for GeoServer: exact plus dissolved presentation layers
#
# Each selected scope gets one named `.gpkg` with `landmass_full`, `ocean_full`,
# and landmass/ocean pairs for every configured level. Detailed layers retain
# all coordinates and attribution; nested `sources` becomes `sources_json`.
# Generalized layers clip to aligned tiles, dissolve by class, then simplify
# shared coastlines together with fixed tile boundaries. Islands/holes are not
# deliberately removed. These approximate geometries are for presentation.
#
# All pieces are processed, independently of display caps. The exporter streams
# exact rows into indexed tables and queries one tile at a time. A tile over the
# coordinate budget or with invalid/nonmatching coverage stops with diagnostics;
# it never drops features, repairs coastlines, or fills source gaps silently.
# Tolerances are in degrees, not metres, and are not error-distance guarantees.
# Some real coastline pieces have different segmentation and tiny numerical
# overlaps. To normalize presentation geometry explicitly, set
# `GPKG_PRECISION_GRID_DEGREES=1e-10`. This rounds and nodes shared boundaries;
# the report records per-class/tile area, component and hole changes. Genuine
# overlaps that remain are rejected. Exact layers never use this normalization.
#
# Install `requirements-geopackage.txt` **inside the notebook runtime** when
# needed. `EXPORT_GEOPACKAGE=False` disables this optional dependency and export.
# Local/S3 routing follows the existing settings, with no fallback. S3 exports
# use local scratch and a downloaded copy for SHA-256 verification, so allow disk
# for two complete files. A dry run performs no GeoPackage writes.
#
# Follow the [GeoServer deployment and styling manual](../docs/geoserver-geopackage.md)
# to publish read-only stores, import the provided SLD styles, and create WMS
# groups that switch detail automatically by scale. S3 files must first be
# downloaded to a filesystem GeoServer can access.

# %%
gpkg_exports = {}
if EXPORT_GEOPACKAGE:
    for scope in dict.fromkeys(GPKG_SCOPES):
        frame = world_surfaces if scope == "world" else regional_surfaces
        bounds = Bounds(-180, -90, 180, 90) if scope == "world" else region_bounds
        gpkg_exports[scope] = export_surface_geopackage(
            frame, spark, settings, scope=scope, bounds=bounds, options=gpkg_options,
            progress=lambda event: print(event, flush=True),
        )
        display(gpkg_exports[scope])
else:
    print("GeoPackage export disabled; exact GeoParquet workflow is unchanged.")

# %% [markdown]
# ### Bounded comparison of locally exported detail levels
#
# Preview the first QA window from a local regional export. Each panel has a
# 300,000-coordinate/500-feature budget; omitted features are reported. The
# exported layers themselves are complete. S3 exports can be previewed after
# downloading the verified file, or through GeoServer using the manual.

# %%
local_gpkg = gpkg_exports.get("regional", {})
if settings.derived_output_mode == "local" and local_gpkg.get("status") == "written":
    import geopandas as gpd
    import shapely
    from overture_lab.geopackage import iter_geopackage_features
    box = qa_windows[0]
    for level in GPKG_LEVELS:
        _, axis = plt.subplots(figsize=(10, 6))
        used = shown = omitted = 0
        for surface in ("ocean", "landmass"):
            shapes = []
            for _, shape in iter_geopackage_features(
                local_gpkg["geopackage_uri"], f"{surface}_{level}",
                bbox=(box.xmin, box.ymin, box.xmax, box.ymax),
            ):
                n = int(shapely.get_num_coordinates(shape))
                if used + n > 300_000 or shown >= 500:
                    omitted += 1
                    continue
                shapes.append(shape)
                used += n
                shown += 1
            if shapes:
                gpd.GeoSeries(shapes, crs="EPSG:4326").plot(ax=axis, color=colors[surface], linewidth=0)
        axis.set_xlim(box.xmin, box.xmax)
        axis.set_ylim(box.ymin, box.ymax)
        axis.set_title(f"{level}: {GPKG_LEVELS[level]:g}° — {shown} pieces, {omitted} omitted in preview")
        plt.show()

# %% [markdown]
# ## Reload later without rescanning the original land and water layers
#
# Use either printed `geoparquet_uri` in a future session. `surface` selects the
# desired class; `bbox` supports candidate pruning. A point exactly on the shared
# coast can intersect both classes, so applications must define their own boundary
# tie policy. Polygon piece counts are not counts of continents or named oceans.

# %%
if regional_export["status"] == "written":
    restored = spark.read.format("geoparquet").load(regional_export["geoparquet_uri"])
    restored.where("surface = 'ocean'").groupBy("scope", "surface").count().show()
    # An illustrative point-in-surface join; boundary matches are retained.
    points = spark.createDataFrame([(center_x, center_y)], "longitude double, latitude double").selectExpr(
        "ST_SetSRID(ST_Point(longitude, latitude), 4326) AS point_geometry")
    points.join(restored, F.expr("ST_Intersects(point_geometry, geometry)"), "left").select(
        "surface", "source_id").show()
else:
    print("Dry run: enable WRITE_DERIVED to obtain a verified URI for later reload.")

# %%
display({"total_seconds": round(time.perf_counter() - started, 3),
         "world": world_report, "regional": regional_report, "coverage": qa_reports})
world_surfaces.unpersist()
regional_surfaces.unpersist()
# Leave the shared notebook Spark context available for further analysis.
