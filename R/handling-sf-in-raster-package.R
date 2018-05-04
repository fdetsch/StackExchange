# Answer to 'R: Handling of sf objects in raster package' ----
# (available online: https://stackoverflow.com/questions/42927384/r-handling-of-sf-objects-in-raster-package/50137902#50137902)

library(raster)
library(sf)

r <- raster(nrow=45, ncol=90)
r[] <- 1:ncell(r)

# crop Raster* with sf object
b <- as(extent(0, 8, 42, 50), 'SpatialPolygons')
crs(b) <- crs(r)
b <- st_as_sf(b) # convert polygons to sf
rb <- crop(r, b)

# mask Raster* with sf object
mb <- mask(r, b)
