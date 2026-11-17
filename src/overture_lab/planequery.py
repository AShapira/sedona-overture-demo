"""Offline, checksummed PlaneQuery observations to directed geodesic connections."""

from datetime import date, timedelta
import json
import math
from pathlib import PurePosixPath
import re

from .flight_routes import _read_small_file, flight_source_uri, geodesic_route

MAX_FILE_BYTES = 64 * 1024 * 1024
QUARTER = ("2026-07-01", "2026-10-01")


def planequery_source_uri(release_uri, configured=""):
    return flight_source_uri(release_uri, configured.strip() or f"{release_uri.rstrip('/')}/external_sources/planequery/2026-Q3")


def validate_manifest(manifest, *, expected_period=QUARTER):
    """Reject incomplete periods and unsafe file paths before any bulk reads."""
    if (manifest.get("format_version") != 1 or manifest.get("dataset") != "PlaneQuery"
            or manifest.get("dataset_id") != "ggman12/planequery-data-flights"
            or manifest.get("source_partition") != "source=algorithm-nn/adsb_source=adsblol/version=4"
            or manifest.get("license") != "ODbL-1.0"
            or any(not re.fullmatch(r"[0-9a-f]{40}", str(manifest.get(key, "")))
                   for key in ("revision", "airport_revision"))):
        raise ValueError("Unsupported PlaneQuery manifest; use scripts/download-planequery.py on an OPEN NETWORK")
    period = (manifest.get("period_start"), manifest.get("period_end_exclusive"))
    if period != expected_period:
        raise ValueError(f"Expected PlaneQuery period {expected_period}, found {period}")
    start, end = map(date.fromisoformat, period)
    days = (end - start).days
    if not 0 < days <= 366 or manifest.get("days") != days:
        raise ValueError("Invalid source period length")
    expected = {(start + timedelta(days=i)).isoformat() for i in range(days)}
    files = manifest.get("files", {})
    if not isinstance(files, dict) or not 1 <= len(files) <= 1200:
        raise ValueError("Invalid source inventory")
    flights, provenance = set(), set()
    for name, record in files.items():
        path = PurePosixPath(name)
        if (not name or path.is_absolute() or ".." in path.parts or str(path) != name
                or not re.fullmatch(r"[A-Za-z0-9_./=-]+", name)):
            raise ValueError(f"Unsafe source path: {name!r}")
        size = record.get("bytes")
        if (isinstance(size, bool) or not isinstance(size, int) or not 0 < size <= MAX_FILE_BYTES
                or not re.fullmatch(r"[0-9a-f]{64}", str(record.get("sha256", "")))):
            raise ValueError(f"Invalid size/hash: {name}")
        role = record.get("role")
        if role in ("flights", "daily_provenance"):
            day = record.get("date")
            if day not in expected or path.parent.as_posix() != f"flights/date={day}":
                raise ValueError(f"Invalid partition: {name}")
            if role == "flights":
                if path.name != "data.parquet" or day in flights:
                    raise ValueError(f"Duplicate/unexpected flight partition: {name}")
                flights.add(day)
            else:
                if path.name not in ("airport_catalog.json", "flight_manifest.json"):
                    raise ValueError(f"Unexpected provenance file: {name}")
                provenance.add(day)
        elif role == "airports":
            if name != "airports.csv":
                raise ValueError("Expected airports.csv reference")
        elif role != "documentation":
            raise ValueError(f"Unknown file role: {role}")
    if (flights != expected or provenance != expected
            or files.get("airports.csv", {}).get("role") != "airports"):
        raise ValueError("Incomplete daily partitions, provenance, or airport reference")
    return files


