#!/usr/bin/env python3
"""Console entry point. No notebook, query-agent, GPU, or DuckDB is required."""
from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "src"))


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    subcommands = parser.add_subparsers(dest="command", required=True)
    for command in ("prepare", "load", "verify", "run"):
        child = subcommands.add_parser(command)
        child.add_argument("--dataset", type=Path, required=True)
        child.add_argument("--report", type=Path, help="New JSON report file; must not exist")
        if command in {"prepare", "run"}:
            child.add_argument("--bbox", nargs=4, type=float, required=True, metavar=("WEST", "SOUTH", "EAST", "NORTH"))
            child.add_argument("--schema-version", required=True)
            child.add_argument("--types", nargs="+", help="theme/type selections; default: all supplied types")
        if command in {"load", "verify", "run"}:
            child.add_argument("--connections", type=Path, required=True)
            child.add_argument("--statement-timeout-seconds", type=int, help="Override the connection file setting")
    args = parser.parse_args(argv)
    spark = None
    try:
        if args.report and args.report.exists():
            raise FileExistsError("Report file exists; choose a fresh path")
        from overture_lab.postgis_import import prepare, load, verify
        if args.command in {"prepare", "run"}:
            from overture_lab.config import load_settings
            from overture_lab.spark import create_sedona
            settings = load_settings()
            spark = create_sedona(settings, "overture-postgis-import")
            result = prepare(spark, settings, args.dataset, args.bbox,
                             schema_version=args.schema_version, types=args.types)
        if args.command in {"load", "verify", "run"}:
            if args.statement_timeout_seconds is not None:
                # Pass an in-memory override: do not rewrite a secret-bearing file.
                from overture_lab.postgis_import.database import read_connections
                config = read_connections(args.connections)
                if not 0 < args.statement_timeout_seconds <= 604800:
                    raise ValueError("Statement timeout must be positive and at most one week")
                config["statement_timeout_seconds"] = args.statement_timeout_seconds
                connections = config
            else:
                connections = args.connections
            result = verify(args.dataset, connections) if args.command == "verify" else load(args.dataset, connections)
        if args.report:
            with args.report.open("x", encoding="utf-8") as stream:
                stream.write(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
        print(json.dumps({"event": "success", "command": args.command, "fingerprint": result["fingerprint"]}), flush=True)
        return 0
    except KeyboardInterrupt:
        print("Import interrupted; preparation may be incomplete. Database load rolls back unless commit already completed.", file=sys.stderr)
        return 130
    except Exception as exc:
        # Remote Spark/JDBC/DB exceptions may embed credentials. Do not echo
        # arbitrary exception text or a traceback in the console/notebook logs.
        from overture_lab.postgis_import.contract import ImportValidationError, ImportResourceError
        message = str(exc) if isinstance(exc, (ImportValidationError, ImportResourceError)) else type(exc).__name__
        print(f"Import failed ({message}); no automatic overwrite or resume. Check configuration and the stage progress above.", file=sys.stderr)
        return 1
    finally:
        if spark is not None:
            spark.stop()


if __name__ == "__main__":
    raise SystemExit(main())
