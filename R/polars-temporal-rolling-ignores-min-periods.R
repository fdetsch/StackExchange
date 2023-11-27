### Question "`$rolling()` method with temporal window ignores `min_periods`" ----
### (available online: https://github.com/pola-rs/r-polars/issues/546)

## install {polars}, see https://github.com/pola-rs/r-polars for options
if (navl <- !"polars" %in% utils::installed.packages()[, "Package"]) {
  
  not_cran = Sys.getenv("NOT_CRAN")
  Sys.setenv(NOT_CRAN = "true")
  
  utils::install.packages(
    "polars"
    , repos = "https://rpolars.r-universe.dev"
  )
}

library(polars)

## prepare sample data
dat = transform(
  airquality
  , "Date" = as.Date(
    paste(
      "1973"
      , Month
      , Day
      , sep = "-"
    )
  )
) |> 
  as_polars_df()

## set sorted flag
dat = dat$
  with_columns(
    pl$col("Date")$set_sorted()
  )

## compute rolling 10% quantile ..
dat$
  with_columns(
    # .. with fixed integer window
    roll_quant_int = pl$
      col("Temp")$
      rolling_quantile(
        0.1
        , window_size = 5L
        , min_periods = 3L
        , by = "Date"
        , closed = "both"
      )
    # .. with dynamic temporal window
    , roll_quant_time = pl$
      col("Temp")$
      rolling_quantile(
        0.1
        , window_size = "4d"
        , min_periods = 3L
        , by = "Date"
        , closed = "both"
      )
  )

## reset options
if (navl) {
  Sys.setenv(NOT_CRAN = not_cran)
}