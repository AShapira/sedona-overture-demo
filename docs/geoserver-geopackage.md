# Deploy Notebook 14 surfaces to GeoServer

This guide publishes the **vector** GeoPackages exported by Notebook 14 as
read-only stores, with landmass/ocean styling and automatic detail selection for
WMS/WMTS maps. It does not configure a running server automatically.

The source model is physical coastline landmass and ocean. Inland lakes and
rivers remain within landmass. Country extents only define the regional rectangle;
they do not define ownership or coastlines. Generalized layers are presentation
approximations, not analytical replacements for the detailed layers.

## 1. Export and check the files

In the notebook runtime, install the optional dependencies when necessary:

```bash
python3 -m pip install -r requirements-geopackage.txt
```

For an air-gapped runtime, use an online machine/container with the **same OS,
Python version and architecture** to prepare wheels:

```bash
python3 -m pip download -r requirements-geopackage.txt -d gpkg-wheels
# Transfer gpkg-wheels and the requirements file to the notebook runtime.
python3 -m pip install --no-index --find-links=gpkg-wheels -r requirements-geopackage.txt
```

Set `WRITE_DERIVED=true` and select the usual `DERIVED_OUTPUT_MODE=local` or `s3`.
S3 requires `DERIVED_OUTPUT_URI`. For local output the root is
`DERIVED_LOCAL_FALLBACK_DIR`; the compose default is `/workspace/.artifacts/derived`.
These examples describe settings, not a command that modifies an existing service.

Notebook controls:

```python
EXPORT_GEOPACKAGE = True
GPKG_SCOPES = ("world", "regional")  # start with ("regional",) for a smaller run
GPKG_LEVELS = {"fine": 0.001, "medium": 0.01, "coarse": 0.05}
GPKG_TILE_DEGREES = 2.0
GPKG_MAX_TILE_COORDINATES = 2_000_000
GPKG_PRECISION_GRID_DEGREES = None  # strict by default; optional 1e-10 for numerical mismatches
```

The output layout is:

```text
<derived-root>/world_surfaces_gpkg/release=<release>/run=<id>/world_surfaces.gpkg
<derived-root>/regional_surfaces_gpkg/release=<release>/run=<id>/regional_surfaces.gpkg
```

Publish only exports whose result says `status: written`. The result includes
SHA-256, bytes, exact layer fingerprints, vertex counts, dependency versions and
processing time. Files ending `.partial.gpkg` are diagnostic staging files, not
completed deployments. S3 outputs are closed and read-back verified before success;
download them to local storage before configuring GeoServer. A bucket URL is not
the database path for this store.

Each file contains the following eight tables with EPSG:4326 MultiPolygons,
integer `fid`, geometry column `geom`, and R-tree spatial indexes:

| Detail | Land table | Ocean table | Geometry |
|---|---|---|---|
| Full | `landmass_full` | `ocean_full` | Exact source pieces (regional pieces are clipped) |
| Fine | `landmass_fine` | `ocean_fine` | Tile dissolve, tolerance 0.001° |
| Medium | `landmass_medium` | `ocean_medium` | Tile dissolve, tolerance 0.01° |
| Coarse | `landmass_coarse` | `ocean_coarse` | Tile dissolve, tolerance 0.05° |

Detailed layers preserve source IDs/version/attribution (`sources_json`) and
flatten bbox fields to scalar columns. Generalized layers have `tile_id`,
`source_count` (clipped source pieces contributing to that class/tile), release,
extent and processing metadata. A generalized feature has no invented source ID.
Both kinds have `surface` equal to `landmass` or `ocean`.

Generalization uses shared coverage simplification with a fixed outer boundary,
after same-class dissolution. It preserves source gaps and checks for overlaps
and nonmatching shared edges. It does not repair invalid coverage automatically.
If a coordinate guard fires, reduce tile size (for example to 1°) and rerun in a
new output directory. Do not increase display limits: they do not affect exports.
Tolerance is angular and is not a maximum positional-error guarantee. Tiling can
add vertices; use the reported dissolved and generalized counts to measure savings.

