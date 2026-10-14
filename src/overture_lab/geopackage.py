"""Optional, streaming surface GeoPackages and bounded coverage generalization.

Sedona supplies validated exact rows. GDAL writes standard indexed GeoPackages;
Shapely processes one indexed tile at a time. No worldwide geometry collection.
Heavy dependencies are imported only when an export is actually enabled.
"""
from __future__ import annotations

from dataclasses import dataclass, field
import hashlib
import json
import math
from pathlib import Path
import sqlite3
import shutil
import time

from .outputs import _run_id, _single_file_run_prefix, _s3_permission_probe
from .regions import Bounds
from .scratch import scratch_status
from .surfaces import SURFACE_FILTERS, regional_bounds, validate_surfaces

DEFAULT_LEVELS = {"fine": 0.001, "medium": 0.01, "coarse": 0.05}
FULL_FIELDS = {
    "surface": "string", "source_id": "string", "source_version": "Int64",
    "sources_json": "string", "source_type": "string", "source_filter": "string",
    "release": "string", "release_uri": "string", "scope": "string",
    "geometry_policy": "string", "extent_json": "string",
    "bbox_xmin": "float64", "bbox_ymin": "float64",
    "bbox_xmax": "float64", "bbox_ymax": "float64",
}
GENERAL_FIELDS = {
    "surface": "string", "tile_id": "string", "source_count": "Int64",
    "source_filter": "string", "release": "string", "release_uri": "string",
    "scope": "string", "extent_json": "string", "geometry_policy": "string",
    "detail_level": "string", "tolerance_degrees": "float64",
    "tile_degrees": "float64", "precision_grid_degrees": "float64",
    "normalization_area_change_deg2": "float64",
}


@dataclass(frozen=True)
class GeneralizationOptions:
    levels: dict[str, float] = field(default_factory=lambda: dict(DEFAULT_LEVELS))
    tile_degrees: float = 2.0
    max_tile_coordinates: int = 2_000_000
    precision_grid_degrees: float | None = None

    def validate(self):
        if (not math.isfinite(self.tile_degrees) or not 0 < self.tile_degrees <= 180
                or not math.isclose(180 / self.tile_degrees, round(180 / self.tile_degrees))):
            raise ValueError("tile_degrees must be positive, <=180, and divide 180 exactly")
        if not self.levels or set(self.levels) - set(DEFAULT_LEVELS):
            raise ValueError("Choose one or more of fine, medium, coarse")
        tolerances = [self.levels[k] for k in DEFAULT_LEVELS if k in self.levels]
        if any(not math.isfinite(v) or v <= 0 for v in tolerances):
            raise ValueError("Generalization tolerances must be finite and positive")
        if tolerances != sorted(set(tolerances)):
            raise ValueError("Tolerances must strictly increase from fine to coarse")
        if not isinstance(self.max_tile_coordinates, int) or self.max_tile_coordinates <= 0:
            raise ValueError("max_tile_coordinates must be a positive integer")
        if self.precision_grid_degrees is not None and (
                not math.isfinite(self.precision_grid_degrees) or self.precision_grid_degrees <= 0
                or self.precision_grid_degrees >= min(tolerances)):
            raise ValueError("precision_grid_degrees must be positive, finite, and below all simplification tolerances")


def check_geopackage_dependencies() -> dict:
    try:
        import shapely
        import pyogrio
        import geopandas
        import pyarrow
    except ImportError as exc:
        raise RuntimeError("GeoPackage export needs requirements-geopackage.txt; "
                           "install it in the notebook runtime, or disable EXPORT_GEOPACKAGE") from exc
    if not hasattr(shapely, "coverage_simplify") or shapely.geos_version < (3, 12, 0):
        raise RuntimeError("GeoPackage generalization requires Shapely >=2.1 and GEOS >=3.12")
    if "w" not in pyogrio.list_drivers().get("GPKG", ""):
        raise RuntimeError("Pyogrio's GDAL must support writing GPKG")
    return {"shapely": shapely.__version__, "geos": shapely.geos_version_string,
            "pyogrio": pyogrio.__version__, "gdal": pyogrio.__gdal_version_string__,
            "geopandas": geopandas.__version__, "pyarrow": pyarrow.__version__}


