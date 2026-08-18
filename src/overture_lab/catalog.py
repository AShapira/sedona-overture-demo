"""Release inventory from Parquet footers without scanning feature columns."""

from __future__ import annotations

from pathlib import Path


def local_release_inventory(release_uri: str):
    """Return a pandas table for a local release.

    This intentionally supports local paths only. S3 inventory should be
    produced during release ingestion and stored alongside the release.
    """
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
