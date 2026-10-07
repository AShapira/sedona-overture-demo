"""Additional full-data export checks and map capture for validation kernels."""
from functools import wraps
import json
from pathlib import Path
import time


def install(root):
    from pyspark.sql import functions as F
    from sedona.sql.types import GeometryType
    from overture_lab import outputs, ports, visualize

    root = Path(root)
    records = []
    maps = []

    def save():
        (root / "exports-validation.json").write_text(json.dumps(records, indent=2))
        (root / "maps.json").write_text(json.dumps(maps, indent=2))

    def compare(before, after, label):
        # JSON retains nested attributes; WKB retains every coordinate and ring.
        # Compare multisets, including duplicate rows, without driver collection.
        def rows(frame):
            columns = [
                F.hex(F.expr(f"ST_AsBinary(`{field.name}`)")).alias(field.name)
                if isinstance(field.dataType, GeometryType) else F.col(field.name)
                for field in before.schema.fields
            ]
            return frame.select(F.to_json(F.struct(*columns),
                                         options={"ignoreNullFields": "false"}).alias("row"))
        left, right = rows(before), rows(after)
        if left.exceptAll(right).limit(1).count() or right.exceptAll(left).limit(1).count():
            raise AssertionError(f"Exact attribute/geometry round trip failed: {label}")

    def verify(frame, spark, uri):
        import pyarrow.parquet as pq
        if not Path(uri).resolve().is_relative_to(root.resolve()):
            raise AssertionError(f"Export escaped the local validation directory: {uri}")
        started = time.monotonic()
        restored = spark.read.format("geoparquet").load(uri)
        compare(frame, restored, uri)
        geometry_columns = [f.name for f in frame.schema.fields if isinstance(f.dataType, GeometryType)]
        for name in geometry_columns:
            bad = restored.where(F.expr(
                f"`{name}` IS NULL OR ST_IsEmpty(`{name}`) OR NOT ST_IsValid(`{name}`) "
                f"OR ST_SRID(`{name}`) <> 4326"))
            if bad.limit(1).count():
                raise AssertionError(f"Invalid restored {name}: {uri}")
        footer = pq.ParquetFile(uri)
        geo = json.loads(footer.schema_arrow.metadata[b"geo"])
        if geo["version"] != "1.1.0" or geo["primary_column"] != "geometry":
            raise AssertionError(f"Unexpected GeoParquet metadata: {uri}")
        for name in geometry_columns:
            covering = geo["columns"][name]["covering"]["bbox"]
            for axis, refs in covering.items():
                if len(refs) != 2 or refs[1] != axis or refs[0] not in restored.columns:
                    raise AssertionError(f"Invalid {name} covering: {covering}")
        record = {"uri": uri, "rows": footer.metadata.num_rows,
                  "bytes": Path(uri).stat().st_size, "geometry_columns": geometry_columns,
                  "exact_attribute_geometry_round_trip": True,
                  "geo_metadata": geo, "seconds": round(time.monotonic() - started, 3)}
        records.append(record)
        save()
        print("VALIDATED_EXPORT", json.dumps({k: v for k, v in record.items() if k != "geo_metadata"}), flush=True)

    original_single = outputs.write_single_geoparquet

    @wraps(original_single)
    def single(dataframe, spark, settings, **kwargs):
        if settings.derived_output_mode != "local" or not settings.write_derived:
            raise AssertionError("Validation requires enabled explicit local exports")
        result = original_single(dataframe, spark, settings, **kwargs)
        verify(dataframe, spark, result.geoparquet_uri)
        return result

    original_roads = outputs.write_single_file_exports

    @wraps(original_roads)
    def roads(dataframe, spark, settings, **kwargs):
        if settings.derived_output_mode != "local" or not settings.write_derived:
            raise AssertionError("Validation requires enabled explicit local exports")
        result = original_roads(dataframe, spark, settings, **kwargs)
        verify(kwargs["geoparquet_dataframe"], spark, result.geoparquet_uri)
        if kwargs.get("boundary_dataframe") is not None:
            verify(kwargs["boundary_dataframe"], spark, result.boundary_geoparquet_uri)
        csv = spark.read.option("header", "true").csv(result.csv_uri)
        columns = kwargs.get("csv_columns", outputs.SINGLE_FILE_CSV_COLUMNS)
        expected = dataframe.select(*[
            F.expr("ST_AsText(geometry)").alias(name) if name == "geometry_wkt"
            else F.col(name).cast("string").alias(name) for name in columns
        ])
        compare(expected, csv, result.csv_uri)
        records.append({"uri": result.csv_uri, "rows": result.row_count,
                        "exact_attribute_geometry_round_trip": True, "format": "csv"})
        save()
        return result

    original_document = visualize._offline_deck_document

    original_ports = ports.export_ports

    @wraps(original_ports)
    def port_export(*args, **kwargs):
        result = original_ports(*args, **kwargs)
        # The port writer validates a staged file, then atomically promotes it.
        # Record the retained destination instead of the removed staging path.
        records[-1]["uri"] = result["destination"]
        if not Path(result["destination"]).is_file():
            raise AssertionError("Port export was not retained after promotion")
        save()
        return result

    @wraps(original_document)
    def document(deck, *args, **kwargs):
        html = original_document(deck, *args, **kwargs)
        destination = root / f"map-{len(maps) + 1:02d}.html"
        destination.write_text(html)
        data = json.loads(deck.to_json())
        maps.append({"path": str(destination), "layers": [layer.get("id") for layer in data["layers"]],
                     "coordinate_counts": visualize.deck_coordinate_counts(data)})
        save()
        return html

    outputs.write_single_geoparquet = single
    outputs.write_single_file_exports = roads
    ports.export_ports = port_export
    visualize._offline_deck_document = document
    save()
