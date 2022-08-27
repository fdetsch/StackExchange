### Question "Incorrect application of timezone offset when sending UTC 
### timestamps from Python to R" ----
### (available online: https://github.com/rstudio/reticulate/issues/1265)

## fetch current utc time in python
pyenv = reticulate::py_run_string(
  "
import datetime as dt
import pytz

current_time = dt.datetime.now()
print(current_time)

current_utc_time = dt.datetime.utcnow()
print(current_utc_time)
  "
)
# 2022-08-27 09:51:30.526013
# 2022-08-27 07:51:30.526053

## access from r
pyenv$current_utc_time
# [1] "2022-08-27 07:51:30 CEST"


### update ----

remotes::install_github(
  "rstudio/reticulate"
)

pyenv1 = reticulate::py_run_string(
  "
import datetime
import pytz

current_time = datetime.datetime.now()
print(current_time)
# 2022-08-26 11:36:02.970260

current_utc_time1 = datetime.datetime.now(tz = pytz.utc)
print(current_utc_time1)

current_utc_time2 = datetime.datetime.now(datetime.timezone.utc)
print(current_utc_time2)
  "
)
# 2022-08-27 09:52:15.750921
# 2022-08-27 07:52:15.750941+00:00
# 2022-08-27 07:52:15.750972+00:00

pyenv$current_utc_time1
# [1] "2022-08-27 07:52:15 UTC"
pyenv$current_utc_time2
# [1] "2022-08-27 07:52:15 UTC"

utils::sessionInfo()
reticulate::py_config()