Allow scratch space for local staging and, for S3, a second downloaded verification
copy. The writer is serial; no worldwide in-memory union is performed. Keep the
existing GeoParquet exports as the analytical/reload path.

### Explicit precision normalization for real coastline segmentation

The tested Overture regional extract has differently segmented shared boundaries
and numerical overlap slivers of approximately `1.8e-18` square degrees in one
tile. Strict mode correctly rejects that coverage. To opt in for presentation
layers, set `GPKG_PRECISION_GRID_DEGREES=1e-10` and rerun. This rounds coordinates,
nodes all shared boundaries together, and rebuilds coverage faces. Any overlap
remaining after this step is rejected; unowned gap faces remain uncovered.

The export report includes per-tile/per-class symmetric-difference area (square
degrees), component counts and hole counts before/after normalization. Every
generalized feature records its precision grid and class/tile area change. Review
these diagnostics: precision rounding can collapse features narrower than its
grid and shift extent edges slightly. The grid is not a simplification tolerance.
Detailed GeoPackage and GeoParquet coordinates remain exact. `None` stays the
default; normalization is never selected silently after a failure.

## 2. Place the files on the GeoServer machine

Use a versioned directory, such as:

```text
<GEOSERVER_DATA_DIR>/data/overture/release-2026-07-22-run-001/world_surfaces.gpkg
<GEOSERVER_DATA_DIR>/data/overture/release-2026-07-22-run-001/regional_surfaces.gpkg
```

Check the copied file's SHA-256 against the notebook report:

```bash
# Linux
sha256sum /srv/geoserver/data/data/overture/release-2026-07-22-run-001/*.gpkg
```

```powershell
# Windows PowerShell
Get-FileHash -Algorithm SHA256 'C:\GeoServerData\data\overture\release-2026-07-22-run-001\*.gpkg'
```

The account running GeoServer needs read access to the files and directory traversal
access. Copy the entire closed `.gpkg`; no WAL or SHM sidecar should be needed.
Keep these published versions immutable while they are open in GeoServer.

For Podman on Linux or Podman Desktop on Windows, add a read-only bind mount to
the **existing service configuration**, using paths appropriate to that host:

```yaml
# Linux example
volumes:
  - /srv/overture-gpkg:/opt/overture-gpkg:ro
```

```yaml
# Windows Podman Desktop example (host folder must be shared with the Podman machine)
volumes:
  - 'C:/GIS/overture-gpkg:/opt/overture-gpkg:ro'
```

Inside that container, the database URI is, for example,
`file:/opt/overture-gpkg/release-2026-07-22-run-001/world_surfaces.gpkg`.
GeoServer cannot use the host's `C:\...` or WSL path unless that location is
exposed inside its container. Add the mount through your normal deployment process;
recreating a running server may interrupt existing users.

## 3. Check GeoPackage vector-store support

In **About & Status → Server Status**, record the exact GeoServer version.
Open **Data → Stores → Add new Store** and look for **GeoPackage** under
**Vector Data Sources**. Some distributions include it. If absent, install the
GeoPackage datastore module matching the exact server version, following that
distribution's extension instructions, then restart during a maintenance window.
The GeoPackage *output* extension supplies WFS/WMS download formats and does not
by itself establish that the vector datasource is installed.

