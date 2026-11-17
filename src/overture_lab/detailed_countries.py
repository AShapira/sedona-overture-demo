"""Experimental country pieces: territorial country areas intersect physical land.

All geometry stays in Sedona. Tile seams partition the result; no global
dissolve, simplification, precision grid, repair, or inland-water subtraction.
"""
from __future__ import annotations

from dataclasses import dataclass, replace
import math
import time

from . import outputs
from .land_water import _tile_parts
from .surfaces import POLYGONS, SURFACE_FILTERS, geometry_bbox, _fingerprints


POLICY = ("experimental; territorial_country_intersect_physical_land; aligned_tiles; "
          "subdivide_and_dissolve; overlay_ng; relate_ng; no_simplification; "
          "no_precision_grid; no_repair; no_inland_water_subtraction")


@dataclass(frozen=True)
class DetailedCountryOptions:
    tile_degrees: float = 0.5
    max_tile_coordinates: int = 2_000_000

    def validate(self):
        d = self.tile_degrees
        if (isinstance(d, bool) or not math.isfinite(d) or not 0 < d <= 180
                or not math.isclose(180 / d, round(180 / d))):
            raise ValueError("Detailed-country tile_degrees must be positive, <=180, and divide 180 exactly")
        n = self.max_tile_coordinates
        if isinstance(n, bool) or not isinstance(n, int) or n < 1:
            raise ValueError("Detailed-country max_tile_coordinates must be a positive integer")


def _check_geometry(frame, label):
    bad = frame.where(
        f"id IS NULL OR geometry IS NULL OR NOT ({POLYGONS}) OR ST_IsEmpty(geometry) "
        "OR NOT ST_IsValid(geometry) OR ST_SRID(geometry) <> 4326 "
        "OR ST_XMin(geometry) < -180 OR ST_XMax(geometry) > 180 "
        "OR ST_YMin(geometry) < -90 OR ST_YMax(geometry) > 90"
    ).select("id").limit(5).collect()
    if bad:
        raise ValueError(f"Invalid experimental {label} source polygons: {bad}; no automatic repair")


def _guard(stats, options, operation):
    from pyspark.sql import functions as F
    bad = (stats.where(F.col("coordinates") > options.max_tile_coordinates)
           .orderBy(F.desc("coordinates")).limit(10).collect())
    if bad:
        raise ValueError(f"Detailed-country {operation} coordinate guard "
                         f"({options.max_tile_coordinates}) exceeded: {[r.asDict() for r in bad]}; "
                         "reduce DETAILED_COUNTRY_TILE_DEGREES")


def _tiled(frame, options):
    from pyspark.sql import functions as F
    # Avoid copying a huge country geometry to every cell in its bounding box.
    # Subdivision only adds cut vertices; the pieces are reunited within tiles.
    blocks = frame.withColumn("geometry", F.explode(F.expr("ST_SubDivide(geometry, 2048)")))
    def guard_clipping(parts):
        _guard(parts.select("id", "tile_id", (F.expr("ST_NPoints(geometry)") + 5).alias("coordinates")),
               options, "input tile clipping")
    return _tile_parts(blocks, options, before_clip=guard_clipping)


