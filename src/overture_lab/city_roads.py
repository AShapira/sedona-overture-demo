"""Complete city-road selection with bounded, offline-capable visualization."""

from __future__ import annotations

from dataclasses import dataclass
import math
from typing import TYPE_CHECKING

from .regions import Bounds, bbox_overlap, exact_intersection

if TYPE_CHECKING:
    from pyspark.sql import DataFrame


CAR_ROAD_CLASSES = (
    "motorway", "trunk", "primary", "secondary", "tertiary", "residential",
    "living_street", "service", "unclassified",
)


@dataclass(frozen=True)
class CityRoadArea:
    division_id: str
    name: str
    country: str
    boundary: "DataFrame"
    search_area: "DataFrame"
    bounds: Bounds
    metric_crs: str


def resolve_city(divisions, *, city_name, country_code, division_id=None):
    """Resolve exactly one locality; an explicit ID supersedes the name."""
    from pyspark.sql import functions as F
    from pyspark.sql.types import StructType

    country = country_code.strip().upper()
    if len(country) != 2 or not country.isascii() or not country.isalpha():
        raise ValueError("COUNTRY_CODE must be a two-letter Overture country code")
    if not division_id and not city_name.strip():
        raise ValueError("CITY_NAME or CITY_DIVISION_ID is required")

    def has(path):
        dtype = divisions.schema
        for part in path.split("."):
            if not isinstance(dtype, StructType) or part not in dtype.names:
                return False
            dtype = dtype[part].dataType
        return True

    empty = F.array().cast("array<string>")
    primary = F.col("names.primary") if has("names.primary") else F.lit(None).cast("string")
    names = F.array(primary)
    if has("names.common"):
        names = F.concat(names, F.coalesce(F.map_values("names.common"), empty))
    if has("names.rules"):
        names = F.concat(names, F.coalesce(F.transform("names.rules", lambda x: x["value"]), empty))
    candidates = divisions.where((F.col("country") == country) & (F.col("subtype") == "locality"))
    if division_id:
        candidates = candidates.where(F.col("id") == division_id.strip())
    else:
        candidates = candidates.where(F.exists(
            names, lambda x: F.lower(F.trim(x)) == F.lit(city_name.strip().lower())))
    matches = candidates.select("id", "country", primary.alias("name")).orderBy("id").limit(21).collect()
    if len(matches) != 1:
        shown = [row.asDict() for row in matches[:20]]
        count = "at least 21" if len(matches) == 21 else str(len(matches))
        raise ValueError(
            f"Expected one locality for {division_id or city_name!r} in {country}; found {count}. "
            f"Candidates (up to 20): {shown}. Check the name/country or set CITY_DIVISION_ID."
        )
    return matches[0]


def prepare_city_area(divisions, areas, *, city_name, country_code, division_id=None, buffer_m=2000):
    """Union all land parts and buffer in a city-centred metric projection.

    Only the single resolved city polygon is collected, never regional roads.
    Azimuthal equidistant avoids UTM zone/polar selection and uses metres.
    Dateline-spanning boundaries require a separate wrapping workflow.
    """
    import shapely
    from shapely.ops import transform
    from pyproj import CRS, Transformer
    from pyspark.sql import functions as F

    if isinstance(buffer_m, bool) or not isinstance(buffer_m, (int, float)) or not math.isfinite(buffer_m) or buffer_m < 0:
        raise ValueError("BUFFER_METERS must be a finite, nonnegative number")
    city = resolve_city(divisions, city_name=city_name, country_code=country_code, division_id=division_id)
    parts = areas.where((F.col("division_id") == city.id) & F.col("is_land"))
    if not parts.limit(1).count():
        raise ValueError(f"No land boundary exists for {city.name!r} ({city.id}); cannot buffer this city")
    if parts.where("geometry IS NULL OR ST_IsEmpty(geometry) OR NOT ST_IsValid(geometry)").limit(1).count():
        raise ValueError(f"Invalid or empty land boundary for {city.id}")
    wkb = parts.agg(F.expr("ST_AsBinary(ST_Union_Agg(geometry))").alias("wkb")).first().wkb
    boundary = shapely.from_wkb(bytes(wkb))
    if boundary.geom_type not in {"Polygon", "MultiPolygon"} or not boundary.is_valid:
        raise ValueError(f"Expected a valid polygon boundary for {city.id}")
    xmin, ymin, xmax, ymax = boundary.bounds
    if xmax - xmin > 180 or not (-180 <= xmin <= xmax <= 180 and -90 <= ymin <= ymax <= 90):
        raise ValueError("City boundary must use longitude/latitude without spanning the antimeridian")
    center = boundary.centroid
    crs = CRS.from_proj4(f"+proj=aeqd +lat_0={center.y} +lon_0={center.x} +datum=WGS84 +units=m +no_defs")
    project = Transformer.from_crs("EPSG:4326", crs, always_xy=True).transform
    unproject = Transformer.from_crs(crs, "EPSG:4326", always_xy=True).transform
    buffered = transform(unproject, transform(project, boundary).buffer(buffer_m)) if buffer_m else boundary
    if buffered.is_empty or not buffered.is_valid or not all(math.isfinite(v) for v in buffered.bounds):
        raise ValueError("Buffer produced an invalid geometry; reduce BUFFER_METERS")
    if buffered.bounds[2] - buffered.bounds[0] > 180:
        raise ValueError("Buffered area crosses the antimeridian; reduce BUFFER_METERS")

    def frame(geometry):
        return divisions.sparkSession.createDataFrame(
            [(bytes(shapely.to_wkb(geometry)),)], "wkb binary"
        ).selectExpr("ST_SetSRID(ST_GeomFromWKB(wkb), 4326) AS geometry")

    return CityRoadArea(city.id, city.name or city_name, city.country,
                       frame(boundary), frame(buffered), Bounds(*buffered.bounds), crs.to_string())