def surface_tiles(bounds: Bounds, tile_degrees: float):
    """Globally aligned tiles clipped to the requested non-wrapped extent."""
    nx, ny = round(360 / tile_degrees), round(180 / tile_degrees)
    for y in range(max(0, math.floor((bounds.ymin + 90) / tile_degrees)),
                   min(ny, math.ceil((bounds.ymax + 90) / tile_degrees))):
        for x in range(max(0, math.floor((bounds.xmin + 180) / tile_degrees)),
                       min(nx, math.ceil((bounds.xmax + 180) / tile_degrees))):
            yield f"{x}_{y}", Bounds(
                max(bounds.xmin, -180 + x * tile_degrees),
                max(bounds.ymin, -90 + y * tile_degrees),
                min(bounds.xmax, -180 + (x + 1) * tile_degrees),
                min(bounds.ymax, -90 + (y + 1) * tile_degrees))


def _polygonal(geometry):
    import shapely
    from shapely.geometry import MultiPolygon
    if geometry.is_empty:
        return MultiPolygon([])
    if geometry.geom_type == "Polygon":
        return MultiPolygon([geometry])
    if geometry.geom_type == "MultiPolygon":
        return geometry
    if geometry.geom_type == "GeometryCollection":
        parts = [_polygonal(p) for p in geometry.geoms]
        return _polygonal(shapely.union_all([p for p in parts if not p.is_empty])) if any(
            not p.is_empty for p in parts) else MultiPolygon([])
    return MultiPolygon([])  # boundary-only contacts have no surface area


def _digest_row(attributes, geometry) -> bytes:
    import shapely
    payload = json.dumps(attributes, sort_keys=True, separators=(",", ":"),
                         ensure_ascii=False, allow_nan=False).encode()
    return hashlib.sha256(payload + b"\0" + shapely.to_wkb(
        geometry, byte_order=1, include_srid=False)).digest()


def _iter_features(path, layer, *, bbox=None):
    """GDAL's Arrow stream honors the GeoPackage spatial index and bounds RAM."""
    import pyogrio
    import shapely
    with pyogrio.open_arrow(path, layer=layer, bbox=bbox, batch_size=128,
                           use_pyarrow=True) as (metadata, reader):
        geometry_name = metadata["geometry_name"] or "wkb_geometry"
        for batch in reader:
            for record in batch.to_pylist():
                geometry = shapely.from_wkb(record.pop(geometry_name))
                yield record, geometry


def iter_geopackage_features(path, layer, *, bbox=None):
    """Stream stored attributes and Shapely geometry for bounded local previews."""
    yield from _iter_features(path, layer, bbox=bbox)


class _LayerWriter:
    def __init__(self, path, name, fields):
        self.path, self.name, self.fields = path, name, fields
        self.rows, self.geometries = [], []
        self.count = self.vertices = self.buffer_vertices = 0
        self.digest = hashlib.sha256()
        self.created = False

    def add(self, attributes, geometry):
        import shapely
        geometry = _polygonal(geometry)
        if geometry.is_empty or not geometry.is_valid:
            raise ValueError(f"Invalid/empty polygon for layer {self.name}")
        casts = {"string": str, "float64": float, "Int64": int}
        values = {k: None if attributes.get(k) is None else casts[dtype](attributes[k])
                  for k, dtype in self.fields.items()}
        self.digest.update(_digest_row(values, geometry))
        vertices = int(shapely.get_num_coordinates(geometry))
        self.count += 1
        self.vertices += vertices
        self.buffer_vertices += vertices
        self.rows.append(values)
        self.geometries.append(geometry)
        if len(self.rows) >= 512 or self.buffer_vertices >= 100_000:
            self.flush()

    def flush(self):
        import pandas as pd
        import geopandas as gpd
        import pyogrio
        if not self.rows and self.created:
            return
        frame = pd.DataFrame({name: pd.Series([r[name] for r in self.rows], dtype=dtype)
                              for name, dtype in self.fields.items()})
        frame = gpd.GeoDataFrame(frame, geometry=self.geometries, crs="EPSG:4326")
        pyogrio.write_dataframe(
            frame, self.path, layer=self.name, driver="GPKG", append=self.created,
            geometry_type="MultiPolygon", promote_to_multi=True,
            dataset_options={"VERSION": "1.2"},
            layer_options={"FID": "fid", "GEOMETRY_NAME": "geom", "SPATIAL_INDEX": "YES"})
        self.created = True
        self.rows.clear()
        self.geometries.clear()
        self.buffer_vertices = 0

    def report(self):
        self.flush()
        return {"rows": self.count, "vertices": self.vertices,
                "fingerprint": self.digest.hexdigest()}


