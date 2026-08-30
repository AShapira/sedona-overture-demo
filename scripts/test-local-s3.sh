#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
container_program=${CONTAINER_PROGRAM:-podman}
sedona_image=${SEDONA_IMAGE:-docker.io/apache/sedona:1.9.0@sha256:a1acf172621652c926214259045b2324f75341026dd726db0bef7e21b4205525}
minio_image=${MINIO_IMAGE:-docker.io/minio/minio:latest}
mc_image=${MINIO_MC_IMAGE:-docker.io/minio/mc:latest}
fixture_dir=$(mktemp -d)
suffix=$$
network="sedona-s3-test-${suffix}"
server="sedona-minio-${suffix}"

cleanup() {
  "${container_program}" rm -f "${server}" >/dev/null 2>&1 || true
  "${container_program}" network rm "${network}" >/dev/null 2>&1 || true
  rm -rf -- "${fixture_dir}"
}
trap cleanup EXIT

"${container_program}" network create "${network}" >/dev/null
"${container_program}" run -d --name "${server}" --network "${network}" \
  --network-alias minio \
  -e MINIO_ROOT_USER=minioadmin \
  -e MINIO_ROOT_PASSWORD=minioadmin \
  "${minio_image}" server /data >/dev/null

for _ in {1..30}; do
  if "${container_program}" run --rm --network "${network}" \
    -e MC_HOST_local=http://minioadmin:minioadmin@minio:9000 \
    "${mc_image}" ls local >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

"${container_program}" run --rm \
  -v "${project_dir}:/workspace:ro" \
  -v "${fixture_dir}:/fixture" \
  --entrypoint python3 \
  "${sedona_image}" /workspace/tests/make_s3_fixture.py /fixture/release
mkdir -p "${fixture_dir}/scratch"

"${container_program}" run --rm --network "${network}" \
  -e MC_HOST_local=http://minioadmin:minioadmin@minio:9000 \
  "${mc_image}" mb local/overture >/dev/null
"${container_program}" run --rm --network "${network}" \
  -e MC_HOST_local=http://minioadmin:minioadmin@minio:9000 \
  -v "${fixture_dir}:/fixture:ro" "${mc_image}" \
  cp --recursive /fixture/release/ \
  local/overture/release/2026-07-22.0/ >/dev/null
"${container_program}" run --rm --network "${network}" \
  -e MC_HOST_local=http://minioadmin:minioadmin@minio:9000 \
  "${mc_image}" admin user add local readonly readonlysecret >/dev/null
"${container_program}" run --rm --network "${network}" \
  -e MC_HOST_local=http://minioadmin:minioadmin@minio:9000 \
  -v "${project_dir}:/workspace:ro" \
  "${mc_image}" admin policy create local sedona-readonly \
  /workspace/tests/minio-readonly-policy.json >/dev/null
"${container_program}" run --rm --network "${network}" \
  -e MC_HOST_local=http://minioadmin:minioadmin@minio:9000 \
  "${mc_image}" admin policy attach local sedona-readonly \
  --user readonly >/dev/null
readonly_ready=false
for _ in {1..30}; do
  if "${container_program}" run --rm --network "${network}" \
    -e MC_HOST_readonly=http://readonly:readonlysecret@minio:9000 \
    "${mc_image}" ls readonly/overture/release/2026-07-22.0 \
    >/dev/null 2>&1; then
    readonly_ready=true
    break
  fi
  sleep 1
done
if [[ "${readonly_ready}" != true ]]; then
  printf 'Read-only MinIO policy did not become usable.\n' >&2
  "${container_program}" run --rm --network "${network}" \
    -e MC_HOST_local=http://minioadmin:minioadmin@minio:9000 \
    "${mc_image}" admin user info local readonly >&2 || true
  "${container_program}" run --rm --network "${network}" \
    -e MC_HOST_local=http://minioadmin:minioadmin@minio:9000 \
    "${mc_image}" admin policy entities local --user readonly >&2 || true
  exit 1
fi

