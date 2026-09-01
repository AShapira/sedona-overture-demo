#!/usr/bin/env python3
"""Extract a small, exact, source-schema Overture subset for QGIS validation."""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import shutil


ROOT = Path(__file__).resolve().parent
REPOSITORY_ROOT = ROOT.parents[1]
ARTIFACT_ROOT = (REPOSITORY_ROOT / ".artifacts" / "qgis-style-test").resolve()
DEFAULT_BBOX = (34.58, 31.74, 34.76, 31.86)
MAX_SPAN_DEGREES = 0.5

TYPE_GEOMETRIES = {
    ("base", "bathymetry"): ("polygon",),
    ("base", "infrastructure"): ("point", "line", "polygon"),
    ("base", "land"): ("point", "line", "polygon"),
    ("base", "land_cover"): ("polygon",),
    ("base", "land_use"): ("point", "line", "polygon"),
    ("base", "water"): ("point", "line", "polygon"),
    ("buildings", "building"): ("polygon",),
    ("buildings", "building_part"): ("polygon",),
    ("places", "place"): ("point",),
    ("transportation", "segment"): ("line",),
    ("transportation", "connector"): ("point",),
}

GEOMETRY_TYPES = {
    "point": ("POINT", "MULTIPOINT"),
    "line": ("LINESTRING", "MULTILINESTRING"),
    "polygon": ("POLYGON", "MULTIPOLYGON"),
}


def parse_bbox(value: str) -> tuple[float, float, float, float]:
    try:
        parts = tuple(float(part.strip()) for part in value.split(","))
    except ValueError as exc:
        raise ValueError("bbox must contain four numeric comma-separated values") from exc
    if len(parts) != 4:
        raise ValueError("bbox must be xmin,ymin,xmax,ymax")
    xmin, ymin, xmax, ymax = parts
    if not (-180 <= xmin <= 180 and -180 <= xmax <= 180):
        raise ValueError("bbox longitude must be between -180 and 180")
    if not (-90 <= ymin <= 90 and -90 <= ymax <= 90):
        raise ValueError("bbox latitude must be between -90 and 90")
    if xmin >= xmax or ymin >= ymax:
        raise ValueError("bbox minimum coordinates must be less than maximum coordinates")
    return parts


def validate_bbox_size(
    bbox: tuple[float, float, float, float], allow_large: bool
) -> None:
    xmin, ymin, xmax, ymax = bbox
    if not allow_large and (
        xmax - xmin > MAX_SPAN_DEGREES or ymax - ymin > MAX_SPAN_DEGREES
    ):
        raise ValueError(
            "bbox spans more than 0.5 degrees; pass --allow-large-bbox only "
            "when the larger scan is intentional"
        )


def resolve_bbox(cli_value: str | None, environment: dict[str, str]) -> tuple[float, float, float, float]:
    if cli_value is not None:
        return parse_bbox(cli_value)
    if environment.get("QGIS_STYLE_TEST_BBOX"):
        return parse_bbox(environment["QGIS_STYLE_TEST_BBOX"])
    return DEFAULT_BBOX


def safe_output_path(value: str | None) -> Path:
    if value is None:
        stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
        output = ARTIFACT_ROOT / stamp
    else:
        output = Path(value).expanduser().resolve()
    try:
        output.relative_to(ARTIFACT_ROOT)
    except ValueError as exc:
        raise ValueError(f"output must be beneath {ARTIFACT_ROOT}") from exc
    if output.exists():
        raise ValueError(f"output already exists: {output}")
    return output


def promote_single_geoparquet(frame, destination: Path) -> int:
    stage = destination.with_name(destination.name + ".stage")
    (
        frame.coalesce(1)
        .write.mode("errorifexists")
        .format("geoparquet")
        .option("geoparquet.version", "1.1.0")
        .option("geoparquet.covering.mode", "auto")
        .save(str(stage))
    )
    parts = [path for path in stage.iterdir() if path.is_file() and path.name.startswith("part-")]
    if len(parts) != 1:
        raise RuntimeError(f"Expected one GeoParquet part in {stage}, found {len(parts)}")
    parts[0].replace(destination)
    shutil.rmtree(stage)
    return frame.count()


