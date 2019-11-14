#' ---
#' title: "Comment to 'Read only certain columns from xls'"
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

#' Available online [here](https://stackoverflow.com/questions/15298800/read-only-certain-columns-from-xls).

library(readxl)

read_xlsx("data/sample.xlsx", range = cell_limits(c(1, 1), c(NA, 7)))

#'
#' ### ZZ. Final things last
#'
#' <details><summary>Session info (click to view)</summary>
devtools::session_info()
#' </details>
