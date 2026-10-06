"""Bounded display preparation for the three configured geographic scopes."""

from __future__ import annotations

from dataclasses import dataclass
from typing import TYPE_CHECKING

from .config import WmsSettings
from .visualize import build_interactive_deck, collect_geodataframe

if TYPE_CHECKING:
    from geopandas import GeoDataFrame
    from .config import LabSettings
    from .regions import ScaleRegions


PUBLIC_OSM_WMS = WmsSettings(
    url="https://ows.terrestris.de/osm/service",
    layers=("OSM-WMS",),
    srs="EPSG:3857",
)
PUBLIC_OSM_ATTRIBUTION = (
    "© OpenStreetMap contributors, © Natural Earth Data, "
    "© GEBCO Bathymetric Compilation Group 2019, © terrestris"
)
COLORS = {"large": [46, 139, 87], "medium": [121, 73, 177], "cities": [230, 126, 34]}


def overview_basemap(mode: str, configured: WmsSettings | None, attribution: str = ""):
    if mode == "public_osm":
        return PUBLIC_OSM_WMS, PUBLIC_OSM_ATTRIBUTION
    if mode == "none":
        return None, ""
    if mode == "configured":
        if configured is None:
            raise ValueError("BASEMAP_MODE='configured' requires WMS_URL and WMS_LAYERS")
        return configured, attribution
    raise ValueError("BASEMAP_MODE must be 'public_osm', 'configured', or 'none'")


def check_overview_limit(counts: dict[str, int], limit: int) -> int:
    """Count every rendered polygon and marker, including overlapping groups."""
    total = sum(counts.values())
    if total > limit:
        raise ValueError(
            f"Region overview needs {total} features but MAP_FEATURE_LIMIT={limit}. "
            "Increase MAP_FEATURE_LIMIT to show every configured area; "
            "no areas have been silently omitted. Counts: " + str(counts)
        )
    return total


def _map_bounds(gdf) -> list[list[float]]:
    xmin, ymin, xmax, ymax = (float(value) for value in gdf.total_bounds)
    return [[xmin, ymin], [xmax, ymax]]


@dataclass
class RegionOverview:
    large: "GeoDataFrame"
    medium: "GeoDataFrame"
    cities: "GeoDataFrame"
    markers: list[dict]
    city_views: list[dict]
    counts: dict[str, int]
    extent_label: str


def prepare_region_overview(
    regions: "ScaleRegions", settings: "LabSettings",
) -> RegionOverview:
    """Preserve every source boundary coordinate; require the large preset."""
    import shapely
    from pyspark.sql import functions as F

    if settings.region_preset != "large":
        raise ValueError("Region overview requires load_settings(region_preset='large')")
    countries = regions.medium
    medium = countries.where(F.col("country").isin(*settings.medium_state_codes))
    counts = {
        "large_country_areas": countries.count(),
        "medium_country_areas": medium.count(),
        "city_areas": regions.small.count(),
        "city_markers": len(settings.small_cities),
    }
    check_overview_limit(counts, settings.map_feature_limit)

    country_display = countries.select(
        "country",
        F.coalesce(F.element_at("names.common", F.lit("en")),
                   F.col("names.primary"), F.col("country")).alias("display_name"),
        "geometry",
    )
    large_gdf = collect_geodataframe(
        country_display, settings.map_feature_limit, ["country", "display_name"]
    )
    large_gdf["membership"] = large_gdf["country"].map(
        lambda code: "Medium + large" if code in settings.medium_state_codes else "Large"
    )
    large_gdf["extent"] = settings.region_extent_label
    medium_gdf = large_gdf[large_gdf["country"].isin(settings.medium_state_codes)].copy()
    city_display = regions.small.select(
        "division_id", "country", "geometry",
    )
    cities_gdf = collect_geodataframe(
        city_display, settings.map_feature_limit, ["division_id", "country"]
    )
    specs = dict(zip(regions.small_division_ids, settings.small_cities, strict=True))
    cities_gdf["display_name"] = cities_gdf["division_id"].map(
        lambda division_id: specs[division_id].name
    )
    cities_gdf["membership"] = "Small cities (medium + large)"
    cities_gdf["extent"] = "Land only"
    markers, city_views = [], []
    for division_id, city in specs.items():
        parts = cities_gdf[cities_gdf["division_id"] == division_id]
        point = shapely.union_all(parts.geometry).representative_point()
        markers.append({
            "position": [point.x, point.y], "division_id": division_id,
            "display_name": city.name, "country": city.state_code,
            "membership": "Small cities (medium + large)",
            "extent": "Land only",
        })
        city_views.append({
            "id": division_id, "label": f"{city.name} ({city.state_code})",
            "bounds": _map_bounds(parts),
        })
    return RegionOverview(
        large_gdf, medium_gdf, cities_gdf, markers, city_views, counts,
        settings.region_extent_label,
    )


def build_region_overview_deck(overview: RegionOverview, *, wms: WmsSettings | None = None):
    """Return the map and control metadata for the embedded HTML renderer."""
    import pydeck as pdk

    layers, groups = [], []
    for group, label, frame in (
        ("large", "Large region", overview.large),
        ("medium", "Medium region", overview.medium),
        ("cities", "Small cities", overview.cities),
    ):
        layer_id = f"overview-{group}"
        layers.append(pdk.Layer(
            "GeoJsonLayer", frame.__geo_interface__, id=layer_id,
            pickable=True, stroked=True, filled=True,
            get_fill_color=COLORS[group] + [45 if group == "large" else 80],
            get_line_color=COLORS[group] + [230],
            line_width_min_pixels=1.5 if group == "large" else 2,
        ))
        groups.append({"id": group, "label": label, "layer_ids": [layer_id], "color": COLORS[group]})
    layers.append(pdk.Layer(
        "ScatterplotLayer", overview.markers, id="overview-city-markers",
        pickable=True, filled=True, stroked=True,
        get_position="position", get_radius=1, radius_min_pixels=7,
        get_fill_color=COLORS["cities"] + [255],
        get_line_color=[90, 40, 0, 255], line_width_min_pixels=1,
    ))
    groups[-1]["layer_ids"].append("overview-city-markers")
    if wms is not None:
        groups.append({"id": "background", "label": "WMS background", "layer_ids": ["airgap-wms-background"]})
    bounds = _map_bounds(overview.large)
    deck = build_interactive_deck(
        layers,
        pdk.ViewState(longitude=(bounds[0][0] + bounds[1][0]) / 2,
                      latitude=(bounds[0][1] + bounds[1][1]) / 2, zoom=3),
        wms=wms,
        tooltip={"text": "{display_name}\nCode: {country}\n{membership}\nExtent: {extent}"},
    )
    controls = {"groups": groups,
                "description": f"Country extent: {overview.extent_label}. Cities: land only.",
                "views": {"large": bounds, "medium": _map_bounds(overview.medium)},
                "cities": overview.city_views}
    return deck, controls