"${container_program}" run --rm --network "${network}" \
  --security-opt=no-new-privileges \
  --memory=8g \
  -e PYTHONPATH=/workspace/src:/opt/spark/python \
  -e OVERTURE_RELEASE_URI=s3a://overture/release/2026-07-22.0 \
  -e OVERTURE_RELEASE=2026-07-22.0 \
  -e REQUIRE_S3_RELEASE=true \
  -e MEDIUM_STATE_CODES='["AA"]' \
  -e SMALL_CITIES='[{"name":"Fixture City","state_code":"AA"}]' \
  -e MEDIUM_SAMPLE_LIMIT=20 \
  -e SMALL_SAMPLE_LIMIT=10 \
  -e MAP_FEATURE_LIMIT=5 \
  -e S3_ENDPOINT=http://minio:9000 \
  -e S3_REGION=us-east-1 \
  -e S3_ACCESS_KEY=minioadmin \
  -e S3_SECRET_KEY=minioadmin \
  -e S3_PATH_STYLE_ACCESS=true \
  -e S3_SSL_ENABLED=false \
  -e SEDONA_SPARK_LOCAL_CORES=2 \
  -e SEDONA_SPARK_DRIVER_MEMORY=4g \
  -e SEDONA_SPARK_PARTITIONS=4 \
  -e SEDONA_SPARK_LOCAL_DIR=/scratch/spark \
  -e SEDONA_SCRATCH_DIR=/scratch \
  -e SEDONA_SCRATCH_BUDGET_GB=20 \
  -e SEDONA_SCRATCH_RESERVE_GB=2 \
  -e DERIVED_LOCAL_FALLBACK_DIR=/scratch/derived \
  -e RELEASE_INVENTORY_CACHE=/scratch/inventory \
  -v "${project_dir}:/workspace:ro" \
  -v "${fixture_dir}/scratch:/scratch" \
  -w /workspace \
  --entrypoint jupyter \
  "${sedona_image}" execute notebooks/00_environment_and_release.ipynb \
  --output /scratch/00_environment_and_release.ipynb --timeout 600

"${container_program}" run --rm --network "${network}" \
  --security-opt=no-new-privileges \
  --memory=8g \
  -e PYTHONPATH=/workspace/src:/opt/spark/python \
  -e OVERTURE_RELEASE_URI=s3a://overture/release/2026-07-22.0 \
  -e OVERTURE_RELEASE=2026-07-22.0 \
  -e REQUIRE_S3_RELEASE=true \
  -e MEDIUM_STATE_CODES='["AA"]' \
  -e SMALL_CITIES='[{"name":"Fixture City","state_code":"AA"}]' \
  -e MEDIUM_SAMPLE_LIMIT=20 \
  -e SMALL_SAMPLE_LIMIT=10 \
  -e MAP_FEATURE_LIMIT=5 \
  -e S3_ENDPOINT=http://minio:9000 \
  -e S3_REGION=us-east-1 \
  -e S3_ACCESS_KEY=minioadmin \
  -e S3_SECRET_KEY=minioadmin \
  -e S3_PATH_STYLE_ACCESS=true \
  -e S3_SSL_ENABLED=false \
  -e WRITE_DERIVED=true \
  -e DERIVED_OUTPUT_URI=s3a://overture/derived/single-file-lab \
  -e ALLOW_LOCAL_DERIVED_FALLBACK=false \
  -e SEDONA_SPARK_LOCAL_CORES=2 \
  -e SEDONA_SPARK_DRIVER_MEMORY=4g \
  -e SEDONA_SPARK_PARTITIONS=4 \
  -e SEDONA_SPARK_LOCAL_DIR=/scratch/spark-roads \
  -e SEDONA_SCRATCH_DIR=/scratch \
  -e SEDONA_SCRATCH_BUDGET_GB=20 \
  -e SEDONA_SCRATCH_RESERVE_GB=2 \
  -e DERIVED_LOCAL_FALLBACK_DIR=/scratch/derived \
  -v "${project_dir}:/workspace:ro" \
  -v "${fixture_dir}/scratch:/scratch" \
  -w /workspace \
  --entrypoint jupyter \
  "${sedona_image}" execute \
  notebooks/10_standalone_sedonaspark_clipped_roads.ipynb \
  --output /scratch/10_standalone_sedonaspark_clipped_roads.ipynb \
  --timeout 1200

