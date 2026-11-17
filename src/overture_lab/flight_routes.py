"""Offline OpenFlights bundles, auditable airport joins, and geodesic route maps."""

from __future__ import annotations

from collections import Counter, defaultdict
import csv
from functools import lru_cache
import hashlib
import io
import json
import math
import re
from urllib.parse import urlparse


SOURCE_URL = "https://openflights.org/data.php"
ROUTE_FIELDS = ("airline", "airline_id", "source_airport", "source_airport_id",
                "destination_airport", "destination_airport_id", "codeshare", "stops", "equipment")
FILE_COLUMNS = {"airports.dat": 14, "airlines.dat": 8, "routes.dat": 9}
MAX_SOURCE_FILE_BYTES = 16 * 1024 * 1024


def flight_source_uri(release_uri, configured=""):
    """Use an explicit offline folder, or external_sources/openflights in the release."""
    uri = (configured.strip() or f"{release_uri.rstrip('/')}/external_sources/openflights").rstrip("/")
    parsed = urlparse(uri)
    if parsed.scheme == "s3":
        uri = "s3a:" + uri[3:]
        parsed = urlparse(uri)
    if (parsed.scheme not in ("", "file", "s3a") or parsed.query or parsed.fragment
            or parsed.username is not None or parsed.password is not None):
        raise ValueError("FLIGHT_ROUTES_URI must be a local absolute path, file:/// path, or s3a:// prefix; no HTTP downloads")
    if parsed.scheme == "s3a":
        if not parsed.netloc or not parsed.path.strip("/"):
            raise ValueError("FLIGHT_ROUTES_URI needs an S3 bucket and folder prefix")
    elif not parsed.path.startswith("/") or parsed.netloc not in ("", "localhost"):
        raise ValueError("Local FLIGHT_ROUTES_URI must be absolute and visible inside the notebook runtime")
    return uri


def _read_small_file(spark, uri, limit):
    path = spark._jvm.org.apache.hadoop.fs.Path(uri)
    fs = path.getFileSystem(spark._jsc.hadoopConfiguration())
    if not fs.exists(path):
        raise FileNotFoundError(
            f"Missing staged OpenFlights file: {uri}. On an OPEN-NETWORK machine run "
            "scripts/download-openflights.py, transfer the whole bundle, then set FLIGHT_ROUTES_URI. "
            "The notebook never downloads missing data."
        )
    status = fs.getFileStatus(path)
    if not status.isFile() or not 0 < status.getLen() <= limit:
        raise ValueError(f"Expected a nonempty source file <= {limit} bytes: {uri}")
    row = spark.read.format("binaryFile").load(uri).select("content").first()
    if row is None or len(row.content) != status.getLen():
        raise ValueError(f"Source file changed while reading: {uri}")
    return bytes(row.content)


def parse_bundle(manifest, contents):
    """Verify the transferred bytes before parsing strict UTF-8 CSV records."""
    if (manifest.get("format_version") != 1 or manifest.get("dataset") != "OpenFlights"
            or not re.fullmatch(r"[0-9a-f]{40}", str(manifest.get("revision", "")))
            or manifest.get("route_period") != "2014-06" or manifest.get("license") != "ODbL-1.0"):
        raise ValueError("Unsupported OpenFlights manifest; prepare a bundle with scripts/download-openflights.py")
    tables = {}
    for filename, width in FILE_COLUMNS.items():
        record = manifest.get("files", {}).get(filename, {})
        data = contents.get(filename, b"")
        if (not data or len(data) > MAX_SOURCE_FILE_BYTES or record.get("bytes") != len(data)
                or record.get("sha256") != hashlib.sha256(data).hexdigest()):
            raise ValueError(f"OpenFlights size/SHA-256 verification failed: {filename}")
        rows = list(csv.reader(io.StringIO(data.decode("utf-8")), strict=True))
        if record.get("rows") != len(rows) or any(len(row) != width for row in rows):
            raise ValueError(f"Unexpected CSV row count or field count: {filename}")
        tables[filename] = [[None if value == r"\N" else value for value in row] for row in rows]
    return tables


