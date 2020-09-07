#' ---
#' title: "Answer to 'ggplotly fails with geom_vline() with xintercept Date value'"
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

#' Available online [here](https://stackoverflow.com/questions/55150087/ggplotly-fails-with-geom-vline-with-xintercept-date-value).

library(plotly)
library(ggplot2) 

set.seed(1)
df <- data.frame(
  date = seq(from = lubridate::ymd("2019-01-01"), by = 1, length.out = 10),
  y = rnorm(10)
)

p <- df %>% 
  ggplot(aes(x = date, y = y)) + 
  geom_line() 

p2 = p + 
  geom_vline(
    aes(
      xintercept = as.numeric(lubridate::ymd("2019-01-08"))
      , text = "date: 2019-01-08"
    )
    , linetype = "dashed"
  )

ggplotly(p2, tooltip = c("x", "y", "text"))