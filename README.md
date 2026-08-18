# Sedona + Overture learning lab

An air-gap-friendly, VS Code notebook curriculum for learning how to inspect,
query, transform, analyse, and visualise a complete Overture Maps release with
Apache Sedona on rootless Podman.

The checked local reference release is `2026-07-22.0` (569 GiB). The notebooks
do not assume that all of it fits in memory: they read one Hive-partitioned
theme/type at a time, use Parquet-friendly bounding-box predicates first, and
only collect explicitly bounded results for tables or maps.

## Curriculum

| Notebook | What it teaches |
|---|---|
| `00_environment_and_release` | Runtime, release inventory, file and row scale |
| `01_shared_data_model` | IDs, geometry, bbox, names, sources, versions |
| `02_addresses` | Address fields, completeness, provenance, point maps |
| `03_base` | Bathymetry, infrastructure, land, cover, use, and water |
| `04_buildings` | Buildings, parts, physical attributes, parent relationships |
| `05_divisions` | Division points, areas, boundaries, hierarchy, perspectives |
| `06_places` | Categories, confidence, contact arrays, brands and addresses |
| `07_transportation` | Segments, connectors, linear referencing and topology |
| `08_cross_theme_etl` | Reusable spatial ETL and cross-theme derivation |
| `09_heavy_visualization` | Safe collection, aggregation, simplification and maps |

Each notebook is stored both as a reviewable `py:percent` source and a standard
`.ipynb`. The `.ipynb` files are generated deterministically by the included
sync script; Jupytext is not required in the air gap.

## Start in VS Code

1. Copy `.env.example` to `.env` and adjust the host data path and resources.
2. Start the lab:

   ```bash
   podman-compose --env-file .env up -d
   ```

3. In VS Code, open a notebook and choose **Select Kernel → Existing Jupyter
   Server**, then enter `http://127.0.0.1:8888/lab`.
4. Open the notebooks in numerical order.

The server binds to loopback and deliberately has no token for local use. Do
not expose port 8888 to another host or network.

Stop it with:

```bash
podman-compose --env-file .env down
```

## Configuration

Important variables are documented in `.env.example`. In particular:

- `OVERTURE_RELEASE_DIR` is the host directory mounted read-only.
- `OVERTURE_RELEASE_URI` is the path seen by Spark. It may instead be an
  `s3a://...` URI for an S3-compatible store.
- `SEDONA_SPARK_LOCAL_CORES`, `SEDONA_SPARK_DRIVER_MEMORY`, and
  `SEDONA_SPARK_PARTITIONS` control the local Spark session.
- `ISRAEL_SAMPLE_LIMIT`, `ASHDOD_SAMPLE_LIMIT`, and `MAP_FEATURE_LIMIT`
  separate medium, small, and browser-safe data sizes.
- `FOCUS_COUNTRY_CODE`, `FOCUS_LOCALITY_EN`, and `FOCUS_LOCALITY_COUNTRY_CODE`
  make the geographic focus explicit.

For S3-compatible storage, set the endpoint and credentials only in `.env`.
That file is ignored by Git. The Sedona 1.9.0 image already contains the
Hadoop S3A and AWS SDK jars, so no online dependency download is needed.

## Deliberate scale levels

- **Raw:** the complete immutable Overture release.
- **Medium:** a bounded Israel sample, capped by `ISRAEL_SAMPLE_LIMIT`.
- **Small:** an exact Ashdod-boundary sample, capped by
  `ASHDOD_SAMPLE_LIMIT`.
- **Map:** a further capped projection with only map-relevant columns.

`limit()` makes a bounded teaching sample; it is not a statistically
representative sample. Analysis notebooks say explicitly when a complete
regional count is required and therefore triggers a full Spark action.

## Maintenance and validation

Regenerate `.ipynb` files after editing paired `.py` sources:

```bash
podman run --rm \
  -v "$PWD:/workspace" -w /workspace \
  --entrypoint python3 docker.io/apache/sedona:1.9.0 \
  scripts/sync_notebooks.py --check
```

Run fast structural tests:

```bash
python3 -m unittest discover -s tests -v
```

Run a real Ashdod smoke execution in the already-present air-gap image:

```bash
scripts/smoke-notebooks.sh notebooks/00_environment_and_release.ipynb \
  notebooks/05_divisions.ipynb
```

Executed notebooks go under `.artifacts/executed/`, not into the source
notebooks.

## License

This project is licensed under the [MIT License](LICENSE). Overture data and
its upstream sources retain their own licenses and attribution requirements.