def read_flight_bundle(spark, source_uri):
    """Read fixed bundle filenames using Hadoop local/S3A credentials, without public HTTP."""
    source_uri = flight_source_uri(source_uri, source_uri)
    manifest = json.loads(_read_small_file(spark, f"{source_uri}/manifest.json", 128 * 1024))
    contents = {name: _read_small_file(spark, f"{source_uri}/{name}", MAX_SOURCE_FILE_BYTES)
                for name in FILE_COLUMNS}
    return manifest, parse_bundle(manifest, contents)


@lru_cache(maxsize=1)
def _geod():
    from pyproj import Geod
    return Geod(ellps="WGS84")


def geodesic_route(lon1, lat1, lon2, lat2, *, max_segment_km=200.0):
    """WGS84 shortest geodesic, densified and split at +/-180 in stored geometry."""
    from shapely.geometry import LineString, MultiLineString

    if (isinstance(max_segment_km, bool) or not math.isfinite(max_segment_km)
            or not 1 <= max_segment_km <= 1000):
        raise ValueError("MAX_SEGMENT_KM must be finite and between 1 and 1000")
    if not all(math.isfinite(v) for v in (lon1, lat1, lon2, lat2)) or not (
            -180 <= lon1 <= 180 and -180 <= lon2 <= 180 and -90 <= lat1 <= 90 and -90 <= lat2 <= 90):
        raise ValueError("Airport coordinates must be finite WGS84 longitude/latitude")
    geod = _geod()
    _, _, distance = geod.inv(lon1, lat1, lon2, lat2)
    if distance < 1:
        raise ValueError("coincident_endpoints")
    intermediate = max(0, math.ceil(distance / (max_segment_km * 1000)) - 1)
    points = [(lon1, lat1)]
    if intermediate:
        points.extend(geod.npts(lon1, lat1, lon2, lat2, intermediate))
    points.append((lon2, lat2))
    parts, current = [], [points[0]]
    for a, b in zip(points, points[1:]):
        if abs(b[0] - a[0]) > 180:
            unwrapped_b = b[0] + (360 if b[0] < a[0] else -360)
            boundary = 180.0 if unwrapped_b > a[0] else -180.0
            azimuth, _, segment_distance = geod.inv(*a, *b)
            lo, hi = 0.0, segment_distance
            latitude = a[1]
            # Locate the crossing on the ellipsoid, not by latitude interpolation.
            for _ in range(50):
                mid = (lo + hi) / 2
                x, latitude, _ = geod.fwd(*a, azimuth, mid)
                x += 360 * round((a[0] - x) / 360)
                if (x < boundary) == (unwrapped_b > a[0]):
                    lo = mid
                else:
                    hi = mid
            crossing = (boundary, latitude)
            if a[0] == boundary:
                crossing = a
            elif b[0] == -boundary:
                crossing = (boundary, b[1])
            if current[-1] != crossing:
                current.append(crossing)
            if len(current) >= 2:
                parts.append(current)
            current = [(-boundary, crossing[1])]
        if current[-1] != b:
            current.append(b)
    if len(current) >= 2:
        parts.append(current)
    geometry = LineString(parts[0]) if len(parts) == 1 else MultiLineString(parts)
    if geometry.is_empty or not geometry.is_valid:
        raise ValueError("Invalid generated geodesic geometry")
    return geometry, distance / 1000


def _airport_indexes(rows):
    by_id, by_code = {}, defaultdict(list)
    invalid = 0
    for row in rows:
        identifier, name, city, country, iata, icao, lat, lon, *rest = row
        if identifier in by_id:
            raise ValueError(f"Duplicate airport ID in source bundle: {identifier}")
        try:
            lon, lat = float(lon), float(lat)
            valid = (math.isfinite(lon) and math.isfinite(lat) and -180 <= lon <= 180
                     and -90 <= lat <= 90 and rest[4] == "airport" and identifier is not None)
        except (TypeError, ValueError):
            valid = False
        airport = dict(id=identifier, name=name, city=city, country=country, iata=iata, icao=icao,
                       lon=lon, lat=lat, valid=valid)
        by_id[identifier] = airport
        invalid += not valid
        for code in {iata, icao} - {None, ""}:
            by_code[code].append(airport)
    return by_id, by_code, invalid


