# `$rolling()` count with temporal window ignores decimal seconds
2023-12-11

- [Setup](#setup)
- [R Approach](#r-approach)
- [Solutions](#solutions)
  - [Python](#python)
  - [Parse date strings in polars](#parse-date-strings-in-polars)
  - [Manual conversion](#manual-conversion)
  - [Use slider package](#use-slider-package)

(available online
[here](https://github.com/pola-rs/r-polars/issues/578))

## Setup

I have a set of high-resolution time series data on which I need to
perform rolling operations with time-based windows. Here is some sample
data for replication purposes:

``` r
library(polars)

## print pkg version
print(
  utils::packageVersion("polars")
)
```

    [1] '0.11.0'

## R Approach

``` r
x = c(
  "2020-01-01 13:45:48.343", "2020-01-01 13:45:48.815"
  , "2020-01-01 13:45:49.289", "2020-01-01 13:45:49.974"
  , "2020-01-01 13:45:51.190", "2020-01-01 13:45:51.631"
)
```

Now, when performing a simple rolling count over a 1-second moving
window, the outcome looks as follows:

``` r
## create {polars} `DataFrame`
df1 = pl$DataFrame(
  "ts" = as.POSIXct(
    x
    , tz = "UTC"
  )
)

## set sorted
df1 = df1$with_columns(
  pl$col("ts")$set_sorted()
)

## perform rolling count
df1$with_columns(
  "n" = pl$count("ts")$
    rolling(
      index_column = "ts"
      , period = "1s"
      , closed = "both"
    )
)
```

    shape: (6, 2)
    ┌─────────────────────────┬─────┐
    │ ts                      ┆ n   │
    │ ---                     ┆ --- │
    │ datetime[ms, UTC]       ┆ u32 │
    ╞═════════════════════════╪═════╡
    │ 2020-01-01 13:45:48 UTC ┆ 2   │
    │ 2020-01-01 13:45:48 UTC ┆ 2   │
    │ 2020-01-01 13:45:49 UTC ┆ 4   │
    │ 2020-01-01 13:45:49 UTC ┆ 4   │
    │ 2020-01-01 13:45:51 UTC ┆ 2   │
    │ 2020-01-01 13:45:51 UTC ┆ 2   │
    └─────────────────────────┴─────┘

Given the sample data, I would expect the resulting count to start at
`1L` and then increase up to `3L` at the 3rd position as more values
fall in the 1-second lookback period. However, it seems like decimal
seconds are disregarded entirely and all timestamps within the full
second are considered instead.

## Solutions

### Python

I also tested this in Python using the exact same sample data, which
gives the expected result:

``` python
import polars as pl

## print pkg version
print(pl.__version__, 
      flush=True)
```

    0.19.19

``` python
df = (
  pl.DataFrame(
    {
      "ts": [
        "2020-01-01 13:45:48.343", "2020-01-01 13:45:48.815", 
        "2020-01-01 13:45:49.289", "2020-01-01 13:45:49.974", 
        "2020-01-01 13:45:51.190", "2020-01-01 13:45:51.631"
      ]
    }
  )
  # convert to datetime
  .with_columns(
    pl.col("ts").str.to_datetime(time_unit = "ms", time_zone = "UTC")
  )
  # set sorted
  .set_sorted("ts")
)

# perform rolling count
df.with_columns(
  pl.count("ts")
    .rolling(index_column = "ts", period = "1s", closed = "both")
    .alias("n")
)
```

    shape: (6, 2)
    ┌─────────────────────────────┬─────┐
    │ ts                          ┆ n   │
    │ ---                         ┆ --- │
    │ datetime[ms, UTC]           ┆ u32 │
    ╞═════════════════════════════╪═════╡
    │ 2020-01-01 13:45:48.343 UTC ┆ 1   │
    │ 2020-01-01 13:45:48.815 UTC ┆ 2   │
    │ 2020-01-01 13:45:49.289 UTC ┆ 3   │
    │ 2020-01-01 13:45:49.974 UTC ┆ 2   │
    │ 2020-01-01 13:45:51.190 UTC ┆ 1   │
    │ 2020-01-01 13:45:51.631 UTC ┆ 2   │
    └─────────────────────────────┴─────┘

What’s strange is that in R, decimal seconds are not printed despite the
indicated temporal resolution `ms` – something that cannot be resolved
through overriding the print behavior for decimal seconds via
`options("digits.secs" = 3L)`. Otherwise, I do not see an apparent
difference between the two versions.

### Parse date strings in polars

See
[pola-rs/r-polars/issues/578#issuecomment-1845542575](https://github.com/pola-rs/r-polars/issues/578#issuecomment-1845542575).

``` r
if (utils::packageVersion("polars") >= "0.11.0.9001") {
  
  df2 = pl$DataFrame(
  "ts" = x
  )
  
  ## convert from string to datetime
  df2 = df2$with_columns(
    pl$col("ts")$str$to_datetime(time_unit = "ms", time_zone = "UTC")$set_sorted()
  )
  
  df2$with_columns(
    "n" = pl$count("ts")$
      rolling(
      index_column = "ts",
      period = "1s",
      closed = "both"
    )
  )
}
```

### Manual conversion

See
[pola-rs/r-polars/issues/578#issuecomment-1846073495](https://github.com/pola-rs/r-polars/issues/578#issuecomment-1846073495).

``` r
x1 = as.POSIXct(
  x
  , tz = "UTC"
)

pl$
  DataFrame(
    "ts" = x1
  )$
  with_columns(
    pl$col("ts")$
      cast(pl$Int64)$
      alias("raw_value")
    , (pl$lit(as.numeric(x1)) * 1000)$
        cast(pl$Datetime("ms",tz = "UTC"))$
        alias("ts_manual")$
        set_sorted()
  )$
  with_columns(
    "n" = pl$count("ts")$
      rolling(
        index_column = "ts_manual",
        period = "1s",
        closed = "both"
      )
  )
```

    shape: (6, 4)
    ┌─────────────────────────┬───────────────┬─────────────────────────────┬─────┐
    │ ts                      ┆ raw_value     ┆ ts_manual                   ┆ n   │
    │ ---                     ┆ ---           ┆ ---                         ┆ --- │
    │ datetime[ms, UTC]       ┆ i64           ┆ datetime[ms, UTC]           ┆ u32 │
    ╞═════════════════════════╪═══════════════╪═════════════════════════════╪═════╡
    │ 2020-01-01 13:45:48 UTC ┆ 1577886348000 ┆ 2020-01-01 13:45:48.343 UTC ┆ 1   │
    │ 2020-01-01 13:45:48 UTC ┆ 1577886348000 ┆ 2020-01-01 13:45:48.815 UTC ┆ 2   │
    │ 2020-01-01 13:45:49 UTC ┆ 1577886349000 ┆ 2020-01-01 13:45:49.289 UTC ┆ 3   │
    │ 2020-01-01 13:45:49 UTC ┆ 1577886349000 ┆ 2020-01-01 13:45:49.974 UTC ┆ 2   │
    │ 2020-01-01 13:45:51 UTC ┆ 1577886351000 ┆ 2020-01-01 13:45:51.190 UTC ┆ 1   │
    │ 2020-01-01 13:45:51 UTC ┆ 1577886351000 ┆ 2020-01-01 13:45:51.631 UTC ┆ 2   │
    └─────────────────────────┴───────────────┴─────────────────────────────┴─────┘

### Use slider package

See
[pola-rs/r-polars/issues/578#issuecomment-1847345605](https://github.com/pola-rs/r-polars/issues/578#issuecomment-1847345605).

``` r
df = data.frame(
  "ts" = as.POSIXct(
    x
    , tz = "UTC"
  )
)

transform(
  df
  , n = slider::slide_index_int(
    .x = ts,
    .i = ts,
    .f = \(x) length(x),
    .before = lubridate::seconds(1),
    .after = 0L
  )
)
```

                       ts n
    1 2020-01-01 13:45:48 1
    2 2020-01-01 13:45:48 2
    3 2020-01-01 13:45:49 3
    4 2020-01-01 13:45:49 2
    5 2020-01-01 13:45:51 1
    6 2020-01-01 13:45:51 2
