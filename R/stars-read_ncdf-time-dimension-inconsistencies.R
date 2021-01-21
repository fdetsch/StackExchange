#' ---
#' title: "stars issue #378: 'read_ncdf() time dimension inconsistencies'"
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
library(openeo)
library(raster)
library(stars)

#' Available online [here](https://github.com/r-spatial/stars/issues/378).

con = connect(
  host = "https://openeo.vito.be"
  , user = "test"
  , password = "test123"
)

p = processes()

## bolzano extent
ext1 = list(
  west = 11.2792
  , south = 46.4643
  , east = 11.4072
  , north = 46.5182
)

dat = p$load_collection(
  id = "SENTINEL2_L2A_SENTINELHUB"
  , spatial_extent = ext1
  , temporal_extent = list("2020-05-02", "2020-05-12")
  , bands = "B04"
)

out = p$save_result(
  data = dat
  , format = "NetCDF"
)

ofl = compute_result(
  out
  , format = "NetCDF"
  , output_file = tempfile(
    fileext = ".ncdf"
  )
)

## raster
rst = brick(ofl)
rst@z
# $`t (days since 2020-05-03 00:00:00)`
# [1] 0 3 5 8

## stars
strs = read_ncdf(ofl)
st_get_dimension_values(strs, "t")
# [1] "2020-05-03 UTC" "2020-05-06 UTC" "2020-05-08 UTC" "2020-05-11 UTC"

ext2 = list(
  west = 8.618217
  , south = 50.06959
  , east = 8.634402
  , north = 50.07507
)

dat = p$load_collection(
  id = "SENTINEL2_L2A_SENTINELHUB"
  , spatial_extent = ext2
  , temporal_extent = list("2020-05-02", "2020-05-12")
  , bands = "B04"
)

out = p$save_result(
  data = dat
  , format = "NetCDF"
)

ofl = compute_result(
  out
  , format = "NetCDF"
  , output_file = tempfile(
    fileext = ".ncdf"
  )
)

## raster
rst = brick(ofl)
rst@z
# $`t (days since 2020-05-04 00:00:00)`
# [1] 0 5

## stars
strs = read_ncdf(ofl)
st_get_dimension_values(strs, "t")
# [1] "2020-05-01 12:00:00 UTC" "2020-05-06 12:00:00 UTC"

