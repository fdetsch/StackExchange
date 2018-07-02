# Answer to 'cannot plot negative longitude values in PlotOnStaticMap in R'
# (available online: https://stackoverflow.com/questions/50643577/cannot-plot-negative-longitude-values-in-plotonstaticmap-in-r)

library(RgoogleMaps)

## example data
df1 = data.frame(lon = c(0.02310676, -0.04666115, 0.09730595, 0.02458385)
                 , lat = c(51.39729, 51.40614, 51.38398, 51.39580)
                 , grp = c("0", "0", "0", "1"))

center = c(51.389486, 0.036657)

## get google map
dfl = tempfile(fileext = ".png")
mm = GetMap(center, zoom = 12, maptype = "roadmap", destfile = dfl)

## display map with points
par(pty = "s")
PlotOnStaticMap(mm, lat = df1$lat, lon = df1$lon, pch = 20, col = df1$grp, cex = 2.3)
