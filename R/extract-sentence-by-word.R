# Answer to 'How to extract Sentence from text with use of particular word in Rstudio?' -----
# (available online: https://stackoverflow.com/questions/47646664/how-to-extract-sentence-from-text-with-use-of-particular-word-in-rstudio?rq=1)

text = "Digital India is an initiative by the Government of India ensuring that Government services are made available to citizens electronically by improving online infrastructure and by increasing Internet connectivity. It was launched on 1 July 2015 by Prime Minister Narendra Modi."
text = paste(text, "Indian summer is a periodically recurring weather phenomenon in Central Europe.")

# regmatches(text
#            , regexpr("[[:graph:][:space:]]*India[[:graph:][:space:]]*", text))
# 
# regmatches(text
#            , regexpr("[[[:alnum:]]\\s]*India[[[:alnum:]]\\s]*", text))

library(stringr)
str_extract_all(text, "([:alnum:]+\\s)*India[[:alnum:]\\s]*\\.")[[1]]
