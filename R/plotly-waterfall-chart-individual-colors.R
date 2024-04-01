#' ---
#' title: Answer to "How to set the color of Individual Bars of a Waterfall Chart in R Plot.ly?"
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

#' Available online: https://stackoverflow.com/a/78251263/1977053
#' 
#+ pkgs
library(plotly)

#' I have been tinkering around with the {waterfalls} package lately, which 
#' makes it easy to create and customize waterfall plots by leveraging {ggplot2}
#' and most of its logic. The plots can then be converted to {plotly} via the 
#' `ggplotly()` function.
#' 
#' If requested, the main function `waterfalls::waterfall()` calculates the 
#' overall total on the fly, so there is no need to do the math manually. I am 
#' only keeping the last row in the sample data for my second, more advanced 
#' example.
#' 
#+ data
df = data.frame(
  Variable = c("Group 1", "A", "B", "C", "D", "E", "Group 2")
  , Value = c(10, 2, 2, 2, 1, 1, 0)
  , Color = c("blue", rep("green", 5L), "yellow")
)

## convert column 'Variable' to `factor`
df$Variable = factor(
  df$Variable
  , levels = unique(df$Variable)
)

#' The following code snippet creates a basic waterfall plot. As mentioned 
#' earlier, there is no need for manual calculations as long as 
#' `calc_total = TRUE`, so the last row of data is discarded before generating 
#' the plot.
#' 
#+ base
## discard row with overall sum
sbs = utils::head(
  df
  , n = -1L
)

## generate waterfall plot
p0 = waterfalls::waterfall(
  sbs
  , rect_text_labels = paste0("$", sbs$Value)
  , calc_total = TRUE
  , total_axis_text = "Group 2"
  , total_rect_text = paste0("$", sum(sbs$Value))
  , total_rect_color = "yellow"
  , total_rect_text_color = "black"
  , total_rect_border_color = "transparent"
  , fill_colours = sbs$Color
  , fill_by_sign = FALSE
  , rect_border = "transparent"
  , draw_axis.x = "front"
) + 
  labs(
    x = NULL
    , y = NULL
  ) + 
  scale_y_continuous(
    labels = scales::dollar_format()
    , expand = c(0, 0)
  ) + 
  theme_minimal()

ggplotly(p0)

#' Let us also explore a second, more advanced example where the aim is to place
#' labels at the top of each bar as shown in your example. Although there is an 
#' argument 'put_rect_text_outside_when_value_below ' that would allow to place 
#' labels outside the boxes, it does not seem to integrate with 'calc_total' 
#' &ndash; at least not with {waterfalls} package version `‘1.0.0’`. Instead, I 
#' am usiing `ggplot2::geom_text()` for a finer control over customized text 
#' annotations.  
#' 
#+ advanced
## create custom labels
df$Text = ifelse(
  df$Variable == "Group 2"
  , cumsum(df$Value)
  , df$Value
)

## add offset for label placement (+5% of total)
df$Position = cumsum(df$Value) + 
  0.05 * sum(df$Value)

## generate advanced waterfall plot
p1 = waterfalls::waterfall(
  sbs
  # "turn off" text labels
  , rect_text_labels = rep("", nrow(sbs))
  , calc_total = TRUE
  , total_axis_text = "Group 2"
  # "turn off" total text label
  , total_rect_text = ""
  , total_rect_color = "yellow"
  , total_rect_border_color = "transparent"
  , fill_colours = sbs$Color
  , fill_by_sign = FALSE
  , rect_border = "transparent"
  , draw_axis.x = "front"
) + 
  geom_text(
    aes(
      x = Variable
      , y = Position
      , label = paste0("$", Text)
    )
    , data = df
    , inherit.aes = FALSE
  ) + 
  labs(
    x = NULL
    , y = NULL
  ) + 
  scale_y_continuous(
    labels = scales::dollar_format()
  ) + 
  theme_minimal()

ggplotly(p1)
