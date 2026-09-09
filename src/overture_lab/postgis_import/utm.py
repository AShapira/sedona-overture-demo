"""WGS84 UTM policy and per-feature projection; no remote grid downloads."""
from __future__ import annotations

import math

METRIC_CRS = {"mode": "per_feature_utm", "srid_column": "geometry_m_srid"}
UTM_POLICY = {
    "datum": "WGS84", "zone_rule": "standard_6_degree_longitude",
    "representative_point": "point_on_surface", "latitude_range": [-80.0, 84.0],
    "equator": "north", "longitude_180_zone": 60,
    "crossing": "whole_geometry_flagged",
}
STATUSES = {"ok", "null_geometry", "empty_geometry", "invalid_geometry",
            "outside_utm", "projection_failed"}


def utm_srid(longitude, latitude):
    if not (math.isfinite(longitude) and math.isfinite(latitude)
            and -180 <= longitude <= 180 and -80 <= latitude <= 84):
        raise ValueError("Coordinates outside WGS84 UTM coverage")
    zone = min(60, math.floor((longitude + 180) / 6) + 1)
    return (32600 if latitude >= 0 else 32700) + zone


def valid_utm_srid(srid):
    return type(srid) is int and (32601 <= srid <= 32660 or 32701 <= srid <= 32760)


def bbox_utm_srids(bbox):
    """Zones touching the closed bbox, including its boundary points."""
    w, s, e, n = bbox
    if n < -80 or s > 84:
        return []
    zones = range(utm_srid(w, 0) - 32600, utm_srid(e, 0) - 32600 + 1)
    hemispheres = ([32700] if s < 0 else []) + ([32600] if n >= 0 else [])
    return sorted(base + zone for base in hemispheres for zone in zones)


def geography_eligible(geom):
    """Mirror the generated-column predicate without coercing coordinates."""
    from shapely import get_coordinates
    if geom is None or geom.is_empty or not geom.is_valid:
        return False
    coordinates = get_coordinates(geom)
    return all(math.isfinite(float(v)) for xy in coordinates for v in xy) and (
        -180 <= geom.bounds[0] <= geom.bounds[2] <= 180
        and -90 <= geom.bounds[1] <= geom.bounds[3] <= 90)


def assignment(geom):
    """Return intended SRID, boundary flag and pre-projection status."""
    if geom is None:
        return None, None, "null_geometry"
    if geom.is_empty:
        return None, None, "empty_geometry"
    if not geography_eligible(geom):
        return None, None, "invalid_geometry"
    w, s, e, n = geom.bounds
    if s < -80 or n > 84:
        return None, None, "outside_utm"
    anchor = geom.representative_point()
    srid = utm_srid(anchor.x, anchor.y)
    zone = srid % 100
    west = -180 + (zone - 1) * 6
    crosses = w < west or e > west + 6 or (s < 0 if srid < 32700 else n > 0)
    return srid, bool(crosses), "ok"


class Projector:
    """Worker-local transformer cache, keyed by target EPSG code."""
    def __init__(self):
        from pyproj import network
        network.set_network_enabled(False)
        self.transformers = {}

    def project(self, wkt):
        from pyproj import Transformer
        from pyproj.exceptions import ProjError
        from shapely import from_wkt, get_coordinates, to_wkt
        from shapely.ops import transform
        geom = from_wkt(wkt) if wkt is not None else None
        srid, crossing, status = assignment(geom)
        result = {"geometry_m": None, "geometry_m_srid": srid,
                  "utm_crosses_zone": crossing, "metric_status": status}
        if status != "ok":
            return result
        if srid not in self.transformers:
            self.transformers[srid] = Transformer.from_crs(4326, srid, always_xy=True)
        transformer = self.transformers[srid]
        try:
            projected = transform(lambda x, y, z=None: transformer.transform(x, y, errcheck=True), geom)
            if projected.is_empty or not all(math.isfinite(float(v)) for xy in get_coordinates(projected) for v in xy):
                result["metric_status"] = "projection_failed"
            else:
                result["geometry_m"] = to_wkt(projected, rounding_precision=-1)
        except (ProjError, ValueError, OverflowError):
            result["metric_status"] = "projection_failed"
        return result


_worker_projector = None


def worker_projector():
    """Reuse at most 120 UTM transformers across tasks in a reused Python worker."""
    global _worker_projector
    if _worker_projector is None:
        _worker_projector = Projector()
    return _worker_projector


def validate_metric_row(row):
    from shapely import from_wkt, get_coordinates
    from .contract import ImportValidationError
    geom = from_wkt(row["geometry"]) if row["geometry"] is not None else None
    srid, crossing, status = assignment(geom)
    actual_status = row["metric_status"]
    if (row["geometry_m_srid"] != srid or row["utm_crosses_zone"] != crossing
            or actual_status not in STATUSES
            or (actual_status != status and not (status == "ok" and actual_status == "projection_failed"))):
        raise ImportValidationError("Feature UTM assignment, crossing flag or metric status mismatch")
    if actual_status == "ok":
        if row["geometry_m"] is None or not valid_utm_srid(srid):
            raise ImportValidationError("Successful UTM projection requires geometry and a valid SRID")
        metric = from_wkt(row["geometry_m"])
        if metric.is_empty or not all(math.isfinite(float(v)) for xy in get_coordinates(metric) for v in xy):
            raise ImportValidationError("Non-finite or empty UTM geometry")
    elif row["geometry_m"] is not None:
        raise ImportValidationError("Unavailable UTM projection must have null metric geometry")
