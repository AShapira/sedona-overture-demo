"""Resolve the configured country and locality from Overture divisions."""

from __future__ import annotations

from dataclasses import dataclass
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from pyspark.sql import DataFrame, SparkSession

from .config import LabSettings
from .spark import read_type


@dataclass(frozen=True)
class Bounds:
    xmin: float
    ymin: float
    xmax: float
    ymax: float

    def as_dict(self) -> dict[str, float]:
        return {
            "xmin": self.xmin,
            "ymin": self.ymin,
            "xmax": self.xmax,
            "ymax": self.ymax,
        }


@dataclass(frozen=True)
class FocusRegions:
    country: "DataFrame"
    locality: "DataFrame"
    country_bounds: Bounds
    locality_bounds: Bounds
    locality_division_id: str


def _bounds(df: "DataFrame") -> Bounds:
    row = df.selectExpr(
        "min(bbox.xmin) AS xmin",
        "min(bbox.ymin) AS ymin",
        "max(bbox.xmax) AS xmax",
        "max(bbox.ymax) AS ymax",
    ).first()
    if row is None or row.xmin is None:
        raise RuntimeError("Resolved region has no usable bounding box")
    return Bounds(row.xmin, row.ymin, row.xmax, row.ymax)


def resolve_focus_regions(
    spark: "SparkSession", settings: LabSettings
) -> FocusRegions:
    from pyspark.sql import functions as F

    divisions = read_type(spark, settings, "divisions", "division")
    locality_rows = (
        divisions.where(
            (F.col("country") == settings.locality_country_code)
            & (F.col("subtype") == "locality")
            & (
                F.element_at(F.col("names.common"), F.lit("en"))
                == settings.locality_name_en
            )
        )
        .select("id", "names.primary", "names.common", "class")
        .collect()
    )
    if len(locality_rows) != 1:
        candidates = [row.asDict(recursive=True) for row in locality_rows]
        raise RuntimeError(
            f"Expected one {settings.locality_name_en!r} locality in "
            f"{settings.locality_country_code}, found {len(locality_rows)}: "
            f"{candidates}"
        )
    locality_division_id = locality_rows[0].id

    areas = read_type(spark, settings, "divisions", "division_area")
    country = areas.where(
        (F.col("country") == settings.country_code)
        & (F.col("subtype") == "country")
        & F.col("is_land")
    ).select("id", "division_id", "names", "bbox", "geometry")
    locality = areas.where(
        (F.col("division_id") == locality_division_id) & F.col("is_land")
    ).select("id", "division_id", "names", "bbox", "geometry")

    if country.count() != 1:
        raise RuntimeError(
            f"Expected one land country area for {settings.country_code}"
        )
    if locality.count() != 1:
        raise RuntimeError(
            f"Expected one land area for {settings.locality_name_en}"
        )

    return FocusRegions(
        country=country,
        locality=locality,
        country_bounds=_bounds(country),
        locality_bounds=_bounds(locality),
        locality_division_id=locality_division_id,
    )


def bbox_overlap(df: "DataFrame", bounds: Bounds) -> "DataFrame":
    """Cheap Parquet-friendly candidate filter before exact spatial work."""
    from pyspark.sql import functions as F

    return df.where(
        (F.col("bbox.xmin") <= bounds.xmax)
        & (F.col("bbox.xmax") >= bounds.xmin)
        & (F.col("bbox.ymin") <= bounds.ymax)
        & (F.col("bbox.ymax") >= bounds.ymin)
    )


def exact_intersection(
    candidates: "DataFrame", boundary: "DataFrame"
) -> "DataFrame":
    """Broadcast one boundary and retain geometries that truly intersect it."""
    from pyspark.sql import functions as F

    boundary_one = boundary.select(
        F.col("geometry").alias("boundary_geometry")
    )
    return (
        candidates.crossJoin(F.broadcast(boundary_one))
        .where(F.expr("ST_Intersects(geometry, boundary_geometry)"))
        .drop("boundary_geometry")
    )


def bounded_sample(
    raw: "DataFrame",
    boundary: "DataFrame",
    bounds: Bounds,
    limit: int,
) -> "DataFrame":
    """Spatially exact bounded teaching sample; not statistical sampling."""
    return exact_intersection(bbox_overlap(raw, bounds), boundary).limit(limit)
