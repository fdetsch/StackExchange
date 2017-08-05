### Answer to 'Cloudmask in Landsat 8 images' -----
### (available online: https://gis.stackexchange.com/questions/250860/cloudmask-in-landsat-8-images)

## packages
library(satellite)
library(RStoolbox)
library(mapview)

## sample data
lc08 = list.files("data/LC08_L1TP_195025_20130707_20170503_01_T1", 
                  pattern = ".TIF$", full.names = TRUE)
lc08 = sortFilesLandsat(lc08)
lc08 = stack(lc08[c(1:7, 9:11)]) # stack without band 8 (15 m)

## clip image (not required anymore since layers have already been clipped)
rext = extent(c(539745, 545955, 5527635, 5532585))
lc08 = crop(lc08, rext)

## mask clouds and visualize
cmsk = cloudMask(lc08, threshold = .4, blue = 2, tir = 9) # bands 2, 10
wocl = mask(lc08, cmsk$CMASK, maskvalue = 1)

viewRGB(wocl, r = 4, g = 3, b = 2)
