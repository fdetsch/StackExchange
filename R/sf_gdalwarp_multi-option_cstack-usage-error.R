### Issue "C stack usage errors during gdalwarp with "-multi" option enabled" ----
### (available online: https://github.com/r-spatial/sf/issues/1994)

src = system.file(
  "tif/geomatrix.tif"
  , package = "sf"
)

dst = file.path(
  tempdir()
  , "geomatrix.tif"
)


### quiet ----

n = 1L

while (n <= 5L) {
  sf::gdal_utils(
    "warp"
    , source = src
    , destination = dst
    , options = c(
      "-multi"
      , "-overwrite"
    )
    , quiet = TRUE
  )
  
  n = n + 1L
}

stars::read_stars(
  dst
) |> 
  plot()


### verbose ----

n = 1L

while (n <= 5L) {
  sf::gdal_utils(
    "warp"
    , source = src
    , destination = dst
    , options = c(
      "-multi"
      , "-overwrite"
    )
    , quiet = TRUE
  )
  
  n = n + 1L
}

# Creating output file that is 25P x 25L.
# 0...10...20...30...40...50...60...70...80...90Error: C stack usage  947109039916 is too close to the limit
# Save workspace image to ~/.RData? [y/n/c]: