# Answer to 'Random Error on getGeoCode Rgooglemaps' -----
# (available online: https://gis.stackexchange.com/questions/267449/random-error-on-getgeocode-rgooglemaps/272744#272744)

library(RgoogleMaps)
library(foreach)

###Replicating a large search data###
PlaceVector <- c(rep("Anchorage,Alaska", 20), rep("Baltimore,Maryland", 20), 
                 rep("Birmingham,Alabama", 20))
iters <- length(PlaceVector)
###Looping to get each geocode###
geoadd <- foreach(a = 1:iters, .combine = rbind) %do% {
  gcd = getGeoCode(paste(PlaceVector[a]))
  
  while (all(is.na(gcd))) {
    gcd = getGeoCode(paste(PlaceVector[a]))
  }
  
  return(gcd)
}

all(!is.na(geoadd))

geoadd <- as.data.frame(geoadd)
geoadd$Place <- PlaceVector
geoadd
