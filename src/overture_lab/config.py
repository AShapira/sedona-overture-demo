"""Configuration with validation before a Spark JVM is created."""

from __future__ import annotations

from dataclasses import asdict, dataclass
import json
import os
from pathlib import Path
import re
from urllib.parse import urlparse


STATE_CODE = re.compile(r"^[A-Z]{2}$")


def _positive_int(name: str, default: int) -> int:
    raw = os.getenv(name, str(default))
    try:
        value = int(raw)
    except ValueError as exc:
        raise ValueError(f"{name} must be an integer, found {raw!r}") from exc
    if value < 1:
        raise ValueError(f"{name} must be at least 1, found {value}")
    return value


def _required_positive_int(name: str) -> int:
    raw = os.getenv(name)
    if raw is None or not raw.strip():
        raise ValueError(f"{name} is required")
    try:
        value = int(raw)
    except ValueError as exc:
        raise ValueError(f"{name} must be an integer, found {raw!r}") from exc
    if value < 1:
        raise ValueError(f"{name} must be at least 1, found {value}")
    return value


def _nonnegative_int(name: str, default: int) -> int:
    raw = os.getenv(name, str(default))
    try:
        value = int(raw)
    except ValueError as exc:
        raise ValueError(f"{name} must be an integer, found {raw!r}") from exc
    if value < 0:
        raise ValueError(f"{name} must be at least 0, found {value}")
    return value


def _boolean(name: str, default: bool) -> bool:
    raw = os.getenv(name, str(default)).strip().lower()
    if raw in {"1", "true", "yes", "on"}:
        return True
    if raw in {"0", "false", "no", "off"}:
        return False
    raise ValueError(f"{name} must be true or false, found {raw!r}")


def _required_json(name: str) -> object:
    raw = os.getenv(name)
    if raw is None or not raw.strip():
        raise ValueError(f"{name} is required")
    try:
        return json.loads(raw)
    except json.JSONDecodeError as exc:
        raise ValueError(f"{name} must contain valid JSON") from exc


def _state_code(value: object, source: str) -> str:
    if not isinstance(value, str):
        raise ValueError(f"{source} must be a string")
    code = value.strip().upper()
    if not STATE_CODE.fullmatch(code):
        raise ValueError(f"{source} must be a two-letter state code")
    return code


def _medium_state_codes() -> tuple[str, ...]:
    value = _required_json("MEDIUM_STATE_CODES")
    if not isinstance(value, list) or not value:
        raise ValueError("MEDIUM_STATE_CODES must be a non-empty JSON array")
    codes = tuple(
        _state_code(item, f"MEDIUM_STATE_CODES[{index}]")
        for index, item in enumerate(value)
    )
    if len(set(codes)) != len(codes):
        raise ValueError("MEDIUM_STATE_CODES must not contain duplicates")
    return codes


@dataclass(frozen=True)
class CitySpec:
    name: str
    state_code: str


def _small_cities(medium_state_codes: tuple[str, ...]) -> tuple[CitySpec, ...]:
    value = _required_json("SMALL_CITIES")
    if not isinstance(value, list) or not value:
        raise ValueError("SMALL_CITIES must be a non-empty JSON array")
    cities = []
    for index, item in enumerate(value):
        source = f"SMALL_CITIES[{index}]"
        if not isinstance(item, dict) or set(item) != {"name", "state_code"}:
            raise ValueError(
                f"{source} must contain exactly name and state_code"
            )
        name = item["name"]
        if not isinstance(name, str) or not name.strip():
            raise ValueError(f"{source}.name must be a non-empty string")
        code = _state_code(item["state_code"], f"{source}.state_code")
        if code not in medium_state_codes:
            raise ValueError(
                f"{source}.state_code must also appear in MEDIUM_STATE_CODES"
            )
        cities.append(CitySpec(name=name.strip(), state_code=code))
    city_keys = {(city.name, city.state_code) for city in cities}
    if len(city_keys) != len(cities):
        raise ValueError("SMALL_CITIES must not contain duplicate city entries")
    return tuple(cities)


@dataclass(frozen=True)
class LabSettings:
    release_uri: str
    release: str
    local_cores: int
    driver_memory: str
    shuffle_partitions: int
    spark_local_dir: str
    medium_state_codes: tuple[str, ...]
    small_cities: tuple[CitySpec, ...]
    medium_sample_limit: int
    small_sample_limit: int
    map_feature_limit: int
    s3_endpoint: str | None
    s3_region: str | None
    s3_access_key: str | None
    s3_secret_key: str | None
    s3_path_style: bool
    s3_ssl_enabled: bool
    scratch_dir: str
    scratch_budget_gb: int
    scratch_reserve_gb: int
    inventory_cache_dir: str
    refresh_release_inventory: bool
    inventory_include_row_counts: bool
    require_s3_release: bool
    write_derived: bool
    derived_output_uri: str | None
    allow_local_derived_fallback: bool
    derived_local_fallback_dir: str

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

    @property
    def storage_mode(self) -> str:
        return "s3a" if self.release_uri.startswith("s3a://") else "local"

    @property
    def medium_state_label(self) -> str:
        return ", ".join(self.medium_state_codes)

    @property
    def small_city_label(self) -> str:
        return ", ".join(
            f"{city.name} ({city.state_code})" for city in self.small_cities
        )

    def prepare_process_environment(self) -> None:
        """Set Spark-launch variables before importing PySpark."""
        local_dir = Path(self.spark_local_dir)
        local_dir.mkdir(parents=True, exist_ok=True)
        os.environ["SPARK_LOCAL_DIRS"] = str(local_dir)
        os.environ["PYSPARK_SUBMIT_ARGS"] = (
            f"--driver-memory {self.driver_memory} pyspark-shell"
        )


