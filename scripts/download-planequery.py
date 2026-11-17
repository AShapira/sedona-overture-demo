#!/usr/bin/env python3
"""OPEN NETWORK ONLY: prepare the complete, pinned PlaneQuery 2026 Q3 bundle."""

import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import date, datetime, timedelta, timezone
import hashlib
import json
from pathlib import Path
import time
from urllib.request import Request, urlopen


REVISION = "fe8fc37a34bf5bd4b0221013b3c8fa9bbdd4cae2"
AIRPORT_REVISION = "bc63f66786d68f639111c99711b4a3d0c0685a90"
DATASET = "ggman12/planequery-data-flights"
PREFIX = "source=algorithm-nn/adsb_source=adsblol/version=4/year=2026"
MAX_BYTES = 64 * 1024 * 1024
START, END = date(2026, 7, 1), date(2026, 10, 1)


def request(url):
    return urlopen(Request(url, headers={"User-Agent": "sedona-overture-demo/offline-data-preparation"}), timeout=90)


def inventory():
    records = {}
    for month in (7, 8, 9):
        url = f"https://huggingface.co/api/datasets/{DATASET}/tree/{REVISION}/{PREFIX}/month={month:02}?recursive=true&limit=1000"
        with request(url) as response:
            if 'rel="next"' in response.headers.get("Link", ""):
                raise ValueError("Unexpected paginated inventory; refusing an incomplete quarter")
            entries = json.load(response)
        for entry in entries:
            if entry["type"] != "file":
                continue
            upstream = entry["path"]
            filename = upstream.rsplit("/", 1)[1]
            if filename not in ("data.parquet", "airport_catalog.json", "flight_manifest.json"):
                continue
            day = f"2026-{month:02}-{upstream.split('/day=')[1][:2]}"
            name = f"flights/date={day}/{filename}"
            record = {"url": f"https://huggingface.co/datasets/{DATASET}/resolve/{REVISION}/{upstream}",
                      "upstream_path": upstream, "bytes": entry["size"], "date": day,
                      "role": "flights" if filename == "data.parquet" else "daily_provenance"}
            if entry.get("lfs"):
                record["sha256"] = entry["lfs"]["oid"]
            else:
                record["git_blob_sha1"] = entry["oid"]
            records[name] = record
    expected = {(START + timedelta(days=i)).isoformat() for i in range((END - START).days)}
    for role in ("flights", "daily_provenance"):
        actual = {r["date"] for r in records.values() if r["role"] == role}
        if actual != expected:
            raise ValueError(f"Incomplete {role} inventory: missing {sorted(expected - actual)}")
    base = f"https://raw.githubusercontent.com/davidmegginson/ourairports-data/{AIRPORT_REVISION}"
    records.update({
        "airports.csv": {"url": f"{base}/airports.csv", "role": "airports"},
        "ourairports-README.md": {"url": f"{base}/README.md", "role": "documentation"},
        "planequery-README.md": {"url": f"https://huggingface.co/datasets/{DATASET}/resolve/{REVISION}/README.md",
                                "role": "documentation"},
    })
    return records


def verify(content, record):
    digest = hashlib.sha256(content).hexdigest()
    if not content or len(content) > MAX_BYTES:
        raise ValueError("Empty or oversized source file")
    if "bytes" in record and len(content) != record["bytes"]:
        raise ValueError("Source length does not match pinned inventory")
    if "sha256" in record and digest != record["sha256"]:
        raise ValueError("SHA-256 does not match pinned source")
    if "git_blob_sha1" in record:
        blob = b"blob " + str(len(content)).encode() + b"\0" + content
        if hashlib.sha1(blob).hexdigest() != record["git_blob_sha1"]:
            raise ValueError("Git blob digest does not match pinned source")
    return {**record, "bytes": len(content), "sha256": digest}


def download_one(folder, name, record):
    path = folder / name
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists():
        # Only reuse files whose bytes match the immutable inventory (or the
        # completed record from this preparation's checkpoint for small files).
        return name, verify(path.read_bytes(), record)
    for attempt in range(3):
        try:
            with request(record["url"]) as response:
                content = response.read(MAX_BYTES + 1)
            checked = verify(content, record)
            temporary = path.with_name(path.name + ".part")
            temporary.write_bytes(content)
            temporary.replace(path)
            return name, checked
        except Exception:
            if attempt == 2:
                raise
            time.sleep(2 ** attempt)