def _resolve_airport(identifier, code, by_id, by_code):
    if identifier is not None and identifier != "":
        airport = by_id.get(identifier)
        method = "id"
        if airport is None:
            return None, "unknown_airport_id"
    else:
        candidates = by_code.get(code, [])
        if len(candidates) != 1:
            return None, "ambiguous_airport_code" if candidates else "unknown_airport_code"
        airport, method = candidates[0], "unique_code"
    if not airport["valid"]:
        return None, "invalid_or_non_airport"
    return airport, method


def build_flight_records(tables, manifest, *, max_segment_km=200.0):
    """Preserve each geolocatable source service row; account for every exclusion."""
    # Validate even when the bundle has no usable routes.
    if (isinstance(max_segment_km, bool) or not math.isfinite(max_segment_km)
            or not 1 <= max_segment_km <= 1000):
        raise ValueError("MAX_SEGMENT_KM must be finite and between 1 and 1000")
    by_id, by_code, invalid_airports = _airport_indexes(tables["airports.dat"])
    airlines = {}
    for row in tables["airlines.dat"]:
        if row[0] in airlines:
            raise ValueError(f"Duplicate airline ID: {row[0]}")
        airlines[row[0]] = row[1]
    records, excluded = [], []
    matched, code_disagreements = Counter(), 0

    @lru_cache(maxsize=100_000)
    def geometry_for(a, b):
        left, right = by_id[a], by_id[b]
        geometry, distance = geodesic_route(left["lon"], left["lat"], right["lon"], right["lat"],
                                            max_segment_km=max_segment_km)
        return bytes(geometry.wkb), distance

    for source_row, values in enumerate(tables["routes.dat"], 1):
        raw = dict(zip(ROUTE_FIELDS, values))
        reasons, endpoints = [], {}
        try:
            stops = int(raw["stops"])
            if stops < 0:
                raise ValueError
        except (TypeError, ValueError):
            reasons.append("invalid_stops")
            stops = None
        for side in ("source", "destination"):
            airport, method = _resolve_airport(raw[f"{side}_airport_id"], raw[f"{side}_airport"], by_id, by_code)
            if airport is None:
                reasons.append(f"{side}:{method}")
            endpoints[side] = (airport, method)
        if not reasons:
            try:
                geometry, distance = geometry_for(endpoints["source"][0]["id"], endpoints["destination"][0]["id"])
            except ValueError as error:
                if str(error) != "coincident_endpoints":
                    raise
                reasons.append(str(error))
        if reasons:
            excluded.append(dict(source_row=source_row, reason=";".join(reasons), **raw))
            continue
        record = dict(raw, id=f"openflights:{manifest['revision']}:{source_row}", source_row=source_row,
                      stops=stops, airline_name=airlines.get(raw["airline_id"]), distance_km=distance,
                      geometry_wkb=geometry, source_dataset="OpenFlights", source_revision=manifest["revision"],
                      route_period=manifest["route_period"], license=manifest["license"],
                      source_url=SOURCE_URL, geometry_method="WGS84 shortest geodesic; dateline split",
                      max_segment_km=float(max_segment_km))
        for side, (airport, method) in endpoints.items():
            matched[method] += 1
            mismatch = bool(raw[f"{side}_airport"] and raw[f"{side}_airport"] not in {airport['iata'], airport['icao']})
            code_disagreements += mismatch
            record.update({f"resolved_{side}_airport_id": airport["id"], f"{side}_airport_name": airport["name"],
                           f"{side}_country": airport["country"], f"{side}_longitude": airport["lon"],
                           f"{side}_latitude": airport["lat"], f"{side}_match_method": method,
                           f"{side}_code_disagrees": mismatch})
        records.append(record)
    reasons = Counter(reason for row in excluded for reason in row["reason"].split(";"))
    report = {"input_route_rows": len(tables["routes.dat"]), "exported_route_rows": len(records),
              "excluded_route_rows": len(excluded), "exclusion_reason_counts": dict(reasons),
              "airport_rows": len(by_id), "invalid_or_non_airport_rows": invalid_airports,
              "matched_endpoint_methods": dict(matched), "endpoint_code_disagreements": code_disagreements,
              "routes_with_stops": sum(row["stops"] > 0 for row in records),
              "routes_without_airline_name": sum(row["airline_name"] is None for row in records),
              "source_revision": manifest["revision"], "route_period": manifest["route_period"],
              "max_segment_km": max_segment_km}
    if not records:
        raise ValueError(f"No geolocatable flight routes: {report}")
    return records, excluded, report


