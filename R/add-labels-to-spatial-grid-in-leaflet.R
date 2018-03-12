### Answer to 'R: Add labels to spatial grid in leaflet -----
### (available online: https://gis.stackexchange.com/questions/274288/r-add-labels-to-spatial-grid-in-leaflet/274421?noredirect=1#comment437557_274421)

library(dplyr)
library(rgeos)
library(mapview)
library(leaflet)
library(raster)
library(stringr)
library(rgdal)

# # reading in shapefiles for the entire US (not included here due to memory 
# # issues, downloaded from 
# # https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2017&layergroup=Urban+Areas)
# urban_areas <- shapefile("data/tl_2017_us_uac10/tl_2017_us_uac10.shp")
# 
# # pulling out only Albuquerque, NM shapefiles
# albuq <- subset(urban_areas, str_detect(NAME10, "Albuquerque, NM"))
# writeOGR(albuq, "data/tl_2017_us_uac10", "tl_2017_albuquerque_uac10"
#          , driver = "ESRI Shapefile")

albuq <- shapefile("data/tl_2017_us_uac10/tl_2017_albuquerque_uac10.shp")

# determine the bounding box of the city boundary
e <- extent(albuq)

# convert to a raster object
r <- raster(e)
projection(r) <- proj4string(albuq)

# add label ID to our grid cells
r <- setValues(r, 1:ncell(r))

# reconvert back to shapefile with the goal of creating a popup of the cell ID for each polygon
shape <- rasterToPolygons(r, dissolve = TRUE)

# clip the grid cells that contain the Albuquerque polygon
p <- shape[albuq, ]

# trim the grid perimeter to match the Albuquerque polygon
map <- gIntersection(p, albuq, byid = TRUE, drop_lower_td = TRUE)


spy = SpatialPolygonsDataFrame(map
                               , data = data.frame(ID = p@data$layer)
                               , match.ID = FALSE)

## display data
m1 = mapview(spy
             , map.types = "OpenStreetMap" # see mapviewGetOption("basemaps")
             , col.regions = "transparent"
             , alpha.regions = .05)
m1

## find centroid coordinates
cnt = rgeos::gCentroid(spy, byid = TRUE)
crd = data.frame(coordinates(cnt))

## add text labels
m2 = m1@map %>%
  addLabelOnlyMarkers(lng = ~ x, lat = ~ y, data = crd
                      , label = as.character(p@data$layer)
                      , labelOptions = labelOptions(noHide = TRUE
                                                    , direction = 'top'
                                                    , textOnly = TRUE)) 
m2
