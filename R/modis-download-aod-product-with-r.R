# Answer to 'Download MODIS/MCD19A2 AOD product with R' ----
# (available online: https://gis.stackexchange.com/questions/295080/download-modis-mcd19a2-aod-product-with-r/295661#295661)

library(MODIS)

# set MODIS options (these can also be passed as '...' in getHdf())
MODISoptions(localArcPath = "OutputDestinationFolder", quiet = FALSE)

# download data
hdf = getHdf("MCD19A2", collection = "006"
             , tileH = 9, tileV = 4
             , begin = "2018.08.28", end = "2018.08.31")
hdf
# $`MCD19A2.006`
# [1] "OutputDestinationFolder/MODIS/MCD19A2.006/2018.08.28/MCD19A2.A2018240.h09v04.006.2018242043359.hdf"
# [2] "OutputDestinationFolder/MODIS/MCD19A2.006/2018.08.29/MCD19A2.A2018241.h09v04.006.2018250043019.hdf"
# [3] "OutputDestinationFolder/MODIS/MCD19A2.006/2018.08.30/MCD19A2.A2018242.h09v04.006.2018250043020.hdf"
# [4] "OutputDestinationFolder/MODIS/MCD19A2.006/2018.08.31/MCD19A2.A2018243.h09v04.006.2018250043021.hdf"

tfs = runGdal("MCD19A2", collection = "006"
              , tileH = 9, tileV = 4
              , begin = "2018.08.28", end = "2018.08.31"
              , job = "MCD19A2", SDSstring = "1010000000000")
tfs
# $`MCD19A2.006`
# $`MCD19A2.006`$`2018-08-28`
# [1] "OutputDestinationFolder/PROCESSED/MCD19A2/MCD19A2.A2018240.Optical_Depth_047.tif"
# [2] "OutputDestinationFolder/PROCESSED/MCD19A2/MCD19A2.A2018240.AOD_Uncertainty.tif"  
# 
# $`MCD19A2.006`$`2018-08-29`
# [1] "OutputDestinationFolder/PROCESSED/MCD19A2/MCD19A2.A2018241.Optical_Depth_047.tif"
# [2] "OutputDestinationFolder/PROCESSED/MCD19A2/MCD19A2.A2018241.AOD_Uncertainty.tif"  
# ...