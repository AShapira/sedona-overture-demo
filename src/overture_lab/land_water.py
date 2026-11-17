"""Exact, tiled land/water masks. Geometry stays in Sedona, including unions.

Water wins source overlaps. No buffering, simplification, repair, or gap filling
is performed. Attribution is aggregated as dataset/license pairs: mask rows are
derived coverage tiles, not original Overture entities.
"""
from __future__ import annotations

from dataclasses import dataclass, replace
import json
import math
import time

from . import outputs
from .regions import Bounds, bbox_overlap
from .surfaces import POLYGONS, REQUIRED_SOURCE_COLUMNS, SURFACE_FILTERS, geometry_bbox, envelope_sql, _fingerprints

WATER_FILTER = "subtype <> 'physical' AND " + POLYGONS
SELECTION = json.dumps({"land": SURFACE_FILTERS["landmass"], "water": WATER_FILTER}, sort_keys=True)
POLICY = "tile_clip; dissolve; land_minus_water; water_precedence; overlay_ng; relate_ng; no_simplification; no_repair; no_line_buffer; intermittent_included"
EMPTY = "ST_SetSRID(ST_GeomFromWKT('MULTIPOLYGON EMPTY'), 4326)"


@dataclass(frozen=True)
class LandWaterOptions:
    tile_degrees: float = 2.0
    max_tile_coordinates: int = 2_000_000

    def validate(self):
        if (not math.isfinite(self.tile_degrees) or not 0 < self.tile_degrees <= 180
                or not math.isclose(180 / self.tile_degrees, round(180 / self.tile_degrees))):
            raise ValueError("Land/water tile_degrees must be positive, <=180, and divide 180 exactly")
        if isinstance(self.max_tile_coordinates, bool) or not isinstance(self.max_tile_coordinates, int) or self.max_tile_coordinates <= 0:
            raise ValueError("Land/water max_tile_coordinates must be a positive integer")


def _source_projection(source, kind):
    from pyspark.sql import functions as F
    missing = REQUIRED_SOURCE_COLUMNS - set(source.columns)
    if missing:
        raise ValueError(f"Land/water {kind} source is missing columns: {sorted(missing)}")
    fields = {f.name for f in source.schema["sources"].dataType.elementType.fields}
    attribution = F.transform("sources", lambda s: F.struct(
        s["dataset"].alias("dataset") if "dataset" in fields else F.lit(None).cast("string").alias("dataset"),
        s["license"].alias("license") if "license" in fields else F.lit(None).cast("string").alias("license")))
    return source.select("id", "subtype", "class", "geometry", F.lit(kind).alias("_kind"),
                         attribution.alias("_attribution"))


def _selected_sources(land, water):
    from pyspark.sql import functions as F
    land = _source_projection(land, "land").where(SURFACE_FILTERS["landmass"])
    water = _source_projection(water, "water")
    classifications = water.groupBy("subtype", "class").agg(
        F.count("*").alias("rows"),
        F.sum(F.when(F.expr(POLYGONS), 1).otherwise(0)).alias("polygon_rows"),
        F.sum(F.when(F.expr("ST_GeometryType(geometry) IN ('ST_LineString', 'ST_MultiLineString')"), 1).otherwise(0)).alias("line_rows"),
        F.sum(F.when(F.expr("ST_GeometryType(geometry) IN ('ST_Point', 'ST_MultiPoint')"), 1).otherwise(0)).alias("point_rows"),
    ).orderBy("subtype", "class").collect()
    # Null geometry/subtype is an error, rather than an unreported exclusion.
    water = water.where("subtype IS NULL OR subtype <> 'physical'").where(
        f"geometry IS NULL OR ({POLYGONS})")
    selected = land.unionByName(water)
    bad = selected.where(
        f"id IS NULL OR subtype IS NULL OR geometry IS NULL OR NOT ({POLYGONS}) "
        "OR ST_IsEmpty(geometry) OR NOT ST_IsValid(geometry) OR ST_SRID(geometry) <> 4326 "
        "OR ST_XMin(geometry) < -180 OR ST_XMax(geometry) > 180 "
        "OR ST_YMin(geometry) < -90 OR ST_YMax(geometry) > 90"
    ).select("id", "_kind", "subtype").limit(5).collect()
    if bad:
        raise ValueError(f"Invalid land/water source polygons: {[r.asDict() for r in bad]}; no automatic repair or deletion")
    return selected, [r.asDict() for r in classifications]


