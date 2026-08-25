"""Safe routing for optional derived GeoParquet and single-file exports."""

from __future__ import annotations

from dataclasses import asdict, dataclass
from datetime import UTC, datetime
import json
from pathlib import Path
import re
import uuid

from .config import LabSettings
from .scratch import scratch_status


PERMISSION_MARKERS = (
    "accessdenied",
    "access denied",
    "permission denied",
    "forbidden",
    "status code: 403",
    "status code 403",
)


@dataclass(frozen=True)
class DerivedWriteResult:
    status: str
    destination: str | None
    row_count: int | None
    used_local_fallback: bool
    detail: str

    def as_dict(self) -> dict[str, object]:
        return asdict(self)


@dataclass(frozen=True)
class SingleFileExportResult:
    status: str
    run_prefix: str | None
    geoparquet_uri: str | None
    csv_uri: str | None
    row_count: int | None
    detail: str

    def as_dict(self) -> dict[str, object]:
        return asdict(self)


@dataclass(frozen=True)
class SingleGeoParquetExportResult:
    status: str
    run_prefix: str | None
    geoparquet_uri: str | None
    row_count: int | None
    detail: str

    def as_dict(self) -> dict[str, object]:
        return asdict(self)


SINGLE_FILE_CSV_COLUMNS = (
    "road_id",
    "source_segment_id",
    "road_class",
    "geometry_wkt",
)


def is_permission_error(error: BaseException) -> bool:
    message = str(error).lower()
    return any(marker in message for marker in PERMISSION_MARKERS)


def _safe_component(value: str) -> str:
    cleaned = re.sub(r"[^A-Za-z0-9._-]+", "-", value).strip("-.")
    if not cleaned:
        raise ValueError(f"Unsafe empty path component derived from {value!r}")
    return cleaned


def _run_id() -> str:
    timestamp = datetime.now(UTC).strftime("%Y%m%dT%H%M%SZ")
    return f"{timestamp}-{uuid.uuid4().hex[:8]}"


def _s3_permission_probe(spark, root_uri: str) -> bool:
    """Return False only when a denied probe left no object behind."""
    jvm = spark._jvm
    probe_uri = (
        f"{root_uri.rstrip('/')}/_permission_probe/{uuid.uuid4().hex}.tmp"
    )
    probe = jvm.org.apache.hadoop.fs.Path(probe_uri)
    filesystem = probe.getFileSystem(spark._jsc.hadoopConfiguration())
    try:
        stream = filesystem.create(probe, False)
        stream.close()
    except Exception as exc:
        if is_permission_error(exc):
            try:
                if not filesystem.exists(probe):
                    return False
            except Exception as existence_error:
                raise RuntimeError(
                    f"Could not verify denied S3 probe cleanup at {probe_uri}"
                ) from existence_error
        raise RuntimeError(f"S3 write-permission probe failed at {probe_uri}") from exc

    try:
        if not filesystem.delete(probe, False):
            raise RuntimeError("the probe object was not deleted")
    except Exception as exc:
        raise RuntimeError(
            f"S3 probe cleanup failed at {probe_uri}; stop before writing data"
        ) from exc
    return True


def _verify_spark_output(spark, destination: str, expected_rows: int) -> None:
    success_uri = f"{destination.rstrip('/')}/_SUCCESS"
    success = spark._jvm.org.apache.hadoop.fs.Path(success_uri)
    filesystem = success.getFileSystem(spark._jsc.hadoopConfiguration())
    if not filesystem.exists(success):
        raise RuntimeError(f"Spark output has no _SUCCESS marker: {destination}")
    actual_rows = spark.read.format("geoparquet").load(destination).count()
    if actual_rows != expected_rows:
        raise RuntimeError(
            f"Output verification failed at {destination}: expected "
            f"{expected_rows} rows, found {actual_rows}"
        )


def _write_s3_manifest(spark, destination: str, manifest: dict[str, object]) -> None:
    manifest_uri = f"{destination.rstrip('/')}.manifest"
    spark.createDataFrame(
        [(json.dumps(manifest, sort_keys=True),)], ["manifest_json"]
    ).coalesce(1).write.mode("errorifexists").json(manifest_uri)


