#!/usr/bin/env python3
"""Convert py:percent notebook sources into deterministic .ipynb files."""

from __future__ import annotations

import argparse
import ast
import hashlib
import json
from pathlib import Path
import re
import sys


CELL = re.compile(r"^# %%(?: \[(markdown|raw)\])?\s*$")


def _markdown(source: str) -> str:
    lines = []
    for line in source.splitlines():
        if line == "#":
            lines.append("")
        elif line.startswith("# "):
            lines.append(line[2:])
        elif line.startswith("#"):
            lines.append(line[1:])
        elif not line.strip():
            lines.append("")
        else:
            raise ValueError(f"Markdown cell has uncommented line: {line!r}")
    return "\n".join(lines).strip()


def _source_lines(source: str) -> list[str]:
    return source.splitlines(keepends=True)


def convert(path: Path) -> dict[str, object]:
    lines = path.read_text(encoding="utf-8").splitlines()
    cells = []
    kind = None
    body: list[str] = []

    def finish() -> None:
        nonlocal body
        if kind is None:
            body = []
            return
        source = "\n".join(body).strip()
        if kind == "markdown":
            cells.append(
                {
                    "cell_type": "markdown",
                    "metadata": {},
                    "source": _source_lines(_markdown(source)),
                }
            )
        elif kind == "raw":
            cells.append(
                {
                    "cell_type": "raw",
                    "metadata": {},
                    "source": _source_lines(_markdown(source)),
                }
            )
        else:
            if source:
                ast.parse(source, filename=str(path))
            cells.append(
                {
                    "cell_type": "code",
                    "execution_count": None,
                    "metadata": {},
                    "outputs": [],
                    "source": _source_lines(source),
                }
            )
        body = []

    for line in lines:
        match = CELL.match(line)
        if match:
            finish()
            kind = match.group(1) or "code"
        elif kind is not None:
            body.append(line)
    finish()
    if not cells:
        raise ValueError(f"No py:percent cells found in {path}")

    for index, cell in enumerate(cells):
        digest = hashlib.sha1(
            f"{path.name}:{index}:{cell['cell_type']}".encode()
        ).hexdigest()[:12]
        cell["id"] = digest

    notebook = {
        "cells": cells,
        "metadata": {
            "kernelspec": {
                "display_name": "Python 3",
                "language": "python",
                "name": "python3",
            },
            "language_info": {"name": "python", "version": "3.12"},
        },
        "nbformat": 4,
        "nbformat_minor": 5,
    }
    return notebook


def serialise(notebook) -> str:
    return json.dumps(notebook, ensure_ascii=False, indent=1) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("paths", nargs="*", type=Path)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    paths = args.paths or sorted(Path("notebooks").glob("*.py"))
    failures = []
    for source in paths:
        target = source.with_suffix(".ipynb")
        expected = serialise(convert(source))
        if args.check:
            if not target.exists() or target.read_text(encoding="utf-8") != expected:
                failures.append(str(target))
        else:
            target.write_text(expected, encoding="utf-8")
            print(target)
    if failures:
        print("Out-of-date notebooks:", *failures, sep="\n  ", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
