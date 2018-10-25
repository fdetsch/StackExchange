# Answer to 'point.in.poly (spatialEco) returns non-intersecting points' ----
# (available online: https://gis.stackexchange.com/questions/300088/point-in-poly-spatialeco-returns-non-intersecting-points/300131#300131)

library(rgeos)
library(sp)
library(spatialEco)
library(raster)

coords <- matrix(c(0,0,0,10,10,10,10,0,0,0),5,2,byrow=TRUE)
SA <- SpatialPolygonsDataFrame(SpatialPolygons(list(Polygons(list(Polygon(coords)),1))),data.frame(pol=1))

pts <- spsample(SA,50,"regular")
pts <- SpatialPointsDataFrame(pts,data.frame(ptid=1:length(pts)))
smallSA <- gBuffer(SA,width= - 1,byid=TRUE)
grd <- raster(extent(smallSA),resolution=2)
grd <- as(grd,"SpatialPolygons")
grd <- SpatialPolygonsDataFrame(grd,data.frame(pol=1:length(grd)))
plot(SA)
plot(grd,add=TRUE)
plot(pts,add=TRUE,col="blue",pch=20)
pts2 <- point.in.poly(pts,smallSA) # includes non-intersecting points!
plot(pts2,add=TRUE,col="red",pch=20)
length(pts)
length(pts2)

# remove non-intersecting points
pts3 <- pts2[-which(is.na(pts2$pol)==TRUE),] 
length(pts3)
plot(pts3,add=TRUE,col="blue",pch=20)


library(sf)

tmp = st_intersection(st_as_sf(pts), st_as_sf(smallSA))
pts4 = as(tmp, "Spatial")

plot(SA)
plot(grd, add = TRUE)
plot(pts4, col = "blue", pch = 20, add = TRUE)

identical(pts3, pts4)
# TRUE