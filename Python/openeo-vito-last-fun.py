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

# get last valid value per pixel
lastcube = ndvicube.reduce_dimension(
    dimension = 't'
    , reducer = 'last'
)

lastcube.download(
    'last.ncdf'
    , format = 'NetCDF'
)