def _normalize_coverage(dissolved, surfaces, *, grid, tile_id, max_coordinates):
    """Explicit fixed precision plus shared noding; retain gaps and reject overlaps.

    Rounding alone is insufficient when source pieces have different collinear
    vertices. Node all boundaries together and classify the resulting faces.
    """
    import shapely
    rounded = shapely.set_precision(dissolved, grid, mode="valid_output")
    lines = shapely.union_all([p.boundary for p in rounded], grid_size=grid)
    if int(shapely.get_num_coordinates(lines)) > max_coordinates:
        raise ValueError(f"Tile {tile_id}: normalized boundary coordinate guard exceeded; reduce tile_degrees")
    faces = list(shapely.polygonize(list(shapely.get_parts(lines))).geoms)
    if sum(int(shapely.get_num_coordinates(p)) for p in faces) > max_coordinates:
        raise ValueError(f"Tile {tile_id}: normalized face coordinate guard exceeded; reduce tile_degrees")
    groups = [[] for _ in rounded]
    shapely.prepare(rounded)
    for face in faces:
        point = face.representative_point()
        owners = [i for i, p in enumerate(rounded) if p.covers(point)]
        if len(owners) > 1:
            raise ValueError(f"Tile {tile_id}: overlap remains after explicit precision normalization; "
                             "no surface-priority repair is performed")
        if owners:
            groups[owners[0]].append(face)
        # Unowned faces are source gaps and remain uncovered.
    normalized = [_polygonal(shapely.union_all(group, grid_size=grid)) for group in groups]
    if any(p.is_empty for p in normalized) or not shapely.coverage_is_valid(normalized):
        raise ValueError(f"Tile {tile_id}: normalization could not produce a nonempty valid coverage; "
                         "reduce precision_grid_degrees or inspect source geometry")
    changes = {}
    for surface, before, after in zip(surfaces, dissolved, normalized):
        changes[surface] = {
            "symmetric_difference_deg2": before.symmetric_difference(after).area,
            "components_before": len(before.geoms), "components_after": len(after.geoms),
            "holes_before": sum(len(p.interiors) for p in before.geoms),
            "holes_after": sum(len(p.interiors) for p in after.geoms),
        }
    return normalized, changes


def generalize_tile(parts, *, tile_id, options):
    """Dissolve each class, then simplify their shared edges as one coverage."""
    import shapely
    options.validate()
    coordinates = sum(int(shapely.get_num_coordinates(p)) for group in parts.values() for p in group)
    if coordinates > options.max_tile_coordinates:
        raise ValueError(f"Tile {tile_id}: {coordinates} coordinates exceeds "
                         f"{options.max_tile_coordinates}; reduce tile_degrees")
    surfaces = [s for s in SURFACE_FILTERS if parts.get(s)]
    dissolved = [_polygonal(shapely.union_all(parts[s])) for s in surfaces]
    if not dissolved:
        return {}, {"input_vertices": 0, "dissolved_vertices": 0, "normalization": {}}
    if not all(p.is_valid and not p.is_empty for p in dissolved):
        raise ValueError(f"Tile {tile_id}: invalid dissolved geometry")
    changes = {}
    if options.precision_grid_degrees is not None:
        dissolved, changes = _normalize_coverage(
            dissolved, surfaces, grid=options.precision_grid_degrees, tile_id=tile_id,
            max_coordinates=options.max_tile_coordinates)
    if not shapely.coverage_is_valid(dissolved):
        raise ValueError(f"Tile {tile_id}: invalid or non-edge-matched land/ocean coverage; "
                         "no automatic repair, gap filling, or feature deletion. "
                         "Inspect coverage or explicitly opt in to precision_grid_degrees")
    footprint = shapely.union_all(dissolved)
    result = {}
    for level, tolerance in options.levels.items():
        simplified = shapely.coverage_simplify(dissolved, tolerance, simplify_boundary=False)
        if not shapely.coverage_is_valid(simplified) or not all(p.is_valid for p in simplified):
            raise RuntimeError(f"Tile {tile_id}/{level}: invalid generalized coverage")
        # A fixed outer boundary must retain both the coverage footprint and gaps.
        changed_area = footprint.symmetric_difference(shapely.union_all(simplified)).area
        if changed_area > max(1e-12, footprint.area * 1e-10):
            raise RuntimeError(f"Tile {tile_id}/{level}: coverage footprint changed by {changed_area} deg²")
        result[level] = {s: _polygonal(p) for s, p in zip(surfaces, simplified)}
    return result, {"input_vertices": coordinates,
                    "dissolved_vertices": sum(int(shapely.get_num_coordinates(p)) for p in dissolved),
                    "normalization": changes}


