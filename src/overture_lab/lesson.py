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
    """Return raw, medium country sample, and small locality sample."""
    raw = read_type(spark, settings, theme, feature_type)
    country = bounded_sample(
        raw,
        regions.country,
        regions.country_bounds,
        settings.country_sample_limit,
    )
    locality = bounded_sample(
        raw,
        regions.locality,
        regions.locality_bounds,
        settings.locality_sample_limit,
    )
    available = [name for name in sample_columns if name in raw.columns]
    return {
        "raw": raw,
        "country": country,
        "locality": locality,
        "schema": schema_table(raw),
        "sample_columns": available,
    }
