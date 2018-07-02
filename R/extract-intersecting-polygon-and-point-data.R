# Answer to 'extract data of polygon shape which intersect with point shape R and create data frame'
# (available online: https://gis.stackexchange.com/questions/287846/extract-data-of-polygon-shape-which-intersect-with-point-shape-r-and-create-data/287957#287957)

library(sf)
library(mapview)

## for the sake of reproducibility, create 'Spatial' example data 
p = as(breweries, "Spatial")
li = as(franconia, "Spatial")

## convert it to 'sf'
p = st_as_sf(p)
li = st_as_sf(li)

## intersect polygons with points, keeping the information from both
pli = st_intersection(li, p)

## transform into a 'data.frame' by removing the geometry
st_geometry(pli) = NULL
head(pli)
