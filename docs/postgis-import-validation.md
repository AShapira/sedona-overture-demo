# PostGIS importer validation — 2026-09-09

## Historical normalized-v2 baseline

The following results describe the original EPSG:2039 implementation. Version-3
UTM validation is recorded separately below; v2 catalog compatibility does not
apply to v3.

Implementation was tested in the pinned Sedona 1.9.0 image extended with the
offline wheels in `requirements-postgis.txt`. Runtime: Python 3.12.3, Spark 4.0.1,
PyArrow 24.0.0, Shapely 2.1.2, PyProj 3.7.2, and Psycopg 3.2.9.
PostgreSQL/PostGIS used the original guide's pinned image digest
`sha256:01a6a70e41e6c4467c8f55f6063555ed72db2d6662cd0d571040d42eadaeb6f6`.
All database and MinIO tests used disposable containers on an internal network,
without host port exposure or persistent database volumes.

| Check | Result |
|---|---|
| Repository unit suite | 64 tests: 63 passed on host; existing pydeck test skipped on host and passed in the image |
| Notebook synchronization, Python syntax, QGIS generated assets, existing shell syntax | Passed |
| Offline extension-image build, with network disabled | Passed |
| Local GeoParquet selection and full load | 9 features, 27 names, 17 addresses, 27 categories, 27 links; passed |
| MinIO/S3A preparation and subsequent database load | Same counts; passed |
| Delivered notebook and production `run`/`verify` CLI | Executed; identical complete database content for the five-feature teaching selection |
| Whole intersecting geometry and boundary point selection | Passed |
| Invalid geometry, null geometry, out-of-region division references | Passed |
| Child multiplicity, Unicode normalization and nested reference paths | Passed, including comparison to the original normalization functions |
| Original snapshot verifier and query-agent catalog generator | Accepted the Sedona-produced normalized-v2 snapshot |
| Loading existing guide data | Passed using ten complete records from a verified real regional snapshot, written with the original Writer |
| Notebook guard and scratch exhaustion | Rejected without a completed snapshot |
| Corrupted snapshot and changed source identity | Rejected |
| Duplicate source feature keys | Rejected after actual Spark processing |
| Existing schema | Refused |
| Injected failure after COPY/index creation | Entire schema rolled back; retry passed |
| Database content corruption | Detected by full-content verification |
| Non-superuser loader, without CREATEROLE | Passed |
| SELECT-only reader | Full verification passed; UPDATE refused |
| Verification transaction properties | Confirmed repeatable-read and read-only |
| Geometry transport | Full EWKB/SRID comparison passed |

Metric projection at `(34.78,31.98)` matched the original guide's DuckDB/PROJ
result exactly: `(179340.2206398131,654179.3315766763)`. The fixture PostGIS server's
default EPSG:2039 transform differed by 9.69285 m because its `spatial_ref_sys`
definition uses a different datum operation. Server definitions were not changed. New v3 preparations use WGS84 UTM instead.

The base Sedona image has no Git executable, so the repository's Git-dependent
structural test ran on the host. The image's renderer tests supplied the pydeck
coverage unavailable on that host. No missing-dependency skip was treated as a pass.

Executed notebooks, JSON reports and synthetic/derived fixtures remain in the
ignored `.artifacts/check/` directory. Console logs are retained under
`.artifacts/validation/`. Fixture credentials are disposable and are not part
of the tracked implementation.

Not established by these checks: the user's existing server routing/TLS,
native Windows mounts, native RHEL SELinux, large-region throughput, or worldwide
capacity. Those require target-environment acceptance. No existing database or
application deployment was modified.


## Normalized-v3 UTM acceptance

Retested with the same pinned runtime and fresh disposable PostGIS/MinIO
containers. New preparations write version 3; existing version-2 snapshots keep
their original EPSG:2039 contract.

| Check | Result |
|---|---|
| Repository unit suite | 67 tests: 66 passed on host; one existing pydeck test skipped, covered by two passing image renderer tests |
| Notebook synchronization and Python syntax | Passed |
| Local and direct S3A preparation | Each: 9 features, 27 names, 17 addresses, 27 categories, 27 links; full load and verification passed |
| Per-feature SRID inventory outside bbox | Bbox 32636; actual projected features 32631 and 32636, including out-of-region division references |
| Multi-zone/equator fixture | 11 whole features; bbox touches 32631, 32632, 32731, 32732; stored SRIDs 32631, 32632, 32732 |
| Whole crossing geometry | Three crossing features flagged; no split or duplicate features |
| Polar, partly polar, and empty geometry | Three `outside_utm`, one `empty_geometry`; WGS84 retained and metric geometry null |
| Concave polygon assignment | Point on surface inside polygon while centroid outside; assignment passed |
| Zone limits and hemispheres | Unit checks cover ±180 longitude, equator, zone edge, -80/84 latitude limits and unsupported latitude rejection |
| Projection values and inverse round-trip | Published PROJ examples matched to 0.01 m; inverse error below 1e-8 degrees; transformer reuse and network-disabled policy passed |
| Cross-zone and cross-equator geography | Distance agreed with independent WGS84 Geod calculation within 0.001 m; radius tests at ±0.01 m passed |
| Geography availability and index | Polar feature queryable, empty feature null; EXPLAIN used an index for ST_DWithin |
| Guarded planar expression | CASE inside ST_DWithin safely executed over the mixed-SRID table |
| SRID constraints | Unsupported SRID and metadata/EWKB SRID mismatches rejected by PostGIS |
| Semantic snapshot validation | False bbox zones, actual SRID inventory, crossing count and per-row SRID rejected even with recomputed hashes |
| Delivered notebook and console `run`/`verify` | Executed, including notebook geography query; identical full database content for five selected features |
| Legacy v2 snapshot | Ten records from the original verified regional snapshot loaded without reinterpretation |
| Projection agreement with PostGIS | Maximum tested UTM geometry difference: 0.0 m |
| Failure behavior | Notebook guard, scratch limit, checksum corruption, source change, duplicate keys, existing schema and database corruption rejected; injected load failure rolled back and retry passed |
| Non-superuser loader and SELECT-only reader | Both versions loaded; reader verification passed with repeatable-read/read-only transaction; UPDATE refused |

The fixture snapshots, executed notebook and JSON reports are retained under
`.artifacts/utm/`; console logs are in `.artifacts/utm/validation/`.
The tests used an internal container network with no exposed host ports and no
persistent database volumes. Disposable containers were removed after validation.
The existing deployment was not contacted. Remote server routing/TLS, Windows
mounts, native RHEL SELinux and production-scale capacity remain untested.

Reproduction uses the scripts listed in the import guide:
`check_postgis_import.py`, `check_postgis_utm.py`, `check_postgis_notebook_cli.py`,
`check_postgis_failures.py`, and `check_postgis_permissions.py`. Run these only
against disposable fixture databases; they intentionally exercise failures and
alter fixture content. The permission test additionally needs a retained valid
v2 snapshot for compatibility testing.
