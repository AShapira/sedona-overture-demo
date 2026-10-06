"""Physical landmass/ocean surfaces, exact extracts, and verified exports.

All geometry processing stays in Sedona. Only summaries and explicitly bounded
display copies are collected. Country boundaries define an extent, not a coast.
"""

from __future__ import annotations

from dataclasses import replace
import json
import math
import time

from .outputs import write_single_geoparquet
from .regions import Bounds, bbox_overlap


SURFACE_FILTERS = {
    "landmass": "subtype = 'land' AND class = 'land'",
    "ocean": "subtype = 'ocean'",
}
POLYGONS = "ST_GeometryType(geometry) IN ('ST_Polygon', 'ST_MultiPolygon')"
REQUIRED_SOURCE_COLUMNS = {"id", "version", "sources", "subtype", "class", "geometry", "bbox"}


def regional_bounds(boxes: tuple[Bounds, ...]) -> Bounds:
    """Combine non-wrapped boxes; refuse ambiguous antimeridian extents."""
    if not boxes:
        raise ValueError("At least one country extent is required")
    for box in boxes:
        values = (box.xmin, box.ymin, box.xmax, box.ymax)
        if not all(math.isfinite(x) for x in values):
            raise ValueError("Extent coordinates must be finite")
        if not (-180 <= box.xmin < box.xmax <= 180 and -90 <= box.ymin < box.ymax <= 90):
            raise ValueError("Invalid or antimeridian-wrapped regional extent")
    result = Bounds(min(b.xmin for b in boxes), min(b.ymin for b in boxes),
                    max(b.xmax for b in boxes), max(b.ymax for b in boxes))
    if result.xmax - result.xmin > 180:
        raise ValueError("Regional extent spans more than 180 degrees; split antimeridian regions explicitly")
    return result


def envelope_sql(bounds: Bounds) -> str:
    regional_bounds((bounds,))
    return (f"ST_SetSRID(ST_PolygonFromEnvelope({bounds.xmin}, {bounds.ymin}, "
            f"{bounds.xmax}, {bounds.ymax}), 4326)")


def geometry_bbox():
    from pyspark.sql import functions as F

    return F.struct(*(F.expr(f"ST_{fn}(geometry)").alias(axis) for axis, fn in (
        ("xmin", "XMin"), ("xmax", "XMax"), ("ymin", "YMin"), ("ymax", "YMax"))))


def source_classification_counts(dataframe):
    missing = REQUIRED_SOURCE_COLUMNS - set(dataframe.columns)
    if missing:
        raise ValueError(f"Surface source is missing columns: {sorted(missing)}")
    return dataframe.groupBy("subtype", "class").count().orderBy("subtype", "class")


def select_world_surfaces(land, water, *, release: str, release_uri: str):
    """Project native coastline surfaces without dissolving or simplifying."""
    from pyspark.sql import functions as F

    frames = []
    for surface, source in (("landmass", land), ("ocean", water)):
        missing = REQUIRED_SOURCE_COLUMNS - set(source.columns)
        if missing:
            raise ValueError(f"{surface} source is missing columns: {sorted(missing)}")
        selected = source.where(SURFACE_FILTERS[surface])
        # Unexpected geometry in a surface classification is an error, not a
        # reason to silently discard a coastline piece.
        frames.append(selected.select(
            F.lit(surface).alias("surface"), F.col("id").alias("source_id"),
            F.col("version").alias("source_version"), "sources",
            F.lit("base/land" if surface == "landmass" else "base/water").alias("source_type"),
            F.lit(SURFACE_FILTERS[surface]).alias("source_filter"),
            F.lit(release).alias("release"), F.lit(release_uri).alias("release_uri"),
            F.lit("world").alias("scope"),
            F.lit("native_coastline_surface; bbox_recomputed; no_simplification; inland_water_within_landmass").alias("geometry_policy"),
            F.lit(None).cast("string").alias("extent_json"),
            # Overture's pruning bbox is rounded outward. Derivatives advertise
            # the exact bounds of their own geometry, without changing vertices.
            geometry_bbox().alias("bbox"), "geometry",
        ))
    return frames[0].unionByName(frames[1])


