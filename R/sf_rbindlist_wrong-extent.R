library(sf)
library(tinytest)

## prepare sample data
data(
  meuse
  , package = "sp"
)

meuse_sf = st_as_sf(
  meuse[1:20, ]
  , coords = c(
    "x"
    , "y"
  )
  , crs = 28992L
)

meuse_lst = split(
  meuse_sf
  , f = rep(1:2, each = 10L)
)


### compare concatenated outputs against original data ----

## base `rbind()`
meuse_base = do.call(
  rbind
  , meuse_lst
)

expect_identical(
   st_bbox(meuse_base)
  , target = st_bbox(meuse_sf)
  , info = "base `rbind()` produces expected boundary"
)

## {dplyr} `bind_rows()`
meuse_dplyr = dplyr::bind_rows(meuse_lst)

expect_identical(
   st_bbox(meuse_dplyr)
  , target = st_bbox(meuse_sf)
  , info = "`dplyr::bind_rows()` produces expected boundary"
)

## {data.table} `rbindlist()`
meuse_dt = st_as_sf(
  data.table::rbindlist(meuse_lst)
)

expect_identical(
   st_bbox(meuse_dt)
  , target = st_bbox(meuse_sf)
  , info = "`data.table::rbindlist()` produces expected boundary"
)

expect_identical(
  st_coordinates(meuse_dt)
  , target = st_coordinates(meuse_base)
  , info = "point coordinates of {data.table} and {dplyr} output are identical"
)
