"""Conservative carriageway reconstruction; not a routable transportation graph.

Spark selects the complete regional input. The bounded Python pass contracts
only mutually unique, identity- and direction-compatible connector incidences.
No spatial snapping, intersection noding, or bearing-based branch choice occurs.
"""
from __future__ import annotations

from bisect import bisect_left, bisect_right
from collections import Counter, defaultdict
from dataclasses import dataclass
import hashlib
import json
import math
import unicodedata


MAJOR_CLASSES = ("motorway", "trunk", "primary")


@dataclass(frozen=True)
class ReconstructionLimits:
    segments: int = 200_000
    connector_references: int = 1_000_000
    vertices: int = 2_000_000
    pieces: int = 400_000


@dataclass(frozen=True)
class ReconstructionResult:
    roads: object
    membership: object
    diagnostics: object
    summary: dict


def _normal(value):
    return " ".join(unicodedata.normalize("NFC", value or "").split()).casefold()


def _range(rule):
    value = rule.get("between")
    if value is None:
        return (0.0, 1.0)
    if len(value) != 2:
        raise ValueError(f"Invalid linear reference: {value}")
    a, b = map(float, value)
    if not (math.isfinite(a) and math.isfinite(b) and 0 <= a < b <= 1):
        raise ValueError(f"Invalid linear reference: {value}")
    return a, b


def _active(rule, position):
    a, b = _range(rule)
    return a <= position < b


def _direction_rules(rules):
    """Keep directional rules and unconditional blanket overrides for motor cars.

    Unscoped conditional access (height limits, private access, opening hours) is
    discarded with the other non-directional attributes of this map derivative.
    It must not erase an explicit one-way heading or split a physical carriageway.
    """
    for rule in rules or []:
        when = rule.get("when") or {}
        modes = when.get("mode")
        if modes and not set(modes).intersection({"vehicle", "motor_vehicle", "car"}):
            continue
        if not when.get("heading") and any(when.get(k) for k in ("during", "using", "recognized", "vehicle")):
            continue
        yield rule


def _direction(rules, position):
    """Resolve generic motor-car headings, retaining conditional uncertainty.

    Without heading-scoped rules, access facts such as closures are not assertions
    of carriageway direction. When headings are present, unscoped rules also
    participate: a later blanket permission can override a heading denial.
    """
    applicable = []
    for rule in _direction_rules(rules):
        if not _active(rule, position):
            continue
        applicable.append(rule)
    if not any((r.get("when") or {}).get("heading") for r in applicable):
        return "bidirectional_assumed"
    state = {"forward": True, "backward": True}
    for rule in applicable:
        when = rule.get("when") or {}
        heading = when.get("heading")
        if heading and heading not in state:
            return "unknown"
        conditional = any(when.get(k) for k in ("during", "using", "recognized", "vehicle"))
        value = rule.get("access_type")
        for h in (heading,) if heading else tuple(state):
            state[h] = None if conditional or value not in ("allowed", "denied") else value == "allowed"
    if None in state.values() or not any(state.values()):
        return "unknown"
    if all(state.values()):
        return "bidirectional_assumed"
    return "forward" if state["forward"] else "backward"


def _identity(row, routes):
    keys = set()
    for route in routes:
        wikidata = (route.get("wikidata") or "").strip()
        ref, network = _normal(route.get("ref")), _normal(route.get("network"))
        if wikidata:
            keys.add("wikidata:" + wikidata)
        elif ref and network:
            keys.add("network:" + json.dumps([network, ref], ensure_ascii=False))
        elif ref:
            countries = tuple(sorted(row.get("country_codes") or []))
            # A missing jurisdiction must not turn ref=1 into a global identity.
            scope = countries or ("unscoped-segment:" + row["id"],)
            keys.add("ref:" + json.dumps([scope, ref], ensure_ascii=False))
    if keys:
        return ("route", tuple(sorted(keys))), "route", sorted(keys)
    name = _normal((row.get("names") or {}).get("primary"))
    if name:
        return ("name", name), "name", []
    return ("anonymous", row["class"]), "topology", []


