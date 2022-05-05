### Answer to 'Creating start date based on end date of prior observation for multiple observations by group'
### (available online: https://stackoverflow.com/q/72113595/1977053)

## sample code
df.have  <- data.frame(id=c(1,1,1,2,2,2,3,3,3),
                       episode_num=c(1,2,3,1,2,3,1,2,3),
                       start_date=as.Date(c("1/1/2001", NA, NA, "5/1/2001", NA, NA, "10/1/1001", NA, NA), "%m/%d/%y"),
                       episode_length=c(10,4,5,20,3,2,1,9,8))

df.want <- df <- data.frame(id=c(1,1,1,2,2,2,3,3,3),
                            episode_num=c(1,2,3,1,2,3,1,2,3),
                            start_date=as.Date(c("1/1/01", "1/12/01","1/17/01","5/1/01","5/22/01","5/26/01","10/1/01","10/3/01","10/13/01"),"%m/%d/%y"),
                            end_date= as.Date(c("1/11/01","1/16/01","1/22/01","5/21/01","5/25/01","5/28/01","10/2/01","10/12/01","10/21/01"), "%m/%d/%y"),
                            episode_length=c(10,4,5,20,3,2,1,9,8))


### solution ----

library(data.table)

dt.have = data.table(
  df.have
)

## calculate remaining start dates per id
dt.have[
  , start_date := min(
    start_date
    , na.rm = TRUE
  ) + c(
    0
    , cumsum(
      episode_length[-.N] + 1 # exclude last episode_length per group from cumsum() since there is no subsequent start_date
    )
  )
  , by = id
]

## append end dates
dt.have[
  , end_date := start_date + episode_length
]

df.out = data.frame(
  dt.have
)

# id episode_num start_date episode_length   end_date
#  1           1 2020-01-01             10 2020-01-11
#  1           2 2020-01-12              4 2020-01-16
#  1           3 2020-01-17              5 2020-01-22
#  2           1 2020-05-01             20 2020-05-21
#  2           2 2020-05-22              3 2020-05-25
#  2           3 2020-05-26              2 2020-05-28
#  3           1 2010-10-01              1 2010-10-02
#  3           2 2010-10-03              9 2010-10-12
#  3           3 2010-10-13              8 2010-10-21


### dplyr ----

library(dplyr)

df.have |> 
  
  # group by id
  group_by(id) |> 
  
  mutate(
    # calculate remaining start dates per id
    start_date = min(
      start_date
      , na.rm = TRUE
    ) + c(
      0
      , cumsum(
        episode_length[-n()] + 1 # exclude last episode_length per group from cumsum() since there is no subsequent start_date
      )
    )
    # append end date
    , end_date = start_date + episode_length
  )

df.have |> 
  group_by(id) |> 
  min(
    start_date
    , na.rm = TRUE
  ) + c(
    0
    , cumsum(
      episode_length[-.N] + 1 # exclude last episode_length per group from cumsum() since there is no subsequent start_date
    )
  )