def download_bundle(output, *, resume=False, workers=4):
    output = Path(output).expanduser().resolve()
    if output.exists():
        raise FileExistsError(f"Completed destination already exists: {output}")
    partial = output.with_name(output.name + ".partial")
    if partial.exists() and not resume:
        raise FileExistsError(f"Use --resume to verify and continue {partial}")
    partial.mkdir(parents=True, exist_ok=True)
    records = inventory()
    checkpoint = partial / "preparation.json"
    previous = json.loads(checkpoint.read_text()) if checkpoint.exists() else {}
    for name, record in previous.items():
        if name in records and record["url"] == records[name]["url"]:
            # Fresh upstream digests/lengths always win over a local checkpoint.
            records[name] = {**record, **records[name]}
    completed = {}
    print(f"Preparing 92 days: {sum(r.get('bytes', 0) for r in records.values()):,} inventoried bytes", flush=True)
    with ThreadPoolExecutor(max_workers=workers) as pool:
        futures = [pool.submit(download_one, partial, name, record) for name, record in records.items()]
        for future in as_completed(futures):
            name, record = future.result()
            completed[name] = record
            temporary = checkpoint.with_suffix(".tmp")
            temporary.write_text(json.dumps(completed, indent=2) + "\n")
            temporary.replace(checkpoint)
            if record["role"] == "flights":
                print(f"Verified {name}: {record['bytes']:,} bytes", flush=True)
    manifest = {
        "format_version": 1, "dataset": "PlaneQuery", "dataset_id": DATASET, "revision": REVISION,
        "source_partition": PREFIX.rsplit("/year=", 1)[0],
        "period_start": START.isoformat(), "period_end_exclusive": END.isoformat(), "days": 92,
        "license": "ODbL-1.0", "license_url": "https://opendatacommons.org/licenses/odbl/1-0/",
        "airport_revision": AIRPORT_REVISION, "airport_reference_date": "2026-10-06",
        "airport_license": "Public domain", "airport_source": "https://ourairports.com/data/",
        "downloaded_at_utc": datetime.now(timezone.utc).isoformat(),
        "limitations": "ADS-B-derived inferred flight endpoints, not scheduled routes or measured route geometry. "
                       "Receiver coverage and inference errors affect counts; all aircraft categories are included. "
                       "Airport geometry uses one pinned 2026-10-06 reference, not daily historical coordinates.",
        "files": dict(sorted(completed.items())),
    }
    (partial / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    (partial / "SHA256SUMS").write_text("".join(f"{r['sha256']}  {n}\n" for n, r in manifest["files"].items()))
    (partial / "README.txt").write_text(
        "PlaneQuery 2026 Q3 offline bundle\n"
        f"Source: https://huggingface.co/datasets/{DATASET}/tree/{REVISION}\n"
        "Prepared on an OPEN NETWORK with scripts/download-planequery.py.\n"
        "Coverage: 2026-07-01 through 2026-09-30, 92 complete daily partitions, algorithm-nn version 4.\n"
        "Attribution: PlaneQuery / ADSB.lol; ODbL 1.0. Retain attribution and applicable share-alike terms.\n"
        "License: https://opendatacommons.org/licenses/odbl/1-0/\n"
        f"Airport reference: OurAirports, public domain, 2026-10-06 commit {AIRPORT_REVISION}.\n"
        "Daily upstream provenance is retained; geometry uses the single pinned reference above.\n"
        "Copy this ENTIRE directory to local storage or internal S3; set FLIGHT_ROUTES_URI.\n"
        "Notebook 20 verifies all manifest lengths and SHA-256 without public network access.\n"
        "Counts are inferred observations, not a complete inventory of scheduled airline services.\n"
    )
    output.parent.mkdir(parents=True, exist_ok=True)
    if output.exists():
        raise FileExistsError(f"Destination appeared during preparation: {output}")
    partial.rename(output)
    print(f"Complete offline bundle: {output}", flush=True)
    return manifest


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True, help="New bundle directory (never overwritten)")
    parser.add_argument("--resume", action="store_true", help="Verify and resume this destination's .partial folder")
    parser.add_argument("--workers", type=int, choices=range(1, 9), default=4)
    args = parser.parse_args()
    download_bundle(args.output, resume=args.resume, workers=args.workers)
