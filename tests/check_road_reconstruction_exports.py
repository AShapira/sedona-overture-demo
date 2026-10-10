"""Independent Arrow/Shapely audit of a completed notebook 17 validation run.

Usage: python3 tests/check_road_reconstruction_exports.py ATTEMPT_DIR RELEASE_DIR
No reconstruction helpers are imported; all three saved tables are audited.
"""
from collections import defaultdict
import json
from pathlib import Path
import sys

import pyarrow as pa
import pyarrow.dataset as ds
import pyarrow.parquet as pq
from pyproj import Geod
import shapely


def main():
    root, release = map(Path, sys.argv[1:3])
    pa.set_cpu_count(4)
    pa.set_io_thread_count(4)
    run = json.loads((root / "report.json").read_text())
    assert run["status"] == "passed"
    summary = json.loads((root / "reconstruction/reconstruction-summary.json").read_text())
    uri = summary["export"]["geoparquet_uri"]
    assert uri.startswith("/results/")
    export = root / uri.removeprefix("/results/")
    roads = pq.ParquetFile(export).read().to_pylist()
    membership = pq.read_table(root / "reconstruction/membership.parquet").to_pylist()
    diagnostics = pq.read_table(root / "reconstruction/diagnostics.parquet").to_pylist()
    per_road, per_source, excluded = defaultdict(list), defaultdict(list), defaultdict(list)
    for item in membership:
        per_road[item["road_id"]].append(item)
        per_source[item["source_segment_id"]].append(item)
    for item in diagnostics:
        if item["kind"] == "excluded_link":
            interval = json.loads(item["detail"])
            excluded[item["source_segment_id"]].append((interval["start"], interval["end"]))
    codes = json.loads(run["configuration"]["MEDIUM_STATE_CODES"])
    areas = ds.dataset(release / "theme=divisions/type=division_area", format="parquet").to_table(
        columns=["geometry", "bbox"], filter=ds.field("country").isin(codes) &
        (ds.field("subtype") == "country") & ds.field("is_territorial")).to_pylist()
    boundary = shapely.union_all(shapely.from_wkb([a["geometry"] for a in areas]))
    shapely.prepare(boundary)
    predicate = None
    for area in areas:
        b = area["bbox"]
        overlap = ((ds.field("bbox", "xmin") <= b["xmax"]) & (ds.field("bbox", "xmax") >= b["xmin"]) &
                   (ds.field("bbox", "ymin") <= b["ymax"]) & (ds.field("bbox", "ymax") >= b["ymin"]))
        predicate = overlap if predicate is None else predicate | overlap
    table = ds.dataset(release / "theme=transportation/type=segment", format="parquet").to_table(
        columns=["id", "geometry", "connectors"], filter=predicate & (ds.field("subtype") == "road") &
        ds.field("class").isin(["motorway", "trunk", "primary"]))
    geometries = shapely.from_wkb(table["geometry"].to_pylist())
    sources = {r["id"]: r for r in table.filter(pa.array(shapely.intersects(geometries, boundary))).to_pylist()}
    assert len(sources) == summary["input_segments"]
    assert set(sources) == set(per_source) | set(excluded), "Input source coverage differs from complete regional scan"
    assert len(roads) == summary["reconstructed_roads"]
    assert len(membership) == summary["atomic_pieces"]
    assert len({r["road_id"] for r in roads}) == len(roads)
    assert len({(m["source_segment_id"], m["start_lr"], m["end_lr"]) for m in membership}) == len(membership)
    geod = Geod(ellps="WGS84")
    road_coordinates = {}
    for road in roads:
        geometry = shapely.from_wkb(road["geometry"])
        assert geometry.geom_type == "LineString" and geometry.is_valid and not geometry.is_empty
        road_coordinates[road["road_id"]] = set(geometry.coords)
        assert abs(geod.geometry_length(geometry) - road["length_m"]) < 1e-5
        parts = sorted(per_road[road["road_id"]], key=lambda m: m["piece_order"])
        assert [p["piece_order"] for p in parts] == list(range(1, len(parts) + 1))
        assert len({p["source_segment_id"] for p in parts}) == road["source_segment_count"]
        assert abs(sum(p["length_m"] for p in parts) - road["length_m"]) < 1e-5
        for a, b in zip(parts, parts[1:]):
            exit_lr = a["start_lr"] if a["reversed"] else a["end_lr"]
            entry_lr = b["end_lr"] if b["reversed"] else b["start_lr"]
            if a["source_segment_id"] == b["source_segment_id"] and exit_lr == entry_lr:
                continue
            left = {c["connector_id"] for c in sources[a["source_segment_id"]]["connectors"] if c["at"] == exit_lr}
            right = {c["connector_id"] for c in sources[b["source_segment_id"]]["connectors"] if c["at"] == entry_lr}
            assert left & right, "Joining membership pieces do not share a connector"
        b = road["geometry_bbox"]
        for key, coordinate in zip(("xmin", "ymin", "xmax", "ymax"), geometry.bounds):
            assert abs(b[key] - coordinate) < 1e-6
    vertices_checked = partial_sources = 0
    for identifier, source in sources.items():
        members = per_source[identifier]
        intervals = sorted([(m["start_lr"], m["end_lr"]) for m in members] + excluded[identifier])
        assert intervals[0][0] == 0 and intervals[-1][1] == 1
        assert all(a[1] == b[0] for a, b in zip(intervals, intervals[1:])), "Source intervals have gaps or overlaps"
        if not members:
            continue
        geometry = shapely.from_wkb(source["geometry"])
        available = set().union(*(road_coordinates[m["road_id"]] for m in members))
        if not excluded[identifier]:
            assert set(geometry.coords).issubset(available), f"Lost source vertices: {identifier}"
            vertices_checked += len(geometry.coords)
        else:
            partial_sources += 1
    result = dict(status="passed", independently_selected_segments=len(sources),
        output_roads=len(roads), membership_intervals=len(membership),
        every_input_interval_retained_or_excluded_once=True, all_joins_connector_verified=True,
        source_vertices_verified=vertices_checked, partially_excluded_sources=partial_sources,
        geometry_bbox_values_verified=True, geodesic_lengths_verified=True)
    (root / "independent-geometry-audit.json").write_text(json.dumps(result, indent=2))
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
