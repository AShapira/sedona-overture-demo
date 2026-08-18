"""Configuration with validation before a Spark JVM is created."""

from __future__ import annotations

from dataclasses import asdict, dataclass
import os
from pathlib import Path


def _positive_int(name: str, default: int) -> int:
    raw = os.getenv(name, str(default))
    try:
        value = int(raw)
    except ValueError as exc:
        raise ValueError(f"{name} must be an integer, found {raw!r}") from exc
    if value < 1:
        raise ValueError(f"{name} must be at least 1, found {value}")
    return value


def _boolean(name: str, default: bool) -> bool:
    raw = os.getenv(name, str(default)).strip().lower()
    if raw in {"1", "true", "yes", "on"}:
        return True
    if raw in {"0", "false", "no", "off"}:
        return False
    raise ValueError(f"{name} must be true or false, found {raw!r}")


@dataclass(frozen=True)
class LabSettings:
    release_uri: str
    release: str
    local_cores: int
    driver_memory: str
    shuffle_partitions: int
    spark_local_dir: str
    country_code: str
    locality_name_en: str
    locality_country_code: str
    country_sample_limit: int
    locality_sample_limit: int
    map_feature_limit: int
    s3_endpoint: str | None
    s3_access_key: str | None
    s3_secret_key: str | None
    s3_path_style: bool
    s3_ssl_enabled: bool

    def type_uri(self, theme: str, feature_type: str) -> str:
        return (
            f"{self.release_uri.rstrip('/')}"
            f"/theme={theme}/type={feature_type}"
        )

    def public_dict(self) -> dict[str, object]:
        values = asdict(self)
        values["s3_access_key"] = "<set>" if self.s3_access_key else None
        values["s3_secret_key"] = "<set>" if self.s3_secret_key else None
        return values

    def prepare_process_environment(self) -> None:
        """Set Spark-launch variables before importing PySpark."""
        local_dir = Path(self.spark_local_dir)
        local_dir.mkdir(parents=True, exist_ok=True)
        os.environ["SPARK_LOCAL_DIRS"] = str(local_dir)
        os.environ["PYSPARK_SUBMIT_ARGS"] = (
            f"--driver-memory {self.driver_memory} pyspark-shell"
        )


def load_settings() -> LabSettings:
    cores = _positive_int("SEDONA_SPARK_LOCAL_CORES", 8)
    partitions = _positive_int("SEDONA_SPARK_PARTITIONS", cores * 2)
    if partitions < cores:
        raise ValueError(
            "SEDONA_SPARK_PARTITIONS must be at least "
            "SEDONA_SPARK_LOCAL_CORES"
        )

    endpoint = os.getenv("S3_ENDPOINT") or None
    access_key = os.getenv("S3_ACCESS_KEY") or None
    secret_key = os.getenv("S3_SECRET_KEY") or None
    if bool(access_key) != bool(secret_key):
        raise ValueError("S3_ACCESS_KEY and S3_SECRET_KEY must be set together")

    settings = LabSettings(
        release_uri=os.getenv("OVERTURE_RELEASE_URI", "/data/overture"),
        release=os.getenv("OVERTURE_RELEASE", "2026-07-22.0"),
        local_cores=cores,
        driver_memory=os.getenv("SEDONA_SPARK_DRIVER_MEMORY", "16g"),
        shuffle_partitions=partitions,
        spark_local_dir=os.getenv("SEDONA_SPARK_LOCAL_DIR", "/var/tmp/spark"),
        country_code=os.getenv("FOCUS_COUNTRY_CODE", "IL"),
        locality_name_en=os.getenv("FOCUS_LOCALITY_EN", "Ashdod"),
        locality_country_code=os.getenv(
            "FOCUS_LOCALITY_COUNTRY_CODE", "IL"
        ),
        country_sample_limit=_positive_int("ISRAEL_SAMPLE_LIMIT", 50_000),
        locality_sample_limit=_positive_int("ASHDOD_SAMPLE_LIMIT", 10_000),
        map_feature_limit=_positive_int("MAP_FEATURE_LIMIT", 2_000),
        s3_endpoint=endpoint,
        s3_access_key=access_key,
        s3_secret_key=secret_key,
        s3_path_style=_boolean("S3_PATH_STYLE_ACCESS", True),
        s3_ssl_enabled=_boolean("S3_SSL_ENABLED", False),
    )
    if settings.map_feature_limit > settings.locality_sample_limit:
        raise ValueError(
            "MAP_FEATURE_LIMIT must not exceed ASHDOD_SAMPLE_LIMIT"
        )
    return settings
