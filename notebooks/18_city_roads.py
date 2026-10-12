# %% [markdown]
# # 18 — Roads in and around a city
#
# Find a city in Overture, expand its **complete land boundary by a buffer in
# metres**, and query every intersecting road segment. The default is **Ofakim
# (אופקים), Israel, plus 2 km**, with ordinary car-road classes selected.
#
# This is a visual road inventory. Class selection does not evaluate private
# access, closures, conditional restrictions, road surfaces, or turn rules, and
# does not establish that a car may legally or physically use every segment.
# Coverage is limited to the configured Overture release.
# [Overture road classes and restrictions](https://docs.overturemaps.org/guides/transportation/roads/)

# %% [markdown]
# ## 1. Choose the city, buffer, and road types
#
# Names match primary, common multilingual, or alternate/rule names, ignoring
# case and surrounding whitespace. Use `CITY_NAME = "אופקים"` for the same
# Hebrew example. If several localities match, the error lists candidate IDs;
# set `CITY_DIVISION_ID` to one of those IDs. An ID supersedes the name but still
# must match the country and locality subtype. A missing boundary stops the
# notebook instead of substituting a point or a different city.
#
# `ROAD_CLASSES = CAR_ROAD_CLASSES` selects motorway, trunk, primary, secondary,
# tertiary, residential, living_street, service, and unclassified roads,
# including their links/ramps. Tracks, unknown classes, and walking/cycling
# paths are excluded by default. Use a custom tuple such as `("primary",
# "secondary")`, or `None` for every road class (including paths).
#
# `BASEMAP_MODE = "none"` is completely offline. `configured` uses the lab's
# WMS; `public_osm` explicitly enables public imagery requests from the browser.

# %%
from pyspark import StorageLevel
from pyspark.sql import functions as F

from overture_lab.city_roads import CAR_ROAD_CLASSES, prepare_city_area, select_city_roads, city_roads_map
from overture_lab.config import load_settings
from overture_lab.region_overview import overview_basemap
from overture_lab.spark import create_sedona, read_type
from overture_lab.visualize import offline_deck_display

CITY_NAME = "Ofakim"
COUNTRY_CODE = "IL"
CITY_DIVISION_ID = None
BUFFER_METERS = 2000
ROAD_CLASSES = CAR_ROAD_CLASSES
MAP_FEATURE_LIMIT = 50_000  # Display only; the query always returns all matches.
BASEMAP_MODE = "none"
CONFIGURED_WMS_ATTRIBUTION = ""

settings = load_settings()
wms, attribution = overview_basemap(BASEMAP_MODE, settings.wms, CONFIGURED_WMS_ATTRIBUTION)
spark = create_sedona(settings, "18-city-roads")
display({"release": settings.release, "city": CITY_NAME, "country": COUNTRY_CODE,
         "division_id_override": CITY_DIVISION_ID, "buffer_meters": BUFFER_METERS,
         "road_classes": ROAD_CLASSES, "map_feature_limit": MAP_FEATURE_LIMIT})

# %% [markdown]
# ## 2. Resolve the city and construct the search area
#
# All land-area parts belonging to the selected locality are unioned. Buffering
# uses a city-centred azimuthal equidistant projection with metre units, then
# transforms back to EPSG:4326. It never treats degrees as metres. Zero keeps
# the original city boundary. Negative/nonfinite buffers and invalid boundaries
# fail explicitly. Dateline-spanning areas need a separate wrapping workflow.
# Only the single city polygon is collected to construct this buffer.

# %%
divisions = read_type(spark, settings, "divisions", "division")
division_areas = read_type(spark, settings, "divisions", "division_area")
city_area = prepare_city_area(
    divisions, division_areas, city_name=CITY_NAME, country_code=COUNTRY_CODE,
    division_id=CITY_DIVISION_ID, buffer_m=BUFFER_METERS,
)
display({"resolved_name": city_area.name, "division_id": city_area.division_id,
         "country": city_area.country, "query_bounds": city_area.bounds.as_dict(),
         "buffer_projection": city_area.metric_crs})

# %% [markdown]
# ## 3. Query all matching road segments
#
# Parquet-friendly **bbox overlap** prunes candidates before an exact
# intersection with the buffered city polygon. Overlap retains roads crossing
# the area even when both endpoints are outside it. Original geometries and all
# source fields remain unchanged: roads are not clipped or reconstructed.
# Some displayed road tails may therefore extend beyond the buffer.
#
# `roads` is the complete Spark DataFrame. No analytical sampling or browser
# limit is applied to the query or these counts. Counts describe source segments,
# not distinct named streets. An empty custom class list selects no roads.

# %%
segments = read_type(spark, settings, "transportation", "segment")
roads = select_city_roads(segments, city_area, road_classes=ROAD_CLASSES).persist(StorageLevel.MEMORY_AND_DISK)
road_count = roads.count()
class_counts = roads.groupBy("class").count().orderBy(F.desc("count"), "class")
display({"matching_road_segments": road_count, "sampling": "none"})
display(class_counts.toPandas())
if road_count == 0:
    print("No roads match this city, buffer, and class selection in this release. The map still shows the search area.")

# %% [markdown]
# ## 4. Explore the roads
#
# Toggle the city boundary, search area, and each road class. Hover over a road
# for its source name, class, and ID. View buttons fit either the search area or
# all whole road segments. Rendering uses the existing bundled offline renderer.
#
# If more than `MAP_FEATURE_LIMIT` roads match, this cell reports the full count
# and stops before collecting roads to the browser. Narrow the selection or
# explicitly increase the limit and rerun this cell. The complete `roads`
# DataFrame and summary above remain available; nothing is silently truncated.

# %%
deck, controls = city_roads_map(roads, city_area, feature_limit=MAP_FEATURE_LIMIT, wms=wms)
display(offline_deck_display(deck, height=760, controls=controls,
    attribution=f"Overture Maps — {settings.release}. {attribution}"))

# %% [markdown]
# ## 5. Release resources when finished
#
# Keep this cell unexecuted while querying `roads` further. After stopping Spark,
# rerun from configuration before rebuilding the results. No export is written.

# %%
roads.unpersist()
spark.stop()
