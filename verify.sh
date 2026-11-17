#!/usr/bin/env bash
set -euo pipefail

for executable in aria2c nmap traceroute; do
    command -v "$executable"
done

python - <<'PY'
from importlib.metadata import version
import tempfile
from pathlib import Path

import babypandas as bpd
import geopandas as gpd
from shapely.geometry import Point

assert version("babypandas") == "0.1.5", version("babypandas")
frame = bpd.DataFrame().assign(value=[1, 2, 3])
assert frame.get("value").sum() == 6

geo = gpd.GeoDataFrame({"name": ["UCSD"]}, geometry=[Point(-117.234, 32.880)], crs="EPSG:4326")
assert geo.to_crs("EPSG:3857").crs.to_epsg() == 3857
with tempfile.TemporaryDirectory() as folder:
    path = Path(folder) / "point.geojson"
    geo.to_file(path, driver="GeoJSON", engine="fiona")
    restored = gpd.read_file(path, engine="fiona")
    assert restored.loc[0, "name"] == "UCSD"
    assert restored.geometry.iloc[0].equals(geo.geometry.iloc[0])

for name in ("babypandas", "geopandas", "numpy", "pandas"):
    print(f"{name}=={version(name)}")
print("Python package checks passed.")
PY

echo "All MA 5 checks passed."