def build_detailed_countries(areas, countries, land, *, release, release_uri,
                             options=DetailedCountryOptions(), progress=None):
    """Return a materialized DISK_ONLY frame and diagnostics; caller unpersists."""
    from pyspark import StorageLevel
    from pyspark.sql import functions as F
    options.validate()
    spark = areas.sparkSession
    if any(spark._jvm.java.lang.System.getProperty(k) != "ng" for k in ("jts.overlay", "jts.relate")):
        raise RuntimeError("Detailed-country overlays require create_sedona(..., overlay_ng=True) in a fresh kernel")
    started = time.perf_counter()
    caches = []
    result = None

    def cache(frame):
        frame = frame.persist(StorageLevel.DISK_ONLY)
        caches.append(frame)
        return frame

    def event(phase, **values):
        if progress:
            values.setdefault("seconds", round(time.perf_counter()-started, 3))
            progress(dict(phase=phase, **values))

    try:
        wanted = countries.select("division_id").distinct()
        if wanted.where("division_id IS NULL").limit(1).count():
            raise ValueError("Displayed country has no division_id; cannot match territorial geometry")
        if not wanted.count():
            raise ValueError("No displayed countries to match")
        territories = cache(areas.where("subtype = 'country' AND is_territorial = true")
                            .join(wanted, "division_id", "left_semi")
                            .select("id", "division_id", "country", "names", "sources", "geometry"))
        missing = wanted.join(territories.select("division_id").distinct(), "division_id", "left_anti")
        if missing.limit(1).count():
            raise ValueError(f"Missing territorial country matches: {[r.division_id for r in missing.limit(20).collect()]}")
        if territories.groupBy("id").count().where("count > 1").limit(1).count():
            raise ValueError("Duplicate territorial source IDs; representations must have distinct IDs")
        _check_geometry(territories, "territorial country")
        selected_land = cache(land.where(SURFACE_FILTERS["landmass"]).select("id", "sources", "geometry"))
        _check_geometry(selected_land, "physical land")
        event("sources_validated", territorial_features=territories.count())

        territory_parts = cache(_tiled(territories.select("id", "geometry"), options))
        _guard(territory_parts.groupBy("id", "tile_id").agg(F.sum("_coordinates").alias("coordinates")),
               options, "territorial tile union")
        occupied = territory_parts.select("tile_id").distinct()
        fields = set(selected_land.schema["sources"].dataType.elementType.fieldNames())
        attribution = F.transform("sources", lambda s: F.struct(*[
            (s[k] if k in fields else F.lit(None).cast("string")).alias(k) for k in ("dataset", "license")]))
        projected = selected_land.select("id", "geometry", attribution.alias("_attribution"))
        land_parts = cache(_tiled(projected, options).join(occupied, "tile_id", "left_semi"))
        _guard(land_parts.groupBy("tile_id").agg(F.sum("_coordinates").alias("coordinates")),
               options, "physical land tile union")
        event("tile_union_guards_passed", tile_degrees=options.tile_degrees)

        land_sources = (land_parts.select("tile_id", F.explode("_attribution").alias("source"))
                        .groupBy("tile_id").agg(F.sort_array(F.collect_set("source")).alias("land_sources"))
                        .withColumn("land_sources", F.from_json(F.to_json("land_sources"),
                                    "array<struct<dataset:string,license:string>>")))
        territorial_tiles = territory_parts.groupBy("id", "tile_id").agg(
            F.expr("ST_Union_Aggr(geometry)").alias("territory"))
        land_tiles = land_parts.groupBy("tile_id").agg(F.expr("ST_Union_Aggr(geometry)").alias("land"))
        pairs = cache(territorial_tiles.join(land_tiles, "tile_id"))
        _guard(pairs.select("id", "tile_id", F.expr("ST_NPoints(territory) + ST_NPoints(land)").alias("coordinates")),
               options, "country/land intersection")
        event("intersection_guard_passed")
        intersections = (pairs.withColumn("geometry", F.expr(
            "ST_SetSRID(ST_CollectionExtract(ST_Intersection(territory, land), 3), 4326)"))
            .where("NOT ST_IsEmpty(geometry)").select("id", "tile_id", "geometry"))
        metadata = territories.select("id", "division_id", "country", F.col("names.primary").alias("name"),
                                      F.col("sources").alias("territorial_sources"))
        result = (intersections.join(metadata, "id").join(land_sources, "tile_id", "left")
                  .withColumnRenamed("id", "territorial_area_id")
                  .withColumn("id", F.concat(F.lit("experimental-country:"), F.sha2(F.to_json(F.struct(
                      F.lit(release).alias("release"), F.lit(options.tile_degrees).alias("tile_degrees"),
                      "territorial_area_id", "tile_id")), 256)))
                  .withColumn("tile_degrees", F.lit(options.tile_degrees))
                  .withColumn("release", F.lit(release)).withColumn("release_uri", F.lit(release_uri))
                  .withColumn("experimental", F.lit(True)).withColumn("geometry_policy", F.lit(POLICY))
                  .withColumn("bbox", geometry_bbox()).persist(StorageLevel.DISK_ONLY))
        report = validate_detailed_countries(result)
        absent = territories.select("id", "division_id", "country").join(
            result.select(F.col("territorial_area_id").alias("id")).distinct(), "id", "left_anti")
        report.update(territorial_features=territories.count(), tile_degrees=options.tile_degrees,
                      empty_territorial_intersections=[r.asDict() for r in absent.collect()],
                      seconds=round(time.perf_counter()-started, 3))
        event("experimental_countries_materialized", **report)
        return result, report
    except BaseException:
        if result is not None:
            result.unpersist()
        raise
    finally:
        for frame in reversed(caches):
            frame.unpersist()


