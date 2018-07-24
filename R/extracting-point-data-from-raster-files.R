# Answer to 'Extracting point data from raster files'
# (available online: https://gis.stackexchange.com/questions/290401/extracting-point-data-from-raster-files)

library(remote)
library(reshape2)

## example raster data
data(vdendool)
tmp = unstack(vdendool)

## create random points
set.seed(123)
pts = sampleRandom(vdendool, size = 5, sp = TRUE)

coords = coordinates(pts)


### option #1: extract using *apply loop ----
xtr = do.call("cbind", lapply(tmp, extract, pts))
colnames(xtr) = names(vdendool)

out = data.frame(coords, xtr)

## if required, transform 'data.frame' from wide into long format
out = melt(out, id.vars = 1:2, variable.name = "layer")


### option #2: use stacked Raster* objects -----

rst = stack(tmp)
xtr = extract(rst, pts)
out = data.frame(coords, xtr)

## same here, use reshape2::melt to bring 'data.frame' into long format