#' ---
#' title: "sf::st_transform() gives “crs not found” error"
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
library(sf)
# Linking to GEOS 3.8.0, GDAL 3.0.4, PROJ 6.3.1

#' Available online [here](https://gis.stackexchange.com/questions/387041/sfst-transform-gives-crs-not-found-error/387056#387056).

disp_win_wgs84 <- st_sf(
  st_sfc(
    st_point(
      c(-97.2, 32.55)
    )
    , st_point(
      c(-85.55, 49.2)
    )
    , crs = 4326
  )
)

disp_win_trans = sf::st_transform(
  disp_win_wgs84
  , crs = "ESRI:102003"
)

disp_win_trans
# Simple feature collection with 2 features and 0 fields
# geometry type:  POINT
# dimension:      XY
# bbox:           xmin: -112073.8 ymin: -552988 xmax: 770239.1 ymax: 1345785
# projected CRS:  USA_Contiguous_Albers_Equal_Area_Conic
# st_sfc.st_point.c..97.2..32.55....st_point.c..85.55..49.2....
# 1                                     POINT (-112073.8 -552988)
# 2                                      POINT (770239.1 1345785)