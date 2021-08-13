### `slope()` returns unrealistic angles
# (available online: https://github.com/michaeldorman/starsExtra/issues/3)


### raster ----

library(raster)

rst = "inst/extdata/dem-nad83.tif" |> 
  raster()

trn = terrain(
  rst
  , unit = "degrees"
)

quantile(
  trn
)
#        0%        25%        50%        75%       100% 
# 0.2190702 13.0571141 16.8310452 21.4173564 31.0428911 


### stars ----

library(starsExtra)

strs = "inst/extdata/dem-nad83.tif" |> 
  read_stars()

slp = slope(
  strs
)

quantile(
  slp[[1]]
  , na.rm = TRUE
)
#       0%      25%      50%      75%     100% 
# 89.86296 89.99725 89.99796 89.99840 89.99904 

## project --> failure
strs = "dem-nad83.tif" |> 
  read_stars() |> 
  st_transform(
    crs = 32611
  )

slp = slope(
  strs
)


### vis ----

library(mapview)

mapview(
  slp
  , layer.name = "starsExtra"
) + 
  mapview(
    trn
    , layer.name = "raster"
  )
