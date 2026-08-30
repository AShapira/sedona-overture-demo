# Sedona + Overture learning lab

An air-gap-friendly, VS Code notebook curriculum for learning how to inspect,
query, transform, analyse, and visualise a complete Overture Maps release with
Apache Sedona. The same twelve lessons support a read-only filesystem release
or an S3A-only release served to Docker Desktop on a Windows host.

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
| `10_standalone_sedonaspark_clipped_roads` | Regional road clipping, named S3 exports, large maps |
| `11_world_airports_and_medium_runways` | Worldwide canonical airport infrastructure, regional runways, named GeoParquet exports and maps |

Each notebook is stored both as a reviewable `py:percent` source and a standard
`.ipynb`. The `.ipynb` files are generated deterministically by the included
sync script; Jupytext is not required in the air gap.

## Start with a local release

1. Copy `.env.example` to `.env`, configure the required geographic scales,
   and adjust the host data path and resources.
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

## Start on Windows Docker Desktop with S3-only data

This mode mounts the repository and one disposable scratch directory. It does
not mount or download the Overture release. In PowerShell:

```powershell
Copy-Item .env.windows-s3-airgap.example .env.windows-s3-airgap
New-Item -ItemType Directory -Force C:\sedona-overture-scratch
```

Edit `.env.windows-s3-airgap` with the real `s3a://` release root, endpoint,
region, credentials, and required geographic scales, then start the pinned
image already imported into the air gap:

```powershell
docker compose --env-file .env.windows-s3-airgap `
  -f compose.windows-s3-airgap.yml up -d
```

Open `http://127.0.0.1:8888/lab`. Notebook 00 performs the storage and scratch
preflight, inventories `theme=*/type=*/*.parquet` through Hadoop S3A, and caches
only a small aggregate JSON under the scratch mount. The default inventory
does not calculate remote row counts; set `INVENTORY_INCLUDE_ROW_COUNTS=true`
only when opening every feature-type dataset is intentional.

After interactive setup is proven, execute the two target smoke lessons and a
final scratch check with:

```powershell
./scripts/smoke-notebooks-s3.ps1
```

For a private HTTPS endpoint whose CA is not already trusted by Java, supply a
PKCS12 truststore and add the TLS override:

```powershell
docker compose --env-file .env.windows-s3-airgap `
  -f compose.windows-s3-airgap.yml `
  -f compose.windows-s3-airgap-tls.yml up -d
```

The server is tokenless for local workstation use and is bound only to
loopback. Do not expose port 8888 to another host or network.

## Configuration

Important variables are documented in `.env.example`. In particular:

- `OVERTURE_RELEASE_DIR` is the host directory mounted read-only.
- `OVERTURE_RELEASE_URI` is the path seen by Spark. It may instead be an
  `s3a://...` URI for an S3-compatible store.
- `SEDONA_SPARK_LOCAL_CORES`, `SEDONA_SPARK_DRIVER_MEMORY`, and
  `SEDONA_SPARK_PARTITIONS` control the local Spark session.
- `MEDIUM_STATE_CODES` is a required JSON string array. Its values match the
  Overture `country` field; for example, `["IL","XW","XG"]`.
- `SMALL_CITIES` is a required JSON array whose objects contain `name` and
  `state_code`, for example
  `[{"name":"City A","state_code":"AA"}]`. Names match English common names
  exactly, and each code must also appear in `MEDIUM_STATE_CODES`.
- `MEDIUM_SAMPLE_LIMIT`, `SMALL_SAMPLE_LIMIT`, and `MAP_FEATURE_LIMIT`
  separate medium, small, and browser-safe data sizes.
- `WMS_URL` and JSON `WMS_LAYERS` optionally add an internal WMS background to
  all interactive maps. `WMS_SRS` defaults to `EPSG:3857`.
- `SEDONA_SCRATCH_BUDGET_GB` and `SEDONA_SCRATCH_RESERVE_GB` guard the
  namespaced scratch tree before work begins. Docker bind mounts do not expose
  a portable hard per-directory quota, so the lab never claims this is a
  filesystem-enforced limit and never deletes host scratch automatically.
- `WRITE_DERIVED` remains false by default. When enabled,
  `DERIVED_OUTPUT_MODE=s3` is the default and uses `DERIVED_OUTPUT_URI`, an S3A
  prefix separate from the immutable release. Set `DERIVED_OUTPUT_MODE=local`
  to write explicitly beneath the Compose-mapped
  `DERIVED_LOCAL_FALLBACK_DIR` instead.

For S3-compatible storage, set the endpoint and credentials only in the
ignored `.env.windows-s3-airgap` file. The Sedona 1.9.0 image already contains
the Hadoop S3A and AWS SDK jars, so no online dependency download is needed.
Diagnostics redact both credential values.

## Optional internal WMS background

Interactive maps use an embedded renderer and no public basemap. To place an
air-gap WMS below the bounded Overture vector layers, configure both values:

```dotenv
WMS_URL=https://maps.airgap.example/geoserver/wms
WMS_LAYERS=["workspace:orthophoto"]
WMS_SRS=EPSG:3857
```

