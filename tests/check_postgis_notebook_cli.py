#!/usr/bin/env python3
"""Execute the delivered notebook and CLI against the same disposable fixture."""
import argparse
import json
from pathlib import Path
import subprocess
import sys

from check_postgis_import import configuration


def main():
    import nbformat
    from nbclient import NotebookClient
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--source", required=True)
    parser.add_argument("--connections", type=Path, required=True)
    args = parser.parse_args()
    args.root.mkdir(parents=True)
    configuration(args.root, args.source)
    repository = Path(__file__).resolve().parents[1]
    config = json.loads(args.connections.read_text())
    config["schema"] = "import_notebook"
    notebook_connections = args.root / "notebook-connections.json"
    notebook_connections.write_text(json.dumps(config))
    nb = nbformat.read(repository / "notebooks/13_import_overture_postgis.ipynb", as_version=4)
    for cell in nb.cells:
        if cell.cell_type == "code" and "ENABLE_DATABASE_WRITES = False" in cell.source:
            cell.source = cell.source.replace('Path(settings.scratch_dir) / "postgis-small-v1"', repr(str(args.root / "notebook")))
            cell.source = cell.source.replace('Path("/workspace/.artifacts/postgis-connections.json")', repr(str(notebook_connections)))
            cell.source = cell.source.replace("ENABLE_DATABASE_WRITES = False", "ENABLE_DATABASE_WRITES = True")
    NotebookClient(nb, timeout=300, kernel_name="python3", resources={"metadata": {"path": str(repository)}}).execute()
    nbformat.write(nb, args.root / "executed-notebook.ipynb")
    config["schema"] = "import_console"
    cli_connections = args.root / "cli-connections.json"
    cli_connections.write_text(json.dumps(config))
    subprocess.run([sys.executable, str(repository / "scripts/import_overture_postgis.py"), "run",
        "--dataset", str(args.root / "console"), "--bbox", "34.76", "31.96", "34.80", "32.00",
        "--types", "places/place", "buildings/building", "--schema-version", "v1.18.0",
        "--connections", str(cli_connections), "--statement-timeout-seconds", "1800",
        "--report", str(args.root / "console-report.json")], check=True)
    from overture_lab.postgis_import import verify
    left = verify(args.root / "notebook", notebook_connections)
    right = verify(args.root / "console", cli_connections)
    assert left["tables"] == right["tables"], (left, right)
    subprocess.run([sys.executable, str(repository / "scripts/import_overture_postgis.py"), "verify",
        "--dataset", str(args.root / "console"), "--connections", str(cli_connections)], check=True)
    print("NOTEBOOK AND CONSOLE PARITY PASSED")


if __name__ == "__main__":
    main()
