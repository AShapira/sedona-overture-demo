#!/usr/bin/env python3
"""Actual Spark/PostGIS multi-zone and hemisphere acceptance; disposable DB only."""
import argparse
import json
from pathlib import Path

from check_postgis_import import configuration


def fixture(root):
    import pyarrow as pa
    import pyarrow.parquet as pq
    from shapely import from_wkt, to_wkb
    schema = pa.schema([("id", pa.string()), ("geometry", pa.binary()),
        ("bbox", pa.struct([(k, pa.float64()) for k in ("xmin", "ymin", "xmax", "ymax")]))],
        metadata={b"geo": json.dumps({"version": "1.1.0", "primary_column": "geometry",
                  "columns": {"geometry": {"encoding": "WKB", "geometry_types": []}}}).encode()})
    shapes = {"west": "POINT (5.9999 50)", "east": "POINT (6.0001 50)",
        "crossing": "LINESTRING (5.9 50,6.1 50)",
        "north": "POINT (6.0001 0.0001)", "south": "POINT (6.0001 -0.0001)",
        "equator_crossing": "LINESTRING (6.1 -0.1,6.1 0.1)",
        "polar": "POINT (6 85)", "south_polar": "POINT (6 -81)",
        "partial_polar": "LINESTRING (6 83,6 85)", "empty": "POINT EMPTY",
        "concave": "POLYGON ((5 49,7 49,7 51,6.8 51,6.8 49.2,5.2 49.2,5.2 51,5 51,5 49))"}
    records = []
    for fid, wkt in shapes.items():
        geom = from_wkt(wkt)
        records.append({"id": fid, "geometry": to_wkb(geom),
                        "bbox": dict(zip(("xmin", "ymin", "xmax", "ymax"), geom.bounds)) if not geom.is_empty else None})
    leaf = root / "theme=divisions/type=division"
    leaf.mkdir(parents=True)
    pq.write_table(pa.Table.from_pylist(records, schema=schema), leaf / "part-0.parquet")


def projector_tests():
    from shapely import from_wkt
    from shapely.ops import transform
    from pyproj import Transformer, network
    from overture_lab.postgis_import.utm import Projector, validate_metric_row
    network.set_network_enabled(True)
    projector = Projector()
    assert not network.is_network_enabled()
    # PROJ's published UTM examples, within their printed millimetre precision.
    for wkt, srid, expected in [("POINT (12 56)", 32633, None),
                              ("POINT (174 -44)", 32760, None),
                              ("POINT (3 0)", 32631, (500000, 0))]:
        row = projector.project(wkt)
        assert row["geometry_m_srid"] == srid
        projected = from_wkt(row["geometry_m"])
        if expected:
            assert abs(projected.x - expected[0]) < 1e-6 and abs(projected.y - expected[1]) < 1e-6
        inverse = Transformer.from_crs(srid, 4326, always_xy=True)
        returned = transform(inverse.transform, projected)
        assert returned.distance(from_wkt(wkt)) < 1e-8
        validate_metric_row({"geometry": wkt, **row})
    cached = projector.transformers[32631]
    projector.project("POINT (3.1 0.1)")
    assert len(projector.transformers) == 3 and projector.transformers[32631] is cached
    from overture_lab.postgis_import.utm import worker_projector
    assert worker_projector() is worker_projector()
    # The published examples specify a zone on a boundary; pin that operation
    # separately from the importer's east-owning boundary assignment rule.
    x, y = Transformer.from_crs(4326, 32632, always_xy=True).transform(12, 56)
    assert abs(x - 687071.44) < .01 and abs(y - 6210141.33) < .01
    x, y = Transformer.from_crs(4326, 32759, always_xy=True).transform(174, -44)
    assert abs(x - 740526.32) < .01 and abs(y - 5123750.87) < .01
    from unittest.mock import patch
    from pyproj.exceptions import ProjError
    with patch("pyproj.Transformer.transform", side_effect=ProjError("fixture failure")):
        failed = projector.project("POINT (3 0)")
        assert failed["metric_status"] == "projection_failed" and failed["geometry_m"] is None
    try:
        validate_metric_row({"geometry": "POINT (3 0)", **projector.project("POINT (3 0)"), "geometry_m_srid": 32632})
        raise AssertionError("Mislabeled SRID accepted")
    except ValueError:
        pass


def snapshot_metadata_tests(dataset):
    """Reject self-consistent checksums around false metadata or mislabeled rows."""
    import copy
    import pyarrow as pa
    import pyarrow.parquet as pq
    from overture_lab.postgis_import.contract import digest, ImportValidationError
    from overture_lab.postgis_import.snapshot import verify_snapshot, sha256
    manifest = verify_snapshot(dataset)

    def rejected(changed, expected):
        changed["fingerprint"] = digest({k: v for k, v in changed.items() if k != "fingerprint"})
        try:
            verify_snapshot(dataset, manifest=changed)
            raise AssertionError("Incorrect UTM metadata accepted")
        except ImportValidationError as exc:
            assert expected in str(exc), str(exc)

    for key, value, error in [("bbox_utm_srids", [32631], "bbox zone"),
            ("metric_srids_present", [32631], "SRID inventory"),
            ("utm_crossing_features", 0, "metric counts")]:
        changed = copy.deepcopy(manifest)
        changed[key] = value
        rejected(changed, error)
    file = dataset / "features.parquet"
    original = file.read_bytes()
    try:
        table = pq.read_table(file)
        records = table.to_pylist()
        next(row for row in records if row["id"] == "west")["geometry_m_srid"] = 32632
        pq.write_table(pa.Table.from_pylist(records, schema=table.schema), file)
        changed = copy.deepcopy(manifest)
        changed["tables"]["features"].update(sha256=sha256(file), bytes=file.stat().st_size)
        rejected(changed, "UTM assignment")
    finally:
        file.write_bytes(original)
    verify_snapshot(dataset)