single_file_listing=$(
  "${container_program}" run --rm --network "${network}" \
    -e MC_HOST_local=http://minioadmin:minioadmin@minio:9000 \
    "${mc_image}" ls --recursive \
    local/overture/derived/single-file-lab/clipped_roads
)
single_file_names=$(printf '%s\n' "${single_file_listing}" | awk '{print $NF}')
single_file_total=$(printf '%s\n' "${single_file_names}" | awk 'NF {count++} END {print count + 0}')
single_file_geoparquet=$(printf '%s\n' "${single_file_names}" | awk '/\/roads\.geoparquet$/ {count++} END {print count + 0}')
single_file_csv=$(printf '%s\n' "${single_file_names}" | awk '/\/roads\.csv$/ {count++} END {print count + 0}')
single_file_boundary=$(printf '%s\n' "${single_file_names}" | awk '/\/boundary\.geoparquet$/ {count++} END {print count + 0}')
if [[ "${single_file_total}" -ne 3 || "${single_file_geoparquet}" -ne 1 || "${single_file_csv}" -ne 1 || "${single_file_boundary}" -ne 1 ]]; then
  printf 'Expected exactly roads.geoparquet, roads.csv, and boundary.geoparquet; found:\n%s\n' \
    "${single_file_names}" >&2
  exit 1
fi
single_file_csv_key=$(printf '%s\n' "${single_file_names}" | awk '/\/roads\.csv$/ {print; exit}')
single_file_csv_rows=$(
  "${container_program}" run --rm --network "${network}" \
    -e MC_HOST_local=http://minioadmin:minioadmin@minio:9000 \
    "${mc_image}" cat \
    "local/overture/derived/single-file-lab/clipped_roads/${single_file_csv_key}" \
    | awk 'END {print NR - 1}'
)
if [[ "${single_file_csv_rows}" -ne 2 ]]; then
  printf 'Expected two clipped CSV rows, found %s.\n' \
    "${single_file_csv_rows}" >&2
  exit 1
fi

"${container_program}" run --rm --network "${network}" \
  --security-opt=no-new-privileges \
  --memory=8g \
  -e PYTHONPATH=/workspace/src:/opt/spark/python \
  -e OVERTURE_RELEASE_URI=s3a://overture/release/2026-07-22.0 \
  -e OVERTURE_RELEASE=2026-07-22.0 \
  -e REQUIRE_S3_RELEASE=true \
  -e MEDIUM_STATE_CODES='["AA"]' \
  -e SMALL_CITIES='[{"name":"Fixture City","state_code":"AA"}]' \
  -e MEDIUM_SAMPLE_LIMIT=20 \
  -e SMALL_SAMPLE_LIMIT=10 \
  -e MAP_FEATURE_LIMIT=5 \
  -e S3_ENDPOINT=http://minio:9000 \
  -e S3_REGION=us-east-1 \
  -e S3_ACCESS_KEY=minioadmin \
  -e S3_SECRET_KEY=minioadmin \
  -e S3_PATH_STYLE_ACCESS=true \
  -e S3_SSL_ENABLED=false \
  -e WRITE_DERIVED=true \
  -e DERIVED_OUTPUT_URI=s3a://overture/derived/airports-runways-lab \
  -e ALLOW_LOCAL_DERIVED_FALLBACK=false \
  -e SEDONA_SPARK_LOCAL_CORES=2 \
  -e SEDONA_SPARK_DRIVER_MEMORY=4g \
  -e SEDONA_SPARK_PARTITIONS=4 \
  -e SEDONA_SPARK_LOCAL_DIR=/scratch/spark-airports-runways \
  -e SEDONA_SCRATCH_DIR=/scratch \
  -e SEDONA_SCRATCH_BUDGET_GB=20 \
  -e SEDONA_SCRATCH_RESERVE_GB=2 \
  -e DERIVED_LOCAL_FALLBACK_DIR=/scratch/derived \
  -v "${project_dir}:/workspace:ro" \
  -v "${fixture_dir}/scratch:/scratch" \
  -w /workspace \
  --entrypoint jupyter \
  "${sedona_image}" execute \
  notebooks/11_world_airports_and_medium_runways.ipynb \
  --output /scratch/11_world_airports_and_medium_runways.ipynb \
  --timeout 1200

