# Answer to 'Crop (bounding) box across 180 deg meridian'
# (available online: https://gis.stackexchange.com/questions/279957/crop-bounding-box-across-180-meridian)

## sample data
library(remote)
data(vdendool)

## see above for details
x1 <- crop(vdendool, extent(-180, 0, 20, 90)) # for global grid: -180, 0, -90, 90
x2 <- crop(vdendool, extent(0, 180, 20, 90))  # for global grid: 0, 180, -90, 90
extent(x1) <- c(180, 360, 20, 90)
m <- merge(x1, x2)

cropbox2 <-c(120, 230, 70, 90)
crop2 <- crop(m, cropbox2)

## verify extent
extent(crop2)

## display layers 1 to 4
spplot(crop2[[1:4]], scales = list(draw = TRUE))
