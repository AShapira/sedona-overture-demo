# %% [markdown]
# # 13 — Medium, large, and city regions on one map
#
# **Execution engine:** SedonaSpark for division resolution; PyDeck for the map.
# **Inputs:** `divisions/division` and `divisions/division_area` only.
# **Outputs:** a configuration summary and one interactive map; no dataset exports.
#
# All configured country and city boundaries are shown together. Country codes
# identify areas in the selected Overture release. The public WMS is visual
# context; the colored overlays come from the local or S3A Overture source.

# %% [markdown]
# ## 1. Configuration and background
#
# `public_osm` uses the public terrestris OpenStreetMap WMS and requires internet
# access from the notebook browser. Its renderer is embedded locally.
# `configured` uses `WMS_URL`, `WMS_LAYERS`, and `WMS_SRS` for an internal WMS;
# set its attribution below. `none` makes no background requests.
#
# The large preset is required because this notebook compares all three scopes.
# Region and city borders retain every source coordinate without simplification.
# `INCLUDE_TERRITORIAL_WATERS=True` uses full territorial country extents.
# Set it to `False` for land-only countries, then rerun the notebook.
# City boundaries remain land-only in both modes.

# %%
from dataclasses import asdict

from overture_lab.config import load_settings
from overture_lab.regions import resolve_scale_regions
from overture_lab.region_overview import (
    overview_basemap, prepare_region_overview, build_region_overview_deck,
)
from overture_lab.spark import create_sedona
from overture_lab.visualize import offline_deck_display

BASEMAP_MODE = "public_osm"  # "public_osm", "configured", or "none"
CONFIGURED_WMS_ATTRIBUTION = ""

INCLUDE_TERRITORIAL_WATERS = True  # False selects land-only country boundaries
settings = load_settings(
    region_preset="large",
    include_territorial_waters=INCLUDE_TERRITORIAL_WATERS,
)
wms, attribution = overview_basemap(BASEMAP_MODE, settings.wms, CONFIGURED_WMS_ATTRIBUTION)
display({
    "release": settings.release,
    "MEDIUM_STATE_CODES": settings.medium_state_codes,
    "LARGE_REGION_STATE_CODES": settings.large_region_state_codes,
    "SMALL_CITIES": [asdict(city) for city in settings.small_cities],
    "MAP_FEATURE_LIMIT": settings.map_feature_limit,
    "INCLUDE_TERRITORIAL_WATERS": settings.include_territorial_waters,
    "country_extent": settings.region_extent_label,
    "background": BASEMAP_MODE,
})
spark = create_sedona(settings, "13-region-overview")

# %% [markdown]
# ## 2. Resolve every configured boundary
#
# The shared resolver checks that every large-region code has a country
# area in the selected extent mode and every configured city resolves uniquely. Medium boundaries are a
# subset of these same country areas, while city selection stays unchanged.

# %%
regions = resolve_scale_regions(spark, settings)
overview = prepare_region_overview(regions, settings)
display({
    "medium_codes_resolved": sorted(overview.medium["country"].unique()),
    "large_codes_resolved": sorted(overview.large["country"].unique()),
    "cities_resolved": [city["label"] for city in overview.city_views],
    "feature_counts": overview.counts,
    "total_rendered_features": sum(overview.counts.values()),
})

# %% [markdown]
# ## 3. Explore the three scopes
#
# Green is the complete large region; purple shows medium on top; orange shows
# cities and their markers. Each checkbox controls a complete group. Hiding
# medium reveals its countries in the large layer beneath it. Hover for names,
# codes, and membership; use the buttons to fit a region or a selected city.
#
# Pan, zoom, and layer controls operate entirely in the browser without rerunning
# Spark. If the WMS is unavailable, the region overlays remain usable.
# The coordinate count is reported before drawing and shown above the map.
# It updates when layers are hidden or shown; repeated borders in different
# layers and polygon closing coordinates are counted separately.

# %%
deck, map_controls = build_region_overview_deck(overview, wms=wms)
map_display = offline_deck_display(
    deck, height=760, controls=map_controls, attribution=attribution,
)
display(map_display)

# %% [markdown]
# ## Collection and source boundaries
#
# `MAP_FEATURE_LIMIT` counts polygons in each layer and city markers, including
# countries drawn in both medium and large. Exceeding it stops with an explicit
# error rather than dropping an area. Full-resolution source boundaries cross
# into the browser. Larger coordinate counts can take longer to render; region
# borders are never simplified to reduce that count.
#
# Public background: [terrestris free OSM WMS](https://terrestris.de/en/products/free-osm-wms/).
# Its attribution is displayed below the map. Other notebooks keep their own
# background choices. This notebook never invokes dataset export functions.