def _tile_parts(selected, options, *, before_clip=None):
    from pyspark.sql import functions as F
    d = options.tile_degrees
    nx, ny = round(360 / d), round(180 / d)
    # Exact geometry bounds avoid outward-rounded provider boxes and unnecessary
    # edge-only duplicates. Clamping keeps +180/+90 in the final tile.
    def indices(lo, hi, offset, count):
        first = F.greatest(F.lit(0), F.least(F.lit(count-1), F.floor((F.expr(lo) + offset) / d).cast("int")))
        last = F.greatest(first, F.least(F.lit(count-1), (F.ceil((F.expr(hi) + offset) / d)-1).cast("int")))
        return F.sequence(first, last)
    parts = (selected.withColumn("_x", F.explode(indices("ST_XMin(geometry)", "ST_XMax(geometry)", 180, nx)))
             .withColumn("_y", F.explode(indices("ST_YMin(geometry)", "ST_YMax(geometry)", 90, ny)))
             .withColumn("tile_id", F.concat_ws("_", "_x", "_y")))
    if before_clip is not None:
        before_clip(parts)
    tile = f"ST_SetSRID(ST_PolygonFromEnvelope(-180D + _x*{d}, -90D + _y*{d}, -180D + (_x+1)*{d}, -90D + (_y+1)*{d}), 4326)"
    return (parts.where(F.expr(f"ST_Intersects(geometry, {tile})"))
            .withColumn("geometry", F.expr(f"ST_SetSRID(ST_CollectionExtract(ST_Intersection(geometry, {tile}), 3), 4326)"))
            .where("NOT ST_IsEmpty(geometry)").drop("_x", "_y")
            .withColumn("_coordinates", F.expr("ST_NPoints(geometry)")))


