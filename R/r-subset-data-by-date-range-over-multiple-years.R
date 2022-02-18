### Answer to 'r subset dataset by date range over multiple years'
### (available online: https://stackoverflow.com/q/48614305/1977053)

## dummy data
dates = seq(
  as.POSIXct("1996-06-10 12:00:00")
  , as.POSIXct("1996-06-15 12:00:00")
  , "1 day"
)

dat = data.frame(
  DATE = dates
  , A = c(178.0, 184.1, 187.2, 194.4, 200.3, 138.9)
  , B = c(24.1, 30.2, 29.4, 35.0, 35.9, 15.1)
  , C = c(1.7, 1.1, 1.8, 5.3, 1.5, 0.0)
)

## convert dates to julian day
dat$JULDAY = format(
  dat$DATE
  , "%j"
)

## target date (here 29 june) as julian day
dat$TARGET = ifelse(
  as.integer(
    format(
      dat$DATE
      , "%y"
    )
  ) %% 4 == 0
  , 171 # leap year
  , 170 # common year
)

## create subset
subset(
  dat
  , JULDAY >= (TARGET - 5) & JULDAY <= (TARGET + 5)
  , select = c("DATE", "A", "B", "C")
)

#         DATE     A    B   C
# 5 1996-06-14 12:00:00 200.3 35.9 1.5
# 6 1996-06-15 12:00:00 138.9 15.1 0.0