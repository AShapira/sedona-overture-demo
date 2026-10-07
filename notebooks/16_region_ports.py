# %% [markdown]
# # 16 — Regional ports, harbors, and maritime components
#
# **Engine:** SedonaSpark. **Inputs:** Places, Base land use, infrastructure,
# water, and country division areas from the configured release.
# **Output:** one local `exports/region_ports.geoparquet` and an interactive map.
#
# Search all regional records, with no analytical sample limit. Explicit
# classifications/tags and name-based candidates remain distinguishable.
# These are source features, not a census of unique real-world ports: multiple
# records may describe one site, and a pier or ferry landing may stand alone.
# Overture coverage and the editable discovery vocabulary limit completeness.

# %% [markdown]
# ## 1. Configuration
#
# Use the same medium/large country codes as the other regional notebooks.
# Territorial extents include coastal water; setting the flag False restricts
# selection to land-intersecting records. Source geometries are retained whole.
# Export is enabled here independently of other notebooks' WRITE_DERIVED flag.
# Reruns refuse to replace an existing file unless OVERWRITE is explicitly True.
# `configured` uses the lab's WMS; `none` is entirely offline; `public_osm`
# requests public map imagery from the browser. No live taxonomy download is needed.

# %%
from functools import reduce
from pathlib import Path

from pyspark import StorageLevel
from pyspark.sql import functions as F

import overture_lab
from overture_lab.config import load_settings
from overture_lab.ports import (
    DEFAULT_SITE_LABELS, DEFAULT_COMPONENT_LABELS, DEFAULT_NAME_TERMS, DEFAULT_NAME_EXCLUDED_LABELS,
    DEFAULT_TAG_RULES, discover_ports, validate_ports, export_ports, ports_map,
)
from overture_lab.region_overview import overview_basemap
from overture_lab.regions import Bounds, bbox_overlap, exact_intersection, select_country_areas
from overture_lab.spark import create_sedona, read_type
from overture_lab.visualize import offline_deck_display

REGION_PRESET = "medium"  # "medium" or "large"
INCLUDE_TERRITORIAL_WATERS = True
WRITE_PORTS = True
OVERWRITE = False
OUTPUT_PATH = Path(overture_lab.__file__).resolve().parents[2] / "exports/region_ports.geoparquet"
BASEMAP_MODE = "none"  # "configured", "none", or "public_osm"
CONFIGURED_WMS_ATTRIBUTION = ""

# All semantic discovery rules are editable here. Exact category labels cover
# legacy/new taxonomies where present; names also search common/rule variants.
# English, Hebrew, and Arabic defaults reflect the configured regional scope.
SITE_LABELS = DEFAULT_SITE_LABELS
COMPONENT_LABELS = DEFAULT_COMPONENT_LABELS
NAME_TERMS = DEFAULT_NAME_TERMS
NAME_EXCLUDED_LABELS = DEFAULT_NAME_EXCLUDED_LABELS
TAG_RULES = DEFAULT_TAG_RULES.copy()

settings = load_settings(region_preset=REGION_PRESET,
                         include_territorial_waters=INCLUDE_TERRITORIAL_WATERS)
MAP_FEATURE_LIMIT = settings.map_feature_limit  # Increase explicitly to display larger results.
wms, attribution = overview_basemap(BASEMAP_MODE, settings.wms, CONFIGURED_WMS_ATTRIBUTION)
display({"release": settings.release, "region_codes": settings.region_state_codes,
         "extent": settings.region_extent_label, "output": str(OUTPUT_PATH),
         "write_ports": WRITE_PORTS, "overwrite": OVERWRITE,
         "map_feature_limit": MAP_FEATURE_LIMIT})
if WRITE_PORTS and OUTPUT_PATH.exists() and not OVERWRITE:
    raise FileExistsError(f"{OUTPUT_PATH} exists; choose another path or set OVERWRITE=True")
spark = create_sedona(settings, "16-region-ports")

# %% [markdown]
# ## 2. Resolve the configured region
#
# Missing country codes fail clearly. Source bounding boxes prune each data
# scan, then exact intersection removes bbox false positives without clipping.