def read_planequery_bundle(spark, source_uri, *, expected_period=QUARTER):
    """Read only transferred local/S3 files; verify every byte before processing."""
    from pyspark.sql import functions as F

    source_uri = planequery_source_uri(source_uri, source_uri)
    try:
        manifest = json.loads(_read_small_file(spark, f"{source_uri}/manifest.json", 2 * 1024 * 1024))
    except FileNotFoundError as error:
        raise FileNotFoundError(f"Missing PlaneQuery bundle at {source_uri}. Run scripts/download-planequery.py "
                                "on an OPEN NETWORK, transfer it, and set FLIGHT_ROUTES_URI. No download is attempted.") from error
    files = validate_manifest(manifest, expected_period=expected_period)
    uris = [f"{source_uri}/{name}" for name in files]
    # Check file lengths before binaryFile can allocate executor memory. Content
    # hashes run on executors; only tiny path/length/digest rows reach the driver.
    for name, uri in zip(files, uris):
        path = spark._jvm.org.apache.hadoop.fs.Path(uri)
        fs = path.getFileSystem(spark._jsc.hadoopConfiguration())
        status = fs.getFileStatus(path)
        if not status.isFile() or status.getLen() != files[name]["bytes"]:
            raise ValueError(f"PlaneQuery size verification failed: {name}")
    checked = spark.read.format("binaryFile").load(uris).select(
        "path", "length", F.sha2("content", 256).alias("sha256")).collect()
    # Hadoop may canonicalize file:/// and s3a paths; match the full relative
    # suffix and require exactly one result per manifest entry.
    if len(checked) != len(files):
        raise ValueError("Source hash inventory changed during read")
    for name, record in files.items():
        matches = [row for row in checked if row.path.endswith("/" + name)]
        if len(matches) != 1 or matches[0].length != record["bytes"] or matches[0].sha256 != record["sha256"]:
            raise ValueError(f"PlaneQuery SHA-256 verification failed: {name}")
    spark.conf.set("spark.sql.session.timeZone", "UTC")
    paths = [f"{source_uri}/{name}" for name, r in files.items() if r["role"] == "flights"]
    observations = spark.read.parquet(*paths).withColumn("source_file", F.input_file_name()).withColumn(
        "source_partition_date", F.regexp_extract("source_file", r"date=(\d{4}-\d{2}-\d{2})/", 1))
    airports = spark.read.option("header", True).option("mode", "FAILFAST").csv(f"{source_uri}/airports.csv")
    return manifest, observations, airports