class _Line:
    """Source vertices indexed by WGS84 cumulative length, not degree length."""

    def __init__(self, geometry, geod):
        self.coords = list(geometry.coords)
        self.geod = geod
        self.distances = [0.0]
        self.index = defaultdict(list)
        for i, coordinate in enumerate(self.coords):
            self.index[coordinate].append(i)
            if i:
                self.distances.append(self.distances[-1] + geod.inv(*self.coords[i-1], *coordinate)[2])
        self.length = self.distances[-1]
        if not math.isfinite(self.length) or self.length <= 0:
            raise ValueError("Cannot reconstruct an empty or zero-length segment")

    def connector(self, point, position):
        matches = self.index.get(tuple(point), [])
        if not matches:
            raise ValueError("Connector geometry is not an exact source vertex; no snapping is permitted")
        i = min(matches, key=lambda k: abs(self.distances[k] - position * self.length))
        if abs(self.distances[i] - position * self.length) > 0.01:
            raise ValueError("Connector at does not match WGS84 source distance within 1 cm")
        return self.distances[i], self.coords[i]

    def point(self, position):
        target = position * self.length
        i = min(max(bisect_right(self.distances, target) - 1, 0), len(self.coords) - 2)
        if target == self.distances[i]:
            return target, self.coords[i]
        if position == 1:
            return self.length, self.coords[-1]
        a, b = self.coords[i:i+2]
        # Preserve the source edge on the WGS84 ellipsoid. Linear interpolation
        # of longitude/latitude would change its measured length when split.
        azimuth = self.geod.inv(*a, *b)[0]
        x, y, _ = self.geod.fwd(*a, azimuth, target - self.distances[i])
        return target, (x, y)

    def slice(self, left, right):
        a, p = left
        b, q = right
        if b <= a:
            raise ValueError("Linear reference cuts are not ordered along source geometry")
        points = [p] + self.coords[bisect_right(self.distances, a):bisect_left(self.distances, b)] + [q]
        return [p for i, p in enumerate(points) if not i or p != points[i-1]]


