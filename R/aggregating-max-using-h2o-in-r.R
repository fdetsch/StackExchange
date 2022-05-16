### Answer to 'Aggregating Max using h2o in R' ----
### (available online: https://stackoverflow.com/q/72253927/1977053)

## initialize h2o
library(h2o)

h2o.init(
  nthreads = parallel::detectCores() * 0.5
)

## generate sample data
df <- data.frame("ID" = 1:16)
df$Group<- c(1,1,1,1,2,2,2,3,3,3,4,4,5,5,5,5)
df$VarA <- c(NA_real_,1,2,3,12,12,12,12,0,14,NA_real_,14,16,16,NA_real_,16)
df$VarB <- c(NA_real_,NA_real_,NA_real_,NA_real_,10,12,14,16,10,12,14,16,10,12,14,16)
df$VarD <- c(10,12,14,16,10,12,14,16,10,12,14,16,10,12,14,16)

df_h2o = as.h2o(
  df
)

## aggregate per group
df_h2o |> 
  
  # convert to long format
  h2o.melt(
    id_vars = "Group" # include "ID" here if you want it as identifier column
    , skipna = TRUE # does not include `NA` in the result
  ) |> 
  
  # calculate `max()` per group
  h2o.ddply(
    .variables = c("Group", "variable")
    , FUN = function(df) {
      max(df[, 3])
    }
  ) |> 
  
  # convert back to wide format
  h2o.pivot(
    index = "Group"
    , column = "variable"
    , value = "ddply_C1"
  )

# Group ID VarA VarB VarD
#     1  4    3  NaN   16
#     2  7   12   14   14
#     3 10   14   16   16
#     4 12   14   16   16
#     5 16   16   16   16
# 
# [5 rows x 5 columns] 

## shut down h2o instance
h2o.shutdown(
  prompt = FALSE
)
