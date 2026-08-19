"""Safe routing for the optional bounded derivative produced by lesson 08."""

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
