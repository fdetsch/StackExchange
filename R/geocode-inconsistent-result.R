# Answer to 'inconsistent result with INVALID_REQUEST in R ggmap geocode()' -----
# (available online: https://stackoverflow.com/questions/30350122/inconsistent-result-with-invalid-request-in-r-ggmap-geocode#new-answer)

library(ggmap)

d <- c("Via del Tritone 123, 00187 Rome, Italy",
       "Via dei Capocci 4/5, 00184 Rome, Italy")

out = lapply(d, function(i) {
  gcd = geocode(i)
  
  while (all(is.na(gcd))) {
    gcd = geocode(i)
  }
  
  data.frame(address = i, gcd)
})

do.call(rbind, out)