def select_city_roads(segments, area, *, road_classes=CAR_ROAD_CLASSES):
    """Return all intersecting road segments with their source fields unchanged.

    None includes all road classes, including footpaths. An empty list is an
    explicit empty selection. Class filtering does not evaluate vehicle access.
    """
    from pyspark.sql import functions as F

    candidates = bbox_overlap(segments, area.bounds).where(F.col("subtype") == "road")
    if road_classes is not None:
        if isinstance(road_classes, str) or any(not isinstance(c, str) or not c.strip() for c in road_classes):
            raise ValueError("ROAD_CLASSES must be None or a list/tuple of nonempty class names")
        candidates = candidates.where(F.col("class").isin(*road_classes))
    return exact_intersection(candidates, area.search_area)


def city_roads_map(roads, area, *, feature_limit=50_000, wms=None):
    """Map every selected segment or fail before collection; never sample."""
    import pydeck as pdk
    from pyspark.sql import functions as F
    from .visualize import build_interactive_deck, collect_geodataframe

    if isinstance(feature_limit, bool) or not isinstance(feature_limit, int) or feature_limit < 1:
        raise ValueError("MAP_FEATURE_LIMIT must be a positive integer")
    count = roads.count()
    if count > feature_limit:
        raise ValueError(f"Map requires {count:,} road segments; MAP_FEATURE_LIMIT={feature_limit:,}. "
                         "Narrow the area/classes or explicitly raise the limit. "
                         "The roads Spark DataFrame and counts still contain every match.")
    view_roads = roads.select("id", "class", "geometry", F.coalesce(
        F.col("names.primary"), F.lit("Unnamed road")).alias("name"))
    frame = collect_geodataframe(view_roads.orderBy("id"), feature_limit,
                                 ["id", "name", "class", "geometry"]).rename(columns={"id": "source_id"})
    frame["class"] = frame["class"].fillna("unknown")
    layers, groups = [], []
    for key, label, data, color in (
        ("buffer", "Search area", area.search_area, [110, 90, 190]),
        ("boundary", "City boundary", area.boundary, [35, 80, 90]),
    ):
        outline = collect_geodataframe(data, 1, ["geometry"])
        identifier = f"city-roads-{key}"
        layers.append(pdk.Layer("GeoJsonLayer", outline.__geo_interface__, id=identifier,
                                filled=False, stroked=True, get_line_color=color, line_width_min_pixels=2))
        groups.append({"id": key, "label": label, "layer_ids": [identifier], "color": color})
    palette = [[210, 60, 55], [225, 125, 25], [175, 140, 0], [40, 140, 65],
               [0, 135, 160], [50, 95, 200], [135, 65, 185], [175, 65, 125], [100, 100, 100]]
    order = list(CAR_ROAD_CLASSES) + sorted(set(frame["class"]) - set(CAR_ROAD_CLASSES))
    for index, road_class in enumerate(order):
        subset = frame.loc[frame["class"] == road_class]
        if subset.empty:
            continue
        identifier = f"city-roads-class-{index}"
        color = palette[index % len(palette)]
        layers.append(pdk.Layer("GeoJsonLayer", subset.__geo_interface__, id=identifier,
                                pickable=True, auto_highlight=True, get_line_color=color,
                                line_width_min_pixels=2))
        groups.append({"id": identifier, "label": f"{road_class} ({len(subset):,})",
                       "layer_ids": [identifier], "color": color})
    if wms:
        groups.append({"id": "background", "label": "WMS background", "layer_ids": ["airgap-wms-background"]})
    b = area.bounds
    span = max(b.xmax - b.xmin, (b.ymax - b.ymin) * 1.4, 0.001)
    deck = build_interactive_deck(layers, pdk.ViewState(
        longitude=(b.xmin + b.xmax) / 2, latitude=(b.ymin + b.ymax) / 2,
        zoom=max(1, min(17, math.log2(360 / span) - 1.1))), wms=wms,
        tooltip={"text": "{name}\nClass: {class}\nID: {source_id}"})
    views = {"City + buffer": [[b.xmin, b.ymin], [b.xmax, b.ymax]]}
    if not frame.empty:
        xmin, ymin, xmax, ymax = map(float, frame.total_bounds)
        views["Whole road segments"] = [[min(xmin, b.xmin), min(ymin, b.ymin)],
                                         [max(xmax, b.xmax), max(ymax, b.ymax)]]
    controls = {"groups": groups, "views": views, "cities": [],
                "description": f"{area.name}: {count:,} whole road segments. "
                               "Class selection is not vehicle-access verification."}
    return deck, controls
