"""Normalized-v3 UTM contract, with explicit support for legacy v2 snapshots.

The normalization rules are adapted from that project's MIT-licensed
benchmark/dataset.py. No query-agent or DuckDB dependency is required.
"""
from __future__ import annotations

import hashlib
import json
import math
import re
import unicodedata

VERSION = 3
BATCH_SIZE = 4096


class ImportValidationError(ValueError):
    """An intentionally credential-free error suitable for console output."""


class ImportResourceError(RuntimeError):
    """A credential-free storage budget error."""


TABLES_V2 = {
    "features": [("relation", "str"), ("id", "str"), ("name", "str"),
                 ("class", "str"), ("subtype", "str"), ("height", "float"),
                 ("num_floors", "float"), ("geometry", "str"), ("geometry_m", "str"),
                 ("longitude", "float"), ("latitude", "float"),
                 ("reference_only", "bool"), ("raw_json", "str")],
    "names": [("relation", "str"), ("id", "str"), ("ordinal", "int"),
              ("name", "str"), ("normalized", "str")],
    "addresses": [("relation", "str"), ("id", "str"), ("ordinal", "int"),
                  ("street", "str"), ("number", "str"), ("city", "str"),
                  ("postcode", "str"), ("country", "str")],
    "categories": [("relation", "str"), ("id", "str"), ("ordinal", "int"),
                   ("category", "str"), ("is_primary", "bool")],
    "links": [("relation", "str"), ("id", "str"), ("ordinal", "int"),
              ("field", "str"), ("target_id", "str")],
}


TABLES = {name: list(columns) for name, columns in TABLES_V2.items()}
TABLES["features"] += [("geometry_m_srid", "int"), ("utm_crosses_zone", "bool"), ("metric_status", "str")]


def tables_for(version):
    if version == 2:
        return TABLES_V2
    if version == VERSION:
        return TABLES
    raise ImportValidationError("Only normalized-v2 and normalized-v3 snapshots are supported")


def metric_srid(row, version):
    return 2039 if version == 2 else row["geometry_m_srid"]


def digest(value):
    return hashlib.sha256(json.dumps(value, sort_keys=True, ensure_ascii=False).encode()).hexdigest()


def identifier(value):
    if not isinstance(value, str) or not re.fullmatch(r"[a-z][a-z0-9_]{0,62}", value):
        raise ImportValidationError("Identifiers require 1-63 lower-case letters, digits or underscores, starting with a letter")
    return value


def validate_bbox(bbox):
    if len(bbox) != 4 or not all(math.isfinite(v) for v in bbox):
        raise ImportValidationError("Bbox requires four finite coordinates")
    w, s, e, n = bbox
    if not (-180 <= w < e <= 180 and -90 <= s < n <= 90):
        raise ImportValidationError("Bbox must be west south east north; antimeridian wrapping is unsupported")
    return list(bbox)


def normalized(value):
    return " " + " ".join(re.findall(r"[^\W_]+", unicodedata.normalize("NFKC", value).casefold())) + " "


def strings(value):
    if isinstance(value, str):
        yield value
    elif isinstance(value, dict):
        for item in value.values():
            yield from strings(item)
    elif isinstance(value, list):
        for item in value:
            yield from strings(item)


def normalize(row):
    row = dict(row)
    if row.get("geometry_m") and re.search(r"\b(?:inf|nan)\b", row["geometry_m"], re.I):
        row["geometry_m"] = None
    payload = json.loads(row["raw_json"])
    relation, fid = row["relation"], row["id"]
    if not isinstance(fid, str) or not fid:
        raise ImportValidationError("Source feature IDs must be nonempty strings")
    result = {k: [] for k in TABLES}
    names = payload.get("names") or {}
    row["name"] = names.get("primary")
    for field in ("class", "subtype", "height", "num_floors"):
        row[field] = payload.get(field)
    result["features"].append(row)
    for i, name in enumerate(strings(names)):
        result["names"].append(dict(relation=relation, id=fid, ordinal=i, name=name, normalized=normalized(name)))
    addresses = payload.get("addresses") or []
    if relation == "addresses_address":
        addresses = [dict(street=payload.get("street"), number=payload.get("number"),
                          locality=payload.get("postal_city"), postcode=payload.get("postcode"), country=payload.get("country"))]
    for i, address in enumerate(addresses):
        result["addresses"].append(dict(relation=relation, id=fid, ordinal=i, street=address.get("street"),
            number=address.get("number"), city=address.get("locality"), postcode=address.get("postcode"), country=address.get("country")))
    categories = payload.get("categories") or {}
    values = ([categories["primary"]] if categories.get("primary") else []) + (categories.get("alternate") or [])
    for i, category in enumerate(values):
        result["categories"].append(dict(relation=relation, id=fid, ordinal=i, category=category,
                                         is_primary=i == 0 and bool(categories.get("primary"))))

    def references(value, path=""):
        if isinstance(value, dict):
            for key, item in value.items():
                field = f"{path}.{key}" if path else key
                if (key.endswith("_id") or (key == "id" and path)) and isinstance(item, str):
                    yield field, item
                elif key != "sources":
                    yield from references(item, field)
        elif isinstance(value, list):
            for i, item in enumerate(value):
                yield from references(item, f"{path}[{i}]")

    for i, (field, target) in enumerate(references(payload)):
        result["links"].append(dict(relation=relation, id=fid, ordinal=i, field=field, target_id=target))
    return result


def arrow_schema(table, version=VERSION):
    import pyarrow as pa
    types = {"str": pa.string(), "float": pa.float64(), "int": pa.int64(), "bool": pa.bool_()}
    return pa.schema([(name, types[kind]) for name, kind in tables_for(version)[table]])


def normalize_partition(rows):
    """Spark owns retries; workers emit normalized rows, never database writes."""
    from .utm import worker_projector
    projector = worker_projector()
    for record in rows:
        row = record.asDict()
        for name in ("longitude", "latitude"):
            if row.get(name) is not None and not math.isfinite(row[name]):
                row[name] = None
        row.update(projector.project(row["geometry"]))
        for table, values in normalize(row).items():
            for value in values:
                yield table, json.dumps(value, ensure_ascii=False, allow_nan=False, separators=(",", ":"))
