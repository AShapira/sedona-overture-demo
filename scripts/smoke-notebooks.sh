#!/usr/bin/env bash
set -euo pipefail

if (($# == 0)); then
  set -- notebooks/00_environment_and_release.ipynb notebooks/05_divisions.ipynb
fi

project_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
release_dir=${OVERTURE_RELEASE_DIR:-${project_dir}/data/overture/release/${OVERTURE_RELEASE:-2026-07-22.0}}
image=${SEDONA_IMAGE:-docker.io/apache/sedona:1.9.0@sha256:a1acf172621652c926214259045b2324f75341026dd726db0bef7e21b4205525}

if [[ ! -d "${release_dir}" ]]; then
  printf 'Overture release directory does not exist: %s\n' "${release_dir}" >&2
  printf 'Set OVERTURE_RELEASE_DIR to the host release directory.\n' >&2
  exit 2
fi

mkdir -p "${project_dir}/.artifacts/executed" "${project_dir}/.cache/spark"

for notebook in "$@"; do
  name=$(basename "${notebook}")
  podman run --rm \
    --security-opt=no-new-privileges \
    --memory="${NOTEBOOK_CONTAINER_MEMORY:-12g}" \
    -e PYTHONPATH=/workspace/src:/opt/spark/python \
    -e PYSPARK_PYTHON=python3 \
    -e PYSPARK_DRIVER_PYTHON=python3 \
    -e OVERTURE_RELEASE_URI=/data/overture \
    -e OVERTURE_RELEASE="${OVERTURE_RELEASE:-2026-07-22.0}" \
    -e SEDONA_SPARK_LOCAL_CORES="${SEDONA_SPARK_LOCAL_CORES:-2}" \
    -e SEDONA_SPARK_DRIVER_MEMORY="${SEDONA_SPARK_DRIVER_MEMORY:-6g}" \
    -e SEDONA_SPARK_PARTITIONS="${SEDONA_SPARK_PARTITIONS:-4}" \
    -e SEDONA_SPARK_LOCAL_DIR=/var/tmp/spark \
    -e SEDONA_SPARK_LOG_LEVEL=ERROR \
    -e SEDONA_SCRATCH_DIR=/var/tmp \
    -e SEDONA_SCRATCH_BUDGET_GB="${SEDONA_SCRATCH_BUDGET_GB:-20}" \
    -e SEDONA_SCRATCH_RESERVE_GB="${SEDONA_SCRATCH_RESERVE_GB:-2}" \
    -e RELEASE_INVENTORY_CACHE=/var/tmp/inventory \
    -e REFRESH_RELEASE_INVENTORY="${REFRESH_RELEASE_INVENTORY:-false}" \
    -e INVENTORY_INCLUDE_ROW_COUNTS="${INVENTORY_INCLUDE_ROW_COUNTS:-false}" \
    -e MEDIUM_STATE_CODES="${MEDIUM_STATE_CODES:?Set MEDIUM_STATE_CODES JSON}" \
    -e SMALL_CITIES="${SMALL_CITIES:?Set SMALL_CITIES JSON}" \
    -e MEDIUM_SAMPLE_LIMIT="${MEDIUM_SAMPLE_LIMIT:?Set MEDIUM_SAMPLE_LIMIT}" \
    -e SMALL_SAMPLE_LIMIT="${SMALL_SAMPLE_LIMIT:?Set SMALL_SAMPLE_LIMIT}" \
    -e MAP_FEATURE_LIMIT="${MAP_FEATURE_LIMIT:-50}" \
    -e WRITE_DERIVED="${WRITE_DERIVED:-false}" \
    -e DERIVED_OUTPUT_MODE="${DERIVED_OUTPUT_MODE:-s3}" \
    -e DERIVED_OUTPUT_URI="${DERIVED_OUTPUT_URI:-}" \
    -e ALLOW_LOCAL_DERIVED_FALLBACK="${ALLOW_LOCAL_DERIVED_FALLBACK:-false}" \
    -e DERIVED_LOCAL_FALLBACK_DIR=/var/tmp/derived \
    -v "${project_dir}:/workspace" \
    -v "${release_dir}:/data/overture:ro" \
    -v "${project_dir}/.cache/spark:/var/tmp/spark" \
    -w /workspace \
    --entrypoint jupyter \
    "${image}" execute \
    "${notebook}" \
    --output "/workspace/.artifacts/executed/${name}" \
    --timeout 600
done
