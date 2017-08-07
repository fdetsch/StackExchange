### Answer to 'R-help: How to draw the same legend (one legend) for	the multiple spatial figures?'
### (available online: https://stat.ethz.ch/pipermail/r-sig-geo/2017-August/025899.html)

## sample data
library(sp)
data("meuse.grid")
gridded(meuse.grid) = ~ x + y
meuse.grid$dist2 = meuse.grid$dist^2

p1 = spplot(meuse.grid, zcol = "dist", at = seq(0, 1, .01), 
            sp.layout = list("sp.text", c(179000, 333250), "a) dist"), 
            colorkey = list(height = .5), scales = list(draw = TRUE))
p2 = spplot(meuse.grid, zcol = "dist2", at = seq(0, 1, .01), 
            sp.layout = list("sp.text", c(179000, 333250), "b) dist2"))

## combine plots using latticeExtra::c.trellis
update(c(p1, p2), layout = c(1, 2), as.table = TRUE) # 1 column, 2 rows
update(c(p1, p2)) # 1 row, 2 columns