Leave both `WMS_URL` and `WMS_LAYERS` unset for a blank background. Layer names
must be the named layers advertised by WMS `GetCapabilities`; multiple names
may be supplied in the JSON array. `WMS_SRS` accepts `EPSG:3857` or
`EPSG:4326`.

The map runs in the workstation browser, so `WMS_URL` must be resolvable and
reachable from that browser rather than only from the container network. The
WMS must allow cross-origin requests from the Jupyter origin, normally
`http://127.0.0.1:8888`. An HTTPS Jupyter page cannot load an HTTP WMS, and a
private WMS CA must be trusted by the workstation browser; the Spark JVM
truststore does not establish browser trust. This integration is deliberately
unauthenticated: do not put credentials in `WMS_URL` or notebook output. Use an
approved same-origin gateway if a future deployment requires authentication.

In a strict air gap, browser traffic should be limited to the Jupyter origin
and the configured WMS origin. The renderer itself does not load CDN scripts,
stylesheets, fonts, worker scripts, or public tiles.

Notebook 08 is read-only unless explicitly enabled. It first creates and
deletes a unique permission marker below the derived prefix. A clean create
denial only falls back to the mapped local directory when the legacy
`ALLOW_LOCAL_DERIVED_FALLBACK=true` switch is explicitly enabled; cleanup
failures or a data write that has already started stop immediately and report
the partial S3 prefix.
Every successful run uses a new directory and is verified by `_SUCCESS` and a
read-back row count, so no previous derivative is overwritten.

Notebook 10 is likewise read-only unless `WRITE_DERIVED=true`. Its default
`DERIVED_OUTPUT_MODE=s3` requires `DERIVED_OUTPUT_URI`; explicit `local` mode
writes beneath the mapped `DERIVED_LOCAL_FALLBACK_DIR`. Neither selected mode
falls back to the other after a write or verification failure. Each successful
unique run prefix contains
exactly `roads.geoparquet`, `roads.csv`, and `boundary.geoparquet`. Spark writes
each format through a temporary one-part directory, promotes the part to the
stable object name, removes Spark metadata, and validates all three objects by
reading them back. Roads GeoParquet has exactly the original physical
transportation segment column structure, without the lab-only `theme` and
`feature_type` labels; each row contains a native clipped LineString and its
recalculated source-style `bbox`. `boundary.geoparquet` contains the exact
one-row configured land-country union used for clipping, plus its configured
state codes. Every clipped road row is also written to CSV. Its columns are
controlled by Notebook 10's `CSV_EXPORT_COLUMNS`, which defaults to `road_id`,
`source_segment_id`, `road_class`, and quoted `geometry_wkt`. This serial
finalisation is slower than normal parallel Spark output and should be used
only when downstream consumers require one object per format.

Notebook 11 selects worldwide airport-scale Infrastructure features by an
explicit allowlist of complete-airport classes, excluding related components
such as terminals, runways, taxiways, aprons, gates, heliports, and airstrips.
It retains the complete Infrastructure row and separately selects complete
runway geometries (`subtype=airport`, `class=runway`) that intersect the
configured medium-state land areas, using bbox pruning before the exact spatial
predicate. Each enabled export has its own unique run prefix containing exactly
one named GeoParquet object: `airports.geoparquet` or `runways.geoparquet`.
Both use GeoParquet 1.1 bbox covering metadata and the same mandatory-S3,
no-local-fallback safety policy as notebook 10. Runway maps are offline and
browser collection is capped by `MAP_FEATURE_LIMIT`.

## Deliberate scale levels

- **Raw:** the complete immutable Overture release.
- **Medium:** the combined configured state-code areas, capped globally by
  `MEDIUM_SAMPLE_LIMIT`.
- **Small:** the exact configured city boundaries, capped globally by
  `SMALL_SAMPLE_LIMIT`.
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

Check multi-boundary bbox pruning and exact-hit deduplication in the pinned
Sedona runtime:

```bash
podman run --rm --security-opt=no-new-privileges --memory=8g \
  -e PYTHONPATH=/workspace/src:/opt/spark/python \
  -v "$PWD:/workspace:ro" -w /workspace --entrypoint python3 \
  docker.io/apache/sedona:1.9.0@sha256:a1acf172621652c926214259045b2324f75341026dd726db0bef7e21b4205525 \
  tests/check_regions_spark.py
```

Render only the Windows Compose image reference without printing the
credential-bearing environment:

```powershell
docker compose --env-file .env.windows-s3-airgap `
  -f compose.windows-s3-airgap.yml config --images
```

Run a real configured-scale smoke execution in the already-present air-gap
image after exporting the four required scale variables:

```bash
scripts/smoke-notebooks.sh notebooks/00_environment_and_release.ipynb \
  notebooks/05_divisions.ipynb
```

When the pinned Sedona and MinIO images are already present, validate the S3A
inventory, one GeoParquet read, permission probe, S3 write, and read-back check
without external network access:

```bash
scripts/test-local-s3.sh
```

Executed notebooks go under `.artifacts/executed/`, not into the source
notebooks.

## License

This project is licensed under the [MIT License](LICENSE). Overture data and
its upstream sources retain their own licenses and attribution requirements.
