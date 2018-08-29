# Answer to 'xyplot in R with several plots in one panel, lattice' ----
# (available online: https://stackoverflow.com/questions/51983606/xyplot-in-r-with-several-plots-in-one-panel-lattice/52073567#52073567

library(lattice)

d <- seq.Date(as.Date("2000-01-01"), as.Date("2000-01-08"), by=1)
df1 <- data.frame(time = d, type = 'type1', value = runif(length(d)))
df2 <- data.frame(time = d, type = 'group1', value = runif(length(d)))
df3 <- data.frame(time = d, type = 'group2', value = runif(length(d)))
df4 <- data.frame(time = d, type = 'pen', value = runif(length(d)))
df <- rbind(df1, df2, df3, df4)

# colors
clr = c("black", "black", "orange", "black")
names(clr) = levels(df$type) # for clarification only

# grouped scatterplot
xyplot(value~time | gsub("group[[:digit:]]", "group", type), df, group = type
       , layout = c(1, length(levels(df$type)) - 1), col = clr, cex = 1.2, pch = 20)
