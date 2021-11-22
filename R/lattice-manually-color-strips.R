### Answer to 'How to manually colour strips using function "useOuterStrips" in 
### package "latticeExtra"?'
### (available online: https://stackoverflow.com/q/33479038)

library(latticeExtra)

set.seed(1899)
mydat = data.frame(response=rnorm(400,mean=1),
                   p = factor(sample(rep(1:4,each=100))),
                   sub = factor(rep(sprintf("sub%i",1:4),each=100)),
                   seas=factor(rep(sprintf("seas%i",1:4),100)))

## set strip background colors
cbPalette = c(
  "#999999", "#E69F00", "#56B4E9", "#009E73" # top
  , "#F0E442", "#0072B2", "#D55E00", "#CC79A7" # left
)

## define core strip function
myStripStyle = function(which.panel, factor.levels, col, ...) {
  panel.rect(
    0, 0, 1, 1
    , col = col[which.panel]
    , border = 1
  )
  panel.text(
    x = 0.5
    , y = 0.5
    , lab = factor.levels[which.panel]
    , ...
  )
}

## and convenience functions for top ..
myStripStyleTop = function(which.panel, factor.levels, ...) {
  myStripStyle(
    which.panel
    , factor.levels
    , col = cbPalette[1:4]
  )
}

## .. and left strips
myStripStyleLeft = function(which.panel, factor.levels, ...) {
  myStripStyle(
    which.panel
    , factor.levels
    , col = cbPalette[5:8]
    , srt = 90 # and other arguments passed to `panel.text()`
  )
}

## assemble plot
useOuterStrips(
  bwplot(
    response ~ factor(p) | factor(sub) + factor(seas)
    , data = mydat
    , fill = cbPalette
  )
  , strip = myStripStyleTop
  , strip.left = myStripStyleLeft
)
