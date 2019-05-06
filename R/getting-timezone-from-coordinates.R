# Answer to 'Getting time-zones from latitude and longitude in raster using R?' ----
# (available online: https://gis.stackexchange.com/questions/142869/getting-time-zones-from-latitude-and-longitude-in-raster-using-r/321796)

library(USAboundaries)
library(lutz)

cts = us_cities()
tzs = tz_lookup(cts)
table(tzs)