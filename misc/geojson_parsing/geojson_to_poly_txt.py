import json
import math

with open("sg.geojson", "r") as f:
    data = json.load(f)

coords = data["features"][0]["geometry"]["coordinates"][0]

# Conver coordinates from [long, lat][] to [x, y] in meters, scaled by the scale factor
# the landmass covered is pretty small so we can do a naive conversion

scale_factor = 0.1

center_long = (min(coord[0] for coord in coords) + max(coord[0] for coord in coords)) / 2
center_lat = (min(coord[1] for coord in coords) + max(coord[1] for coord in coords)) / 2

def longlat_to_xy(long, lat):
    x = (long - center_long) * 111320 * scale_factor * math.cos(center_lat * math.pi / 180)
    y = (lat - center_lat) * 110540 * scale_factor
    return x, y

with open("sg_poly.txt", "w") as f:
    for coord in coords:
        x, y = longlat_to_xy(coord[0], coord[1])
        f.write(f"{x} {y}\n")