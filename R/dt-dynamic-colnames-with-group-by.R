### Answer to 'R data.table dynamic column name of group by returning new table'
### (available online: https://stackoverflow.com/q/59576235)

library(data.table)

set.seed(123)
dt = data.table(
  a = sample(1:100, 100)
  , b = sample(1:100, 100)
  , id = rep(1:10, 10)
)

## 1 column
dt[
  , Map(
    function(i) {
      mean(a)
    }
    , i = "Mean"
  )
  , by = id
]

## 2+ columns
dt[
  , Map(
    function(i, fun) {
      do.call(
        fun
        , list(a)
      )
    }
    , i = c("Mean", "SD")
    , fun = c(mean, sd)
  )
  , by = id
]

# id Mean       SD
# 1:  1 56.8 29.23012
# 2:  2 50.5 26.18842
# 3:  3 50.5 24.82047
# 4:  4 42.4 34.72495
# 5:  5 49.9 26.99979
# 6:  6 47.8 28.35411
# 7:  7 60.6 31.52142
# 8:  8 57.4 32.22904
# 9:  9 54.6 27.90141
# 10: 10 34.5 30.94529