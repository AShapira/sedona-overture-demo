#!/usr/bin/env python3
"""Source identity and duplicate-key rejection with actual Spark processing."""
import argparse
from pathlib import Path
import shutil
from unittest.mock import patch

from check_postgis_import import configuration


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--source", type=Path, required=True)
    args = parser.parse_args()
    args.root.mkdir(parents=True)
    from overture_lab.spark import create_sedona
    from overture_lab.postgis_import import prepare
    from overture_lab.postgis_import.snapshot import source_inventory
    settings = configuration(args.root, str(args.source))
    spark = create_sedona(settings, "postgis-failure-acceptance")
    try:
        calls = 0

        def changed(*positional, **keywords):
            nonlocal calls
            inventory = source_inventory(*positional, **keywords)
            calls += 1
            if calls > 1:
                inventory[0]["mtime"] += 1
            return inventory

        with patch("overture_lab.postgis_import.snapshot.source_inventory", side_effect=changed):
            try:
                prepare(spark, settings, args.root / "changed", [34.76, 31.96, 34.80, 32.00],
                        schema_version="v1.18.0", types=["places/place"])
                raise AssertionError("Changed source was accepted")
            except ValueError as exc:
                assert "changed" in str(exc), str(exc)
                assert not (args.root / "changed/manifest.json").exists()
        duplicate_source = args.root / "duplicate-source"
        leaf = duplicate_source / "theme=places/type=place"
        leaf.mkdir(parents=True)
        source_file = args.source / "theme=places/type=place/part-0.parquet"
        shutil.copyfile(source_file, leaf / "part-0.parquet")
        shutil.copyfile(source_file, leaf / "part-1.parquet")
        from dataclasses import replace
        try:
            prepare(spark, replace(settings, release_uri=str(duplicate_source)), args.root / "duplicate",
                    [34.76, 31.96, 34.80, 32.00], schema_version="v1.18.0")
            raise AssertionError("Duplicate source keys were accepted")
        except ValueError as exc:
            assert "Duplicate" in str(exc), str(exc)
            assert not (args.root / "duplicate/manifest.json").exists()
        print("SOURCE CHANGE AND DUPLICATE REJECTION PASSED")
    finally:
        spark.stop()


if __name__ == "__main__":
    main()