def flight_dataframe(spark, records):
    from pyspark.sql import functions as F

    fields = [f"{name} {'int' if name == 'stops' else 'string'}" for name in ROUTE_FIELDS]
    fields += ["id string", "source_row long", "airline_name string", "distance_km double", "geometry_wkb binary",
               "source_dataset string", "source_revision string", "route_period string", "license string",
               "source_url string", "geometry_method string", "max_segment_km double"]
    for side in ("source", "destination"):
        fields += [f"resolved_{side}_airport_id string", f"{side}_airport_name string", f"{side}_country string",
                   f"{side}_longitude double", f"{side}_latitude double", f"{side}_match_method string",
                   f"{side}_code_disagrees boolean"]
    return (spark.createDataFrame(records, ", ".join(fields)).repartition(4)
            .withColumn("geometry", F.expr("ST_SetSRID(ST_GeomFromWKB(geometry_wkb), 4326)"))
            .drop("geometry_wkb"))


def validate_flight_routes(routes):
    from pyspark.sql import functions as F

    bad = F.expr("id IS NULL OR geometry IS NULL OR ST_IsEmpty(geometry) OR NOT ST_IsValid(geometry) "
                 "OR ST_SRID(geometry) <> 4326 OR GeometryType(geometry) NOT IN ('LINESTRING', 'MULTILINESTRING') "
                 "OR ST_XMin(geometry) < -180 OR ST_XMax(geometry) > 180 "
                 "OR ST_YMin(geometry) < -90 OR ST_YMax(geometry) > 90")
    report = routes.agg(F.count("*").alias("features"), F.countDistinct("id").alias("distinct_ids"),
                        F.sum(F.expr("ST_NPoints(geometry)")).alias("coordinates"),
                        F.sum(F.when(bad, 1).otherwise(0)).alias("invalid_features")).first().asDict()
    if not report["features"] or report["invalid_features"] or report["features"] != report["distinct_ids"]:
        raise ValueError(f"Invalid flight-route layer: {report}")
    return report


def flight_display_frame(routes, *, feature_limit=100_000, coordinate_limit=2_000_000):
    """Display every directed airport pair once; export retains individual services."""
    from pyspark.sql import functions as F
    from .visualize import collect_geodataframe

    for value in (feature_limit, coordinate_limit):
        if isinstance(value, bool) or not isinstance(value, int) or value < 1:
            raise ValueError("Map feature and coordinate limits must be positive integers")
    pairs = routes.groupBy("resolved_source_airport_id", "resolved_destination_airport_id").agg(
        F.first("geometry").alias("geometry"), F.first("source_airport_name").alias("origin_name"),
        F.first("destination_airport_name").alias("destination_name"),
        F.count("*").alias("route_records"),
        F.countDistinct(F.coalesce("airline_id", "airline")).alias("airline_count"),
        F.round(F.first("distance_km"), 1).alias("distance_km"),
    ).withColumn("source_id", F.concat_ws("→", "resolved_source_airport_id", "resolved_destination_airport_id"))
    report = pairs.agg(F.count("*").alias("features"), F.sum(F.expr("ST_NPoints(geometry)")).alias("coordinates")).first()
    if report.features > feature_limit or (report.coordinates or 0) > coordinate_limit:
        raise ValueError(f"World flight map needs {report.features:,} pairs / {report.coordinates:,} coordinates. "
                         "Increase MAP_FEATURE_LIMIT / MAP_COORDINATE_LIMIT; no routes were sampled. Export is complete.")
    columns = ["source_id", "origin_name", "destination_name", "route_records", "airline_count", "distance_km"]
    return collect_geodataframe(pairs.orderBy("source_id"), limit=feature_limit, columns=columns)


