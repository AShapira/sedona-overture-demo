"""Resolve configured medium and small scales from Overture divisions."""

from __future__ import annotations

from dataclasses import dataclass
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from pyspark.sql import DataFrame, SparkSession

from .config import CitySpec, LabSettings
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
class ScaleRegions:
    medium: "DataFrame"
    small: "DataFrame"
    medium_bounds: tuple[Bounds, ...]
    small_bounds: tuple[Bounds, ...]
    small_division_ids: tuple[str, ...]


def _bounds(df: "DataFrame") -> tuple[Bounds, ...]:
    rows = df.select("bbox.xmin", "bbox.ymin", "bbox.xmax", "bbox.ymax").collect()
    bounds = _bounds_from_values(
        (row.xmin, row.ymin, row.xmax, row.ymax) for row in rows
    )
    return bounds


def _bounds_from_values(values) -> tuple[Bounds, ...]:
    bounds = tuple(Bounds(*value) for value in values)
    if not bounds or any(item.xmin is None for item in bounds):
        raise RuntimeError("Resolved scale has no usable bounding boxes")
    return bounds


def _resolve_city_division_ids(
    city_rows: list[dict[str, object]], city_specs: tuple[CitySpec, ...]
) -> tuple[str, ...]:
    division_ids = []
    for city in city_specs:
        matches = [
            row
            for row in city_rows
            if row["country"] == city.state_code
            and row["names"]["common"].get("en") == city.name
        ]
        if len(matches) != 1:
            raise RuntimeError(
                f"Expected one {city.name!r} locality in {city.state_code}, "
                f"found {len(matches)}: {matches}"
            )
        division_ids.append(matches[0]["id"])
    return tuple(division_ids)


def resolve_scale_regions(
    spark: "SparkSession", settings: LabSettings
) -> ScaleRegions:
    from pyspark.sql import functions as F

    divisions = read_type(spark, settings, "divisions", "division")
    city_names = [city.name for city in settings.small_cities]
    city_rows = (
        divisions.where(
            F.col("country").isin(*settings.medium_state_codes)
            & (F.col("subtype") == "locality")
            & F.element_at(F.col("names.common"), F.lit("en")).isin(
                *city_names
            )
        )
        .select("id", "country", "names", "class")
        .collect()
    )
    division_ids = _resolve_city_division_ids(
        [row.asDict(recursive=True) for row in city_rows], settings.small_cities
    )

    areas = read_type(spark, settings, "divisions", "division_area")
    columns = ["id", "division_id", "country", "names", "bbox", "geometry"]
    medium = areas.where(
        F.col("country").isin(*settings.medium_state_codes)
        & (F.col("subtype") == "country")
        & F.col("is_land")
    ).select(*columns)
    resolved_codes = {
        row.country for row in medium.select("country").distinct().collect()
    }
    missing_codes = set(settings.medium_state_codes) - resolved_codes
    if missing_codes:
        raise RuntimeError(
            "No land country area found for configured state codes: "
            f"{sorted(missing_codes)}"
        )

    small = areas.where(
        F.col("division_id").isin(*division_ids) & F.col("is_land")
    ).select(*columns)
    resolved_ids = {
        row.division_id for row in small.select("division_id").distinct().collect()
    }
    missing_ids = set(division_ids) - resolved_ids
    if missing_ids:
        raise RuntimeError(
            "No land division area found for configured cities with IDs: "
            f"{sorted(missing_ids)}"
        )

    return ScaleRegions(
        medium=medium,
        small=small,
        medium_bounds=_bounds(medium),
        small_bounds=_bounds(small),
        small_division_ids=tuple(division_ids),
    )


def bbox_overlap(
    df: "DataFrame", bounds: Bounds | tuple[Bounds, ...]
) -> "DataFrame":
    """Cheap Parquet-friendly candidate filter before exact spatial work."""
    from pyspark.sql import functions as F

    items = (bounds,) if isinstance(bounds, Bounds) else bounds
    if not items:
        raise ValueError("At least one bounding box is required")
    predicate = None
    for item in items:
        overlap = (
            (F.col("bbox.xmin") <= item.xmax)
            & (F.col("bbox.xmax") >= item.xmin)
            & (F.col("bbox.ymin") <= item.ymax)
            & (F.col("bbox.ymax") >= item.ymin)
        )
        predicate = overlap if predicate is None else predicate | overlap
    return df.where(predicate)


def exact_intersection(
    candidates: "DataFrame", boundary: "DataFrame"
) -> "DataFrame":
    """Retain each candidate once when it intersects any broadcast boundary."""
    from pyspark.sql import functions as F

    boundary_geometries = boundary.select(
        F.col("geometry").alias("boundary_geometry")
    ).alias("boundary")
    return candidates.alias("candidate").join(
        F.broadcast(boundary_geometries),
        F.expr(
            "ST_Intersects(candidate.geometry, boundary.boundary_geometry)"
        ),
        "left_semi",
    )


def bounded_sample(
    raw: "DataFrame",
    boundary: "DataFrame",
    bounds: Bounds | tuple[Bounds, ...],
    limit: int,
) -> "DataFrame":
    """Spatially exact bounded teaching sample; not statistical sampling."""
    return exact_intersection(bbox_overlap(raw, bounds), boundary).limit(limit)
