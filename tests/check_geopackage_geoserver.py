"""Publish a fixture ONLY to a disposable GeoServer, validate SLDs and render levels.

This mutates the named test workspace. Set GPKG_TEST_USER/GPKG_TEST_PASSWORD in
the environment. The GeoPackage path must be visible to the server itself.
"""
import argparse
import base64
import hashlib
import json
import os
from pathlib import Path
import urllib.parse
import urllib.request


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--url", required=True)
    parser.add_argument("--gpkg", required=True)
    parser.add_argument("--styles", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    token = base64.b64encode((os.environ["GPKG_TEST_USER"] + ":" + os.environ["GPKG_TEST_PASSWORD"]).encode()).decode()
    def request(path, data=None, method=None, content_type="application/json"):
        payload = json.dumps(data).encode() if isinstance(data, dict) else data
        req = urllib.request.Request(args.url.rstrip("/") + path, data=payload, method=method,
                                     headers={"Authorization": "Basic " + token, "Content-Type": content_type})
        with urllib.request.urlopen(req, timeout=90) as response:
            return response.read()
    workspace = "gpkg_validation"
    request("/rest/workspaces", {"workspace": {"name": workspace}})
    request(f"/rest/workspaces/{workspace}/datastores", {"dataStore": {
        "name": "surfaces", "connectionParameters": {"entry": [
            {"@key": "dbtype", "$": "geopkg"}, {"@key": "database", "$": args.gpkg},
            {"@key": "read_only", "$": "true"}, {"@key": "immutable", "$": "true"}]}}})
    levels = ("full", "fine", "medium", "coarse")
    layer_names = []
    for level in levels:
        name = "surfaces_" + level
        request(f"/rest/workspaces/{workspace}/styles?name={name}",
                (args.styles / (name + ".sld")).read_bytes(), content_type="application/vnd.ogc.sld+xml")
        for surface in ("ocean", "landmass"):
            table = surface + "_" + level
            request(f"/rest/workspaces/{workspace}/datastores/surfaces/featuretypes", {"featureType": {
                "name": table, "nativeName": table, "srs": "EPSG:4326"}})
            request(f"/rest/layers/{workspace}:{table}", {"layer": {
                "defaultStyle": {"name": name, "workspace": workspace}}}, method="PUT")
            layer_names.append(workspace + ":" + table)
    request(f"/rest/workspaces/{workspace}/layergroups", {"layerGroup": {
        "name": "surfaces", "mode": "SINGLE",
        "publishables": {"published": [{"@type": "layer", "name": name} for name in layer_names]},
        "styles": {"style": [{"name": "surfaces_" + level, "workspace": workspace}
                               for level in levels for _ in range(2)]},
        "bounds": {"minx": 0, "miny": 0, "maxx": 4, "maxy": 2, "crs": "EPSG:4326"}}})
    report = {"layers": layer_names, "renders": []}
    for level, scale in (("full", 100000), ("fine", 1000000), ("medium", 10000000), ("coarse", 30000000)):
        width = 256 * 0.00028 * scale
        cx, cy = 111319.49, 111325.14
        bbox = f"{cx-width/2},{cy-width/2},{cx+width/2},{cy+width/2}"
        params = {"service": "WMS", "version": "1.1.1", "request": "GetMap", "styles": "",
                  "srs": "EPSG:3857", "bbox": bbox, "width": 256, "height": 256,
                  "format": "image/png", "transparent": "true"}
        params["layers"] = workspace + ":surfaces"
        grouped = request("/wms?" + urllib.parse.urlencode(params))
        params["layers"] = ",".join(workspace + ":" + s + "_" + level for s in ("ocean", "landmass"))
        pair = request("/wms?" + urllib.parse.urlencode(params))
        assert grouped.startswith(b"\x89PNG\r\n\x1a\n"), grouped[:500]
        assert grouped == pair, f"Group/pair mismatch at {level}: style level selection differs"
        (args.output / f"{level}.png").write_bytes(grouped)
        report["renders"].append({"level": level, "scale": scale, "bytes": len(grouped),
                                  "sha256": hashlib.sha256(grouped).hexdigest()})
    report["status"] = "passed"
    (args.output / "geoserver-report.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