def validate_geopackage(path, expected):
    """Check every feature, exact coordinate/attribute fingerprints, CRS and R-trees."""
    import shapely
    with sqlite3.connect(f"{Path(path).resolve().as_uri()}?mode=ro", uri=True) as db:
        if db.execute("PRAGMA integrity_check").fetchall() != [("ok",)]:
            raise RuntimeError("GeoPackage SQLite integrity check failed")
        tables = dict(db.execute("SELECT table_name, srs_id FROM gpkg_contents WHERE data_type='features'"))
        if set(tables) != set(expected) or any(v != 4326 for v in tables.values()):
            raise RuntimeError("GeoPackage layers/CRS differ from the export contract")
        for layer in expected:
            geometry = db.execute("SELECT column_name, geometry_type_name, srs_id FROM gpkg_geometry_columns "
                                  "WHERE table_name=?", (layer,)).fetchone()
            if geometry != ("geom", "MULTIPOLYGON", 4326):
                raise RuntimeError(f"Incorrect geometry declaration: {layer}: {geometry}")
            index = f"rtree_{layer}_geom"
            if not db.execute("SELECT 1 FROM sqlite_master WHERE name=?", (index,)).fetchone():
                raise RuntimeError(f"Missing spatial index: {layer}")
            if db.execute(f'SELECT count(*) FROM "{index}"').fetchone()[0] != expected[layer]["rows"]:
                raise RuntimeError(f"Spatial index row count differs: {layer}")
            digest, count, vertices = hashlib.sha256(), 0, 0
            for attributes, shape in _iter_features(path, layer):
                if shape.is_empty or not shape.is_valid or shape.geom_type != "MultiPolygon":
                    raise RuntimeError(f"Invalid stored geometry: {layer}")
                digest.update(_digest_row(attributes, shape))
                count += 1
                vertices += int(shapely.get_num_coordinates(shape))
            if {"rows": count, "vertices": vertices, "fingerprint": digest.hexdigest()} != expected[layer]:
                raise RuntimeError(f"GeoPackage geometry/attribute fingerprint mismatch: {layer}")