def _write_local_manifest(destination: Path, manifest: dict[str, object]) -> None:
    path = destination.parent / f"{destination.name}.manifest.json"
    path.write_text(
        json.dumps(manifest, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )


def _single_file_run_prefix(
    settings: LabSettings,
    dataset_name: str,
    *,
    run_id: str | None = None,
) -> str:
    if not settings.derived_output_uri:
        raise ValueError(
            "Single-file S3 exports require DERIVED_OUTPUT_URI"
        )
    safe_dataset = _safe_component(dataset_name)
    release = _safe_component(settings.release)
    actual_run_id = _safe_component(run_id or _run_id())
    return (
        f"{settings.derived_output_uri.rstrip('/')}/{safe_dataset}/"
        f"release={release}/run={actual_run_id}"
    )


def _part_file(filesystem, spark, staging_uri: str, suffix: str):
    staging = spark._jvm.org.apache.hadoop.fs.Path(staging_uri)
    matches = [
        status.getPath()
        for status in filesystem.listStatus(staging)
        if status.isFile()
        and status.getPath().getName().startswith("part-")
        and status.getPath().getName().endswith(suffix)
    ]
    if len(matches) != 1:
        names = sorted(
            status.getPath().getName()
            for status in filesystem.listStatus(staging)
        )
        raise RuntimeError(
            f"Expected one {suffix} part file at {staging_uri}, "
            f"found {len(matches)} among {names}"
        )
    return matches[0]


def _promote_single_part(
    dataframe,
    spark,
    *,
    staging_uri: str,
    destination_uri: str,
    output_format: str,
    options: dict[str, str],
) -> None:
    staging = spark._jvm.org.apache.hadoop.fs.Path(staging_uri)
    destination = spark._jvm.org.apache.hadoop.fs.Path(destination_uri)
    filesystem = staging.getFileSystem(spark._jsc.hadoopConfiguration())
    if filesystem.exists(staging) or filesystem.exists(destination):
        raise RuntimeError(
            "Single-file export target already exists: "
            f"{staging_uri} or {destination_uri}"
        )

    writer = dataframe.coalesce(1).write.mode("errorifexists").format(
        output_format
    )
    for name, value in options.items():
        writer = writer.option(name, value)
    writer.save(staging_uri)

    suffix = ".parquet" if output_format == "geoparquet" else ".csv"
    part = _part_file(filesystem, spark, staging_uri, suffix)
    if not filesystem.rename(part, destination):
        raise RuntimeError(
            f"Could not promote {part} to final object {destination_uri}"
        )
    if not filesystem.delete(staging, True):
        raise RuntimeError(
            f"Could not remove single-file staging prefix {staging_uri}"
        )
    if not filesystem.exists(destination):
        raise RuntimeError(
            f"Promoted S3 object is missing after rename: {destination_uri}"
        )


def _geoparquet_metadata(spark, geoparquet_uri: str) -> dict[str, object]:
    """Read the GeoParquet JSON metadata from a named Parquet object's footer."""
    path = spark._jvm.org.apache.hadoop.fs.Path(geoparquet_uri)
    converter = (
        spark._jvm.org.apache.parquet.format.converter.ParquetMetadataConverter
    )
    footer = spark._jvm.org.apache.parquet.hadoop.ParquetFileReader.readFooter(
        spark._jsc.hadoopConfiguration(),
        path,
        converter.NO_FILTER,
    )
    geo_json = footer.getFileMetaData().getKeyValueMetaData().get("geo")
    if not geo_json:
        raise RuntimeError("GeoParquet output footer has no geo metadata")
    try:
        metadata = json.loads(geo_json)
    except json.JSONDecodeError as exc:
        raise RuntimeError("GeoParquet output has invalid geo metadata JSON") from exc
    if not isinstance(metadata, dict):
        raise RuntimeError("GeoParquet output geo metadata is not an object")
    return metadata


def _verify_single_geoparquet(
    spark,
    *,
    run_prefix: str,
    geoparquet_uri: str,
    object_name: str,
    expected_rows: int,
    expected_schema: tuple[tuple[str, str], ...],
) -> None:
    from pyspark.sql import functions as F

    written = spark.read.format("geoparquet").load(geoparquet_uri)
    actual_columns = tuple(written.columns)
    expected_types = dict(expected_schema)
    required_columns = set(expected_types) | {"geometry_bbox"}
    if (
        len(actual_columns) != len(required_columns)
        or set(actual_columns) != required_columns
    ):
        raise RuntimeError(
            "GeoParquet read-back schema mismatch: expected exactly "
            f"{sorted(required_columns)}, found {sorted(actual_columns)}"
        )
    actual_types = {
        field.name: field.dataType.json()
        for field in written.schema.fields
        if field.name != "geometry_bbox"
    }
    if actual_types != expected_types:
        raise RuntimeError(
            "GeoParquet read-back data types do not match the input schema: "
            f"expected {expected_types}, found {actual_types}"
        )
    validation = written.agg(
        F.count("*").alias("row_count"),
        F.sum(
            F.when(
                F.expr(
                    "geometry IS NULL "
                    "OR ST_IsEmpty(geometry) "
                    "OR NOT ST_IsValid(geometry) "
                    "OR ST_SRID(geometry) <> 4326 "
                    "OR geometry_bbox IS NULL"
                ),
                1,
            ).otherwise(0)
        ).alias("invalid_rows"),
    ).first()
    if int(validation.row_count) != expected_rows:
        raise RuntimeError(
            "GeoParquet read-back row count mismatch: expected "
            f"{expected_rows}, found {validation.row_count}"
        )
    if int(validation.invalid_rows or 0) != 0:
        raise RuntimeError(
            "GeoParquet read-back contains "
            f"{validation.invalid_rows} invalid rows"
        )

    metadata = _geoparquet_metadata(spark, geoparquet_uri)
    if metadata.get("version") != "1.1.0":
        raise RuntimeError(
            "GeoParquet output is not version 1.1.0: "
            f"{metadata.get('version')!r}"
        )
    primary_column = metadata.get("primary_column")
    columns_metadata = metadata.get("columns", {})
    geometry_metadata = (
        columns_metadata.get(primary_column, {})
        if isinstance(columns_metadata, dict)
        else {}
    )
    bbox_covering = geometry_metadata.get("covering", {}).get("bbox", {})
    expected_covering = {
        axis: ["geometry_bbox", axis]
        for axis in ("xmin", "ymin", "xmax", "ymax")
    }
    if primary_column != "geometry" or bbox_covering != expected_covering:
        raise RuntimeError(
            "GeoParquet output has no valid geometry_bbox covering metadata"
        )

    run = spark._jvm.org.apache.hadoop.fs.Path(run_prefix)
    filesystem = run.getFileSystem(spark._jsc.hadoopConfiguration())
    names = sorted(
        status.getPath().getName()
        for status in filesystem.listStatus(run)
        if status.isFile()
    )
    if names != [object_name]:
        raise RuntimeError(
            f"Expected exactly {[object_name]} at {run_prefix}, found {names}"
        )


def write_single_geoparquet(
    dataframe,
    spark,
    settings: LabSettings,
    *,
    dataset_name: str,
    object_name: str,
) -> SingleGeoParquetExportResult:
    """Write and verify one named GeoParquet 1.1 object in a unique S3 run."""
    if "geometry" not in dataframe.columns:
        raise ValueError("Single GeoParquet export requires a geometry column")
    if "geometry_bbox" in dataframe.columns:
        raise ValueError(
            "geometry_bbox is reserved for the GeoParquet covering column"
        )
    if _safe_component(object_name) != object_name or not object_name.endswith(
        ".geoparquet"
    ):
        raise ValueError(
            "object_name must be a safe basename ending in .geoparquet"
        )
    if not settings.write_derived:
        return SingleGeoParquetExportResult(
            status="dry-run",
            run_prefix=None,
            geoparquet_uri=None,
            row_count=None,
            detail=(
                "Set WRITE_DERIVED=true and DERIVED_OUTPUT_URI to write the "
                "single-file S3 export."
            ),
        )
    if not settings.derived_output_uri:
        raise ValueError(
            "WRITE_DERIVED=true single GeoParquet exports require "
            "DERIVED_OUTPUT_URI"
        )
    if not _s3_permission_probe(spark, settings.derived_output_uri):
        raise RuntimeError(
            "The configured DERIVED_OUTPUT_URI denied the clean S3 write probe; "
            "single GeoParquet exports do not use local fallback"
        )

    run_prefix = _single_file_run_prefix(settings, dataset_name)
    geoparquet_uri = f"{run_prefix}/{object_name}"
    row_count = dataframe.count()
    try:
        _promote_single_part(
            dataframe,
            spark,
            staging_uri=f"{run_prefix}/._geoparquet_staging",
            destination_uri=geoparquet_uri,
            output_format="geoparquet",
            options={
                "compression": "zstd",
                "geoparquet.version": "1.1.0",
                "geoparquet.covering.mode": "auto",
            },
        )
        _verify_single_geoparquet(
            spark,
            run_prefix=run_prefix,
            geoparquet_uri=geoparquet_uri,
            object_name=object_name,
            expected_rows=row_count,
            expected_schema=tuple(
                (field.name, field.dataType.json())
                for field in dataframe.schema.fields
            ),
        )
    except Exception as exc:
        raise RuntimeError(
            "Single GeoParquet S3 export started but did not verify. No local "
            f"fallback was attempted; inspect partial prefix {run_prefix}"
        ) from exc
    return SingleGeoParquetExportResult(
        status="written",
        run_prefix=run_prefix,
        geoparquet_uri=geoparquet_uri,
        row_count=row_count,
        detail="One named S3 object and its read-back validation succeeded.",
    )


def _verify_single_file_exports(
    spark,
    *,
    run_prefix: str,
    geoparquet_uri: str,
    csv_uri: str,
    expected_rows: int,
    expected_geoparquet_schema: tuple[tuple[str, str], ...],
) -> None:
    from pyspark.sql import functions as F

    written = spark.read.format("geoparquet").load(geoparquet_uri)
    expected_types = dict(expected_geoparquet_schema)
    expected_columns = tuple(name for name, _ in expected_geoparquet_schema)
    if tuple(written.columns) != expected_columns:
        raise RuntimeError(
            "GeoParquet read-back schema mismatch: expected exactly "
            f"{list(expected_columns)}, found {written.columns}"
        )
    actual_types = {
        field.name: field.dataType.json()
        for field in written.schema.fields
    }
    if actual_types != expected_types:
        raise RuntimeError(
            "GeoParquet read-back data types do not match the complete input "
            f"schema: expected {expected_types}, found {actual_types}"
        )
    geo_validation = written.agg(
        F.count("*").alias("row_count"),
        F.sum(
            F.when(
                F.expr(
                    "geometry IS NULL "
                    "OR ST_IsEmpty(geometry) "
                    "OR NOT ST_IsValid(geometry) "
                    "OR GeometryType(geometry) <> 'LINESTRING' "
                    "OR ST_Length(geometry) <= 0 "
                    "OR ST_SRID(geometry) <> 4326 "
                    "OR bbox IS NULL "
                    "OR bbox.xmin <> ST_XMin(geometry) "
                    "OR bbox.ymin <> ST_YMin(geometry) "
                    "OR bbox.xmax <> ST_XMax(geometry) "
                    "OR bbox.ymax <> ST_YMax(geometry)"
                ),
                1,
            ).otherwise(0)
        ).alias("invalid_rows"),
    ).first()
    if int(geo_validation.row_count) != expected_rows:
        raise RuntimeError(
            "GeoParquet read-back row count mismatch: expected "
            f"{expected_rows}, found {geo_validation.row_count}"
        )
    if int(geo_validation.invalid_rows or 0) != 0:
        raise RuntimeError(
            "GeoParquet read-back contains "
            f"{geo_validation.invalid_rows} invalid rows"
        )
    metadata = _geoparquet_metadata(spark, geoparquet_uri)
    primary_column = metadata.get("primary_column")
    columns_metadata = metadata.get("columns", {})
    geometry_metadata = (
        columns_metadata.get(primary_column, {})
        if isinstance(columns_metadata, dict)
        else {}
    )
    bbox_covering = geometry_metadata.get("covering", {}).get("bbox", {})
    expected_covering = {
        axis: ["bbox", axis] for axis in ("xmin", "ymin", "xmax", "ymax")
    }
    if (
        metadata.get("version") != "1.1.0"
        or primary_column != "geometry"
        or bbox_covering != expected_covering
    ):
        raise RuntimeError(
            "GeoParquet output metadata does not use the source bbox column "
            "as the geometry covering"
        )

    csv_frame = (
        spark.read.option("header", "true")
        .csv(csv_uri)
    )
    if tuple(csv_frame.columns) != SINGLE_FILE_CSV_COLUMNS:
        raise RuntimeError(
            "CSV read-back columns do not match the defined subset: expected "
            f"{list(SINGLE_FILE_CSV_COLUMNS)}, found {csv_frame.columns}"
        )
    csv_validation = csv_frame.select(
        *SINGLE_FILE_CSV_COLUMNS,
        F.expr("ST_GeomFromWKT(geometry_wkt)").alias("parsed_geometry"),
    ).agg(
        F.count("*").alias("row_count"),
        F.sum(
            F.when(
                F.expr(
                    "road_id IS NULL "
                    "OR source_segment_id IS NULL "
                    "OR road_class IS NULL "
                    "OR geometry_wkt IS NULL "
                    "OR parsed_geometry IS NULL "
                    "OR ST_IsEmpty(parsed_geometry) "
                    "OR NOT ST_IsValid(parsed_geometry) "
                    "OR GeometryType(parsed_geometry) <> 'LINESTRING'"
                ),
                1,
            ).otherwise(0)
        ).alias("invalid_rows"),
    ).first()
    if int(csv_validation.row_count) != expected_rows:
        raise RuntimeError(
            "CSV read-back row count mismatch: expected "
            f"{expected_rows}, found {csv_validation.row_count}"
        )
    if int(csv_validation.invalid_rows or 0) != 0:
        raise RuntimeError(
            f"CSV read-back contains {csv_validation.invalid_rows} invalid rows"
        )

    run = spark._jvm.org.apache.hadoop.fs.Path(run_prefix)
    filesystem = run.getFileSystem(spark._jsc.hadoopConfiguration())
    names = sorted(
        status.getPath().getName()
        for status in filesystem.listStatus(run)
        if status.isFile()
    )
    expected_names = ["roads.csv", "roads.geoparquet"]
    if names != expected_names:
        raise RuntimeError(
            f"Expected exactly {expected_names} at {run_prefix}, found {names}"
        )


def write_single_file_exports(
    dataframe,
    spark,
    settings: LabSettings,
    *,
    dataset_name: str,
    geoparquet_dataframe,
) -> SingleFileExportResult:
    """Write source-schema GeoParquet and subset WKT CSV to a unique S3 run."""
    required_columns = {
        "road_id",
        "source_segment_id",
        "road_class",
        "geometry",
    }
    missing = required_columns - set(dataframe.columns)
    if missing:
        raise ValueError(
            f"Single-file road export is missing columns: {sorted(missing)}"
        )
    geoparquet_required = {"bbox", "geometry"}
    geoparquet_missing = geoparquet_required - set(geoparquet_dataframe.columns)
    if geoparquet_missing:
        raise ValueError(
            "Single-file road GeoParquet export is missing columns: "
            f"{sorted(geoparquet_missing)}"
        )
    if "geometry_bbox" in geoparquet_dataframe.columns:
        raise ValueError(
            "Road GeoParquet must use the source bbox column, not geometry_bbox"
        )
    if not settings.write_derived:
        return SingleFileExportResult(
            status="dry-run",
            run_prefix=None,
            geoparquet_uri=None,
            csv_uri=None,
            row_count=None,
            detail=(
                "Set WRITE_DERIVED=true and DERIVED_OUTPUT_URI to write the "
                "single-file S3 exports."
            ),
        )
    if not settings.derived_output_uri:
        raise ValueError(
            "WRITE_DERIVED=true single-file exports require DERIVED_OUTPUT_URI"
        )
    if not _s3_permission_probe(spark, settings.derived_output_uri):
        raise RuntimeError(
            "The configured DERIVED_OUTPUT_URI denied the clean S3 write probe; "
            "single-file exports do not use local fallback"
        )

    from pyspark.sql import functions as F

    run_prefix = _single_file_run_prefix(settings, dataset_name)
    geoparquet_uri = f"{run_prefix}/roads.geoparquet"
    csv_uri = f"{run_prefix}/roads.csv"
    row_count = dataframe.count()
    geoparquet_row_count = geoparquet_dataframe.count()
    if geoparquet_row_count != row_count:
        raise RuntimeError(
            "GeoParquet and CSV source row counts differ: "
            f"{geoparquet_row_count} versus {row_count}"
        )
    csv_frame = dataframe.select(
        "road_id",
        "source_segment_id",
        "road_class",
        F.expr("ST_AsText(geometry)").alias("geometry_wkt"),
    )
    try:
        _promote_single_part(
            geoparquet_dataframe,
            spark,
            staging_uri=f"{run_prefix}/._geoparquet_staging",
            destination_uri=geoparquet_uri,
            output_format="geoparquet",
            options={
                "compression": "zstd",
                "geoparquet.version": "1.1.0",
                "geoparquet.covering.geometry": "bbox",
            },
        )
        _promote_single_part(
            csv_frame,
            spark,
            staging_uri=f"{run_prefix}/._csv_staging",
            destination_uri=csv_uri,
            output_format="csv",
            options={"header": "true", "quoteAll": "true"},
        )
        _verify_single_file_exports(
            spark,
            run_prefix=run_prefix,
            geoparquet_uri=geoparquet_uri,
            csv_uri=csv_uri,
            expected_rows=row_count,
            expected_geoparquet_schema=tuple(
                (field.name, field.dataType.json())
                for field in geoparquet_dataframe.schema.fields
            ),
        )
    except Exception as exc:
        raise RuntimeError(
            "Single-file S3 export started but did not verify. No local "
            f"fallback was attempted; inspect partial prefix {run_prefix}"
        ) from exc
    return SingleFileExportResult(
        status="written",
        run_prefix=run_prefix,
        geoparquet_uri=geoparquet_uri,
        csv_uri=csv_uri,
        row_count=row_count,
        detail="Two named S3 objects and both read-back validations succeeded.",
    )


def write_derived(
    dataframe,
    spark,
    settings: LabSettings,
    *,
    dataset_name: str,
) -> DerivedWriteResult:
    """Write one new run, preferring S3 and falling back only before data write."""
    safe_dataset = _safe_component(dataset_name)
    if not settings.write_derived:
        return DerivedWriteResult(
            status="dry-run",
            destination=settings.derived_output_uri,
            row_count=None,
            used_local_fallback=False,
            detail="Set WRITE_DERIVED=true to write a bounded derivative.",
        )

    run_id = _run_id()
    release = _safe_component(settings.release)
    relative = f"{safe_dataset}/release={release}/run={run_id}"
    can_write_s3 = False
    if settings.derived_output_uri:
        can_write_s3 = _s3_permission_probe(spark, settings.derived_output_uri)

    row_count = dataframe.count()
    manifest = {
        "dataset": safe_dataset,
        "release": settings.release,
        "release_uri": settings.release_uri,
        "run_id": run_id,
        "row_count": row_count,
    }

    if settings.derived_output_uri:
        if can_write_s3:
            destination = f"{settings.derived_output_uri.rstrip('/')}/{relative}"
            try:
                dataframe.write.mode("errorifexists").format("geoparquet").save(
                    destination
                )
                _verify_spark_output(spark, destination, row_count)
                _write_s3_manifest(spark, destination, manifest)
            except Exception as exc:
                raise RuntimeError(
                    "S3 derivative write started but did not verify. No local "
                    f"fallback was attempted; inspect partial prefix {destination}"
                ) from exc
            return DerivedWriteResult(
                status="written",
                destination=destination,
                row_count=row_count,
                used_local_fallback=False,
                detail="S3 output and read-back row count verified.",
            )

    if not settings.allow_local_derived_fallback:
        raise RuntimeError(
            "The derived S3 prefix is not writable and local fallback is disabled"
        )

    scratch_status(settings)
    destination_path = Path(settings.derived_local_fallback_dir) / relative
    destination_path.parent.mkdir(parents=True, exist_ok=True)
    destination = str(destination_path)
    dataframe.write.mode("errorifexists").format("geoparquet").save(destination)
    _verify_spark_output(spark, destination, row_count)
    manifest["local_fallback"] = True
    _write_local_manifest(destination_path, manifest)
    scratch_status(settings)
    fallback_reason = (
        "The configured S3 prefix denied the clean permission probe"
        if settings.derived_output_uri
        else "No derived S3 prefix was configured"
    )
    return DerivedWriteResult(
        status="written",
        destination=destination,
        row_count=row_count,
        used_local_fallback=True,
        detail=f"{fallback_reason}; local scratch output verified.",
    )