def select_source_features(source, bbox, functions):
    """Return bbox candidates and the exact, whole-feature selection."""
    xmin, ymin, xmax, ymax = bbox
    candidates = source.where(
        (functions.col("bbox.xmin") <= xmax)
        & (functions.col("bbox.xmax") >= xmin)
        & (functions.col("bbox.ymin") <= ymax)
        & (functions.col("bbox.ymax") >= ymin)
    )
    envelope = (
        f"ST_PolygonFromEnvelope({xmin}, {ymin}, {xmax}, {ymax})"
    )
    return candidates, candidates.where(
        functions.expr(f"ST_Intersects(geometry, {envelope})")
    )


def extract(args: argparse.Namespace) -> Path:
    from pyspark.sql import functions as F
    from sedona.spark import SedonaContext

    bbox = resolve_bbox(args.bbox, os.environ)
    validate_bbox_size(bbox, args.allow_large_bbox)
    output = safe_output_path(args.output)
    output.mkdir(parents=True)
    release_root = args.release_root or os.getenv("OVERTURE_RELEASE_URI")
    if not release_root:
        raise ValueError("Set --release-root or OVERTURE_RELEASE_URI")
    builder = (
        SedonaContext.builder()
        .master(f"local[{args.cores}]")
        .appName("overture-qgis-schema-1.18.0-subset")
        .config("spark.driver.memory", args.driver_memory)
        .config("spark.serializer", "org.apache.spark.serializer.KryoSerializer")
        .config("spark.sql.parquet.filterPushdown", "true")
        .config("spark.ui.showConsoleProgress", "false")
    )
    spark = SedonaContext.create(builder.getOrCreate())
    spark.sparkContext.setLogLevel("ERROR")
    outputs: list[dict[str, object]] = []
    selection_stats: list[dict[str, object]] = []
    try:
        for (theme, feature_type), families in TYPE_GEOMETRIES.items():
            uri = f"{release_root.rstrip('/')}/theme={theme}/type={feature_type}"
            source = spark.read.format("geoparquet").load(uri)
            columns = source.columns
            candidates, selected = select_source_features(source, bbox, F)
            if selected.columns != columns:
                raise RuntimeError(f"Source schema changed while selecting {theme}/{feature_type}")
            candidate_rows = candidates.count()
            exact_rows = selected.count()
            selection_stats.append({
                "theme": theme,
                "type": feature_type,
                "bbox_candidate_rows": candidate_rows,
                "exact_rows": exact_rows,
                "bbox_false_positives_removed": candidate_rows - exact_rows,
            })
            for family in families:
                values = GEOMETRY_TYPES[family]
                family_frame = selected.where(F.upper(F.expr("GeometryType(geometry)")).isin(*values))
                row_count = family_frame.count()
                destination = output / f"{theme}-{feature_type}-{family}.geoparquet"
                written_count = promote_single_geoparquet(family_frame.select(*columns), destination)
                if written_count != row_count:
                    raise RuntimeError(f"Row-count mismatch for {destination}")
                outputs.append({"theme": theme, "type": feature_type, "geometry": family, "rows": row_count, "file": destination.name})
    finally:
        spark.stop()
    manifest = {
        "overture_schema_version": "1.18.0",
        "release_root": release_root,
        "bbox": bbox,
        "selection": "bbox overlap followed by exact ST_Intersects; source geometries retained whole",
        "selection_stats": selection_stats,
        "outputs": outputs,
    }
    (output / "subset-manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    return output


def main() -> int:
    parser = argparse.ArgumentParser(
        description=(
            "Extract an unnamed small coastal/urban subset for QGIS styles "
            "bound to Overture schema 1.18.0."
        )
    )
    parser.add_argument("--release-root", help="Local or s3a:// root of a full Overture release")
    parser.add_argument("--bbox", help="xmin,ymin,xmax,ymax; overrides QGIS_STYLE_TEST_BBOX")
    parser.add_argument("--allow-large-bbox", action="store_true")
    parser.add_argument("--output", help="New directory beneath .artifacts/qgis-style-test")
    parser.add_argument("--cores", type=int, default=8)
    parser.add_argument("--driver-memory", default="6g")
    args = parser.parse_args()
    try:
        bbox = resolve_bbox(args.bbox, os.environ)
        validate_bbox_size(bbox, args.allow_large_bbox)
        output = extract(args)
    except (ValueError, RuntimeError) as exc:
        parser.error(str(exc))
    print(f"Created source-schema QGIS subset: {output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