airport_runway_listing=$(
  "${container_program}" run --rm --network "${network}" \
    -e MC_HOST_local=http://minioadmin:minioadmin@minio:9000 \
    "${mc_image}" ls --recursive \
    local/overture/derived/airports-runways-lab
)
airport_runway_names=$(
  printf '%s\n' "${airport_runway_listing}" \
    | awk '$NF !~ /\/$/ {print $NF}'
)
airport_runway_total=$(printf '%s\n' "${airport_runway_names}" | awk 'NF {count++} END {print count + 0}')
airport_object_key=$(printf '%s\n' "${airport_runway_names}" | awk '/\/airports\.geoparquet$/ {print; exit}')
runway_object_key=$(printf '%s\n' "${airport_runway_names}" | awk '/\/runways\.geoparquet$/ {print; exit}')
airport_object_count=$(printf '%s\n' "${airport_runway_names}" | awk '/\/airports\.geoparquet$/ {count++} END {print count + 0}')
runway_object_count=$(printf '%s\n' "${airport_runway_names}" | awk '/\/runways\.geoparquet$/ {count++} END {print count + 0}')
if [[ "${airport_runway_total}" -ne 2 || "${airport_object_count}" -ne 1 || "${runway_object_count}" -ne 1 ]]; then
  printf 'Expected exactly airports.geoparquet and runways.geoparquet; found:\n%s\n' \
    "${airport_runway_names}" >&2
  exit 1
fi

"${container_program}" run --rm --network "${network}" \
  --security-opt=no-new-privileges \
  --memory=8g \
  -e PYTHONPATH=/workspace/src:/opt/spark/python \
  -e OVERTURE_RELEASE_URI=s3a://overture/release/2026-07-22.0 \
  -e OVERTURE_RELEASE=2026-07-22.0 \
  -e MEDIUM_STATE_CODES='["AA"]' \
  -e SMALL_CITIES='[{"name":"Fixture City","state_code":"AA"}]' \
  -e MEDIUM_SAMPLE_LIMIT=20 \
  -e SMALL_SAMPLE_LIMIT=10 \
  -e MAP_FEATURE_LIMIT=5 \
  -e S3_ENDPOINT=http://minio:9000 \
  -e S3_REGION=us-east-1 \
  -e S3_ACCESS_KEY=minioadmin \
  -e S3_SECRET_KEY=minioadmin \
  -e S3_PATH_STYLE_ACCESS=true \
  -e S3_SSL_ENABLED=false \
  -e AIRPORT_OBJECT_URI="s3a://overture/derived/airports-runways-lab/${airport_object_key}" \
  -e RUNWAY_OBJECT_URI="s3a://overture/derived/airports-runways-lab/${runway_object_key}" \
  -e SEDONA_SPARK_LOCAL_CORES=2 \
  -e SEDONA_SPARK_DRIVER_MEMORY=4g \
  -e SEDONA_SPARK_PARTITIONS=4 \
  -e SEDONA_SPARK_LOCAL_DIR=/tmp/spark-airports-runways-verify \
  -v "${project_dir}:/workspace:ro" \
  -w /workspace \
  --entrypoint python3 \
  "${sedona_image}" -c \
  'import os; from overture_lab.config import load_settings; from overture_lab.spark import create_sedona; s=load_settings(); spark=create_sedona(s,"airports-runways-readback-smoke"); airports=spark.read.format("geoparquet").load(os.environ["AIRPORT_OBJECT_URI"]); runways=spark.read.format("geoparquet").load(os.environ["RUNWAY_OBJECT_URI"]); assert {(row.id,row["class"]) for row in airports.select("id","class").collect()}=={("canonical-airport-one","international_airport"),("canonical-airport-two","regional_airport")}; assert {row.id for row in runways.select("id").collect()}=={"inside-runway","crossing-runway"}; assert "source_tags" in airports.columns and "geometry_bbox" in airports.columns; assert "source_tags" in runways.columns and "geometry_bbox" in runways.columns; crossing=runways.where(runways.id=="crossing-runway").selectExpr("ST_XMin(geometry) AS xmin", "GeometryType(geometry) AS kind").first(); assert crossing.xmin < 34.0 and crossing.kind == "POLYGON", crossing' || {
    printf 'Airport/runway read-back validation failed.\n' >&2
    exit 1
  }

