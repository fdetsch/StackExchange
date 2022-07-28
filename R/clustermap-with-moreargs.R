### Answer to 'parLapply: unused argument (MoreArgs' ----
### (available online: https://stackoverflow.com/q/51669434/1977053)

library(parallel)
cluster = makeCluster(3)

testFUN =  function(
    n = 10
    , min = 0
    , max = 100
    , outname="test1.Rdata"
) {
  nums = runif(
    n
    , min = min
    , max = max
  )

  total = sum(
    nums
  )

  save(
    total
    , file = outname
  )

  return(
    total
  )
}

nlist = list(
  first = 5
  , second = 10
  , third = 15
)

outname = sprintf(
  "test%s.Rdata"
  , 1:3
)

clusterMap(
  cl = cluster
  , fun = testFUN
  , nlist
  , outname
  , MoreArgs = list(
    min = 33
    , max = 110
  )
)
# $first
# [1] 335.4677
#
# $second
# [1] 681.2613
#
# $third
# [1] 1065.619

stopCluster(
  cluster
)