def validate_surfaces(dataframe, *, require_both: bool = False) -> list[dict]:
    """Fail on invalid analytical geometry or missing provenance; return counts."""
    from pyspark.sql import functions as F

    bad = (f"geometry IS NULL OR ST_IsEmpty(geometry) OR NOT ST_IsValid(geometry) "
           f"OR NOT ({POLYGONS}) OR ST_SRID(geometry) <> 4326 "
           "OR source_id IS NULL OR source_version IS NULL OR release IS NULL "
           "OR source_type IS NULL OR source_filter IS NULL OR geometry_policy IS NULL "
           "OR scope IS NULL OR release_uri IS NULL OR surface IS NULL "
           "OR surface NOT IN ('landmass', 'ocean') "
           "OR bbox IS NULL OR bbox.xmin IS NULL OR bbox.xmax IS NULL "
           "OR bbox.ymin IS NULL OR bbox.ymax IS NULL "
           "OR ST_XMin(geometry) < -180 OR ST_XMax(geometry) > 180 "
           "OR ST_YMin(geometry) < -90 OR ST_YMax(geometry) > 90 "
           "OR abs(bbox.xmin - ST_XMin(geometry)) > 0.000001 "
           "OR abs(bbox.xmax - ST_XMax(geometry)) > 0.000001 "
           "OR abs(bbox.ymin - ST_YMin(geometry)) > 0.000001 "
           "OR abs(bbox.ymax - ST_YMax(geometry)) > 0.000001")
    rows = dataframe.groupBy("surface").agg(
        F.count("*").alias("rows"),
        F.sum(F.when(F.expr(bad), 1).otherwise(0)).alias("invalid_rows"),
        F.sum(F.when(F.col("sources").isNull(), 1).otherwise(0)).alias("missing_sources"),
        F.collect_set(F.expr("ST_GeometryType(geometry)")).alias("geometry_types"),
    ).collect()
    report = [r.asDict() for r in rows]
    if require_both and {r["surface"] for r in report} != set(SURFACE_FILTERS):
        raise RuntimeError(f"Release lacks a required physical surface class: {report}. No administrative fallback.")
    if any(r["invalid_rows"] for r in report):
        raise RuntimeError(f"Invalid analytical surface rows: {report}; no automatic repair or deletion")
    return sorted(report, key=lambda r: r["surface"])


def clip_surfaces(world, bounds: Bounds, *, scope: str = "regional"):
    """Clip a validated world frame to an exact rectangle, keeping polygon parts."""
    from pyspark.sql import functions as F

    envelope = envelope_sql(bounds)
    clipped = bbox_overlap(world, bounds).where(F.expr(f"ST_Intersects(geometry, {envelope})"))
    clipped = clipped.withColumn("geometry", F.expr(
        f"ST_SetSRID(ST_CollectionExtract(ST_Intersection(geometry, {envelope}), 3), 4326)"
    )).where("NOT ST_IsEmpty(geometry)")
    return (clipped.withColumn("bbox", geometry_bbox())
            .withColumn("scope", F.lit(scope))
            .withColumn("extent_json", F.lit(json.dumps(bounds.as_dict(), sort_keys=True)))
            .withColumn("geometry_policy", F.lit(
                "rectangle_intersection; no_simplification; inland_water_within_landmass")))


def coverage_report(world, bounds: Bounds, *, max_vertices: int = 2_000_000) -> dict:
    """Topology QA in a small window. Areas are square degrees, not physical area.

    No gaps are filled. The vertex guard prevents an accidental worldwide union.
    Empty and single-class windows are valid diagnostics.
    """
    from pyspark.sql import functions as F
    from pyspark import StorageLevel

    regional_bounds((bounds,))
    if bounds.xmax - bounds.xmin > 1 or bounds.ymax - bounds.ymin > 1:
        raise ValueError("Coverage QA windows must be at most one degree per side")
    clipped = clip_surfaces(world, bounds, scope="qa").persist(StorageLevel.DISK_ONLY)
    try:
        vertices = clipped.selectExpr("ST_NPoints(geometry) AS n").agg(F.sum("n")).first()[0] or 0
        if vertices > max_vertices:
            raise ValueError(f"Coverage window has {vertices} vertices; shrink it below {max_vertices}")
        empty = "ST_SetSRID(ST_GeomFromWKT('POLYGON EMPTY'), 4326)"
        unions = clipped.groupBy("surface").agg(F.expr("ST_Union_Aggr(geometry)").alias("shape"))
        land = unions.where("surface = 'landmass'").select(F.col("shape").alias("land"))
        sea = unions.where("surface = 'ocean'").select(F.col("shape").alias("ocean"))
        # One anchor row also handles a window containing only one class or none.
        shapes = world.sparkSession.range(1).join(land, how="left").join(sea, how="left").select(
            F.coalesce("land", F.expr(empty)).alias("land"),
            F.coalesce("ocean", F.expr(empty)).alias("ocean"),
        )
        result = shapes.selectExpr(
            "ST_Area(ST_Intersection(land, ocean)) AS overlap_deg2",
            f"ST_Area(ST_Difference({envelope_sql(bounds)}, ST_Union(land, ocean))) AS uncovered_deg2",
        ).first().asDict()
        return {"bounds": bounds.as_dict(), "vertices": vertices, **result}
    finally:
        clipped.unpersist()