def build_surface_geopackage(path, records, *, scope, bounds, release, release_uri,
                             options=None, progress=None):
    """Build a new local file from an iterator of (scalar attributes, WKB) pairs.

    Caller owns staging/promotion. Exceptions leave the staging file for diagnosis.
    No source rows are limited by the notebook's display settings.
    """
    import shapely
    options = options or GeneralizationOptions()
    options.validate()
    versions = check_geopackage_dependencies()
    if scope not in {"world", "regional"}:
        raise ValueError("scope must be world or regional")
    if scope == "world":
        if bounds != Bounds(-180, -90, 180, 90):
            raise ValueError("world scope requires worldwide bounds")
    else:
        regional_bounds((bounds,))
    if Path(path).exists():
        raise FileExistsError(path)
    Path(path).parent.mkdir(parents=True, exist_ok=True)
    started = time.perf_counter()
    full = {s: _LayerWriter(path, f"{s}_full", FULL_FIELDS) for s in SURFACE_FILTERS}
    for row_number, (attributes, wkb) in enumerate(records, 1):
        if attributes["surface"] not in full:
            raise ValueError("Unexpected surface class")
        full[attributes["surface"]].add(attributes, shapely.from_wkb(bytes(wkb)))
        if progress and row_number % 10_000 == 0:
            progress({"phase": "writing_detailed", "rows": row_number})
    reports = {w.name: w.report() for w in full.values()}
    if progress:
        progress({"phase": "detailed", "layers": reports})
    writers = {(level, s): _LayerWriter(path, f"{s}_{level}", GENERAL_FIELDS)
               for level in options.levels for s in SURFACE_FILTERS}
    tile_count = occupied = input_vertices = dissolved_vertices = 0
    normalization = []
    # Generalized writes must not run while an Arrow read cursor is open.
    for tile_id, box in surface_tiles(bounds, options.tile_degrees):
        parts = {s: [] for s in SURFACE_FILTERS}
        clip = shapely.box(box.xmin, box.ymin, box.xmax, box.ymax)
        coordinates = 0
        for surface in SURFACE_FILTERS:
            for _, geometry in _iter_features(path, f"{surface}_full", bbox=(box.xmin, box.ymin, box.xmax, box.ymax)):
                part = _polygonal(geometry.intersection(clip))
                if part.is_empty:
                    continue
                coordinates += int(shapely.get_num_coordinates(part))
                if coordinates > options.max_tile_coordinates:
                    raise ValueError(f"Tile {tile_id}: coordinate guard exceeded; reduce tile_degrees")
                parts[surface].append(part)
        generalized, stats = generalize_tile(parts, tile_id=tile_id, options=options)
        tile_count += 1
        occupied += bool(generalized)
        input_vertices += stats["input_vertices"]
        dissolved_vertices += stats["dissolved_vertices"]
        if stats["normalization"]:
            normalization.append({"tile_id": tile_id, "surfaces": stats["normalization"]})
        for level, geometries in generalized.items():
            for surface, geometry in geometries.items():
                writers[level, surface].add({
                    "surface": surface, "tile_id": tile_id, "source_count": len(parts[surface]),
                    "source_filter": SURFACE_FILTERS[surface], "release": release,
                    "release_uri": release_uri, "scope": scope,
                    "extent_json": json.dumps(bounds.as_dict(), sort_keys=True),
                    "geometry_policy": "tile_clip; dissolve_by_surface; shared_coverage_simplification; "
                                       "fixed_outer_boundary; inland_water_within_landmass" + (
                                           "; explicit_precision_normalization" if options.precision_grid_degrees else ""),
                    "detail_level": level, "tolerance_degrees": options.levels[level],
                    "tile_degrees": options.tile_degrees,
                    "precision_grid_degrees": options.precision_grid_degrees,
                    "normalization_area_change_deg2": stats["normalization"].get(surface, {}).get(
                        "symmetric_difference_deg2", 0.0),
                }, geometry)
        if progress and tile_count % 25 == 0:
            progress({"phase": "generalizing", "tiles": tile_count, "occupied_tiles": occupied})
    reports.update({w.name: w.report() for w in writers.values()})
    validate_geopackage(path, reports)
    return {"layers": reports, "tiles": tile_count, "occupied_tiles": occupied,
            "clipped_input_vertices": input_vertices, "dissolved_vertices": dissolved_vertices,
            "precision_grid_degrees": options.precision_grid_degrees,
            "normalization": normalization,
            "bytes": Path(path).stat().st_size, "dependencies": versions,
            "seconds": round(time.perf_counter() - started, 3)}


def _file_sha256(path):
    with Path(path).open("rb") as stream:
        return hashlib.file_digest(stream, "sha256").hexdigest()


def _upload_verified(spark, local_path, destination, verification_path):
    """Use the existing authenticated Hadoop filesystem; verify a full download."""
    path_type = spark._jvm.org.apache.hadoop.fs.Path
    target = path_type(destination)
    filesystem = target.getFileSystem(spark._jsc.hadoopConfiguration())
    if filesystem.exists(target):
        raise FileExistsError(destination)
    filesystem.copyFromLocalFile(False, False, path_type(Path(local_path).resolve().as_uri()), target)
    filesystem.copyToLocalFile(False, target, path_type(Path(verification_path).resolve().as_uri()), True)
    if _file_sha256(local_path) != _file_sha256(verification_path):
        raise RuntimeError(f"GeoPackage upload byte verification failed: {destination}")
    Path(verification_path).unlink()


