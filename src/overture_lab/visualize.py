"""Strictly bounded, air-gap-safe table and geometry visualisation."""

from __future__ import annotations


def collect_geodataframe(df, limit: int, columns: list[str] | None = None):
    """Collect at most ``limit`` rows and decode geometry from WKB.

    The explicit limit is the safety boundary between distributed processing
    and driver/browser rendering.
    """
    from pyspark.sql import functions as F
    import geopandas as gpd
    import shapely

    selected = [F.col(name) for name in (columns or []) if name != "geometry"]
    selected.append(F.expr("ST_AsBinary(geometry)").alias("_geometry_wkb"))
    pdf = df.select(*selected).limit(limit).toPandas()
    wkb = pdf.pop("_geometry_wkb").map(
        lambda value: bytes(value) if value is not None else None
    )
    geometry = gpd.GeoSeries(shapely.from_wkb(wkb), crs="EPSG:4326")
    return gpd.GeoDataFrame(pdf, geometry=geometry, crs="EPSG:4326")


def static_geometry_plot(
    df,
    limit: int,
    columns: list[str] | None = None,
    column: str | None = None,
    title: str | None = None,
    figsize: tuple[int, int] = (9, 7),
):
    """Offline Matplotlib map; no remote basemap requests are made."""
    import matplotlib.pyplot as plt

    gdf = collect_geodataframe(df, limit=limit, columns=columns)
    _, axis = plt.subplots(figsize=figsize)
    if gdf.empty:
        axis.text(0.5, 0.5, "No features in this scope", ha="center")
        axis.set_axis_off()
    else:
        gdf.plot(
            ax=axis,
            column=column if column in gdf.columns else None,
            legend=bool(column and column in gdf.columns),
            markersize=8,
            linewidth=0.8,
            alpha=0.75,
        )
        axis.set_xlabel("longitude")
        axis.set_ylabel("latitude")
    axis.set_title(title or f"Bounded map (at most {limit:,} features)")
    return gdf, axis


def interactive_geometry_map(
    df,
    limit: int,
    columns: list[str] | None = None,
):
    """Offline pydeck geometry layer with no network basemap."""
    import pydeck as pdk

    gdf = collect_geodataframe(df, limit=limit, columns=columns)
    if gdf.empty:
        return None
    minx, miny, maxx, maxy = gdf.total_bounds
    layer = pdk.Layer(
        "GeoJsonLayer",
        gdf.__geo_interface__,
        pickable=True,
        stroked=True,
        filled=True,
        get_fill_color=[45, 145, 210, 90],
        get_line_color=[20, 60, 90, 210],
        line_width_min_pixels=1,
    )
    view = pdk.ViewState(
        longitude=(minx + maxx) / 2,
        latitude=(miny + maxy) / 2,
        zoom=11,
    )
    return pdk.Deck(layers=[layer], initial_view_state=view, map_style=None)
