#' ---
#' title: "openeo issue #53: 'Download raster time series from Google Earth Engine'"
#' author: "fdetsch"
#' output:
#'   html_notebook:
#'     code_folding: show
#'     toc: true
#'     toc_depth: 2
#'     toc_float: true
#'     collapsed: false
#' ---
#+ setup, include=FALSE
knitr::opts_chunk[['set']](collapse=FALSE, message=FALSE, warning=FALSE, prompt=FALSE)
#+ libs, echo=FALSE
library(plotly)

#' Available online [here](https://github.com/Open-EO/openeo-r-client/issues/53).

library(openeo)
library(raster)

## area of interest
aoi = list(
  west = 5.61
  , east = 5.66
  , south = 51.97
  , north = 51.99
)


### TERRASCOPE ====

#+ connect
vito = connect(
  host = "https://openeo.vito.be"
  , user = "group"
  , password = "group123"
)

#+ process
p1 = processes()

dat1 = p1$load_collection(
  id = "TERRASCOPE_S2_TOC_V2"
  , spatial_extent = aoi
  , temporal_extent = list("2020-04-01", "2020-04-10")
)

spectral_reduce1 = p1$apply(
  dat1
  , function(x, context) {
    p1$normalized_difference(x[8], x[11])
  }
)

r1 = p1$save_result(
  data = spectral_reduce1
  , format = "NetCDF"
)

#+ download
ofl1 = "vito_s2_ndwi.ncdf"
compute_result(
  r1,
  format = "NetCDF",
  output_file = ofl1
)

#+ import
rst1 = brick(ofl1)
dim(rst1)
# 236 (nrow) 336 (ncol) 4 (nlayers)


### GOOGLE EARTH ENGINE ====

#+ connect
gee = connect(
  host = "https://earthengine.openeo.org"
  , user = "group1"
  , password = "test123"
)

#+ process_1
p2 = processes()

dat2 = p2$load_collection(
  id = "COPERNICUS/S2"
  , spatial_extent = aoi
  , temporal_extent = list("2020-04-01", "2020-04-10")
)

spectral_reduce2.1 = p2$apply(dat2, function(x, context) {
  p2$normalized_difference(x["B8"], x["B12"])
})

r2.1 = p2$save_result(
  data = spectral_reduce2.1
  , format = "GTIFF-ZIP"
)

#+ download
ofl2 = "gee_s2_ndwi.zip"
compute_result(
  r2.1,
  format = "GTIFF-ZIP",
  output_file = ofl2
)

# SERVER-ERROR: Server error: Dimension 'undefined' does not exist.

#+ process_2
spectral_reduce2.2 = p2$reduce_dimension(
  data = dat2
  , reducer = function(x, context) {
    p2$normalized_difference(x["B8"], x["B12"])
  }
  , dimension = "bands"
)

r2.2 = p2$save_result(
  data = spectral_reduce2.2
  , format = "GTIFF-ZIP"
)

compute_result(
  r2.2,
  format = "GTIFF-ZIP",
  output_file = ofl2
)

rst2.2 = raster::brick(
  unzip(
    ofl2
    , exdir = tempdir()
  )
)
dim(rst2.2)
# 401 (nrow) 1000 (ncol) 1 (nlayers)

