#' ---
#' title: "plotly issue #1836: 'Set default button in rangeselector'"
#' author: "fdetsch"
#' output:
#'   html_notebook:
#'     code_folding: show
#'     toc: true
#'     toc_depth: 2
#'     toc_float: true
#'     collapsed: false
#' ---
#+ setup, include=FALSE
knitr::opts_chunk[['set']](collapse=FALSE, message=FALSE, warning=FALSE, prompt=FALSE)
#+ libs, echo=FALSE
library(plotly)

#' Available online [here](https://github.com/ropensci/plotly/issues/1836).

dat = airquality
dat$Date = as.Date(paste(1973, dat$Month, dat$Day, sep = "-"))

p0 = plot_ly(dat, x = ~ Date, y = ~ Ozone, type = "bar")

p1 = p0 %>% layout(
  xaxis = list(
    rangeselector = list(
      buttons = list(
        list(
          count = 1
          , label = "1 mo"
          , step = "month"
          , stepmode = "backward"
        )
        , list(step = "all")
      )
    )
  )
)
p1

p1 %>% layout(
  xaxis = list(
    range = c(
      {
        dt = max(dat$Date)
        lubridate::month(dt) = lubridate::month(dt) - 1
        dt
      }
      , max(dat$Date)
    )
  )
)
