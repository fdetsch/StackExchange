# Comment to 'Read NetCDF chlorophyll data in R' ----
# (available online: https://gis.stackexchange.com/questions/297709/read-netcdf-chlorophyll-data-in-r)

library(raster)

ifl = "https://oceandata.sci.gsfc.nasa.gov/cgi/getfile/A20182132018243.L3m_MO_CHL_chlor_a_4km.nc"
ofl = tempfile(fileext = ".nc")
download.file(ifl, ofl, mode = "wb")

rst = raster(ofl, varname = "chlor_a")
ext = extent(-85, -80, 20, 30)
crp = crop(rst, ext, snap = "out")
crp