def export_surface_geopackage(dataframe, spark, settings, *, scope, bounds,
                              options=None, progress=None):
    """Export all exact rows plus generalized layers, respecting local/S3 routing."""
    options = options or GeneralizationOptions()
    options.validate()
    if scope not in {"world", "regional"}:
        raise ValueError("scope must be world or regional")
    if not settings.write_derived:
        return {"status": "dry-run", "geopackage_uri": None,
                "detail": "Set WRITE_DERIVED=true to export GeoPackage"}
    check_geopackage_dependencies()
    validate_surfaces(dataframe, require_both=(scope == "world"))
    if settings.derived_output_mode not in {"local", "s3"}:
        raise ValueError("GeoPackage output mode must be local or s3")
    if settings.derived_output_mode == "s3":
        if not settings.derived_output_uri:
            raise ValueError("GeoPackage S3 export requires DERIVED_OUTPUT_URI")
        if not _s3_permission_probe(spark, settings.derived_output_uri):
            raise RuntimeError("GeoPackage S3 destination denied write access; no local fallback")
    scratch_status(settings)
    run_id = _run_id()
    run_prefix = _single_file_run_prefix(settings, f"{scope}_surfaces_gpkg", run_id=run_id)
    destination = f"{run_prefix}/{scope}_surfaces.gpkg"
    stage_dir = (Path(run_prefix) if settings.derived_output_mode == "local" else
                 Path(settings.scratch_dir) / "geopackage" / run_id)
    stage_dir.mkdir(parents=True, exist_ok=False)
    stage = stage_dir / f"{scope}_surfaces.partial.gpkg"
    from pyspark.sql import functions as F
    from pyspark.sql.types import ArrayType, MapType, StructType
    # Explicit scalar contract, retaining all exact source attribution.
    fields = [F.col(name) for name in FULL_FIELDS if name not in {"sources_json"} and not name.startswith("bbox_")]
    sources_type = dataframe.schema["sources"].dataType
    fields.append((F.to_json("sources") if isinstance(sources_type, (ArrayType, MapType, StructType))
                   else F.col("sources").cast("string")).alias("sources_json"))
    fields.extend(F.col(f"bbox.{axis}").alias(f"bbox_{axis}") for axis in ("xmin", "ymin", "xmax", "ymax"))
    stream = dataframe.select(*fields, F.expr("ST_AsBinary(geometry)").alias("wkb"))
    def records():
        for row in stream.toLocalIterator(prefetchPartitions=False):
            record = row.asDict()
            wkb = record.pop("wkb")
            yield record, wkb
    def report_progress(event):
        scratch_status(settings)
        if progress:
            progress(event)
    try:
        report = build_surface_geopackage(stage, records(), scope=scope, bounds=bounds,
                                         release=settings.release, release_uri=settings.release_uri,
                                         options=options, progress=report_progress)
        checksum = _file_sha256(stage)
        scratch_status(settings)
        if settings.derived_output_mode == "local":
            stage.rename(destination)
        else:
            status = scratch_status(settings)
            if (shutil.disk_usage(stage_dir).free - report["bytes"] < settings.scratch_reserve_gb * 1024**3
                    or status.namespace_used_gib + report["bytes"] / 1024**3 > status.usable_budget_gib):
                raise RuntimeError("Insufficient scratch space for the S3 verification download")
            _upload_verified(spark, stage, destination, stage_dir / "upload-verification.gpkg")
            stage.unlink()
            stage_dir.rmdir()
    except Exception as exc:
        raise RuntimeError(f"GeoPackage export did not verify: {exc}. Inspect staging {stage_dir} "
                           f"and destination {destination}; no target fallback attempted") from exc
    return {"status": "written", "geopackage_uri": destination, "run_prefix": run_prefix,
            "sha256": checksum, **report}
