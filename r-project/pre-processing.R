library(SnowballC)
library(ggplot2)
library(tm)
library(wordcloud)
library (devtools)
library(qdapRegex)

preProcess <- function(stringList, rmNum = FALSE, rmPont = FALSE, rmSpace = FALSE,
                       rmStopWords = FALSE, stemDoc = FALSE, rmLink = TRUE){
  post = sapply(stringList, tolower)
  if(rmLink){
    post = rm_url(post, pattern=pastex("@rm_twitter_url", "@rm_url")) #remove links
  }
  
  post = Corpus(VectorSource(post)) # creating corpus
  post = tm_map(post, content_transformer(tolower))
  
  if(rmNum){
    post = tm_map(post, removeNumbers)
  }
  
  if(rmPont){
    post = tm_map(post, removePunctuation)
  }
  
  if(rmSpace){
    post = tm_map(post, stripWhitespace)
  }
  
  if(rmStopWords){
    post = tm_map(post, removeWords, stopwords('pt'))
  }
  
  if(stemDoc){
    post = tm_map(post, stemDocument)
  }
  
  return(post$content)
}

remove_html_tags <- function(htmlString) {
  return(gsub("<.*?>", "", htmlString))
}


# custom tokenizer
custom_tokenizer <- function(param_big_string) {
  #' lower-cases, removes punctuation, new line and return characters, 
  #' and removes unnecessary whitespace, then strsplits 
  split_content <- sapply(param_big_string, removePunctuation, preserve_intra_word_dashes=T)
  split_content <- sapply(split_content, function(y) gsub("[\r\n]", " ", y))
  split_content <- sapply(split_content, tolower)
  split_content <- sapply(split_content, function(y) gsub("(?<=[\\s])\\s*|^\\s+|\\s+$", "", y, perl=TRUE))
  return(split_content)
  #return(split_content <- (sapply(split_content, strsplit, " ")))
}