"${container_program}" run --rm --network "${network}" \
  --security-opt=no-new-privileges \
  --memory=8g \
  -e PYTHONPATH=/workspace/src:/opt/spark/python \
  -e OVERTURE_RELEASE_URI=/fixture/release \
  -e OVERTURE_RELEASE=2026-07-22.0 \
  -e MEDIUM_STATE_CODES='["AA"]' \
  -e SMALL_CITIES='[{"name":"Fixture City","state_code":"AA"}]' \
  -e MEDIUM_SAMPLE_LIMIT=20 \
  -e SMALL_SAMPLE_LIMIT=10 \
  -e MAP_FEATURE_LIMIT=5 \
  -e S3_ENDPOINT=http://minio:9000 \
  -e S3_REGION=us-east-1 \
  -e S3_ACCESS_KEY=minioadmin \
  -e S3_SECRET_KEY=minioadmin \
  -e S3_PATH_STYLE_ACCESS=true \
  -e S3_SSL_ENABLED=false \
  -e WRITE_DERIVED=true \
  -e DERIVED_OUTPUT_URI=s3a://overture/derived/local-input-single \
  -e ALLOW_LOCAL_DERIVED_FALLBACK=false \
  -e SEDONA_SPARK_LOCAL_CORES=2 \
  -e SEDONA_SPARK_DRIVER_MEMORY=4g \
  -e SEDONA_SPARK_PARTITIONS=4 \
  -e SEDONA_SPARK_LOCAL_DIR=/tmp/spark-local-input \
  -v "${project_dir}:/workspace:ro" \
  -v "${fixture_dir}:/fixture:ro" \
  -w /workspace \
  --entrypoint python3 \
  "${sedona_image}" -c \
  'from pyspark.sql import functions as F; from overture_lab.config import load_settings; from overture_lab.outputs import write_single_file_exports, write_single_geoparquet; from overture_lab.spark import create_sedona, read_type; s=load_settings(); assert s.storage_mode=="local"; spark=create_sedona(s,"local-input-s3-output-smoke"); segment=read_type(spark,s,"transportation","segment").where(F.col("id")=="inside-road"); df=segment.select(F.concat_ws("#",F.col("id"),F.lit(0)).alias("road_id"),F.col("id").alias("source_segment_id"),F.col("class").alias("road_class"),F.expr("ST_SetSRID(geometry, 4326)").alias("geometry")); result=write_single_file_exports(df,spark,s,dataset_name="local_input_roads",geoparquet_dataframe=segment); assert result.row_count==1 and result.geoparquet_uri.startswith("s3a://"), result; raw=read_type(spark,s,"places","place"); airport=raw.where(F.col("basic_category")=="airport").select(*[F.expr("ST_SetSRID(geometry, 4326)").alias("geometry") if name=="geometry" else F.col(name) for name in raw.columns]); geo_result=write_single_geoparquet(airport,spark,s,dataset_name="local_input_airports",object_name="airports.geoparquet"); assert geo_result.row_count==2 and geo_result.geoparquet_uri.startswith("s3a://"), geo_result'

