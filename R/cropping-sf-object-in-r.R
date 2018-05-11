# Answer to 'Cropping sf object in R?' (added as comment to answer by @sebdelgarno) ----
# (available online: https://gis.stackexchange.com/questions/282524/cropping-sf-object-in-r)

library(cancensus)
library(sf)

options(cancensus.api_key = "CensusMapper_1939f5467f9ab0103dcdd03635321ff2")
census_data <- get_census(dataset='CA16', regions=list(CMA="59933"),
                          vectors=c("v_CA16_408","v_CA16_409","v_CA16_410"),
                          level='CSD', geo_format = "sf", labels="short")

box = st_bbox(c(xmin = -122.9, xmax = -122.5, ymin = 49.1, ymax = 49.3)
              , crs = st_crs(4326))
box = st_as_sfc(box) # see https://github.com/r-spatial/sf/issues/572

ont_crop <- st_intersection(census_data, box)
ont_join <- st_join(census_data, box)