def validate_detailed_countries(frame):
    from pyspark.sql import functions as F
    bad = (f"geometry IS NULL OR ST_IsEmpty(geometry) OR NOT ({POLYGONS}) "
           "OR NOT ST_IsValid(geometry) OR ST_SRID(geometry) <> 4326 "
           "OR id IS NULL OR id = territorial_area_id OR division_id IS NULL "
           "OR territorial_area_id IS NULL OR tile_id IS NULL OR release IS NULL "
           "OR experimental IS NULL OR NOT experimental OR geometry_policy IS NULL "
           "OR bbox IS NULL OR ST_XMin(geometry) < -180 OR ST_XMax(geometry) > 180 "
           "OR ST_YMin(geometry) < -90 OR ST_YMax(geometry) > 90")
    for axis, fn in (("xmin", "XMin"), ("xmax", "XMax"), ("ymin", "YMin"), ("ymax", "YMax")):
        bad += f" OR bbox.{axis} IS NULL OR isnan(bbox.{axis}) OR abs(bbox.{axis} - ST_{fn}(geometry)) > 1e-12"
    stats = frame.agg(F.count("*").alias("features"), F.countDistinct("division_id").alias("divisions"),
                      F.countDistinct("country").alias("country_codes"),
                      F.sum(F.expr("ST_NPoints(geometry)")).alias("coordinates"),
                      F.sum(F.when(F.expr(bad), 1).otherwise(0)).alias("invalid_features")).first().asDict()
    if stats["invalid_features"]:
        raise ValueError(f"Invalid experimental country geometry/provenance: {stats}")
    if frame.groupBy("territorial_area_id", "tile_id").count().where("count > 1").limit(1).count():
        raise ValueError("Duplicate experimental country/tile pieces")
    return stats


def export_detailed_countries(frame, spark, settings):
    """One separately named local/S3 file, verified without destination fallback."""
    if settings.write_derived:
        validate_detailed_countries(frame)
    result = outputs.write_single_geoparquet(frame, spark, replace(settings, allow_local_derived_fallback=False),
        dataset_name="world-countries-detailed-experimental", object_name="detailed_countries_experimental.geoparquet")
    report = result.as_dict()
    if result.status == "written":
        try:
            restored = spark.read.format("geoparquet").load(result.geoparquet_uri)
            report["validation"] = validate_detailed_countries(restored)
            before, after = _fingerprints(frame), _fingerprints(restored)
            if before.exceptAll(after).limit(1).count() or after.exceptAll(before).limit(1).count():
                raise RuntimeError("Experimental country attribute/geometry fingerprints differ after reload")
            report["exact_round_trip"] = True
        except Exception as exc:
            raise RuntimeError(f"Experimental country read-back failed; inspect {result.run_prefix}") from exc
    return report
