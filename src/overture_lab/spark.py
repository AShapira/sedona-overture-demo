"""Sedona session construction and Overture GeoParquet readers."""

from __future__ import annotations

import os
from typing import TYPE_CHECKING

from .config import LabSettings
from .scratch import scratch_status

if TYPE_CHECKING:
    from pyspark.sql import DataFrame, SparkSession


def create_sedona(settings: LabSettings, app_name: str) -> "SparkSession":
    scratch_status(settings)
    settings.prepare_process_environment()

    from pyspark import SparkContext
    from sedona.spark import SedonaContext

    expected_master = f"local[{settings.local_cores}]"
    builder = (
        SedonaContext.builder()
        .master(expected_master)
        .appName(app_name)
        .config("spark.driver.memory", settings.driver_memory)
        .config("spark.serializer", "org.apache.spark.serializer.KryoSerializer")
        .config("spark.sql.adaptive.enabled", "true")
        .config("spark.sql.parquet.filterPushdown", "true")
        .config(
            "spark.sql.shuffle.partitions", str(settings.shuffle_partitions)
        )
        .config("spark.ui.showConsoleProgress", "false")
    )

    uses_s3 = settings.release_uri.startswith("s3a://") or bool(
        settings.derived_output_uri
    )
    if uses_s3:
        if settings.s3_endpoint:
            builder = builder.config(
                "spark.hadoop.fs.s3a.endpoint", settings.s3_endpoint
            )
        if settings.s3_region:
            builder = builder.config(
                "spark.hadoop.fs.s3a.endpoint.region", settings.s3_region
            )
        builder = (
            builder.config(
                "spark.hadoop.fs.s3a.path.style.access",
                str(settings.s3_path_style).lower(),
            )
            .config(
                "spark.hadoop.fs.s3a.connection.ssl.enabled",
                str(settings.s3_ssl_enabled).lower(),
            )
            .config("spark.hadoop.fs.s3a.connection.maximum", "16")
        )
        if settings.s3_access_key and settings.s3_secret_key:
            os.environ["AWS_ACCESS_KEY_ID"] = settings.s3_access_key
            os.environ["AWS_SECRET_ACCESS_KEY"] = settings.s3_secret_key
            builder = builder.config(
                "spark.hadoop.fs.s3a.aws.credentials.provider",
                "software.amazon.awssdk.auth.credentials."
                "EnvironmentVariableCredentialsProvider",
            )
        else:
            builder = builder.config(
                "spark.hadoop.fs.s3a.aws.credentials.provider",
                "org.apache.hadoop.fs.s3a.AnonymousAWSCredentialsProvider",
            )

    active = SparkContext._active_spark_context
    if active is not None and active.master != expected_master:
        raise RuntimeError(
            "A Spark context with incompatible resources is already active. "
            "Restart the notebook kernel before changing resource settings."
        )

    spark = SedonaContext.create(builder.getOrCreate())
    spark.sparkContext.setLogLevel(os.getenv("SEDONA_SPARK_LOG_LEVEL", "ERROR"))
    return spark


def read_type(
    spark: "SparkSession",
    settings: LabSettings,
    theme: str,
    feature_type: str,
) -> "DataFrame":
    """Read one Overture Hive leaf as a SedonaDataFrame."""
    from pyspark.sql import functions as F

    return (
        spark.read.format("geoparquet")
        .load(settings.type_uri(theme, feature_type))
        .withColumn("theme", F.lit(theme))
        .withColumn("feature_type", F.lit(feature_type))
    )