"${container_program}" run --rm \
  --security-opt=no-new-privileges \
  --memory=8g \
  -e PYTHONPATH=/workspace/src:/opt/spark/python \
  -e OVERTURE_RELEASE_URI=/fixture/release \
  -e OVERTURE_RELEASE=2026-07-22.0 \
  -e MEDIUM_STATE_CODES='["AA"]' \
  -e SMALL_CITIES='[{"name":"Fixture City","state_code":"AA"}]' \
  -e MEDIUM_SAMPLE_LIMIT=20 \
  -e SMALL_SAMPLE_LIMIT=10 \
  -e MAP_FEATURE_LIMIT=5 \
  -e WRITE_DERIVED=true \
  -e DERIVED_OUTPUT_MODE=local \
  -e ALLOW_LOCAL_DERIVED_FALLBACK=false \
  -e SEDONA_SPARK_LOCAL_CORES=2 \
  -e SEDONA_SPARK_DRIVER_MEMORY=4g \
  -e SEDONA_SPARK_PARTITIONS=4 \
  -e SEDONA_SPARK_LOCAL_DIR=/scratch/spark-explicit-local \
  -e SEDONA_SCRATCH_DIR=/scratch \
  -e SEDONA_SCRATCH_BUDGET_GB=20 \
  -e SEDONA_SCRATCH_RESERVE_GB=2 \
  -e DERIVED_LOCAL_FALLBACK_DIR=/scratch/explicit-local \
  -v "${project_dir}:/workspace:ro" \
  -v "${fixture_dir}/scratch:/scratch" \
  -w /workspace \
  --entrypoint python3 \
  "${sedona_image}" -c \
  'from overture_lab.config import load_settings; from overture_lab.outputs import write_single_file_exports; from overture_lab.spark import create_sedona; s=load_settings(); assert s.derived_output_mode=="local"; spark=create_sedona(s,"explicit-local-single-file-smoke"); df=spark.sql("SELECT '\''road#0'\'' AS road_id, '\''road'\'' AS source_segment_id, '\''primary'\'' AS road_class, ST_SetSRID(ST_GeomFromWKT('\''LINESTRING (34.2 32.2, 34.8 32.8)'\''), 4326) AS geometry"); geoparquet_df=df.selectExpr("source_segment_id AS id", "CAST(struct(34.2D AS xmin, 34.8D AS xmax, 32.2D AS ymin, 32.8D AS ymax) AS STRUCT<xmin: DOUBLE, xmax: DOUBLE, ymin: DOUBLE, ymax: DOUBLE>) AS bbox", "geometry"); boundary=spark.sql("SELECT '\''AA'\'' AS state_codes, ST_SetSRID(ST_GeomFromWKT('\''POLYGON ((34 32, 35 32, 35 33, 34 33, 34 32))'\''), 4326) AS geometry"); result=write_single_file_exports(df,spark,s,dataset_name="explicit_local_roads",geoparquet_dataframe=geoparquet_df,boundary_dataframe=boundary); assert result.row_count==1 and result.run_prefix.startswith("/scratch/explicit-local/"), result; assert result.geoparquet_uri.startswith("/scratch/explicit-local/") and result.csv_uri.startswith("/scratch/explicit-local/") and result.boundary_geoparquet_uri.startswith("/scratch/explicit-local/"), result'

explicit_local_files=$(find "${fixture_dir}/scratch/explicit-local" -type f -printf '%f\n' | sort)
if [[ "${explicit_local_files}" != $'boundary.geoparquet\nroads.csv\nroads.geoparquet' ]]; then
  printf 'Explicit local output inventory is incorrect:\n%s\n' \
    "${explicit_local_files}" >&2
  exit 1
fi

