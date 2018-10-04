# Answer to 'Calculating block statistics from land cover raster using R?' ----
# (available online: https://gis.stackexchange.com/questions/297908/calculating-block-statistics-from-land-cover-raster-using-r)

library(raster)

r = raster(ncols = 1e2, nrows = 1e2
           , xmn = 100, xmx = 1100, ymn = 0, ymx = 1000
           , crs="+proj=lcc +lat_1=35 +lat_2=65 +lat_0=52 +lon_0=10 +x_0=4000000 +y_0=2800000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")

x = 0:5
set.seed(123)
r[] <- sample(x, 1e5, replace = TRUE)


### benchmark ----

library(microbenchmark)
library(velox)

microbenchmark(
  
  ## raster approach
  rasterAgg = {
    lst1 = lapply(unique(r), function(land_class) {
      aggregate(r, fact = 2, fun = function(vals, na.rm) {
        sum(vals == land_class, na.rm = na.rm)/length(vals)
      })
    })
  }
  
  ## velox approach
  , veloxAgg = {
    vls = r[]
    
    lst2 = lapply(unique(r), function(i) {
      # set the current land cover class to 1, everything else to 0
      ids = (vls == i)
      vls[ids] = 1; vls[!ids] = 0
      rst = setValues(r, vls)
      
      # create velox raster and aggregate
      vlx = velox(rst)
      vlx$aggregate(factor = 2, aggtype = "mean")
      vlx$as.RasterLayer()
    })
  }
  
  ## repeat every chunk n times
  , times = 10)

# Unit: milliseconds
# expr       min        lq      mean    median        uq       max neval cld
# rasterAgg 5844.2713 5950.7560 6140.8879 6186.1065 6354.8678 6370.6968    10   b
# veloxAgg   319.2344  336.5698  472.3171  375.2693  622.2361  744.8573    10  a
