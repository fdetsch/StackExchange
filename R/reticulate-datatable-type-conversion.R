### Support for datatable type conversion
# (available online: https://github.com/rstudio/reticulate/issues/1081)

library(reticulate)

py_install("datatable")
py_run_string(
  code = "import datatable as dt; dat = dt.Frame(r.iris)"
)

py$dat

py$
  dat$
  to_pandas() |> 
  data.table::data.table()