def flight_routes_map(frame, *, countries=None, wms=None, observed=False, min_active_days=14):
    import pydeck as pdk
    from .visualize import build_interactive_deck

    layers, groups = [], []
    if wms is not None:
        groups.append({"id": "background", "label": "Background", "layer_ids": ["airgap-wms-background"]})
    if countries is not None:
        layers.append(pdk.Layer("GeoJsonLayer", countries.__geo_interface__, id="flight-country-context",
                                pickable=False, filled=True, stroked=True, get_fill_color=[224, 230, 235],
                                get_line_color=[145, 158, 170], line_width_min_pixels=0.5))
        groups.append({"id": "countries", "label": "Country context", "layer_ids": ["flight-country-context"]})
    layers.append(pdk.Layer("GeoJsonLayer", frame.__geo_interface__, id="world-flight-routes", pickable=True,
                            auto_highlight=True, filled=False, stroked=True, get_line_color=[14, 105, 165, 95],
                            highlight_color=[240, 130, 35, 255], line_width_min_pixels=1, wrap_longitude=True))
    label = "Recurring inferred connections" if observed else "Historical flight links"
    description = (f"PlaneQuery • July–September 2026 • Observed on ≥{min_active_days} days. "
                   "Inferred airport connections; lines are modeled geodesics." if observed else
                   "OpenFlights • June 2014 • Modeled airport links, not observed flight tracks. Hover for route details.")
    tooltip = ("{origin_name} → {destination_name}\n{distance_km} km (geodesic)\n"
               "{observation_count} observations on {active_days} days\n"
               "July–September 2026 • inferred endpoints\nPair: {source_id}" if observed else
               "{origin_name} → {destination_name}\n{distance_km} km (geodesic)\n"
               "{route_records} source records; {airline_count} airline identifiers\n"
               "Historical: June 2014\nPair ID: {source_id}")
    groups.append({"id": "flights", "label": f"{label} ({len(frame):,} directed pairs)",
                   "layer_ids": ["world-flight-routes"], "color": [14, 105, 165]})
    controls = {"groups": groups, "cities": [], "views": {"world": [[-180, -65], [180, 80]]},
                "description": description}
    deck = build_interactive_deck(layers, pdk.ViewState(longitude=0, latitude=15, zoom=0.5), wms=wms,
        tooltip={"text": tooltip})
    return deck, controls


def write_flight_audit(spark, run_prefix, manifest, report, excluded):
    """Retain source identity and every unmappable row alongside the verified export."""
    text = io.StringIO()
    writer = csv.DictWriter(text, fieldnames=["source_row", "reason", *ROUTE_FIELDS])
    writer.writeheader()
    writer.writerows(excluded)
    documents = {"source-manifest.json": json.dumps(manifest, indent=2) + "\n",
                 "route-quality.json": json.dumps(report, indent=2) + "\n", "excluded-routes.csv": text.getvalue()}
    for name, content in documents.items():
        path = spark._jvm.org.apache.hadoop.fs.Path(f"{run_prefix}/{name}")
        fs = path.getFileSystem(spark._jsc.hadoopConfiguration())
        stream = fs.create(path, False)
        try:
            stream.write(bytearray(content.encode("utf-8")))
        finally:
            stream.close()
    return {name: f"{run_prefix}/{name}" for name in documents}