def build_land_water(land, water, *, release, release_uri, options=LandWaterOptions(), progress=None):
    """Return a materialized DISK_ONLY world mask and scalar diagnostics.

    The caller owns the returned frame and must unpersist it. Internal caches
    are released even on failure. Coordinate guards run before any tile union.
    """
    from pyspark import StorageLevel
    from pyspark.sql import functions as F
    options.validate()
    if any(land.sparkSession._jvm.java.lang.System.getProperty(key) != "ng"
           for key in ("jts.overlay", "jts.relate")):
        raise RuntimeError("Land/water construction requires create_sedona(..., overlay_ng=True) "
                           "in a fresh notebook kernel")
    started = time.perf_counter()
    selected, classifications = _selected_sources(land, water)
    if progress:
        progress({"phase": "water_classifications", "classes": classifications})
    parts = _tile_parts(selected, options).persist(StorageLevel.DISK_ONLY)
    dissolved = mask = diagnostics = None
    try:
        stats = parts.groupBy("tile_id").agg(
            F.sum("_coordinates").alias("coordinates"),
            F.sum(F.when(F.col("_kind") == "land", 1).otherwise(0)).alias("land_source_count"),
            F.sum(F.when(F.col("_kind") == "water", 1).otherwise(0)).alias("water_source_count"),
            F.sum(F.when(F.col("_attribution").isNull() | (F.size("_attribution") == 0), 1).otherwise(0)).alias("missing_sources"))
        oversized = stats.where(F.col("coordinates") > options.max_tile_coordinates).orderBy(F.desc("coordinates")).limit(10).collect()
        if oversized:
            raise ValueError(f"Land/water tile coordinate guard ({options.max_tile_coordinates}) exceeded: "
                             f"{[r.asDict() for r in oversized]}; reduce LAND_WATER_TILE_DEGREES")
        if progress:
            progress({"phase": "tile_guard_passed", "max_tile_coordinates": options.max_tile_coordinates})
        # Aggregate attribution separately from geometry. A tile's two classes
        # share the contributing land+water dataset/license attribution.
        attribution = (parts.select("tile_id", F.explode("_attribution").alias("source"))
                       .groupBy("tile_id").agg(F.sort_array(F.collect_set("source")).alias("sources"))
                       # Parquet readers restore nullable array elements. Match
                       # that schema before writing, without weakening checks.
                       .withColumn("sources", F.from_json(F.to_json("sources"),
                                   "array<struct<dataset:string,license:string>>")))
        unions = parts.groupBy("tile_id", "_kind").agg(F.expr("ST_Union_Aggr(geometry)").alias("shape"))
        l = unions.where("_kind = 'land'").select("tile_id", F.col("shape").alias("land"))
        w = unions.where("_kind = 'water'").select("tile_id", F.col("shape").alias("water"))
        dissolved = (stats.join(l, "tile_id", "left").join(w, "tile_id", "left")
                     .join(attribution, "tile_id", "left")
                     .withColumn("land", F.coalesce("land", F.expr(EMPTY)))
                     .withColumn("water", F.coalesce("water", F.expr(EMPTY)))
                     .withColumn("dry_land", F.expr("ST_SetSRID(ST_CollectionExtract(ST_Difference(land, water), 3), 4326)"))
                     .persist(StorageLevel.DISK_ONLY))
        # RelateNG avoids quadratic boundary tests in Sedona's overlay wrappers.
        diagnostics = dissolved.selectExpr(
            "tile_id", "coordinates",
            "ST_Area(ST_Intersection(dry_land, water)) AS overlap_deg2",
            "ST_Area(ST_SymDifference(ST_Union(land, water), ST_Union(dry_land, water))) AS footprint_change_deg2",
            f"{options.tile_degrees ** 2} - ST_Area(ST_Union(land, water)) AS uncovered_deg2",
            "NOT ST_IsValid(dry_land) OR NOT ST_IsValid(water) AS invalid").persist()
        invalid = diagnostics.where("invalid OR overlap_deg2 > 1e-12 OR footprint_change_deg2 > 1e-12").limit(5).collect()
        if invalid:
            raise RuntimeError(f"Invalid land/water tile coverage: {[r.asDict() for r in invalid]}; no automatic repair")
        totals = diagnostics.agg(F.count("*").alias("occupied_tiles"), F.max("coordinates").alias("max_tile_coordinates"),
                                F.sum("overlap_deg2").alias("overlap_deg2"),
                                F.sum("footprint_change_deg2").alias("footprint_change_deg2"),
                                F.sum(F.greatest(F.lit(0.0), F.col("uncovered_deg2"))).alias("uncovered_in_occupied_tiles_deg2")).first().asDict()
        totals["empty_tiles"] = round(360 / options.tile_degrees) * round(180 / options.tile_degrees) - totals["occupied_tiles"]
        mask = (dissolved.withColumn("surface", F.explode(F.array(F.lit("land"), F.lit("water"))))
                .withColumn("geometry", F.expr("ST_SetSRID(CASE WHEN surface = 'land' THEN dry_land ELSE water END, 4326)"))
                .where("NOT ST_IsEmpty(geometry)")
                .select("surface", "tile_id", "land_source_count", "water_source_count", "missing_sources", "sources", "geometry")
                .withColumn("tile_degrees", F.lit(options.tile_degrees))
                .withColumn("release", F.lit(release)).withColumn("release_uri", F.lit(release_uri))
                .withColumn("scope", F.lit("world")).withColumn("extent_json", F.lit(None).cast("string"))
                .withColumn("source_filter", F.lit(SELECTION)).withColumn("geometry_policy", F.lit(POLICY))
                .withColumn("bbox", geometry_bbox()).persist(StorageLevel.DISK_ONLY))
        report = {"water_classifications": classifications, "coverage": totals,
                  "surfaces": validate_land_water(mask), "seconds": round(time.perf_counter()-started, 3)}
        report["water_selection"] = {
            "selected_polygon_rows": sum(r["polygon_rows"] for r in classifications if r["subtype"] != "physical"),
            "excluded_physical_rows": sum(r["rows"] for r in classifications if r["subtype"] == "physical"),
            "excluded_line_rows": sum(r["line_rows"] for r in classifications),
            "excluded_point_rows": sum(r["point_rows"] for r in classifications),
        }
        return mask, report
    except BaseException:
        if mask is not None:
            mask.unpersist()
        raise
    finally:
        parts.unpersist()
        if dissolved is not None:
            dissolved.unpersist()
        if diagnostics is not None:
            diagnostics.unpersist()


