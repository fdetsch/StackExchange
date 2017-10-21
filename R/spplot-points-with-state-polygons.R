### Answer to 'R-help: How to draw the same legend (one legend) for	the multiple spatial figures?'
### (available online: https://stat.ethz.ch/pipermail/r-sig-geo/2017-October/026101.html)

library(spgwr)
library(spdep)
library(maps)
library(maptools)

data<-read.csv("data/try.csv",header=TRUE)
coords=cbind(data$Longitude,data$Latitude)
g.adapt.gauss <- gwr.sel(y~x, data,coords,adapt=TRUE)
res.adpt <- gwr(y~x, data,coords, adapt=g.adapt.gauss)
brks <- c(-0.25, 0, 0.01, 0.025, 0.075)
cols <- grey(5:2/6)
res.adpt$SDF$ols.e <- residuals(lm(y~x, data))

## download state polygons for the us
library(raster)
usa = getData("GADM", country = "USA", level = 1, path = "data")

## create subset of state polygons (otherwise spplot() will take quite long) 
proj4string(res.adpt$SDF) = "+init=epsg:4326"

ext = extend(extent(res.adpt$SDF), 2.5)
states = crop(usa, ext)

## add state boundaries to spplot() using 'sp.layout'
p = spplot(res.adpt$SDF, c("ols.e","gwr.e"), main = "Residuals", 
           sp.layout = list("sp.polygons", states))
p
