#!/usr/bin/env python3
"""Run full-data notebooks in isolated Podman containers; retain local evidence."""
import argparse
import ast
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import time
import traceback

ROOT = Path(__file__).resolve().parents[1]
IMAGE = "docker.io/apache/sedona:1.9.0@sha256:a1acf172621652c926214259045b2324f75341026dd726db0bef7e21b4205525"


def hashes():
    paths = [p for directory in ("src", "notebooks") for p in (ROOT / directory).rglob("*")
             if p.suffix in {".py", ".js", ".ipynb"}]
    paths += [Path(__file__), ROOT / "scripts/notebook_validation.py"]
    return {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(paths)}


def assignments(source, values):
    """Replace only named top-level configuration assignments in a run copy."""
    lines = source.splitlines(keepends=True)
    changes = []
    for node in ast.parse(source).body:
        if isinstance(node, ast.Assign) and len(node.targets) == 1:
            name = getattr(node.targets[0], "id", None)
            if name in values:
                changes.append((node.lineno - 1, node.end_lineno, f"{name} = {values[name]}\n"))
    for start, end, replacement in reversed(changes):
        lines[start:end] = [replacement]
    return "".join(lines)


def worker(number, destination, timeout):
    import nbformat
    from nbclient import NotebookClient

    path = next((ROOT / "notebooks").glob(f"{number:02d}_*.ipynb"))
    notebook = nbformat.read(path, as_version=4)
    for cell in notebook.cells:
        if cell.cell_type == "code":
            cell.source = assignments(cell.source, {
                "REGION_PRESET": repr("large"), "INCLUDE_TERRITORIAL_WATERS": "True",
                "BASEMAP_MODE": repr("none"), "OVERWRITE": "False",
                "OUTPUT_PATH": "Path('/results/exports/region_ports.geoparquet')",
            })
            cell.outputs, cell.execution_count = [], None
    notebook.cells.insert(0, nbformat.v4.new_code_cell(
        "from notebook_validation import install\ninstall('/results')"))
    initial = hashes()
    report = {"notebook": path.name, "source_hashes": initial, "status": "running",
              "configuration": {k: v for k, v in os.environ.items() if k.startswith(
                  ("SEDONA_", "OVERTURE_", "MEDIUM_", "LARGE_", "SMALL_", "MAP_FEATURE_", "DERIVED_", "WRITE_DERIVED"))}}
    started = time.monotonic()
    def progress(cell, cell_index, **kwargs):
        event = {"cell": cell_index, "kind": cell.cell_type, "elapsed_seconds": round(time.monotonic()-started, 2)}
        print(json.dumps(event), flush=True)
        with (destination / "progress.jsonl").open("a") as stream:
            stream.write(json.dumps(event) + "\n")
    try:
        NotebookClient(notebook, timeout=timeout, kernel_name="python3",
                       resources={"metadata": {"path": str(ROOT)}},
                       on_cell_start=progress).execute()
        if hashes() != initial:
            raise RuntimeError("Validation source changed during execution")
        records = json.loads((destination / "exports-validation.json").read_text())
        expected_exports = {10: 3, 11: 2, 12: 0, 13: 0, 14: 2, 15: 1, 16: 1}[number]
        if len(records) != expected_exports:
            raise AssertionError(f"Expected {expected_exports} validated exports, found {len(records)}")
        report.update(status="passed", exports=records)
    except BaseException:
        report.update(status="failed", error=traceback.format_exc())
        raise
    finally:
        report["seconds"] = round(time.monotonic()-started, 3)
        report["code_cells"] = sum(c.cell_type == "code" for c in notebook.cells) - 1
        report["outputs"] = [o.get("data", {}).get("text/plain", o.get("text", ""))
                             for c in notebook.cells for o in c.get("outputs", [])
                             if o.get("output_type") in ("display_data", "execute_result", "stream")]
        nbformat.write(notebook, destination / path.name.replace(".ipynb", ".executed.ipynb"))
        (destination / "report.json").write_text(json.dumps(report, indent=2))


def configuration():
    # Read only non-secret settings; do not source .env through a shell.
    keys = {"OVERTURE_RELEASE_DIR", "OVERTURE_RELEASE", "MEDIUM_STATE_CODES", "LARGE_REGION_STATE_CODES",
            "SMALL_CITIES", "MEDIUM_SAMPLE_LIMIT", "SMALL_SAMPLE_LIMIT", "MAP_FEATURE_LIMIT"}
    values = {}
    path = ROOT / ".env"
    if path.exists():
        for line in path.read_text().splitlines():
            key, separator, value = line.partition("=")
            if separator and key.strip() in keys:
                value = value.strip()
                if len(value) >= 2 and value[0] == value[-1] and value[0] in "\"'":
                    value = value[1:-1]
                values[key.strip()] = value
    values.update({k: os.environ[k] for k in keys if k in os.environ})
    return values