def clip_land_water(world, bounds: Bounds):
    from pyspark.sql import functions as F
    envelope = envelope_sql(bounds)
    return (bbox_overlap(world, bounds).where(F.expr(f"ST_Intersects(geometry, {envelope})"))
            .withColumn("geometry", F.expr(f"ST_SetSRID(ST_CollectionExtract(ST_Intersection(geometry, {envelope}), 3), 4326)"))
            .where("NOT ST_IsEmpty(geometry)").withColumn("bbox", geometry_bbox())
            .withColumn("scope", F.lit("regional"))
            .withColumn("extent_json", F.lit(json.dumps(bounds.as_dict(), sort_keys=True)))
            .withColumn("geometry_policy", F.concat("geometry_policy", F.lit("; regional_rectangle_intersection"))))


def validate_land_water(frame):
    from pyspark.sql import functions as F
    bad = (f"geometry IS NULL OR ST_IsEmpty(geometry) OR NOT ST_IsValid(geometry) OR NOT ({POLYGONS}) "
           "OR ST_SRID(geometry) <> 4326 OR surface IS NULL OR surface NOT IN ('land', 'water') "
           "OR tile_id IS NULL OR release IS NULL OR release_uri IS NULL OR scope IS NULL "
           "OR source_filter IS NULL OR geometry_policy IS NULL OR bbox IS NULL "
           "OR ST_XMin(geometry) < -180 OR ST_XMax(geometry) > 180 OR ST_YMin(geometry) < -90 OR ST_YMax(geometry) > 90 ")
    for axis, fn in (("xmin", "XMin"), ("xmax", "XMax"), ("ymin", "YMin"), ("ymax", "YMax")):
        bad += f" OR bbox.{axis} IS NULL OR isnan(bbox.{axis}) OR abs(bbox.{axis} - ST_{fn}(geometry)) > 1e-12"
    report = [r.asDict() for r in frame.groupBy("surface").agg(F.count("*").alias("rows"),
              F.sum(F.when(F.expr(bad), 1).otherwise(0)).alias("invalid_rows")).orderBy("surface").collect()]
    if any(r["invalid_rows"] for r in report):
        raise RuntimeError(f"Invalid land/water mask rows: {report}")
    return report


def export_land_water(frame, spark, settings, *, scope):
    if scope not in {"world", "regional"}:
        raise ValueError("Land/water export scope must be world or regional")
    started = time.perf_counter()
    if settings.write_derived:
        validate_land_water(frame)
    result = outputs.write_single_geoparquet(frame, spark, replace(settings, allow_local_derived_fallback=False),
                                           dataset_name=f"{scope}_land_water", object_name=f"{scope}_land_water.geoparquet")
    report = result.as_dict()
    if result.status == "written":
        try:
            restored = spark.read.format("geoparquet").load(result.geoparquet_uri)
            report["surfaces"] = validate_land_water(restored)
            before, after = _fingerprints(frame), _fingerprints(restored)
            if before.exceptAll(after).limit(1).count() or after.exceptAll(before).limit(1).count():
                raise RuntimeError("Land/water geometry/provenance fingerprints differ after reload")
            path = spark._jvm.org.apache.hadoop.fs.Path(result.geoparquet_uri)
            report["bytes"] = path.getFileSystem(spark._jsc.hadoopConfiguration()).getFileStatus(path).getLen()
        except Exception as exc:
            raise RuntimeError(f"Land/water read-back failed; inspect {result.run_prefix}. No fallback attempted.") from exc
    report["seconds"] = round(time.perf_counter()-started, 3)
    return report
