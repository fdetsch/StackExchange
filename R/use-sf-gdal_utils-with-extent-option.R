### Answer to 'How to use sf:gdal_utils with extent option (-te)? -----
### (available online: https://gis.stackexchange.com/q/374492/13504)

src_dataset = system.file(
  "tif/L7_ETMs.tif"
  , package = "stars"
)


### sf ----

dst_dataset_r = tempfile(
  fileext = ".vrt"
)

sf::gdal_utils(
  util = 'buildvrt'
  , source = src_dataset
  , destination = dst_dataset_r
  , options = c(
    "-te", 290000, 9119000, 295000, 9120000
  )
)

# check the size of the VRT dataset
readLines(
  dst_dataset_r
  , n = 1L
)
# [1] "<VRTDataset rasterXSize=\"175\" rasterYSize=\"35\">"


### gdal cli ----

dst_dataset_cli = tempfile(
  fileext = ".vrt"
)

system(
  sprintf(
    paste(
      "gdalbuildvrt"
      , "-te 290000 9119000 295000 9120000"
      , dst_dataset_cli
      , "%s"
    )
    , src_dataset
  )
  , intern = TRUE
)

readLines(
  dst_dataset_cli
  , n = 1L
)
#> [1] "<VRTDataset rasterXSize=\"175\" rasterYSize=\"35\">"