# Answer to 'R Raster: extract weighted mean within circle of specific radius' ----
# (available online: https://gis.stackexchange.com/questions/294317/r-raster-extract-weighted-mean-within-circle-of-specific-radius/294437#294437)

WOA <- readRDS('data/WOA.RDS')

xy <- data.frame(x = -40, y = 60)

## transform point data to 'SpatialPoints'
coordinates(xy) <- ~ x + y
proj4string(xy) <- "+init=epsg:4326"

## create 100-km buffer
xy_utm = spTransform(xy, CRS("+init=epsg:32621"))
gbf_utm = rgeos::gBuffer(xy_utm, width = 1e5, quadsegs = 250L)
gbf = spTransform(gbf_utm, CRS(proj4string(xy)))

## extract values and calculate weighted mean
vls = extract(WOA, gbf, weights = TRUE)[[1]]
sum(vls[, 1] * vls[, 2])

