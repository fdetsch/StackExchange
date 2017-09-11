library(corrplot)

## create and visualize correlation matrix
data(mtcars)
M <- cor(mtcars)

corrplot(M, cl.pos = "n", na.label = " ", addgrid.col = "grey80")

## select cells to highlight (e.g., statistically significant values)
set.seed(10)
ids <- sample(1:length(M), 15L)

## duplicate correlation matrix and reject all irrelevant values
N <- M
N[-ids] <- NA

## add significant cells to the initial corrplot iteratively 
for (i in ids) {
  O <- N
  O[-i] <- NA
  corrplot(O, cl.pos = "n", na.label = " ", addgrid.col = "black", add = TRUE, 
           bg = "transparent", tl.col = "transparent")
}

