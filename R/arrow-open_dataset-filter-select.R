### Answer to 'Working with big data sets in R with parquet' ----
### (available online: https://stackoverflow.com/a/77860894)

library(arrow)
library(dplyr)

## write sample .parquet data
dat = transform(
  airquality
  , Year = 1973
)

write_dataset(
  dat
  , path = "~/Downloads/airquality"
  , format = "parquet"
  , partitioning = c(
    "Year"
    , "Month"
  )
  , basename_template = "data-part-{i}.parquet"
  , existing_data_behavior = "overwrite"
  , compression = "gzip"
)

## read subset of rows and columns back into r
open_dataset(
  "~/Downloads/airquality"
) |> 
  filter(
    Month == 6L
  ) |> 
  select(
    Day
    , Temp
  ) |> 
  collect()