"${container_program}" run --rm --network "${network}" \
  --security-opt=no-new-privileges \
  --memory=8g \
  -e PYTHONPATH=/workspace/src:/opt/spark/python \
  -e OVERTURE_RELEASE_URI=s3a://overture/release/2026-07-22.0 \
  -e MEDIUM_STATE_CODES='["AA"]' \
  -e SMALL_CITIES='[{"name":"Fixture City","state_code":"AA"}]' \
  -e MEDIUM_SAMPLE_LIMIT=20 \
  -e SMALL_SAMPLE_LIMIT=10 \
  -e MAP_FEATURE_LIMIT=5 \
  -e S3_ENDPOINT=http://minio:9000 \
  -e S3_REGION=us-east-1 \
  -e S3_ACCESS_KEY=minioadmin \
  -e S3_SECRET_KEY=minioadmin \
  -e S3_PATH_STYLE_ACCESS=true \
  -e S3_SSL_ENABLED=false \
  -e WRITE_DERIVED=true \
  -e DERIVED_OUTPUT_URI=s3a://overture/derived/sedona-lab \
  -e ALLOW_LOCAL_DERIVED_FALLBACK=true \
  -e SEDONA_SPARK_LOCAL_CORES=2 \
  -e SEDONA_SPARK_DRIVER_MEMORY=4g \
  -e SEDONA_SPARK_PARTITIONS=4 \
  -e SEDONA_SPARK_LOCAL_DIR=/tmp/spark \
  -v "${project_dir}:/workspace:ro" \
  -w /workspace \
  --entrypoint python3 \
  "${sedona_image}" -c \
  'from overture_lab.config import load_settings; from overture_lab.outputs import write_derived; from overture_lab.spark import create_sedona, read_type; s=load_settings(); spark=create_sedona(s,"s3-read-write-smoke"); df=read_type(spark,s,"places","place"); assert df.count()==3; result=write_derived(df,spark,s,dataset_name="fixture_places"); assert result.row_count==3 and not result.used_local_fallback, result'

"${container_program}" run --rm --network "${network}" \
  --security-opt=no-new-privileges \
  --memory=8g \
  -e PYTHONPATH=/workspace/src:/opt/spark/python \
  -e OVERTURE_RELEASE_URI=s3a://overture/release/2026-07-22.0 \
  -e MEDIUM_STATE_CODES='["AA"]' \
  -e SMALL_CITIES='[{"name":"Fixture City","state_code":"AA"}]' \
  -e MEDIUM_SAMPLE_LIMIT=20 \
  -e SMALL_SAMPLE_LIMIT=10 \
  -e MAP_FEATURE_LIMIT=5 \
  -e S3_ENDPOINT=http://minio:9000 \
  -e S3_REGION=us-east-1 \
  -e S3_ACCESS_KEY=readonly \
  -e S3_SECRET_KEY=readonlysecret \
  -e S3_PATH_STYLE_ACCESS=true \
  -e S3_SSL_ENABLED=false \
  -e WRITE_DERIVED=true \
  -e DERIVED_OUTPUT_URI=s3a://overture/derived/read-only-test \
  -e ALLOW_LOCAL_DERIVED_FALLBACK=true \
  -e DERIVED_LOCAL_FALLBACK_DIR=/scratch/derived \
  -e SEDONA_SPARK_LOCAL_CORES=2 \
  -e SEDONA_SPARK_DRIVER_MEMORY=4g \
  -e SEDONA_SPARK_PARTITIONS=4 \
  -e SEDONA_SPARK_LOCAL_DIR=/scratch/spark-readonly \
  -e SEDONA_SCRATCH_DIR=/scratch \
  -e SEDONA_SCRATCH_BUDGET_GB=20 \
  -e SEDONA_SCRATCH_RESERVE_GB=2 \
  -v "${project_dir}:/workspace:ro" \
  -v "${fixture_dir}/scratch:/scratch" \
  -w /workspace \
  --entrypoint python3 \
  "${sedona_image}" -c \
  'from overture_lab.config import load_settings; from overture_lab.outputs import write_derived; from overture_lab.spark import create_sedona, read_type; s=load_settings(); spark=create_sedona(s,"s3-readonly-fallback-smoke"); df=read_type(spark,s,"places","place"); result=write_derived(df,spark,s,dataset_name="fixture_places_readonly"); assert result.row_count==3 and result.used_local_fallback and result.destination.startswith("/scratch/derived/"), result'

