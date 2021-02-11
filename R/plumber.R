# Answer to 'How Do I Consume an Array of JSON Objects using Plumber in R'
# (available online: https://stackoverflow.com/questions/48667477/how-do-i-consume-an-array-of-json-objects-using-plumber-in-r)

#* @post /score
score = function(Gender, State){
  
  # ## sample data
  # lst = list(
  #   Gender = c("F", "F", "M")
  #   , State = c("AZ", "NY", "DC")
  # )
  # 
  # ## jsonify
  # jsn = lapply(
  #   lst
  #   , toJSON
  # )
  
  lapply(
    list(Gender, State)
    , as.factor
  )
  
  # request = POST(
  #   url = "http://localhost:8000/score?"
  #   , query = jsn # values must be length 1
  # )
  # 
  # ## query
  # response = content(
  #   request
  #   , as = "text"
  #   , encoding = "UTF-8"
  # )
  # 
  # fromJSON(
  #   response
  # )
}