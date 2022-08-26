### Question "Incorrect application of timezone offset when sending UTC 
### timestamps from Python to R" ----
### (available online: https://github.com/rstudio/reticulate/issues/1265)

## fetch current utc time in python
pyenv = reticulate::py_run_string(
  "
from datetime import datetime

current_time = datetime.now()
print(current_time)
# 2022-08-26 11:36:02.970260

current_utc_time = datetime.utcnow()
print(current_utc_time)
# 2022-08-26 09:36:02.970276
  "
)
# 2022-08-26 11:36:02.970260
# 2022-08-26 09:36:02.970276

## access from r
pyenv$current_utc_time
# [1] "2022-08-26 07:36:02 UTC"

utils::sessionInfo()
reticulate::py_config()
