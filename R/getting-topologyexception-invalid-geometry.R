# Question 'Getting TopologyException: Input geom 1 is invalid which is due to self-intersection in R?' ----
# (available online: https://gis.stackexchange.com/questions/163445/getting-topologyexception-input-geom-1-is-invalid-which-is-due-to-self-intersec)

library(maps)
library(maptools)

map_states = map("state", fill = TRUE, plot = FALSE)

IDs = sapply(strsplit(map_states$names, ":"), "[[", 1)
spydf_states = map2SpatialPolygons(map_states, IDs = IDs, proj4string = CRS("+init=epsg:4326"))

plot(spydf_states)

rgeos::gIsValid(spydf_states)
