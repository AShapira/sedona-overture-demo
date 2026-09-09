# Import regional Overture data with Sedona 1.9.0

Use notebook **13** for small selections and `scripts/import_overture_postgis.py`
for console operation. Both use the same implementation. The destination is an
**existing PostgreSQL database with PostGIS enabled**. The importer does not
provision a database or change existing schemas, server configuration, or roles.

```text
GeoParquet on read-only disk or internal S3
  → Sedona bbox + exact-intersection selection
  → Spark worker normalization → local normalized Parquet parts
  → five checksummed Parquet files + normalized-v3 manifest
  → PostgreSQL COPY → indexes/views → verification → COMMIT
```

New preparations write **normalized-v3**, extending the original five-table
[query-agent import contract](https://github.com/AShapira/overture-query-agent/blob/codex/benchmark-postgis-kinetica/docs/import-overture-postgis.md)
with per-feature UTM metadata. The loader and verifier still accept existing
normalized-v2 snapshots, preserving their EPSG:2039 geometry exactly. They do not
reinterpret or upgrade those files. Neither DuckDB nor the query-agent is a
runtime dependency. Fingerprints identify a particular prepared snapshot.

The separate query-agent's fixed-EPSG:2039 catalog is **not compatible with v3**
until its catalog and query generation support mixed UTM SRIDs or geography.
This importer does not modify that application.

## 1. Prepare the offline client image

The repository's pinned Sedona image contains Sedona **1.9.0**, Spark **4.0.1**,
Python **3.12**, PyArrow, Shapely, and PyProj. It needs the additional packages in
`requirements-postgis.txt`. The extension image installs them into a virtual
environment that retains the base image's packages and registers its notebook kernel.

On a connected Linux x86-64 preparation machine, from this repository:

```bash
mkdir -p .artifacts/postgis-wheels
python3 -m pip download --only-binary=:all: --python-version 312 \
  --implementation cp --abi cp312 --platform manylinux2014_x86_64 \
  --requirement requirements-postgis.txt --dest .artifacts/postgis-wheels
(cd .artifacts/postgis-wheels && sha256sum *.whl > SHA256SUMS)
podman pull docker.io/apache/sedona:1.9.0@sha256:a1acf172621652c926214259045b2324f75341026dd726db0bef7e21b4205525
podman build --pull=never --network=none -f Containerfile.postgis-import \
  -t localhost/sedona-overture-postgis:1.9.0 .
podman save --format oci-archive -o .artifacts/sedona-postgis.oci.tar \
  localhost/sedona-overture-postgis:1.9.0
sha256sum .artifacts/sedona-postgis.oci.tar > .artifacts/sedona-postgis.oci.tar.sha256
```

Transfer the checkout, image archive, and checksums through your approved offline
process. On the disconnected host, verify the archive from the repository root
and import it with `podman load -i .artifacts/sedona-postgis.oci.tar`.
For an offline rebuild, transfer the wheel directory too and run
`sha256sum --check SHA256SUMS` from inside it before building. Downloads and builds
are preparation steps; notebook and CLI runtime perform no package installation.

Use `compose.postgis-import.yml` after the normal Compose file. This preserves
the existing lab's Spark, local-data, S3, and scratch environment. To launch a
separate importer notebook service without replacing an existing lab:

```bash
JUPYTER_PORT=8890 SPARK_UI_PORT=4042 podman-compose -p sedona-postgis \
  --env-file .env -f compose.yml -f compose.postgis-import.yml up -d --no-build lab
```

Open notebook 13 in that Jupyter service. For existing notebook services, changing
the image requires recreating that service after saving notebook work. A plain
`exec` into the old image will not acquire the additional packages.

## 2. Source, region, and storage

Reuse the demo's `OVERTURE_RELEASE_URI` (`/data/overture` or `s3a://bucket/prefix`),
`OVERTURE_RELEASE`, and `S3_*` configuration. Set `--schema-version` to the matching
official release schema version. Preparation records this declaration and the
inspected physical schemas; it does not download or independently certify the
official schema/release mapping. Input requires `id`, `bbox`, and GeoParquet geometry.
All requested source types must exist. PMTiles is not an import source.

The bbox is **west south east north**. An exact intersection follows the source
bbox prefilter; whole geometries remain intact. Antimeridian-wrapping rectangles
are refused. Production imports require a bbox and have no sample limit.
Select types with `--types places/place buildings/building`, or omit it to import
all supplied types. When included, all `divisions/division` records are retained,
including out-of-region references marked `reference_only=true`.

The five tables are `features`, `names`, `addresses`, `categories`, and `links`.
Children join on **both `relation` and `id`**. Ordinals preserve duplicates/order;
name search uses Unicode NFKC and case folding. `raw_json` is text containing all
source non-geometry fields, including Hive theme/type fields. Geometry remains
EPSG:4326. Source geometry is not repaired, clipped, split, or duplicated.
Centroids are not guaranteed entrance points.

### UTM assignment and boundary handling

`geometry_m` stores the **whole feature** in WGS84 UTM. Each row adds:

| Field | Meaning |
|---|---|
| `geometry_m_srid` | EPSG:32601–32660 north or EPSG:32701–32760 south; null when no UTM assignment is possible |
| `utm_crosses_zone` | True when geometry extends outside its assigned longitude band or hemisphere; null without an assignment |
| `metric_status` | `ok`, `null_geometry`, `empty_geometry`, `invalid_geometry`, `outside_utm`, or `projection_failed` |

A point on the feature's surface selects the nominal six-degree longitude zone
and hemisphere. Longitude 180 uses zone 60; the equator uses north. This uses
standard EPSG longitude bands, not the special Norway/Svalbard MGRS grid zones.
The full geometry must fit the UTM latitude range **80°S to 84°N**. A projection
failure retains the selected SRID and crossing flag but leaves `geometry_m` null.
Other unavailable cases have no SRID or crossing flag. WGS84 geometry is retained.
PyProj uses explicit longitude/latitude order, caches a transformer per used SRID
inside each Spark worker, and disables PROJ network access.
[PROJ UTM definition and examples](https://proj.org/en/stable/operations/projections/utm.html).

A bbox spanning multiple zones or hemispheres is supported automatically: each
feature has its own projection. Crossing features are projected whole and flagged;
planar distortion can be substantial for large features. The manifest records
`metric_geometry_crs` (mode `per_feature_utm` and SRID column), `utm_policy`, closed-bbox
`bbox_utm_srids`, actual `metric_srids_present`, `metric_srid_counts`,
`metric_status_counts`, and `utm_crossing_features`. An east edge exactly on a
zone boundary includes the touched eastern zone. Actual SRIDs can extend beyond
the bbox list because whole features and division references are retained.

### Distance queries, including multiple zones

Version-3 PostGIS tables use a mixed-SRID `geometry_m` column with constraints
checking the SRID range, agreement with `geometry_m_srid`, and status consistency.
A generated `geometry_geog geography(Geometry,4326)` column is populated only for
valid, nonempty WGS84 geometries within longitude/latitude bounds. It can include
polar features with no UTM projection. Invalid and empty features have null
geography. A GiST index supports geography proximity queries.

Prefer geography for distance/radius queries across zones, across the equator,
or for large crossing features. Both functions below return/use metres; geography
uses spheroidal distance by default.
[PostGIS ST_DWithin](https://postgis.net/docs/ST_DWithin.html),
[PostGIS ST_Distance](https://postgis.net/docs/ST_Distance.html).

```sql
WITH q AS (
  SELECT ST_SetSRID(ST_MakePoint(6.0,50.0),4326)::geography AS point
)
SELECT relation, id, name, ST_Distance(geometry_geog,q.point) AS distance_m
FROM import_central_v1.features CROSS JOIN q
WHERE NOT reference_only AND ST_DWithin(geometry_geog,q.point,1000)
ORDER BY distance_m LIMIT 20;
```

For a specifically local planar query, choose one SRID and exclude crossing
features. Place CASE **inside the spatial function** so query-planner evaluation
order cannot compare mixed SRIDs. This intentionally searches only zone 31N:

```sql
WITH q AS (
  SELECT ST_Transform(ST_SetSRID(ST_MakePoint(5.9,50.0),4326),32631) AS point
)
SELECT relation, id, name
FROM import_central_v1.features CROSS JOIN q
WHERE NOT reference_only AND ST_DWithin(
  CASE WHEN geometry_m_srid=32631 AND NOT utm_crosses_zone
       THEN geometry_m END, q.point, 1000);
```

This guarded planar expression may not use the plain geometry GiST index.
Use geography when all nearby features must be included across zone boundaries.
Never compare `geometry_m` from different SRIDs directly or assume the bbox has
one universal metric CRS. Legacy v2 tables retain fixed EPSG:2039 and do not gain
the v3 metadata or generated geography column.

Snapshots must be under `SEDONA_SCRATCH_DIR`. The soft watchdog accounts for that
entire directory **and** `SEDONA_SPARK_LOCAL_DIR`, including retained snapshots,
Spark spill, normalization parts, and verification indexes. It checks the
configured `SEDONA_SCRATCH_BUDGET_GB`/`SEDONA_SCRATCH_RESERVE_GB` boundary every second
and between consolidation batches. This is not a hard filesystem quota: transient
overshoot is possible. Reserve enough database disk for tables, indexes, and WAL;
the loader cannot measure a remote server's free space.

Raw source objects are never staged locally. Spark intermediate `_parts` and the
five final normalized files coexist during preparation. Keep the final files and
manifest for retries. After successful verification, you may explicitly remove
that snapshot's `_parts` directory to reclaim space. The importer does not remove
host-mounted data automatically. Verification needs temporary disk space and write
access in the snapshot directory for a bounded-cache SQLite key index.

Source identity uses fresh S3 object ETags/sizes/mtimes or local SHA-256 checksums.
It is checked before and after preparation. Local identity verification reads
each selected source file twice; plan that I/O cost. Preserve the immutable source
throughout preparation. Missing final manifest means incomplete output; use a
fresh path after interruption. Do not hand-edit manifests to bless partial data.

## 3. Existing PostgreSQL server

An administrator must enable PostGIS and give the loading user database `CREATE`
permission and PostGIS function/type access. The loader creates and owns a new schema and its
tables, views, and indexes. It does not need superuser or `CREATEROLE`.

Create a separate password file securely with mode **0600**; avoid putting the
password in command arguments or notebook cells. Example connection file at
`.artifacts/postgis-connections.json` (all paths are **container paths**):

```json
{
  "schema": "import_central_v1",
  "statement_timeout_seconds": 3600,
  "postgis": {
    "host": "postgis.internal.example",
    "port": 5432,
    "dbname": "overture",
    "user": "overture_loader",
    "password_file": "/workspace/.artifacts/secrets/postgis-password",
    "sslmode": "verify-full",
    "sslrootcert": "/workspace/.artifacts/secrets/postgis-ca.pem"
  }
}
```

Host, port, database, user, and password file are required. TLS can also use libpq
environment variables when passed into the container explicitly. `sslmode` and
`sslrootcert` in the connection file override those defaults. Configure the S3 CA
separately according to the demo's TLS instructions. `127.0.0.1` inside the lab
refers to the lab container, not the workstation or a different database container.

Schema names require 1–63 lowercase letters/digits/underscores, starting with a
letter. Existing schemas are refused, even if empty. Statement timeout defaults
to **3600 seconds per statement**, including COPY/index/verification work; CLI
`--statement-timeout-seconds` overrides it. Lock timeout is five seconds.

Loading creates the schema, copies data, adds the documented GiST/B-tree indexes,
relation views and `dataset_identity`, and runs table-specific `ANALYZE`. It checks
the full content and rechecks the snapshot before committing the transaction.
Errors roll back the new schema. No partition worker writes to PostgreSQL, so
Spark task retries cannot duplicate database rows.

After success, an administrator can grant access to an **existing** reader:

```sql
GRANT USAGE ON SCHEMA import_central_v1 TO overture_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA import_central_v1 TO overture_reader;
```

Use a reader with no inherited write privileges. The importer never switches a
running application's catalog. Version-3 clients must understand per-row UTM
SRIDs or query `geometry_geog`; the original fixed-CRS catalog cannot be used
unchanged. Existing application deployments remain an explicit operation.

## 4. Console execution

From the repository on Linux/WSL, use the existing `.env` configuration:

```bash
podman-compose -p sedona-postgis --env-file .env \
  -f compose.yml -f compose.postgis-import.yml run --rm --no-deps lab \
  python3 scripts/import_overture_postgis.py run \
  --dataset /workspace/.artifacts/postgis-central-v1 \
  --bbox 34.65 31.75 35.05 32.35 --schema-version v1.18.0 \
  --connections /workspace/.artifacts/postgis-connections.json \
  --report /workspace/.artifacts/postgis-central-v1-load.json
```

`run` prepares, loads, and verifies. The notebook's 10,000-feature guard does not
apply to this command. To split the stages, use `prepare` with `--dataset`,
`--bbox`, `--schema-version`, and optional `--types`; then use `load` or `verify`
with just `--dataset` and `--connections`. Prepared snapshot loading/verification
does not start Spark and does not need source credentials.

From an already configured importer container, the invocation is ordinary Python:

```bash
python3 scripts/import_overture_postgis.py load \
  --dataset /workspace/.artifacts/postgis-central-v1 \
  --connections /workspace/.artifacts/postgis-connections.json
python3 scripts/import_overture_postgis.py verify \
  --dataset /workspace/.artifacts/postgis-central-v1 \
  --connections /workspace/.artifacts/postgis-connections.json \
  --report /workspace/.artifacts/postgis-central-v1-verification.json
```

For Windows Podman Desktop, use the same container commands with the project's
Windows S3 Compose configuration as the base and add this overlay. Mount password
and CA files at their declared Linux paths and enforce Linux password permissions
inside an appropriate private mount. Native Windows mounts/TLS require separate
deployment-machine acceptance; Linux execution is not proof of that boundary.

Progress is newline-delimited JSON. Reports contain timings, counts, fingerprint,
and complete-content checksums, not credentials. Report paths must be new. Exit
status is zero only on success, 1 on failure, and 130 on interruption. A lost
connection while COMMIT is in flight has an uncertain outcome: run `verify` first
to determine whether the schema committed. A failed report write after a successful
commit does not undo the database; the same verification step resolves that case.

Verification uses server-side cursors and disk-backed key indexes; it checks every
feature key, scalar/JSON field, child row including multiplicity, and native EWKB
including per-row SRIDs and the generated geography column for v3. It runs in a repeatable read-only transaction when invoked
separately. Geometry round-trip verification establishes transport correctness,
not geographic accuracy or source coverage.

## 5. Validation

Dependency-free checks: `python3 -m unittest discover -s tests -v` and
`python3 scripts/sync_notebooks.py --check`. Run
`tests/check_postgis_import.py --root <fresh scratch path> --connections <fixture file>`
in the importer image against a **disposable database only**: its failure tests
intentionally change fixture data. Optional `--source s3a://...` tests an uploaded
copy of the same fixture. Optional `--reference <query-agent dataset.py>` compares
the pure normalization contract with the reference implementation.

Run `tests/check_postgis_utm.py --root <fresh scratch path> --connections <fixture file>`
for zone/equator boundaries, polar/empty features, projection oracles, geography
measurements and database constraints. The notebook/CLI, failure, and permission
checks live in the other `tests/check_postgis_*.py` scripts. See
[recorded validation](postgis-import-validation.md) for the tested scope.

Target acceptance must verify container-to-server routing, authentication,
least-privilege loading, reader grants, remote TLS, source access, and resource
capacity. Regional fixture success is not a worldwide throughput benchmark.

References: [Sedona PostGIS guidance](https://sedona.apache.org/latest/tutorial/sql/#save-to-postgis),
[Psycopg COPY](https://www.psycopg.org/psycopg3/docs/basic/copy.html).
