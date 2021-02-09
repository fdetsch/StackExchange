# Answer to 'How Do I Consume an Array of JSON Objects using Plumber in R'
# (available online: https://stackoverflow.com/questions/48667477/how-do-i-consume-an-array-of-json-objects-using-plumber-in-r)

#* @post /score
score = function(data){
  
  # dat = data.frame(
  #   Gender = c("F", "F", "M")
  #   , State = c("AZ", "NY", "DC")
  # )
  # 
  # jsonlite::toJSON(
  #   dat
  #   , dataframe = "columns"
  # )
  
  lst = jsonlite::fromJSON(data)
  lapply(
    lst
    , as.factor
  )
}