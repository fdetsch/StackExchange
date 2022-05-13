### Answer to 'Problems using `plot_gg()` from `rayshader` package - R'
### (available online: https://stackoverflow.com/q/72228610/1977053)

remotes::install_github(
  "tylermorganwall/rayshader"
)

library(rayshader)
library(ggplot2)

(
  mtplot <- ggplot(mtcars) + 
  geom_point(aes(x=mpg,y=disp,color=cyl)) + 
  scale_color_continuous(limits=c(0,8)) 
)

## with `preview = TRUE`
try(
  dev.off()
  , silent = TRUE
)

ofl1 = tempfile(fileext = ".png")

png(ofl1, width = 12, height = 8, units = "cm", res = 300)

plot1 = plot_gg(
  mtplot
  , width = 3.5
  , sunangle = 225
  , preview = TRUE
)

dev.off()

## with `preview = FALSE` (default)
plot2 = plot_gg(
  mtplot
  , width = 3.5
  , multicore = TRUE
  , windowsize = c(1400, 866)
  , sunangle = 225
  , zoom = 0.60
  , phi = 30
  , theta = 45
)

ofl2 = tempfile(fileext = ".png")

render_snapshot(
  filename = ofl2
  , clear = TRUE
)