def reconstruct_rows(rows, connectors, *, release, limits=ReconstructionLimits()):
    """Reconstruct bounded dictionaries with WKB geometry and connector points.

Returns three tuples of rows and a scalar summary. Failures are explicit: a
    malformed source or an exceeded cap never produces a quietly truncated result.
"""
    from pyproj import Geod
    from shapely import from_wkb, to_wkb
    from shapely.geometry import LineString

    if len(rows) > limits.segments:
        raise ValueError(f"Segment graph limit exceeded: {len(rows)} > {limits.segments}")
    if len({r["id"] for r in rows}) != len(rows):
        raise ValueError("Duplicate source segment IDs")
    reference_count = sum(len(r.get("connectors") or []) for r in rows)
    if reference_count > limits.connector_references:
        raise ValueError("Connector reference graph limit exceeded")
    geod = Geod(ellps="WGS84")
    pieces, diagnostics = [], []
    vertex_count = 0
    source_length = excluded_length = retained_length = 0.0
    source_classes, source_identities = Counter(), Counter()
    retained_sources = set()

    def diagnostic(kind, *, segment=None, road=None, connector=None, detail="", length=0.0):
        diagnostics.append(dict(kind=kind, source_segment_id=segment, road_id=road,
                                connector_id=connector, detail=detail, length_m=float(length)))

    for row in sorted(rows, key=lambda r: r["id"]):
        if row["class"] not in MAJOR_CLASSES:
            raise ValueError(f"Unexpected road class: {row['class']}")
        geometry = from_wkb(bytes(row["geometry"]))
        if geometry.geom_type != "LineString" or geometry.is_empty or not geometry.is_valid:
            raise ValueError(f"Invalid source LineString: {row['id']}")
        vertex_count += len(geometry.coords)
        if vertex_count > limits.vertices:
            raise ValueError("Geometry vertex graph limit exceeded")
        line = _Line(geometry, geod)
        source_length += line.length
        refs = row.get("connectors") or []
        cuts, nodes = {0.0: line.point(0), 1.0: line.point(1)}, {}
        for c in refs:
            at, cid = float(c["at"]), c["connector_id"]
            if not math.isfinite(at) or not 0 <= at <= 1:
                raise ValueError(f"Invalid connector position: {row['id']}")
            if cid not in connectors:
                raise ValueError(f"Missing connector: {cid}")
            if at in nodes and nodes[at] != ("connector", cid):
                raise ValueError("Distinct connector IDs at the same source position")
            cuts[at] = line.connector(connectors[cid], at)
            nodes[at] = ("connector", cid)
        if 0.0 not in nodes or 1.0 not in nodes:
            raise ValueError(f"Missing endpoint connector reference: {row['id']}")
        relevant = (row.get("routes") or []) + (row.get("subclass_rules") or []) + list(_direction_rules(row.get("access_restrictions")))
        for rule in relevant:
            for at in _range(rule):
                if at not in cuts:
                    cuts[at] = line.point(at)
        positions = sorted(cuts)
        had_retained = False
        for start, end in zip(positions, positions[1:]):
            midpoint = (start + end) / 2
            subclass = row.get("subclass")
            for rule in row.get("subclass_rules") or []:
                if _active(rule, midpoint):
                    subclass = rule["value"]
            coordinates = line.slice(cuts[start], cuts[end])
            part = LineString(coordinates)
            length = geod.geometry_length(part)
            if subclass == "link":
                excluded_length += length
                diagnostic("excluded_link", segment=row["id"], length=length,
                           detail=json.dumps({"start": start, "end": end}))
                continue
            had_retained = True
            routes = [a for a in row.get("routes") or [] if _active(a, midpoint)]
            identity, basis, route_ids = _identity(row, routes)
            direction = _direction(row.get("access_restrictions"), midpoint)
            if direction == "unknown":
                diagnostic("unresolved_direction", segment=row["id"], length=length,
                           detail=json.dumps({"start": start, "end": end}))
            if not geometry.is_simple:
                diagnostic("source_self_crossing", segment=row["id"], detail="Connectivity still uses connector IDs only")
            pieces.append(dict(segment=row["id"], start=start, end=end, coords=coordinates,
                nodes=(nodes.get(start, ("cut", row["id"], start)), nodes.get(end, ("cut", row["id"], end))),
                identity=identity, basis=basis, route_ids=route_ids,
                route_refs=sorted({a["ref"] for a in routes if a.get("ref")}),
                name=(row.get("names") or {}).get("primary") or next((a["name"] for a in routes if a.get("name")), None),
                road_class=row["class"], direction=direction, length=length,
                extent_limited=bool(row.get("extent_limited"))))
            retained_length += length
            if len(pieces) > limits.pieces:
                raise ValueError("Atomic piece graph limit exceeded")
        if had_retained:
            retained_sources.add(row["id"])
            source_classes[row["class"]] += 1
            source_identities["route_metadata" if row.get("routes") else "name_only" if (row.get("names") or {}).get("primary") else "unnamed"] += 1

    # Ports are (piece index, source endpoint 0/1). Each port can be paired with
    # at most one other; these symmetric pairs form paths or rings, not trees.
    incident = defaultdict(list)
    for i, piece in enumerate(pieces):
        for side, node in enumerate(piece["nodes"]):
            incident[node].append((i, side))

    def can_pair(a, b):
        i, side = a
        j, other_side = b
        p, q = pieces[i], pieces[j]
        if i == j or p["identity"] != q["identity"]:
            return False
        pd, qd = p["direction"], q["direction"]
        if "unknown" in (pd, qd):
            return False
        if (pd == "bidirectional_assumed") != (qd == "bidirectional_assumed"):
            return False
        if pd != "bidirectional_assumed":
            p_out = side == (1 if pd == "forward" else 0)
            q_out = other_side == (1 if qd == "forward" else 0)
            if p_out == q_out:
                return False
        return p["coords"][0 if side == 0 else -1] == q["coords"][0 if other_side == 0 else -1]

    paired = {}
    for node, ports in sorted(incident.items(), key=lambda x: str(x[0])):
        candidates = {}
        for port in ports:
            p = pieces[port[0]]
            candidates[port] = [] if p["basis"] == "topology" and len(ports) != 2 else [
                other for other in ports if can_pair(port, other)]
        for port, matches in candidates.items():
            if len(matches) == 1 and candidates[matches[0]] == [port]:
                paired[port] = matches[0]
            elif len(ports) > 1:
                diagnostic("ambiguous_branch" if len(matches) > 1 else "continuation_stopped",
                           segment=pieces[port[0]]["segment"],
                           connector=node[1] if node[0] == "connector" else None,
                           detail="No mutually unique compatible continuation")

    seen, roads, membership = set(), [], []
    for seed in range(len(pieces)):
        if seed in seen:
            continue
        component, todo = set(), [seed]
        while todo:
            i = todo.pop()
            if i in component:
                continue
            component.add(i)
            for side in (0, 1):
                if (i, side) in paired:
                    todo.append(paired[i, side][0])
        endpoints = [(i, side) for i in sorted(component) for side in (0, 1) if (i, side) not in paired]
        closed = not endpoints
        first = pieces[min(component)]
        one_way = first["direction"] in ("forward", "backward")
        starts = endpoints or [(i, side) for i in sorted(component) for side in (0, 1)]
        if one_way:
            starts = [(i, side) for i, side in starts if side == (0 if pieces[i]["direction"] == "forward" else 1)]
        if not starts:
            raise AssertionError("Directed component has no valid traversal start")
        i, side = min(starts)
        ordered, coordinates = [], []
        while i not in seen:
            seen.add(i)
            p = pieces[i]
            points = p["coords"] if side == 0 else list(reversed(p["coords"]))
            if coordinates and coordinates[-1] != points[0]:
                raise AssertionError("Attempted to fabricate a joining edge")
            coordinates.extend(points if not coordinates else points[1:])
            ordered.append((i, side == 1))
            continuation = paired.get((i, 1-side))
            if continuation is None:
                break
            i, side = continuation
        if len(ordered) != len(component):
            raise AssertionError("Chain did not consume its component exactly once")
        # A one-piece source ring has no paired ports but is still a loop.
        closed = closed or (coordinates[0] == coordinates[-1] and pieces[ordered[0][0]]["nodes"][0] == pieces[ordered[-1][0]]["nodes"][1])
        geometry = LineString(coordinates)
        length = geod.geometry_length(geometry)
        expected = sum(pieces[i]["length"] for i, _ in ordered)
        if abs(length - expected) > max(1e-5, expected * 1e-10):
            raise AssertionError("Merged length does not conserve source intervals")
        token = json.dumps([release, sorted((pieces[i]["segment"], pieces[i]["start"], pieces[i]["end"]) for i in component)], separators=(",", ":"))
        road_id = "road-" + hashlib.sha256(token.encode()).hexdigest()[:24]
        names, classes = Counter(), Counter()
        for i, _ in ordered:
            p = pieces[i]
            if p["name"]:
                names[p["name"]] += p["length"]
            classes[p["road_class"]] += p["length"]
        direction = "loop" if closed else "unknown" if first["direction"] == "unknown" else "bidirectional"
        if one_way and not closed:
            bearing = geod.inv(*coordinates[0], *coordinates[-1])[0] % 360
            direction = ("northbound", "eastbound", "southbound", "westbound")[int((bearing + 45) // 90) % 4]
        roads.append(dict(road_id=road_id, name=min(names, key=lambda n: (-names[n], n)) if names else None,
            route_ids=first["route_ids"], route_refs=sorted({ref for i, _ in ordered for ref in pieces[i]["route_refs"]}),
            road_class=min(classes, key=lambda c: (-classes[c], MAJOR_CLASSES.index(c))),
            direction=direction, length_m=length, source_segment_count=len({pieces[i]["segment"] for i in component}),
            identity_basis=first["basis"], geometry=to_wkb(geometry)))
        if any(pieces[i]["extent_limited"] for i in component):
            diagnostic("region_limited", road=road_id, detail="Contains a source segment extending outside the selected region")
        for order, (i, reverse) in enumerate(ordered, 1):
            p = pieces[i]
            membership.append(dict(road_id=road_id, source_segment_id=p["segment"], start_lr=p["start"],
                end_lr=p["end"], piece_order=order, reversed=reverse, direction_status=p["direction"], length_m=p["length"]))

    if len(membership) != len(pieces) or len({(r["source_segment_id"], r["start_lr"], r["end_lr"]) for r in membership}) != len(pieces):
        raise AssertionError("Source interval coverage is not exactly once")
    if abs(source_length - excluded_length - retained_length) > max(0.01, source_length * 1e-8):
        raise AssertionError("Retained plus excluded length does not conserve source length")
    return ReconstructionResult(tuple(sorted(roads, key=lambda r: r["road_id"])), tuple(membership), tuple(diagnostics), {
        "release": release, "input_segments": len(rows), "retained_source_segments": len(retained_sources),
        "connector_references": reference_count, "referenced_connectors": len({c['connector_id'] for r in rows for c in r.get('connectors') or []}),
        "source_vertices": vertex_count, "atomic_pieces": len(pieces), "reconstructed_roads": len(roads),
        "source_length_m": source_length, "excluded_link_length_m": excluded_length,
        "retained_length_m": retained_length, "output_length_m": sum(r["length_m"] for r in roads),
        "source_classes": dict(source_classes), "source_identity_coverage": dict(source_identities),
        "output_classes": dict(Counter(r["road_class"] for r in roads)),
        "output_identity_basis": dict(Counter(r["identity_basis"] for r in roads)),
        "diagnostics": dict(Counter(r["kind"] for r in diagnostics)),
        "interval_accounting_passed": True, "length_conservation_passed": True})


def reconstruct_major_roads(spark, segments, connectors, areas, *, release,
                            limits=ReconstructionLimits(), verify_determinism=False):
    """Select full intersecting sources and return roads/membership/diagnostics DFs.

The caller supplies country areas selected with the existing region contract.
Nothing is written. Caps are checked in Spark before collecting geometry.
"""
    from pyspark import StorageLevel
    from pyspark.sql import functions as F
    from .regions import Bounds, bbox_overlap, exact_intersection

    bounds = tuple(Bounds(r.xmin, r.ymin, r.xmax, r.ymax) for r in areas.select("bbox.*").collect())
    columns = ["id", "geometry", "bbox", "class", "subclass", "subclass_rules", "names", "routes", "connectors", "access_restrictions"]
    selected = exact_intersection(bbox_overlap(segments.where(
        (F.col("subtype") == "road") & F.col("class").isin(*MAJOR_CLASSES)), bounds), areas).select(*columns).persist(StorageLevel.MEMORY_AND_DISK)
    try:
        stats = selected.agg(F.count("*").alias("segments"), F.sum(F.size("connectors")).alias("refs"),
            F.sum(F.expr("ST_NPoints(geometry)")).alias("vertices"),
            F.min("bbox.xmin").alias("xmin"), F.min("bbox.ymin").alias("ymin"),
            F.max("bbox.xmax").alias("xmax"), F.max("bbox.ymax").alias("ymax")).first()
        if stats.segments == 0:
            raise ValueError("No major road segments intersect the selected region")
        if stats.segments > limits.segments or stats.refs > limits.connector_references or stats.vertices > limits.vertices:
            raise ValueError(f"Regional graph exceeds configured limits: {stats.asDict()}; no sampling performed")
        country_matches = selected.alias("s").join(F.broadcast(areas.select(
            "country", F.col("geometry").alias("country_geometry"))),
            F.expr("ST_Intersects(s.geometry, country_geometry)"), "inner").groupBy("s.id").agg(
                F.sort_array(F.collect_set("country")).alias("country_codes"))
        union = areas.agg(F.expr("ST_Union_Aggr(geometry)").alias("region_geometry"))
        prepared = selected.join(country_matches, "id").crossJoin(F.broadcast(union)).select(
            *[F.col(c) for c in columns if c not in ("geometry", "bbox")], "country_codes",
            (~F.expr("ST_Covers(region_geometry, geometry)")).alias("extent_limited"),
            F.expr("ST_AsBinary(geometry)").alias("geometry"))
        wanted = selected.select(F.explode("connectors").alias("c")).select(F.col("c.connector_id").alias("id")).distinct()
        resolved = bbox_overlap(connectors, Bounds(stats.xmin, stats.ymin, stats.xmax, stats.ymax)).join(
            F.broadcast(wanted), "id", "inner").select("id", F.expr("ST_X(geometry)").alias("x"), F.expr("ST_Y(geometry)").alias("y")).collect()
        if len({r.id for r in resolved}) != len(resolved):
            raise ValueError("Duplicate connector features")
        source_rows = [r.asDict(recursive=True) for r in prepared.collect()]
        connector_points = {r.id: (r.x, r.y) for r in resolved}
        result = reconstruct_rows(source_rows, connector_points, release=release, limits=limits)
        if verify_determinism:
            repeated = reconstruct_rows(list(reversed(source_rows)), connector_points, release=release, limits=limits)
            if result != repeated:
                raise AssertionError("Reconstruction changed after reversing source input order")
            result.summary["determinism_verified"] = True
    finally:
        selected.unpersist()

    road_schema = "road_id string, name string, route_ids array<string>, route_refs array<string>, road_class string, direction string, length_m double, source_segment_count long, identity_basis string, geometry binary"
    membership_schema = "road_id string, source_segment_id string, start_lr double, end_lr double, piece_order long, reversed boolean, direction_status string, length_m double"
    diagnostic_schema = "kind string, source_segment_id string, road_id string, connector_id string, detail string, length_m double"
    roads = spark.createDataFrame(list(result.roads), road_schema).withColumn("geometry", F.expr("ST_SetSRID(ST_GeomFromWKB(geometry), 4326)"))
    return ReconstructionResult(roads, spark.createDataFrame(list(result.membership), membership_schema),
        spark.createDataFrame(list(result.diagnostics), diagnostic_schema), result.summary)
