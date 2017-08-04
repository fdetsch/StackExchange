### Answer to 'Loop points in polygon based on subset of two columns in R -----
### (available online: https://gis.stackexchange.com/questions/250929/loop-points-in-polygon-based-on-subset-of-two-columns-in-r)

## packages
library(sp)
library(plyr)
library(dplyr)
library(microbenchmark)

## sample data
long = c(-1.747429, -1.519554, 0.430455, -2.049941, -1.288655, 1.311327, -2.217094, 0.718583, -1.646491)
lat = c(54.407632, 53.369744, 51.519982, 52.347591, 54.530768, 51.12631, 53.430349, 51.552895, 55.028696)
species = c('d', 'c', 'd', 'd', 'd', 'c', 'c', 'c', 'c')
month = c(1, 2, 3, 2, 3, 4, 3, 2, 3)

dat = data.frame(long, lat, month, species)
coordinates(dat) = ~ long + lat # set spatial context for future use
proj4string(dat) = "+init=epsg:4326"

## group into list of data.frames with species counts per month ...
## ... using dplyr in combination with plyr::dlply
microbenchmark(
  {
    dat@data %>%
      group_by(month, species) %>%
      summarise(count = n()) %>%
      dlply("month")
  },
  
  ## ... using plyr::dlply only
  {
    dat2 = dlply(dat@data, c("month", "species"), count)
    dat2 = data.frame(attr(dat2, "split_labels"), count = unlist(dat2))
    split(dat2, f = dat2$month)
  }
)
