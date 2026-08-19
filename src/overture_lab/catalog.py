"""Release inventory for local filesystems and S3A object storage."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import re
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from pyspark.sql import SparkSession

    from .config import LabSettings


REQUIRED_RELEASE_TYPES = {
    ("addresses", "address"),
    ("base", "bathymetry"),
    ("base", "infrastructure"),
    ("base", "land"),
    ("base", "land_cover"),
    ("base", "land_use"),
    ("base", "water"),
    ("buildings", "building"),
    ("buildings", "building_part"),
    ("divisions", "division"),
    ("divisions", "division_area"),
    ("divisions", "division_boundary"),
    ("places", "place"),
    ("transportation", "connector"),
    ("transportation", "segment"),
}

S3_LEAF = re.compile(r"(?:^|/)theme=([^/]+)/type=([^/]+)/.+\.parquet$")


def aggregate_s3_objects(
    objects: list[tuple[str, int]],
) -> dict[tuple[str, str], dict[str, int]]:
    """Aggregate Parquet object metadata by Hive theme/type leaf."""
    totals: dict[tuple[str, str], dict[str, int]] = {}
    for object_uri, size in objects:
        match = S3_LEAF.search(object_uri)
        if not match:
            continue
        key = (match.group(1), match.group(2))
        aggregate = totals.setdefault(key, {"files": 0, "bytes": 0})
        aggregate["files"] += 1
        aggregate["bytes"] += int(size)
    return totals


def local_release_inventory(release_uri: str):
    """Return a pandas inventory from local Parquet footers."""
    if release_uri.startswith(("s3://", "s3a://")):
        raise ValueError(
            "Footer inventory over S3 is intentionally disabled. Store an "
            "ingestion manifest locally instead of opening every remote file."
        )

    import pandas as pd
    import pyarrow.parquet as pq

    root = Path(release_uri)
    records: list[dict[str, object]] = []
    for leaf in sorted(root.glob("theme=*/type=*")):
        files = sorted(leaf.glob("*.parquet"))
        if not files:
            continue
        rows = 0
        bytes_total = 0
        for file in files:
            rows += pq.ParquetFile(file).metadata.num_rows
            bytes_total += file.stat().st_size
        records.append(
            {
                "theme": leaf.parent.name.removeprefix("theme="),
                "type": leaf.name.removeprefix("type="),
                "files": len(files),
                "rows": rows,
                "compressed_gib": round(bytes_total / 1024**3, 3),
            }
        )
    return pd.DataFrame.from_records(records)


def _cache_path(settings: "LabSettings") -> Path:
    identity = hashlib.sha256(
        f"{settings.release_uri.rstrip('/')}\0{settings.release}".encode()
    ).hexdigest()[:16]
    return Path(settings.inventory_cache_dir) / f"{settings.release}-{identity}.json"


def _load_cached_inventory(settings: "LabSettings"):
    path = _cache_path(settings)
    if settings.refresh_release_inventory or not path.is_file():
        return None
    payload = json.loads(path.read_text(encoding="utf-8"))
    if payload.get("release_uri") != settings.release_uri.rstrip("/"):
        return None
    if bool(payload.get("includes_row_counts")) != bool(
        settings.inventory_include_row_counts
    ):
        return None
    import pandas as pd

    return pd.DataFrame.from_records(payload["records"])


def _store_cached_inventory(settings: "LabSettings", records) -> Path:
    path = _cache_path(settings)
    path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "format_version": 1,
        "release": settings.release,
        "release_uri": settings.release_uri.rstrip("/"),
        "includes_row_counts": settings.inventory_include_row_counts,
        "records": records,
    }
    temporary = path.with_suffix(".tmp")
    temporary.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    temporary.replace(path)
    return path


def s3_release_inventory(spark: "SparkSession", settings: "LabSettings"):
    """List an S3A release through Hadoop without downloading Parquet data."""
    cached = _load_cached_inventory(settings)
    if cached is not None:
        cached.attrs["source"] = "scratch cache"
        cached.attrs["cache_path"] = str(_cache_path(settings))
        return cached

    root_uri = settings.release_uri.rstrip("/")
    root = spark._jvm.org.apache.hadoop.fs.Path(root_uri)
    filesystem = root.getFileSystem(spark._jsc.hadoopConfiguration())
    if not filesystem.exists(root):
        raise RuntimeError(f"Overture S3 release root does not exist: {root_uri}")

    objects: list[tuple[str, int]] = []
    iterator = filesystem.listFiles(root, True)
    while iterator.hasNext():
        status = iterator.next()
        objects.append((status.getPath().toString(), int(status.getLen())))
    totals = aggregate_s3_objects(objects)

    if not totals:
        raise RuntimeError(
            "No theme=<name>/type=<name> Parquet objects were found under "
            f"{root_uri}"
        )

    records: list[dict[str, object]] = []
    for (theme, feature_type), aggregate in sorted(totals.items()):
        rows = None
        if settings.inventory_include_row_counts:
            rows = (
                spark.read.format("geoparquet")
                .load(settings.type_uri(theme, feature_type))
                .count()
            )
        records.append(
            {
                "theme": theme,
                "type": feature_type,
                "files": aggregate["files"],
                "rows": rows,
                "compressed_gib": round(aggregate["bytes"] / 1024**3, 3),
            }
        )

    cache_path = _store_cached_inventory(settings, records)
    import pandas as pd

    inventory = pd.DataFrame.from_records(records)
    inventory.attrs["source"] = "S3A listing"
    inventory.attrs["cache_path"] = str(cache_path)
    return inventory


def release_inventory(spark: "SparkSession", settings: "LabSettings"):
    """Dispatch inventory to the configured local or S3A implementation."""
    if settings.storage_mode == "s3a":
        return s3_release_inventory(spark, settings)
    inventory = local_release_inventory(settings.release_uri)
    inventory.attrs["source"] = "local Parquet footers"
    inventory.attrs["cache_path"] = None
    return inventory


def validate_curriculum_types(inventory) -> None:
    """Fail early when the release cannot support the ten lessons."""
    present = set(zip(inventory["theme"], inventory["type"], strict=True))
    missing = sorted(REQUIRED_RELEASE_TYPES - present)
    if missing:
        formatted = ", ".join(f"{theme}/{kind}" for theme, kind in missing)
        raise RuntimeError(f"Release is missing required feature types: {formatted}")


def schema_table(df):
    """Flatten a Spark schema into a readable pandas table."""
    import pandas as pd

    return pd.DataFrame(
        [
            {
                "field": field.name,
                "spark_type": field.dataType.simpleString(),
                "nullable": field.nullable,
            }
            for field in df.schema.fields
            if field.name not in {"theme", "feature_type"}
        ]
    )
