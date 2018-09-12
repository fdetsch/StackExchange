# Answer to 'IS there a way to get MODIS tiles as a function of lat/long in R?' ----
# (available online: https://stackoverflow.com/questions/48793558/is-there-a-way-to-get-modis-tiles-as-a-function-of-lat-long-in-r)

# devtools::install_github("MatMatt/MODIS", ref = "develop")
library(MODIS)

## set point coordinates (taken from https://en.wikipedia.org/wiki/Frankfurt)
dat = data.frame(lon = 8.682222, lat = 50.110556, loc = "Frankfurt am Main")
pts = sf::st_as_sf(dat, coords = c("lon", "lat"), crs = 4326)

## get overlying tile
tls = getTile(pts)
tls@tile
# [1] "h18v03"