def _normalised_s3_parts(uri: str) -> tuple[str, str]:
    parsed = urlparse(uri)
    if parsed.scheme != "s3a" or not parsed.netloc:
        raise ValueError(f"Expected an s3a:// URI, found {uri!r}")
    return parsed.netloc.lower(), parsed.path.strip("/")


def _overlapping_s3_prefixes(left: str, right: str) -> bool:
    left_bucket, left_path = _normalised_s3_parts(left)
    right_bucket, right_path = _normalised_s3_parts(right)
    if left_bucket != right_bucket:
        return False
    left_parts = tuple(part for part in left_path.split("/") if part)
    right_parts = tuple(part for part in right_path.split("/") if part)
    shortest = min(len(left_parts), len(right_parts))
    return left_parts[:shortest] == right_parts[:shortest]


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

    medium_state_codes = _medium_state_codes()
    small_cities = _small_cities(medium_state_codes)

    settings = LabSettings(
        release_uri=os.getenv("OVERTURE_RELEASE_URI", "/data/overture"),
        release=os.getenv("OVERTURE_RELEASE", "2026-07-22.0"),
        local_cores=cores,
        driver_memory=os.getenv("SEDONA_SPARK_DRIVER_MEMORY", "16g"),
        shuffle_partitions=partitions,
        spark_local_dir=os.getenv("SEDONA_SPARK_LOCAL_DIR", "/var/tmp/spark"),
        medium_state_codes=medium_state_codes,
        small_cities=small_cities,
        medium_sample_limit=_required_positive_int("MEDIUM_SAMPLE_LIMIT"),
        small_sample_limit=_required_positive_int("SMALL_SAMPLE_LIMIT"),
        map_feature_limit=_positive_int("MAP_FEATURE_LIMIT", 2_000),
        s3_endpoint=endpoint,
        s3_region=os.getenv("S3_REGION") or None,
        s3_access_key=access_key,
        s3_secret_key=secret_key,
        s3_path_style=_boolean("S3_PATH_STYLE_ACCESS", True),
        s3_ssl_enabled=_boolean("S3_SSL_ENABLED", False),
        scratch_dir=os.getenv("SEDONA_SCRATCH_DIR", "/var/tmp"),
        scratch_budget_gb=_positive_int("SEDONA_SCRATCH_BUDGET_GB", 20),
        scratch_reserve_gb=_nonnegative_int("SEDONA_SCRATCH_RESERVE_GB", 2),
        inventory_cache_dir=os.getenv(
            "RELEASE_INVENTORY_CACHE", "/var/tmp/inventory"
        ),
        refresh_release_inventory=_boolean(
            "REFRESH_RELEASE_INVENTORY", False
        ),
        inventory_include_row_counts=_boolean(
            "INVENTORY_INCLUDE_ROW_COUNTS", False
        ),
        require_s3_release=_boolean("REQUIRE_S3_RELEASE", False),
        write_derived=_boolean("WRITE_DERIVED", False),
        derived_output_uri=os.getenv("DERIVED_OUTPUT_URI") or None,
        allow_local_derived_fallback=_boolean(
            "ALLOW_LOCAL_DERIVED_FALLBACK", True
        ),
        derived_local_fallback_dir=os.getenv(
            "DERIVED_LOCAL_FALLBACK_DIR", "/var/tmp/derived"
        ),
    )
    if settings.small_sample_limit > settings.medium_sample_limit:
        raise ValueError(
            "SMALL_SAMPLE_LIMIT must not exceed MEDIUM_SAMPLE_LIMIT"
        )
    if settings.map_feature_limit > settings.small_sample_limit:
        raise ValueError(
            "MAP_FEATURE_LIMIT must not exceed SMALL_SAMPLE_LIMIT"
        )
    if settings.scratch_reserve_gb >= settings.scratch_budget_gb:
        raise ValueError(
            "SEDONA_SCRATCH_RESERVE_GB must be smaller than "
            "SEDONA_SCRATCH_BUDGET_GB"
        )
    if settings.release_uri.startswith(("s3://", "s3a://")):
        _normalised_s3_parts(settings.release_uri)
    if settings.require_s3_release and settings.storage_mode != "s3a":
        raise ValueError(
            "REQUIRE_S3_RELEASE=true requires OVERTURE_RELEASE_URI to use s3a://"
        )
    if settings.derived_output_uri:
        _normalised_s3_parts(settings.derived_output_uri)
        if settings.release_uri.startswith("s3a://") and _overlapping_s3_prefixes(
            settings.release_uri, settings.derived_output_uri
        ):
            raise ValueError(
                "DERIVED_OUTPUT_URI must not equal, contain, or be contained "
                "by OVERTURE_RELEASE_URI"
            )
    if (
        settings.write_derived
        and not settings.derived_output_uri
        and not settings.allow_local_derived_fallback
    ):
        raise ValueError(
            "WRITE_DERIVED requires DERIVED_OUTPUT_URI or enabled local fallback"
        )
    scratch_root = Path(settings.scratch_dir).resolve()
    fallback_root = Path(settings.derived_local_fallback_dir).resolve()
    if not fallback_root.is_relative_to(scratch_root):
        raise ValueError(
            "DERIVED_LOCAL_FALLBACK_DIR must be inside SEDONA_SCRATCH_DIR"
        )
    return settings