def host(args):
    config = configuration()
    release = Path(args.release_dir or config.pop("OVERTURE_RELEASE_DIR", "")).resolve()
    if not (release / "theme=divisions" / "type=division_area").is_dir():
        raise ValueError("--release-dir must identify the complete local Overture release")
    config.pop("OVERTURE_RELEASE_DIR", None)
    required = {"MEDIUM_STATE_CODES", "LARGE_REGION_STATE_CODES", "SMALL_CITIES",
                "MEDIUM_SAMPLE_LIMIT", "SMALL_SAMPLE_LIMIT"}
    if required - config.keys():
        raise ValueError(f"Missing configuration: {sorted(required-config.keys())}")
    root = (args.run_dir or ROOT / ".artifacts/notebooks-10-16" / datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")).resolve()
    if not root.is_relative_to((ROOT / ".artifacts").resolve()):
        raise ValueError("--run-dir must be inside the ignored .artifacts directory")
    root.mkdir(parents=True, exist_ok=True)
    summary = {"release_dir": str(release), "image": IMAGE, "notebooks": [], "status": "running"}
    try:
        for number in args.notebooks:
            available = int(next(line.split()[1] for line in Path('/proc/meminfo').read_text().splitlines()
                                 if line.startswith('MemAvailable:'))) // (1024 * 1024)
            memory = min(36, available - 6)
            if memory < 12:
                raise RuntimeError("Insufficient available memory: leave 6 GiB for the host and at least 12 GiB for validation")
            driver = min(24, memory - 8)
            attempt = 1
            while (root / f"{number:02d}-attempt-{attempt}").exists():
                attempt += 1
            destination = root / f"{number:02d}-attempt-{attempt}"
            destination.mkdir()
            name = f"sedona-validate-{number}-{os.getpid()}"
            environment = dict(config, PYTHONPATH="/workspace/src:/workspace/scripts:/opt/spark/python",
                PYSPARK_PYTHON="python3", PYSPARK_DRIVER_PYTHON="python3",
                OVERTURE_RELEASE_URI="/data/overture", WRITE_DERIVED="true", DERIVED_OUTPUT_MODE="local",
                DERIVED_OUTPUT_URI="", ALLOW_LOCAL_DERIVED_FALLBACK="false", DERIVED_LOCAL_FALLBACK_DIR="/results/exports",
                SEDONA_SCRATCH_DIR="/results", SEDONA_SCRATCH_BUDGET_GB="100", SEDONA_SCRATCH_RESERVE_GB="20",
                SEDONA_SPARK_LOCAL_DIR="/results/scratch", SEDONA_SPARK_LOCAL_CORES="12",
                SEDONA_SPARK_DRIVER_MEMORY=f"{driver}g", SEDONA_SPARK_PARTITIONS="48", SEDONA_SPARK_LOG_LEVEL="ERROR",
                RELEASE_INVENTORY_CACHE="/results/inventory", MPLCONFIGDIR="/results/matplotlib")
            # Ports must render every feature. Other notebooks retain their native display cap.
            if number == 16:
                environment.update(MAP_FEATURE_LIMIT=str(args.ports_map_limit),
                    SMALL_SAMPLE_LIMIT=str(max(args.ports_map_limit, int(environment["SMALL_SAMPLE_LIMIT"]))),
                    MEDIUM_SAMPLE_LIMIT=str(max(args.ports_map_limit, int(environment["MEDIUM_SAMPLE_LIMIT"]))))
            command = ["podman", "run", "--rm", "--name", name, "--network=none",
                "--security-opt=no-new-privileges", f"--memory={memory}g", "--cpus=12",
                "-v", f"{ROOT}:/workspace:ro", "-v", f"{release}:/data/overture:ro",
                "-v", f"{destination}:/results", "-w", "/workspace"]
            for key, value in environment.items():
                command += ["-e", f"{key}={value}"]
            command += ["--entrypoint", "python3", IMAGE, "scripts/validate-notebooks.py",
                        "--worker", str(number), "--timeout", str(args.timeout)]
            print(f"Notebook {number}: {destination}; container={memory} GiB driver={driver} GiB", flush=True)
            with (destination / "run.log").open("w") as log:
                try:
                    result = subprocess.run(command, stdout=log, stderr=subprocess.STDOUT)
                finally:
                    # This uniquely named disposable container belongs only to this invocation.
                    subprocess.run(["podman", "stop", "--ignore", "--time=10", name], capture_output=True)
            summary["notebooks"].append({"number": number, "directory": str(destination), "exit_code": result.returncode})
            if result.returncode:
                raise RuntimeError(f"Notebook {number} failed; see {destination / 'run.log'}")
        summary["status"] = "passed"
    except BaseException:
        summary.update(status="failed", error=traceback.format_exc())
        raise
    finally:
        # Each invocation retains its own summary, including partial reruns.
        path = root / f"invocation-{datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ')}.json"
        path.write_text(json.dumps(summary, indent=2))
        print(path, flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--release-dir")
    parser.add_argument("--run-dir", type=Path)
    parser.add_argument("--notebooks", type=int, nargs="+", choices=range(10, 17), default=list(range(10, 17)))
    parser.add_argument("--ports-map-limit", type=int, default=50_000)
    parser.add_argument("--timeout", type=int, default=7200, help="Per-cell timeout in seconds")
    parser.add_argument("--worker", type=int, choices=range(10, 17), help=argparse.SUPPRESS)
    args = parser.parse_args()
    if args.worker is not None:
        worker(args.worker, Path("/results"), args.timeout)
    else:
        host(args)


if __name__ == "__main__":
    main()