"${container_program}" run --rm --network "${network}" \
  --security-opt=no-new-privileges \
  --memory=8g \
  -e PYTHONPATH=/workspace/src:/opt/spark/python \
  -e OVERTURE_RELEASE_URI=s3a://overture/release/2026-07-22.0 \
  -e MEDIUM_STATE_CODES='["AA"]' \
  -e SMALL_CITIES='[{"name":"Fixture City","state_code":"AA"}]' \
  -e MEDIUM_SAMPLE_LIMIT=20 \
  -e SMALL_SAMPLE_LIMIT=10 \
  -e MAP_FEATURE_LIMIT=5 \
  -e S3_ENDPOINT=http://minio:9000 \
  -e S3_REGION=us-east-1 \
  -e S3_ACCESS_KEY=readonly \
  -e S3_SECRET_KEY=readonlysecret \
  -e S3_PATH_STYLE_ACCESS=true \
  -e S3_SSL_ENABLED=false \
  -e WRITE_DERIVED=true \
  -e DERIVED_OUTPUT_URI=s3a://overture/derived/read-only-single \
  -e ALLOW_LOCAL_DERIVED_FALLBACK=true \
  -e SEDONA_SPARK_LOCAL_CORES=2 \
  -e SEDONA_SPARK_DRIVER_MEMORY=4g \
  -e SEDONA_SPARK_PARTITIONS=4 \
  -e SEDONA_SPARK_LOCAL_DIR=/scratch/spark-readonly-single \
  -e SEDONA_SCRATCH_DIR=/scratch \
  -e SEDONA_SCRATCH_BUDGET_GB=20 \
  -e SEDONA_SCRATCH_RESERVE_GB=2 \
  -e DERIVED_LOCAL_FALLBACK_DIR=/scratch/derived \
  -v "${project_dir}:/workspace:ro" \
  -v "${fixture_dir}/scratch:/scratch" \
  -w /workspace \
  --entrypoint python3 \
  "${sedona_image}" -c \
  'from overture_lab.config import load_settings; from overture_lab.outputs import write_single_file_exports, write_single_geoparquet; from overture_lab.spark import create_sedona; s=load_settings(); spark=create_sedona(s,"s3-readonly-single-file-smoke"); df=spark.sql("SELECT '\''road#0'\'' AS road_id, '\''road'\'' AS source_segment_id, '\''primary'\'' AS road_class, ST_SetSRID(ST_GeomFromWKT('\''LINESTRING (34.2 32.2, 34.8 32.8)'\''), 4326) AS geometry"); denied=False
try:
    geoparquet_df=df.selectExpr("source_segment_id AS id", "struct(34.2D AS xmin, 32.2D AS ymin, 34.8D AS xmax, 32.8D AS ymax) AS bbox", "geometry")
    write_single_file_exports(df,spark,s,dataset_name="clipped_roads",geoparquet_dataframe=geoparquet_df)
except RuntimeError as exc:
    denied="denied" in str(exc).lower() and "fallback" in str(exc).lower()
assert denied, "single-file writer did not stop after denied probe"
generic_denied=False
try:
    write_single_geoparquet(df.select("source_segment_id","geometry"),spark,s,dataset_name="read_only_geoparquet",object_name="runways.geoparquet")
except RuntimeError as exc:
    generic_denied="denied" in str(exc).lower() and "fallback" in str(exc).lower()
assert generic_denied, "single GeoParquet writer did not stop after denied probe"'

readonly_single_count=$(
  "${container_program}" run --rm --network "${network}" \
    -e MC_HOST_local=http://minioadmin:minioadmin@minio:9000 \
    "${mc_image}" ls --recursive local/overture/derived \
    | awk '/read-only-single|read_only_geoparquet/ {count++} END {print count + 0}'
)
if [[ "${readonly_single_count}" -ne 0 ]]; then
  printf 'Read-only single-file probe left %s unexpected objects.\n' \
    "${readonly_single_count}" >&2
  exit 1
fi
