### Answer to 'How to use rbind with SPDFs when the number of columns of arguments do not match?' -----
### (available online: https://gis.stackexchange.com/questions/267284/how-to-use-rbind-with-spdfs-when-the-number-of-columns-of-arguments-do-not-match/267355#267355)

library(raster)

France_map <- getData(name = "GADM", country = "FRA", level = 0, path = "D:/Data/GADM")
Germany_map <- getData(name = "GADM", country = "DEU", level = 1, path = "D:/Data/GADM")
Belgium_map <- getData(name = "GADM", country = "BEL", level = 2, path = "D:/Data/GADM")

## two-step approach
df = plyr::rbind.fill(France_map@data, Germany_map@data, Belgium_map@data)
spdf = SpatialPolygonsDataFrame(bind(as(France_map, "SpatialPolygons")
                                     , as(Germany_map, "SpatialPolygons")
                                     , as(Belgium_map, "SpatialPolygons"))
                                , data = df)

## all-in-one
out1 = bind(France_map, Germany_map, Belgium_map)

countries = list(France_map, Germany_map, Belgium_map)
out2 = do.call(bind, countries)

identical(out1, out2)