This guide uses standard GeoPackage vector stores and SLD 1.0; it does not require
the Pregeneralized Features module. See the official
[GeoPackage store reference](https://docs.geoserver.org/main/en/user/data/vector/geopkg/)
and [publishing tutorial](https://docs.geoserver.org/stable/en/user/gettingstarted/geopkg-quickstart/).

## 4. Create a workspace and two stores

1. Sign in to the GeoServer administration UI with your deployment's administrator account.
2. Under **Data → Workspaces**, add workspace `overture`, namespace URI
   `https://example.org/overture`. Use your organization's namespace in production.
3. Under **Data → Stores → Add new Store → GeoPackage**, choose workspace `overture`.
4. Name the first store `world_surfaces_store`. Set **database** to the deployed
   world file URI. For a file under the data directory, use
   `file:data/overture/release-2026-07-22-run-001/world_surfaces.gpkg`.
5. Enable **Read only**. If the version exposes **immutable**, enable it only for
   a file that will never be modified in place while the store is open.
6. Keep connection-pool settings at the installed version's defaults initially.
   SQLite file stores do not need application database credentials.
7. Save. Repeat for `regional_surfaces_store`, using `regional_surfaces.gpkg`.

On native Windows an absolute database URI can be
`file:/C:/GeoServerData/data/overture/release-2026-07-22-run-001/world_surfaces.gpkg`.
Prefer the file browser or a data-directory-relative URI to avoid path mistakes.

## 5. Import the four styles

In **Data → Styles → Add a new style**, upload each repository SLD below, choose
workspace `overture`, choose SLD format, **Validate**, then **Save**:

| GeoServer style name | File | Active denominator range |
|---|---|---|
| `surfaces_full` | [surfaces_full.sld](../geoserver/styles/surfaces_full.sld) | less than 500,000 |
| `surfaces_fine` | [surfaces_fine.sld](../geoserver/styles/surfaces_fine.sld) | 500,000 to below 5,000,000 |
| `surfaces_medium` | [surfaces_medium.sld](../geoserver/styles/surfaces_medium.sld) | 5,000,000 to below 25,000,000 |
| `surfaces_coarse` | [surfaces_coarse.sld](../geoserver/styles/surfaces_coarse.sld) | 25,000,000 and above |

Each style has two rules filtered on `surface`: ocean blue `#78bce0`, landmass tan
`#cfbd8a`, both opaque. No stroke is drawn, so artificial source/tile boundaries
are not outlined. The styles work for either class and either scope. Example rule:

```xml
<Rule>
  <Name>landmass_medium</Name>
  <ogc:Filter><ogc:PropertyIsEqualTo>
    <ogc:PropertyName>surface</ogc:PropertyName>
    <ogc:Literal>landmass</ogc:Literal>
  </ogc:PropertyIsEqualTo></ogc:Filter>
  <MinScaleDenominator>5000000</MinScaleDenominator>
  <MaxScaleDenominator>25000000</MaxScaleDenominator>
  <PolygonSymbolizer><Fill>
    <CssParameter name="fill">#cfbd8a</CssParameter>
  </Fill></PolygonSymbolizer>
</Rule>
```

Import the complete SLD files, which include the required namespace declarations.
Minimum scales are inclusive; maximum scales are exclusive. For example, exactly
1:5,000,000 activates medium, not fine. These are initial cartographic settings,
not a measured performance SLA. Adjust both neighboring boundaries together to
avoid gaps or overlapping levels. WMS DPI settings can affect calculated scale.
See [SLD scale selection](https://docs.geoserver.org/3.0.x/en/user/styling/sld/reference/rules/).

## 6. Publish layers with unique names

For each store, use **Publish** beside every table:

1. Keep the native table name. Set the **published name** to `<scope>_<table>`:
   for example, `world_landmass_fine` and `regional_landmass_fine`. Prefixes prevent
   collisions between the two stores in one workspace.
2. Set declared SRS to `EPSG:4326`; confirm the native SRS is also EPSG:4326.
   Do not relabel the native coordinates as EPSG:3857.
3. Under Bounding Boxes, click **Compute from data** for native bounds and
   **Compute from native bounds** for geographic bounds.
4. On **Publishing**, assign the corresponding `overture:surfaces_<detail>` style
   as the default. Save.

Publish all eight tables per scope. An empty class still has an empty table;
GeoServer may need manually specified bounds matching the export extent when no
features exist. Do not fabricate features to populate its bounds.

A layer preview outside its style's scale range is intentionally transparent.
Use the groups below for continuous display at every scale. If you export only a
subset of detail levels, also adjust group membership and style ranges explicitly.

## 7. Create one WMS group per scope

Under **Data → Layer Groups → Add new layer group**, select workspace `overture`,
name `world_surfaces`, and mode **single**. Add these layer/style pairs in order:

| Layers (in drawing order) | Style for both |
|---|---|
| `world_ocean_coarse`, `world_landmass_coarse` | `overture:surfaces_coarse` |
| `world_ocean_medium`, `world_landmass_medium` | `overture:surfaces_medium` |
| `world_ocean_fine`, `world_landmass_fine` | `overture:surfaces_fine` |
| `world_ocean_full`, `world_landmass_full` | `overture:surfaces_full` |

Set group bounds CRS to EPSG:4326 and generate bounds from the layers. Save.
Repeat with group `regional_surfaces` and all `regional_` layer names. Use the
regional export rectangle as group bounds if needed.

At any scale only one ocean/land pair has active rules; all members still appear
in the group's configuration. A single-mode group is one WMS layer name with a
fixed member order, as described in the
[layer-group reference](https://docs.geoserver.org/main/en/user/data/webadmin/layergroups/).
It is not a security boundary: apply your usual workspace/layer access rules.

## 8. Verify WMS before enabling a cache

Replace the host/port below with your GeoServer address. For secured services use
your usual authenticated client; do not paste credentials into shared URLs.

```text
http://localhost:8080/geoserver/overture/wms?service=WMS&version=1.1.1&request=GetCapabilities
http://localhost:8080/geoserver/overture/wms?service=WMS&version=1.1.1&request=GetMap&layers=overture:world_surfaces&styles=&srs=EPSG:4326&bbox=-180,-90,180,90&width=1024&height=512&format=image/png&transparent=true
http://localhost:8080/geoserver/overture/wms?service=WMS&version=1.1.1&request=GetMap&layers=overture:world_surfaces&styles=&srs=EPSG:3857&bbox=-20037508.34,-20037508.34,20037508.34,20037508.34&width=1024&height=1024&format=image/png&transparent=true
```

Use a bbox from the notebook's `regional_rectangle` for the regional group.
WMS 1.1.1 EPSG:4326 uses longitude/latitude bbox order. WMS 1.3.0 EPSG:4326 uses
latitude/longitude order; use CRS:84 for longitude/latitude order with 1.3.0.
EPSG:3857 cannot show the poles and is limited to approximately ±85.0511° latitude.
The GeoPackage itself retains the full EPSG:4326 extent.

Check a jagged coast, small islands, a 2° tile boundary, and the regional edge.
Zoom through all three style boundaries. Inspect logs for missing files, SQL errors
and geometry exceptions. Capture response times for the **same** bbox, size, CRS
and style, including first and repeated requests. Vertex reduction is not proof
of a particular WMS latency; report measured timings separately.

## 9. Enable GeoWebCache for the groups

In **Tile Caching → Tile Layers**, enable/configure the two layer groups. If a
group is absent, check the group's tile-cache settings and reload the tile-layer
list. Select PNG, the default group style, and the EPSG:3857 gridset used by the
client. Bound regional caching to the regional extent in the gridset CRS.

Start with on-demand tiles or a small bounded seed at low zooms (for example 0–5).
Estimate tile count, disk, and elapsed time before expanding the seed. Do not seed
the entire world at detailed zooms as a default. Source spatial indexes speed
feature selection; the tile cache avoids repeated rendering of the same map tile.

```text
http://localhost:8080/geoserver/gwc/service/wmts?SERVICE=WMTS&REQUEST=GetCapabilities
http://localhost:8080/geoserver/gwc/service/wmts?SERVICE=WMTS&VERSION=1.0.0&REQUEST=GetTile&LAYER=overture:world_surfaces&STYLE=&TILEMATRIXSET=EPSG:3857&TILEMATRIX=EPSG:3857:0&TILEROW=0&TILECOL=0&FORMAT=image/png
```

Use the layer, style, matrix-set and matrix identifiers advertised in your actual
WMTS capabilities; they can differ from the example. Ordinary WMS requests are
useful for uncached diagnostics. Compare them separately from cached WMTS results.

## 10. Update, roll back, and troubleshoot

For an update, export/download into a **new** versioned directory, verify its hash
and layer schema, then switch the store's database URI through GeoServer's UI during
your normal deployment window. Retain the previous file and record both paths.
Never overwrite an open immutable GeoPackage in place. Recompute bounds if the
extent changed, verify uncached WMS, then truncate affected group caches before
allowing stale cached tiles to be served. Re-seed only the required extent/zooms.
For rollback, restore the previous store URI and styles, verify uncached WMS, and
truncate caches again.

| Symptom | Check |
|---|---|
| GeoPackage missing from store types | Correct vector datastore module for the exact GeoServer version; server restart |
| Cannot open file | URI syntax, service-account permissions, container-visible mount, complete copy |
| Database locked | Another writer, in-place replacement, read-only setting, SQLite sidecars; deploy a closed new version |
| Blank individual layer | Rule scale range, `surface` values, assigned style, bounds and CRS |
| Blank group | All members/styles present; correct workspace prefix; request intersects exported extent |
| Visible rectangular outlines | Remove polygon strokes from all member styles |
| Hairline artifacts between fills | Compare uncached output at the same size/CRS; inspect source coverage and rendering before changing geometry |
| Old data after replacement | Correct store URI plus affected GeoWebCache truncation |
| Generalization stops | Tile ID in error, coordinate budget, valid/edge-matched coverage; reduce tile size for budget errors |
| Slow detail views | Confirm selected scale, R-tree presence, bounded requests and cache behavior; measure representative requests |

## Validation boundary

Repeat the focused checks from the repository root:

```bash
python3 -m unittest discover -s tests -p test_geopackage.py -v
# Run this inside the pinned Sedona runtime with the optional dependencies:
python3 tests/check_geopackage_spark.py --output /tmp/gpkg-check
# Disposable MinIO + Sedona containers; requires a container engine:
bash scripts/test-geopackage-s3.sh
python3 scripts/sync_notebooks.py --check
```

`tests/check_geopackage_geoserver.py` publishes a generated fixture into a
**disposable test server** using `GPKG_TEST_USER` and `GPKG_TEST_PASSWORD` environment
variables. It registers all layers/styles and compares group images against the
expected active pair at each detail level. It must not target a production server.

The exporter validates every stored geometry/attribute fingerprint, layer CRS/type,
SQLite integrity, and index row count. Repository tests cover geometry fixtures,
tile boundaries and scale thresholds. These checks do not by themselves certify
your GeoServer installation, file permissions, real-world rendering, or WMS speed.
Retain notebook export reports and the results of the deployment checks above.

### Recorded implementation checks

Validated on 2026-10-14 with the pinned Sedona 1.9.0 runtime, Overture release
`2026-07-22.0`, 2° tiles and explicit precision grid `1e-10`. Counts below combine
landmass and ocean coordinate positions, including ring-closing coordinates:

| Sample | Full | Fine | Medium | Coarse |
|---|---:|---:|---:|---:|
| Existing regional export (223 detailed features) | 83,797 | 8,035 | 2,099 | 1,665 |
| Mediterranean (34,31,36,33) | 10,956 | 1,162 | 288 | 246 |
| Norway (4,60,6,62) | 1,828,305 | 155,844 | 104,946 | 102,528 |
| Dateline vicinity (178,-18,180,-16) | 133,804 | 11,685 | 2,877 | 2,251 |

For these four samples, normalization reported no component or hole losses.
Summed class/tile symmetric-difference areas were respectively `7.92e-10`,
`2.70e-13`, `1.57e-11` and `1.75e-12` square degrees. These are rounding-change
diagnostics before simplification, not positional-error bounds for generalized
geometry. Detailed-layer fingerprints stayed exact.

An isolated GeoServer 3.0.1 opened all eight generated fixture layers and accepted
all four SLDs. At scales 1:100,000, 1:1,000,000, 1:10,000,000 and 1:30,000,000,
the WMS group image matched the expected active pair. A disposable MinIO/Sedona
test passed S3 upload/download hash verification; injected permission denial and
upload interruption also passed. The full worldwide production export and
production GeoServer/cache performance were not run. Local logs, JSON reports,
GeoPackages and fixture WMS images are retained under the ignored
`.artifacts/geopackage-validation/` directory.