def display_surfaces(dataframe, *, limit: int, tolerance: float,
                     max_points_per_feature: int = 20_000, max_total_points: int = 300_000):
    """Bound both feature count and per-feature complexity before collection."""
    from pyspark.sql import functions as F
    from pyspark.sql import Window

    if (limit <= 0 or not math.isfinite(tolerance) or tolerance <= 0
            or max_points_per_feature <= 0 or max_total_points <= 0):
        raise ValueError("Display limits and simplification tolerance must be positive")
    selected = dataframe.orderBy(F.xxhash64("surface", "source_id"), "surface", "source_id").limit(limit)
    preview = (selected.select("surface", "source_id", F.expr(
        f"ST_SimplifyPreserveTopology(geometry, {tolerance})").alias("geometry"))
        .withColumn("_points", F.expr("ST_NPoints(geometry)"))
        .where(F.col("_points") <= max_points_per_feature))
    order = Window.orderBy(F.xxhash64("surface", "source_id"), "surface", "source_id").rowsBetween(
        Window.unboundedPreceding, Window.currentRow)
    return (preview.withColumn("_total_points", F.sum("_points").over(order))
            .where(F.col("_total_points") <= max_total_points).drop("_points", "_total_points"))


def surface_grid(dataframe, *, cell_degrees: float = 2.0,
                 bounds: Bounds = Bounds(-180, -90, 180, 90), max_cells: int = 20_000):
    """Classify cell centers for an offline world overview, without collecting polygons.

    A cell's color describes its center only, not its entire area. Missing and
    ambiguous centers remain visible. The broadcast side is the bounded grid.
    """
    from pyspark.sql import functions as F

    if bounds != Bounds(-180, -90, 180, 90):
        regional_bounds((bounds,))
    if not math.isfinite(cell_degrees) or cell_degrees <= 0:
        raise ValueError("Grid spacing must be positive and finite")
    nx = math.ceil((bounds.xmax - bounds.xmin) / cell_degrees)
    ny = math.ceil((bounds.ymax - bounds.ymin) / cell_degrees)
    if nx * ny > max_cells:
        raise ValueError(f"Grid would contain {nx * ny} cells, exceeding {max_cells}")
    grid = (dataframe.sparkSession.range(nx * ny)
            .withColumn("column", F.col("id") % nx)
            .withColumn("row", F.floor(F.col("id") / nx))
            .withColumn("longitude", F.lit(bounds.xmin) + (F.col("column") + 0.5) * ((bounds.xmax-bounds.xmin)/nx))
            .withColumn("latitude", F.lit(bounds.ymin) + (F.col("row") + 0.5) * ((bounds.ymax-bounds.ymin)/ny))
            .withColumn("center", F.expr("ST_SetSRID(ST_Point(longitude, latitude), 4326)")))
    matches = (dataframe.select("surface", "geometry").join(F.broadcast(grid),
               F.expr("ST_Intersects(geometry, center)"))
               .groupBy("id").agg(F.collect_set("surface").alias("classes")))
    return (grid.drop("center").join(matches, "id", "left")
            .withColumn("surface", F.when(F.col("classes").isNull(), F.lit("uncovered"))
                        .when(F.size("classes") > 1, F.lit("ambiguous"))
                        .otherwise(F.element_at("classes", 1)))
            .drop("classes").orderBy("row", "column"))


def _fingerprints(dataframe):
    from pyspark.sql import functions as F

    columns = sorted(c for c in dataframe.columns if c != "geometry_bbox")
    projected = dataframe.select(*(F.hex(F.expr("ST_AsBinary(geometry)")).alias(c)
                                  if c == "geometry" else F.col(c) for c in columns))
    return projected.select(F.sha2(F.to_json(F.struct(*columns), options={"ignoreNullFields": "false"}), 256).alias("digest"))


def export_surfaces(dataframe, spark, settings, *, scope: str) -> dict:
    """Write one exact file, then verify all row fingerprints, bbox, and metadata."""
    if scope not in {"world", "regional"}:
        raise ValueError("Export scope must be world or regional")
    started = time.perf_counter()
    if settings.write_derived:
        validate_surfaces(dataframe, require_both=(scope == "world"))
    result = write_single_geoparquet(
        dataframe, spark, replace(settings, allow_local_derived_fallback=False),
        dataset_name=f"{scope}_surfaces", object_name=f"{scope}_surfaces.geoparquet",
    )
    report = result.as_dict()
    if result.status == "written":
        try:
            written = spark.read.format("geoparquet").load(result.geoparquet_uri)
            report["surfaces"] = validate_surfaces(written, require_both=(scope == "world"))
            before, after = _fingerprints(dataframe), _fingerprints(written)
            if before.exceptAll(after).limit(1).count() or after.exceptAll(before).limit(1).count():
                raise RuntimeError("GeoParquet geometry/provenance fingerprints differ after reload")
            path = spark._jvm.org.apache.hadoop.fs.Path(result.geoparquet_uri)
            report["bytes"] = path.getFileSystem(spark._jsc.hadoopConfiguration()).getFileStatus(path).getLen()
        except Exception as exc:
            raise RuntimeError(f"Surface read-back failed; inspect {result.run_prefix}. No fallback attempted.") from exc
    report["seconds"] = round(time.perf_counter() - started, 3)
    return report
