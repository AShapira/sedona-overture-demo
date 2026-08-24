"""Small presentation helpers shared by explanatory notebooks."""

from __future__ import annotations

from .catalog import schema_table
from .regions import bounded_sample
from .spark import read_type


def inspect_type(
    spark,
    settings,
    regions,
    theme: str,
    feature_type: str,
    sample_columns: list[str],
):
    """Return raw data plus configured medium and small samples."""
    raw = read_type(spark, settings, theme, feature_type)
    medium = bounded_sample(
        raw,
        regions.medium,
        regions.medium_bounds,
        settings.medium_sample_limit,
    )
    small = bounded_sample(
        raw,
        regions.small,
        regions.small_bounds,
        settings.small_sample_limit,
    )
    available = [name for name in sample_columns if name in raw.columns]
    return {
        "raw": raw,
        "medium": medium,
        "small": small,
        "schema": schema_table(raw),
        "sample_columns": available,
    }
