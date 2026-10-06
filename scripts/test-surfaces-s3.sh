#!/usr/bin/env bash
# Isolated generated-data S3 test: no host ports, release mount, or live credentials.
set -euo pipefail
project_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
container_program=${CONTAINER_PROGRAM:-podman}
sedona_image=${SEDONA_IMAGE:-docker.io/apache/sedona:1.9.0@sha256:a1acf172621652c926214259045b2324f75341026dd726db0bef7e21b4205525}
minio_image=${MINIO_IMAGE:-docker.io/minio/minio:latest}
run_id="$(date -u +%Y%m%dT%H%M%SZ)-$$"
network="surface-s3-${run_id}"
server="surface-minio-${run_id}"
runner="surface-check-${run_id}"
report_dir="${project_dir}/.artifacts/surface-validation/s3-${run_id}"
mkdir -p "${report_dir}"
cleanup() {
  "${container_program}" rm -f "${runner}" "${server}" >/dev/null 2>&1 || true
  "${container_program}" network rm "${network}" >/dev/null 2>&1 || true
}
trap cleanup EXIT
"${container_program}" network create "${network}" >/dev/null
"${container_program}" run -d --name "${server}" --network "${network}" \
  --network-alias minio --security-opt=no-new-privileges \
  -e MINIO_ROOT_USER=surfacefixture -e MINIO_ROOT_PASSWORD=surfacefixturesecret \
  "${minio_image}" server /data >/dev/null
"${container_program}" run --rm --name "${runner}" --network "${network}" \
  --security-opt=no-new-privileges --memory=6g --cpus=2 \
  -v "${project_dir}:/workspace:ro" -v "${report_dir}:/reports" -w /workspace \
  -e PYTHONPATH=/workspace/src:/opt/spark/python \
  -e OVERTURE_RELEASE_URI=/tmp/generated-release -e OVERTURE_RELEASE=fixture \
  -e S3_ENDPOINT=http://minio:9000 -e S3_REGION=us-east-1 \
  -e S3_ACCESS_KEY=surfacefixture -e S3_SECRET_KEY=surfacefixturesecret \
  -e S3_PATH_STYLE_ACCESS=true -e S3_SSL_ENABLED=false \
  -e DERIVED_OUTPUT_URI=s3a://surface-test/derived \
  -e SEDONA_SPARK_LOCAL_CORES=2 -e SEDONA_SPARK_DRIVER_MEMORY=4g \
  -e SEDONA_SPARK_PARTITIONS=4 -e SEDONA_SPARK_LOCAL_DIR=/tmp/spark \
  -e SEDONA_SCRATCH_DIR=/tmp -e DERIVED_LOCAL_FALLBACK_DIR=/tmp/derived \
  --entrypoint python3 "${sedona_image}" -c '
import runpy, sys, time
from pyarrow import fs
client = fs.S3FileSystem(access_key="surfacefixture", secret_key="surfacefixturesecret",
    endpoint_override="minio:9000", scheme="http", region="us-east-1", allow_bucket_creation=True)
for attempt in range(30):
    try:
        client.create_dir("surface-test")
        break
    except OSError:
        if attempt == 29:
            raise
        time.sleep(1)
sys.argv = ["tests/check_surfaces_spark.py", "--output", "/reports", "--s3"]
runpy.run_path(sys.argv[0], run_name="__main__")
' 2>&1 | tee "${report_dir}/run.log"
printf 'S3 validation evidence: %s\n' "${report_dir}"
