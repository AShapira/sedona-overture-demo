#!/usr/bin/env python3
"""OPEN NETWORK ONLY: stage a pinned OpenFlights bundle for offline notebook 20."""

import argparse
import csv
from datetime import datetime, timezone
import hashlib
import io
import json
from pathlib import Path
import re
import tempfile
from urllib.request import Request, urlopen


DEFAULT_REVISION = "cd163fa17710f3135540651626ad719dd5322a05"
FILES = {"airports.dat": 14, "airlines.dat": 8, "routes.dat": 9}
MAX_FILE_BYTES = 16 * 1024 * 1024


def download_bundle(destination, revision=DEFAULT_REVISION):
    if not re.fullmatch(r"[0-9a-f]{40}", revision):
        raise ValueError("--revision must be a full 40-character Git commit SHA")
    destination = Path(destination).expanduser().resolve()
    if destination.exists():
        raise FileExistsError(f"Bundle destination already exists: {destination}; use a new folder")
    destination.parent.mkdir(parents=True, exist_ok=True)
    manifest = {
        "format_version": 1, "dataset": "OpenFlights", "revision": revision,
        "repository": "https://github.com/jpatokal/openflights",
        "documentation_url": "https://openflights.org/data.php",
        "license": "ODbL-1.0", "license_url": "https://opendatacommons.org/licenses/odbl/1-0/",
        "route_period": "2014-06", "downloaded_at_utc": datetime.now(timezone.utc).isoformat(),
        "limitations": "Historical route links; not current schedules, flight frequency, or observed tracks.",
        "files": {},
    }
    # An interrupted download leaves no apparently complete bundle. Never replace
    # a previous source snapshot; only this temporary directory is cleaned up.
    with tempfile.TemporaryDirectory(prefix=".openflights-download-", dir=destination.parent) as temporary:
        folder = Path(temporary) / "bundle"
        folder.mkdir()
        for filename in (*FILES, "data-documentation.php"):
            upstream = "data.php" if filename == "data-documentation.php" else f"data/{filename}"
            url = f"https://raw.githubusercontent.com/jpatokal/openflights/{revision}/{upstream}"
            request = Request(url, headers={"User-Agent": "sedona-overture-demo/offline-data-preparation"})
            with urlopen(request, timeout=60) as response:
                content = response.read(MAX_FILE_BYTES + 1)
            if not content or len(content) > MAX_FILE_BYTES:
                raise ValueError(f"Empty or oversized download: {filename}")
            record = {"url": url, "bytes": len(content), "sha256": hashlib.sha256(content).hexdigest()}
            if filename in FILES:
                rows = list(csv.reader(io.StringIO(content.decode("utf-8")), strict=True))
                if not rows or any(len(row) != FILES[filename] for row in rows):
                    raise ValueError(f"Unexpected CSV shape in {filename}")
                record["rows"] = len(rows)
            (folder / filename).write_bytes(content)
            manifest["files"][filename] = record
            print(f"Downloaded {filename}: {len(content):,} bytes", flush=True)
        (folder / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
        (folder / "SHA256SUMS").write_text("".join(
            f"{record['sha256']}  {name}\n" for name, record in manifest["files"].items()
        ), encoding="utf-8")
        (folder / "README.txt").write_text(
            "OpenFlights offline source bundle\n"
            "Prepared with scripts/download-openflights.py on an open-network machine.\n"
            f"Pinned repository revision: {revision}\n"
            "Route data period: June 2014. Download date is NOT route observation date.\n"
            "Source: https://openflights.org/data.php\n"
            "License: ODbL 1.0; https://opendatacommons.org/licenses/odbl/1-0/\n"
            "Individual contents: https://opendatacommons.org/licenses/dbcl/1-0/\n"
            "Retain attribution and applicable share-alike terms when redistributing.\n"
            "data-documentation.php is the pinned upstream documentation source.\n"
            "Copy this ENTIRE folder to local storage or an internal S3 prefix.\n"
            "Set FLIGHT_ROUTES_URI to that folder as seen inside the notebook runtime.\n"
            "Notebook 20 checks manifest sizes and SHA-256 before parsing any data.\n",
            encoding="utf-8",
        )
        if destination.exists():
            raise FileExistsError(destination)
        folder.rename(destination)
    print(f"Offline bundle ready: {destination}", flush=True)
    return manifest


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", required=True, type=Path, help="New local bundle directory; never overwritten")
    parser.add_argument("--revision", default=DEFAULT_REVISION, help="Pinned upstream commit SHA")
    args = parser.parse_args()
    download_bundle(args.output, args.revision)


if __name__ == "__main__":
    main()