# %%
selected_regions = select_country_areas(
    read_type(spark, settings, "divisions", "division_area"), settings.region_state_codes,
    include_territorial_waters=settings.include_territorial_waters,
).select("country", "bbox", "geometry").persist(StorageLevel.MEMORY_AND_DISK)
region_bounds = tuple(Bounds(row.xmin, row.ymin, row.xmax, row.ymax)
                      for row in selected_regions.select("bbox.*").collect())
boundary = selected_regions.agg(F.expr("ST_Union_Agg(geometry)").alias("geometry"))
display({"resolved_codes": sorted(row.country for row in selected_regions.select("country").distinct().collect())})

# %% [markdown]
# ## 3. Discover sites and components
#
# Explicit Base classes include marinas, naval bases, ferry terminals, piers,
# quays, breakwaters, and dock water areas. Places use exact category labels;
# broad service categories alone do not establish a physical port.
# Tag matching uses known maritime keys/values. Name matches are candidates,
# including possible businesses named after a port, and need review.
# Generic industrial/military areas and bays require maritime evidence.
# Aviation classifications and unrelated infrastructure such as bus stops are
# excluded from name-only matching; explicit maritime tags remain discoverable.
# No nearest-port association or spatial merging is inferred.
# Missing optional name/category/tag fields are tolerated; missing input layers
# fail rather than silently producing an incomplete inventory.

# %%
parts = []
for theme, feature_type in (("base", "land_use"), ("base", "infrastructure"),
                            ("base", "water"), ("places", "place")):
    raw = read_type(spark, settings, theme, feature_type)
    candidates = discover_ports(
        bbox_overlap(raw, region_bounds), theme=theme, feature_type=feature_type,
        release=settings.release, site_labels=SITE_LABELS, component_labels=COMPONENT_LABELS,
        name_terms=NAME_TERMS, tag_rules=TAG_RULES, name_excluded_labels=NAME_EXCLUDED_LABELS,
    )
    parts.append(exact_intersection(candidates, selected_regions))

ports = reduce(lambda left, right: left.unionByName(right), parts).dropDuplicates(
    ["source_theme", "source_type", "id"]
).persist(StorageLevel.MEMORY_AND_DISK)
port_feature_count = validate_ports(ports)
display({"matched_source_features": port_feature_count,
         "note": "These are feature counts, not unique real-world port counts."})
ports.groupBy("source_theme", "source_type", "feature_role", "evidence_level").count().orderBy(
    "source_theme", "source_type", "feature_role", "evidence_level"
).show(100, truncate=False)
ports.select("id", "name", "class", "feature_role", "evidence_level", "match_evidence").show(30, truncate=False)
if port_feature_count == 0:
    print("No ports matched in this release/region. The export will still contain a valid empty GeoParquet.")

# %% [markdown]
# ## 4. Save all results to one GeoParquet
#
# Mixed geometry types share one EPSG:4326 geometry column. Common fields carry
# identity, classification, role, evidence, release, and provenance. Additional
# original attributes are retained in `source_attributes_json`, with original
# provenance also available as `sources_json`.
# The shared exporter writes and validates a temporary GeoParquet 1.1 file,
# then promotes it atomically to the selected path. Staging is cleaned up.
# Export precedes map collection, so browser budgets never truncate the file.

# %%
export_result = (export_ports(ports, spark, settings, OUTPUT_PATH, overwrite=OVERWRITE)
                 if WRITE_PORTS else {"status": "disabled", "row_count": port_feature_count})
display(export_result)

# %% [markdown]
# ## 5. Explore the complete result
#
# Toggle explicit sites, candidate sites, components, and the regional boundary.
# Hover to inspect source IDs and discovery evidence. The map retains original
# geometries. If the result exceeds MAP_FEATURE_LIMIT, increase that setting and
# rerun this cell; the export above is already complete. No silent sampling occurs.

# %%
deck, controls = ports_map(ports, boundary, feature_limit=MAP_FEATURE_LIMIT, wms=wms)
display(offline_deck_display(deck, height=760, controls=controls, attribution=attribution))

# %% [markdown]
# ## 6. Release cached data
#
# Run this after exploring. Rerun selection before rebuilding the map if needed.

# %%
ports.unpersist()
selected_regions.unpersist()
spark.stop()
