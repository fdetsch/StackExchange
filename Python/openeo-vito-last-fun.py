# ---
# title: "openeo-python-client issue #221: 'Appropriate use of `last` function'"
# author: "fdetsch"
# output:
#   html_notebook:
#     code_folding: show
#     toc: true
#     toc_depth: 2
#     toc_float: true
#     collapsed: false
# ---

#' Available online [here](https://github.com/Open-EO/openeo-python-client/issues/221).

import openeo
import tempfile

con = openeo.connect(
    'https://openeo.vito.be'
).authenticate_basic(
    'test'
    , 'test123'
)

# make dictionary, containing bounding box
urk = {"west": 5.5661, "south": 52.6457, "east": 5.7298, "north": 52.7335}

# make list, containing the temporal interval
t = ["2021-04-26", "2021-04-30"]

# load datacube
datacube = con.load_collection(
    "SENTINEL2_L2A_SENTINELHUB"
    , spatial_extent = urk
    , temporal_extent = t
    , bands = ["B04", "B08"]
)

# calculate ndvi
ndvicube = datacube.ndvi(
    nir = 'B08'
    , red = 'B04'
    , target_band = 'ndvi'
)


### via `reduce_dimension()` ----
### (see https://github.com/Open-EO/openeo-geopyspark-driver/issues/91)

# get last valid value per pixel
lastcube = ndvicube.reduce_dimension(
    dimension = 't'
    , reducer = 'last'
)


### via user-defined function ----
### (see https://github.com/Open-EO/openeo-geopyspark-driver/issues/90)

udf = '''
import xarray
from openeo_udf.api.datacube import DataCube

def apply_datacube(cube: DataCube, context: dict) -> DataCube:
    array: xarray.DataArray = cube.get_array()
    last = array.tail({"t": 1})
    return DataCube(last)
'''

lastcube = ndvicube.apply_dimension(
    code = udf
    , runtime = 'Python'
)

## download results
lastcube.download(
    tempfile.gettempdir() + '/ndvi_tail.ncdf'
    , format = 'NetCDF'
)