def main():
    import psycopg
    from shapely import from_wkt
    from pyproj import Geod
    from overture_lab.spark import create_sedona
    from overture_lab.postgis_import import prepare, load, verify
    from overture_lab.postgis_import.snapshot import rows
    from overture_lab.postgis_import.database import read_connections, connection
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--connections", type=Path, required=True)
    args = parser.parse_args()
    args.root.mkdir(parents=True)
    projector_tests()
    fixture(args.root / "source")
    settings = configuration(args.root)
    spark = create_sedona(settings, "utm-multi-zone-acceptance")
    dataset = args.root / "snapshot"
    try:
        manifest = prepare(spark, settings, dataset, [5.8, -0.2, 6.2, 50.2], schema_version="v1.18.0")
    finally:
        spark.stop()
    snapshot_metadata_tests(dataset)
    features = {r["id"]: r for r in rows(dataset, "features")}
    assert manifest["bbox_utm_srids"] == [32631, 32632, 32731, 32732]
    assert manifest["metric_srids_present"] == [32631, 32632, 32732]
    assert features["west"]["geometry_m_srid"] == 32631
    assert features["east"]["geometry_m_srid"] == 32632
    assert features["south"]["geometry_m_srid"] == 32732
    assert features["north"]["geometry_m_srid"] == 32632
    assert features["crossing"]["utm_crosses_zone"]
    assert features["equator_crossing"]["utm_crosses_zone"]
    for name in ("polar", "south_polar", "partial_polar"):
        assert features[name]["metric_status"] == "outside_utm"
        assert features[name]["geometry_m"] is None
    assert features["empty"]["metric_status"] == "empty_geometry"
    poly = from_wkt(features["concave"]["geometry"])
    assert not poly.contains(poly.centroid)
    assert poly.contains(poly.representative_point())
    assert features["concave"]["utm_crosses_zone"]
    config = read_connections(args.connections)
    config["schema"] = "import_utm_zones"
    load(dataset, config)
    verify(dataset, config)
    with connection(config) as conn:
        for left, right, coords in [("west", "east", (5.9999, 50, 6.0001, 50)),
                                   ("south", "north", (6.0001, -.0001, 6.0001, .0001))]:
            expected = Geod(ellps="WGS84").inv(*coords)[2]
            distance, near, far = conn.execute("""SELECT ST_Distance(a.geometry_geog,b.geometry_geog),
                ST_DWithin(a.geometry_geog,b.geometry_geog,%s), ST_DWithin(a.geometry_geog,b.geometry_geog,%s)
                FROM import_utm_zones.features a, import_utm_zones.features b WHERE a.id=%s AND b.id=%s""",
                (expected + .01, expected - .01, left, right)).fetchone()
            assert abs(distance - expected) < .001 and near and not far, (left, distance, expected)
        polar, empty = conn.execute("SELECT geometry_geog IS NOT NULL FROM import_utm_zones.features WHERE id='polar'").fetchone()[0], conn.execute("SELECT geometry_geog IS NULL FROM import_utm_zones.features WHERE id='empty'").fetchone()[0]
        assert polar and empty
        # CASE inside the function is safe even if SQL predicates are reordered.
        conn.execute("""SELECT ST_DWithin(CASE WHEN geometry_m_srid=32631 AND NOT utm_crosses_zone THEN geometry_m END,
            ST_Transform(ST_SetSRID(ST_Point(5.9999,50),4326),32631),100) FROM import_utm_zones.features""").fetchall()
        conn.execute("SET LOCAL enable_seqscan=off")
        plan = str(conn.execute("EXPLAIN SELECT id FROM import_utm_zones.features WHERE ST_DWithin(geometry_geog,ST_SetSRID(ST_Point(6,50),4326)::geography,100)").fetchall())
        assert "Index" in plan, plan
    for update in ("geometry_m_srid=2039", "geometry_m_srid=32632", "geometry_m=ST_SetSRID(geometry_m,32731)"):
        try:
            with connection(config) as conn:
                conn.execute(f"UPDATE import_utm_zones.features SET {update} WHERE id='west'")
            raise AssertionError("Database accepted mismatched SRID")
        except psycopg.errors.CheckViolation:
            pass
    print("UTM MULTI-ZONE, HEMISPHERE, POLAR, SRID CONSTRAINT AND GEOGRAPHY ACCEPTANCE PASSED")


if __name__ == "__main__":
    main()
