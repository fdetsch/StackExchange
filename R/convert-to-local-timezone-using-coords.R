# Answer to 'convert to local time zone using latitude and longitude?'
# (available online: https://stackoverflow.com/questions/23414340/convert-to-local-time-zone-using-latitude-and-longitude/49996425?noredirect=1#comment87009946_49996425)

library(sf)

## example data
dat = data.frame(lon = -2
                 , lat = 13
                 , time1 = as.POSIXlt("2014-02-12 17:00:00", tz = "EST"))

## convert to 'sf' object
sdf = st_as_sf(dat, coords = c("lon", "lat"), crs = 4326)

## import timezones (download from 
## https://github.com/evansiroky/timezone-boundary-builder/releases/download/2018d/timezones.geojson.zip) 
## and intersect with spatial points
tzs = st_read("timezones.geojson/combined.json", quiet = TRUE)
sdf = st_join(sdf, tzs)

## convert timestamps to local time
sdf$timeL = as.POSIXlt(sdf$time1, tz = as.character(sdf$tzid))
sdf$timeL