def build_connections(observations, airports, manifest, *, max_segment_km=200.0):
    """Aggregate all valid directed pairs; return classified rows for a full audit."""
    from pyspark import StorageLevel
    from pyspark.sql import functions as F, types as T

    if isinstance(max_segment_km, bool) or not math.isfinite(max_segment_km) or not 1 <= max_segment_km <= 1000:
        raise ValueError("MAX_SEGMENT_KM must be finite and between 1 and 1000")
    required = {"takeoff_time", "landing_time", "takeoff_airport_id", "landing_airport_id",
                "takeoff_airport_ident", "landing_airport_ident", "source_file", "source_partition_date"}
    if required - set(observations.columns):
        raise ValueError(f"Missing PlaneQuery columns: {sorted(required - set(observations.columns))}")
    airport_columns = {"id", "ident", "name", "type", "latitude_deg", "longitude_deg", "iso_country"}
    if airport_columns - set(airports.columns):
        raise ValueError("Missing OurAirports reference columns")
    reference = airports.select(F.col("id").cast("long").alias("airport_id"),
        "ident", "name", "type", "iso_country", F.col("longitude_deg").cast("double").alias("lon"),
        F.col("latitude_deg").cast("double").alias("lat"))
    if reference.filter("airport_id IS NULL").limit(1).count() or reference.groupBy("airport_id").count().filter("count > 1").limit(1).count():
        raise ValueError("Null/duplicate OurAirports IDs would make endpoint joins ambiguous")
    joined = observations
    for side, key in (("origin", "takeoff_airport_id"), ("destination", "landing_airport_id")):
        lookup = reference.select(*[F.col(c).alias(f"{side}_{c}") for c in reference.columns])
        joined = joined.join(F.broadcast(lookup), F.col(key) == F.col(f"{side}_airport_id"), "left")
    valid_coords = F.lit(True)
    for side in ("origin", "destination"):
        valid_coords = valid_coords & F.col(f"{side}_lon").between(-180, 180) & F.col(f"{side}_lat").between(-90, 90)
    reason = (F.when(F.col("takeoff_time").isNull() | F.col("landing_time").isNull()
                     | (F.col("landing_time") <= F.col("takeoff_time")), "invalid_times")
              .when((F.col("takeoff_time") < F.lit(manifest["period_start"]).cast("timestamp"))
                    | (F.col("takeoff_time") >= F.lit(manifest["period_end_exclusive"]).cast("timestamp")), "outside_period")
              .when(F.col("takeoff_airport_id").isNull() | F.col("landing_airport_id").isNull(), "missing_airport_id")
              .when(F.col("origin_airport_id").isNull() | F.col("destination_airport_id").isNull(), "unknown_airport_id")
              .when(~F.coalesce(valid_coords, F.lit(False)), "invalid_airport_coordinates")
              .when(F.col("origin_airport_id") == F.col("destination_airport_id"), "same_airport")
              .when(F.expr("ST_DistanceSphere(ST_Point(origin_lon, origin_lat), ST_Point(destination_lon, destination_lat)) < 1.01"),
                    "coincident_endpoints"))
    classified = joined.withColumn("exclusion_reason", reason).withColumn("observation_day", F.to_date("takeoff_time"))
    classified = classified.withColumn("airport_ident_disagreement", F.coalesce(
        (F.col("takeoff_airport_ident") != F.col("origin_ident"))
        | (F.col("landing_airport_ident") != F.col("destination_ident")), F.lit(False))).withColumn(
            "partition_day_disagreement", F.col("observation_day") != F.to_date("source_partition_date"))
    classified = classified.persist(StorageLevel.DISK_ONLY)
    counts = {row.exclusion_reason or "accepted": row["count"]
              for row in classified.groupBy("exclusion_reason").count().collect()}
    valid = classified.filter("exclusion_reason IS NULL")
    endpoint_columns = [f"{side}_{col}" for side in ("origin", "destination")
                        for col in ("airport_id", "ident", "name", "type", "iso_country", "lon", "lat")]
    pairs = valid.groupBy(*endpoint_columns).agg(
        F.count("*").alias("observation_count"), F.countDistinct("observation_day").alias("active_days"),
        F.date_format(F.min("takeoff_time"), "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").alias("first_observed_utc"),
        F.date_format(F.max("takeoff_time"), "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").alias("last_observed_utc"),
        F.sum(F.col("airport_ident_disagreement").cast("long")).alias("ident_disagreement_count"),
        F.sum(F.col("partition_day_disagreement").cast("long")).alias("partition_day_disagreement_count"),
        *[F.sum(F.when(F.month("takeoff_time") == month, 1).otherwise(0)).alias(f"observations_{month:02}") for month in (7, 8, 9)],
    )

    @F.udf(T.StructType([T.StructField("wkb", T.BinaryType(), False), T.StructField("km", T.DoubleType(), False)]))
    def line(lon1, lat1, lon2, lat2):
        geometry, distance = geodesic_route(lon1, lat1, lon2, lat2, max_segment_km=max_segment_km)
        return bytes(geometry.wkb), distance

    routes = pairs.withColumn("_line", line("origin_lon", "origin_lat", "destination_lon", "destination_lat"))
    routes = routes.withColumn("geometry", F.expr("ST_SetSRID(ST_GeomFromWKB(_line.wkb), 4326)"))
    routes = routes.withColumn("distance_km", F.col("_line.km")).drop("_line").withColumn(
        "id", F.concat_ws(":", F.lit("planequery"), F.lit(manifest["revision"][:12]),
                          F.col("origin_airport_id"), F.col("destination_airport_id")))
    for key, value in {"source": "PlaneQuery / ADSB.lol", "source_revision": manifest["revision"],
                       "source_partition": manifest["source_partition"], "period_start": manifest["period_start"],
                       "period_end_exclusive": manifest["period_end_exclusive"],
                       "airport_reference_revision": manifest["airport_revision"],
                       "airport_reference_date": manifest["airport_reference_date"], "license": manifest["license"],
                       "geometry_method": "WGS84 shortest geodesic; split at antimeridian",
                       "max_segment_km": max_segment_km}.items():
        routes = routes.withColumn(key, F.lit(value))
    report = {
        "input_observations": sum(counts.values()), "accepted_observations": counts.pop("accepted", 0),
        "excluded_by_reason": counts, "excluded_observations": sum(counts.values()),
        "period_start": manifest["period_start"], "period_end_exclusive": manifest["period_end_exclusive"],
        "daily_input": [row.asDict() for row in classified.groupBy("source_partition_date").agg(
            F.count("*").alias("observations"), F.sum(F.when(F.col("exclusion_reason").isNull(), 1).otherwise(0)).alias("accepted")
        ).orderBy("source_partition_date").collect()],
        "policy": "One mutually exclusive exclusion reason per row in priority order; ID-only airport join. "
                  "All airport facility types retained, including currently closed facilities. "
                  "Ident and partition-date disagreements are flags, not exclusions. "
                  "Duplicate source observations remain counted; counts are not guaranteed unique aircraft flights.",
        "source_limitations": manifest.get("limitations"),
    }
    assert report["input_observations"] == report["accepted_observations"] + report["excluded_observations"]
    return routes, classified, report


