"""Strictly bounded, air-gap-safe table and geometry visualisation."""

from __future__ import annotations

from functools import lru_cache
from html import escape
import json
from pathlib import Path
from typing import TYPE_CHECKING


if TYPE_CHECKING:
    from overture_lab.config import WmsSettings


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


def build_interactive_deck(
    layers,
    initial_view_state,
    *,
    wms: WmsSettings | None = None,
    tooltip=True,
):
    """Build a pydeck map with an optional internal WMS background."""
    import pydeck as pdk

    configured_layers = list(layers)
    if wms is not None:
        configured_layers.insert(
            0,
            pdk.Layer(
                "_WMSLayer",
                id="airgap-wms-background",
                data=wms.url,
                service_type=pdk.types.String("wms"),
                layers=[pdk.types.String(name) for name in wms.layers],
                srs=pdk.types.String(wms.srs),
                # loaders.gl otherwise defaults to CDN-hosted worker scripts.
                load_options={"core": {"worker": False}},
            ),
        )
    return pdk.Deck(
        layers=configured_layers,
        initial_view_state=initial_view_state,
        tooltip=tooltip,
        map_style=None,
        map_provider=None,
    )


@lru_cache(maxsize=1)
def _installed_pydeck_bundle() -> str:
    """Read the deck.gl renderer bundled with the installed pydeck package."""
    import pydeck

    path = (
        Path(pydeck.__file__).resolve().parent
        / "nbextension"
        / "static"
        / "index.js"
    )
    if not path.is_file():
        raise RuntimeError(f"Installed pydeck renderer is missing: {path}")
    return path.read_text(encoding="utf-8")


def _script_safe_json(value) -> str:
    encoded = value if isinstance(value, str) else json.dumps(value)
    return (
        encoded.replace("&", "\\u0026")
        .replace("<", "\\u003c")
        .replace(">", "\\u003e")
    )


def _offline_deck_document(deck, bundle: str | None = None) -> str:
    """Create a self-contained deck.gl document without remote resource tags."""
    deck_json = _script_safe_json(deck.to_json())
    tooltip_json = _script_safe_json(getattr(deck, "_tooltip", True))
    renderer = bundle if bundle is not None else _installed_pydeck_bundle()
    return f"""<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="referrer" content="no-referrer">
  <style>
    html, body, #deck-container {{
      width: 100%;
      height: 100%;
      margin: 0;
      overflow: hidden;
      background: #f8fafc;
    }}
  </style>
  <script>{renderer}</script>
</head>
<body>
  <div id="deck-container"></div>
  <script>
    const container = document.getElementById("deck-container");
    const jsonInput = {deck_json};
    const tooltip = {tooltip_json};
    createDeck({{container, jsonInput, tooltip}});
  </script>
</body>
</html>"""


class _InlineHtml:
    def __init__(self, data: str):
        self.data = data

    def _repr_html_(self) -> str:
        return self.data


def offline_deck_display(deck, width: str = "100%", height: int = 500):
    """Return an iframe whose renderer and map configuration are fully inline."""
    document = _offline_deck_document(deck)
    source = escape(document, quote=True)
    return _InlineHtml(
        f'<iframe title="Interactive map" srcdoc="{source}" '
        f'width="{escape(width, quote=True)}" height="{height}" '
        'style="border:0; display:block" referrerpolicy="no-referrer">'
        "</iframe>"
    )


def interactive_geometry_map(
    df,
    limit: int,
    columns: list[str] | None = None,
    wms: WmsSettings | None = None,
):
    """Bounded interactive geometry over an optional internal WMS."""
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
    deck = build_interactive_deck(
        [layer],
        view,
        wms=wms,
    )
    return offline_deck_display(deck)
