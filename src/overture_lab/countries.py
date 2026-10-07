"""Worldwide country selection and bounded display copies."""

from __future__ import annotations

import math


def select_world_countries(areas):
    """Retain every source land-country feature, including dual-flag rows."""
    from pyspark.sql import functions as F

    return areas.where((F.col("subtype") == "country") & F.col("is_land")).drop(
        "theme", "feature_type"
    )


def validate_countries(countries) -> dict:
    """Reject incomplete geometry rather than silently repairing or dropping it."""
    from pyspark.sql import functions as F

    invalid = F.expr(
        "geometry IS NULL OR ST_IsEmpty(geometry) OR NOT ST_IsValid(geometry) "
        "OR ST_SRID(geometry) <> 4326 "
        "OR GeometryType(geometry) NOT IN ('POLYGON', 'MULTIPOLYGON')"
    )
    report = countries.agg(
        F.count("*").alias("features"),
        F.countDistinct("country").alias("country_codes"),
        F.sum(F.when(invalid, 1).otherwise(0)).alias("invalid_geometries"),
    ).first().asDict()
    if not report["features"]:
        raise ValueError("No land-country polygons found in this release")
    if report["invalid_geometries"]:
        raise ValueError(f"Invalid country geometry: {report}")
    return report


def country_display_frame(countries, *, feature_limit: int, tolerance: float = 0.01,
                          coordinate_limit: int = 750_000):
    """Check Spark-side budgets before collecting all simplified display features."""
    from pyspark.sql import functions as F
    from .visualize import collect_geodataframe

    if feature_limit < 1 or coordinate_limit < 1:
        raise ValueError("Display budgets must be positive")
    if not math.isfinite(tolerance) or tolerance < 0:
        raise ValueError("Display tolerance must be finite and nonnegative")
    count = countries.limit(feature_limit + 1).count()
    if count > feature_limit:
        raise ValueError(
            f"World map exceeds MAP_FEATURE_LIMIT={feature_limit}; increase the "
            "configured limit to include every country. No features were omitted."
        )
    candidates = countries.withColumn(
        "_simplified", F.expr(f"ST_SimplifyPreserveTopology(geometry, {float(tolerance)})")
    ).withColumn("full_resolution_preview", F.expr(
        "_simplified IS NULL OR ST_IsEmpty(_simplified) OR NOT ST_IsValid(_simplified)"
    ))
    # Some multipart source features acquire nested shells in JTS simplification.
    # Use their valid original geometry for display rather than repair or omit them.
    display_frame = candidates.select(
        "id", "country",
        F.coalesce(F.element_at("names.common", F.lit("en")),
                   F.col("names.primary"), F.col("country"), F.col("id")).alias("name"),
        "full_resolution_preview",
        F.when(F.col("full_resolution_preview"), F.col("geometry"))
        .otherwise(F.col("_simplified")).alias("geometry"),
    )
    stats = display_frame.agg(
        F.sum(F.expr("ST_NPoints(geometry)")).alias("coordinates"),
        F.sum(F.when(F.expr("geometry IS NULL OR ST_IsEmpty(geometry) "
                           "OR NOT ST_IsValid(geometry)"), 1).otherwise(0)).alias("invalid"),
    ).first()
    if stats.invalid or not count:
        raise ValueError("Display requires nonempty, valid country polygons")
    if stats.coordinates > coordinate_limit:
        raise ValueError(
            f"World map needs {stats.coordinates:,} coordinates, exceeding "
            f"MAP_COORDINATE_LIMIT={coordinate_limit:,}. Increase MAP_TOLERANCE "
            "or the coordinate budget; no countries were omitted."
        )
    return collect_geodataframe(display_frame.orderBy("country", "id"),
                                limit=feature_limit,
                                columns=["id", "country", "name", "full_resolution_preview"])