def connection_display_frame(routes, *, min_active_days=14, feature_limit=100_000, coordinate_limit=2_000_000):
    from pyspark.sql import functions as F
    from .visualize import collect_geodataframe

    if any(isinstance(v, bool) or not isinstance(v, int) or v < 1 for v in (min_active_days, feature_limit, coordinate_limit)):
        raise ValueError("Map recurrence and budgets must be positive integers")
    display = routes.filter(F.col("active_days") >= min_active_days).select(
        F.concat_ws("→", "origin_ident", "destination_ident").alias("source_id"),
        "origin_name", "destination_name", "observation_count", "active_days", "geometry",
        F.round("distance_km", 1).alias("distance_km"))
    report = display.agg(F.count("*").alias("features"), F.sum(F.expr("ST_NPoints(geometry)")).alias("coordinates")).first()
    if not report.features:
        raise ValueError("No connections meet MAP_MIN_ACTIVE_DAYS; lower the display threshold. Export is complete.")
    if report.features > feature_limit or (report.coordinates or 0) > coordinate_limit:
        raise ValueError(f"Map needs {report.features:,} pairs / {report.coordinates:,} coordinates. Increase the display "
                         "budgets or MAP_MIN_ACTIVE_DAYS; no routes were sampled. Export is complete.")
    return collect_geodataframe(display.orderBy("source_id"), limit=feature_limit,
        columns=["source_id", "origin_name", "destination_name", "observation_count", "active_days", "distance_km"])


def write_connection_audit(spark, run_prefix, manifest, report, classified):
    excluded_uri = f"{run_prefix}/excluded-observations"
    classified.filter("exclusion_reason IS NOT NULL").write.mode("errorifexists").parquet(excluded_uri)
    documents = {"source-manifest.json": manifest, "route-quality.json": report}
    for name, value in documents.items():
        path = spark._jvm.org.apache.hadoop.fs.Path(f"{run_prefix}/{name}")
        stream = path.getFileSystem(spark._jsc.hadoopConfiguration()).create(path, False)
        try:
            stream.write(bytearray((json.dumps(value, indent=2) + "\n").encode()))
        finally:
            stream.close()
    return {**{name: f"{run_prefix}/{name}" for name in documents}, "excluded-observations": excluded_uri}
