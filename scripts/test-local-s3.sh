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
  'from overture_lab.config import load_settings; from overture_lab.outputs import write_derived; from overture_lab.spark import create_sedona, read_type; s=load_settings(); spark=create_sedona(s,"s3-read-write-smoke"); df=read_type(spark,s,"places","place"); assert df.count()==1; result=write_derived(df,spark,s,dataset_name="fixture_places"); assert result.row_count==1 and not result.used_local_fallback, result'

"${container_program}" run --rm --network "${network}" \
  --security-opt=no-new-privileges \
  --memory=8g \
  -e PYTHONPATH=/workspace/src:/opt/spark/python \
  -e OVERTURE_RELEASE_URI=s3a://overture/release/2026-07-22.0 \
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
  'from overture_lab.config import load_settings; from overture_lab.outputs import write_derived; from overture_lab.spark import create_sedona, read_type; s=load_settings(); spark=create_sedona(s,"s3-readonly-fallback-smoke"); df=read_type(spark,s,"places","place"); result=write_derived(df,spark,s,dataset_name="fixture_places_readonly"); assert result.row_count==1 and result.used_local_fallback and result.destination.startswith("/scratch/derived/"), result'
