# Answer to 'Points on lines in lattice plot legend in R' ----
# (available online: https://stackoverflow.com/questions/52046348/points-on-lines-in-lattice-plot-legend-in-r/52076716#52076716)

drawComboKey <- function(...) {
  key = simpleKey(...)
  key = draw.key(key, draw = FALSE)
  
  ngroups <- (length(key$children)-1)/3
  #remove points column
  key$framevp$layout$ncol        <- key$framevp$layout$ncol-3L
  key$framevp$layout$respect.mat <- key$framevp$layout$respect.mat[,-(3:5)]
  key$framevp$layout$widths      <- key$framevp$layout$widths[-(3:5)]
  
  #adjust background
  key$children[[1]]$col[2]                   <- key$children[[1]]$col[2]-3L
  key$children[[1]]$cellvp$layout.pos.col[2] <- key$children[[1]]$cellvp$layout.pos.col[2]-3L
  key$children[[1]]$cellvp$valid.pos.col[2]  <- key$children[[1]]$cellvp$valid.pos.col[2]-3L
  
  #combine lines/points
  mylines<-(2+ngroups*2):(1+ngroups*3)
  for(i in mylines) {
    key$children[[i]]$children <- gList(key$children[[i-ngroups]]$children, key$children[[i]]$children)
    key$children[[i]]$childrenOrder         <- names(key$children[[i]]$children)
    key$children[[i]]$col                   <- key$children[[i]]$col-3L
    key$children[[i]]$cellvp$layout.pos.col <- key$children[[i]]$cellvp$layout.pos.col-3L
    key$children[[i]]$cellvp$valid.pos.col  <- key$children[[i]]$cellvp$valid.pos.col-3L
  }
  
  key$childrenOrder<-names(key$children)
  key
}

library(grid)
library(lattice)
library(latticeExtra)

my.chart = xyplot(Sepal.Length + Sepal.Width ~ Petal.Length + Petal.Width, 
                  data = iris, type = "b",
                  auto.key = list(space = "left", lines = TRUE, points = TRUE)
)

my.chart$legend$left$fun = "drawComboKey" # change position according to 'space'
plot(my.chart)
