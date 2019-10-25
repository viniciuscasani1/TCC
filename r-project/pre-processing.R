library(SnowballC)
library(ggplot2)
library(tm)
library(wordcloud)
library (devtools)
library(qdapRegex)

preProcess <- function(stringList, rmNum = FALSE, rmPont = FALSE, rmSpace = FALSE,
                       rmStopWords = FALSE, stemDoc = FALSE, rmLink = TRUE){
  stringList = gsub("[^\x01-\x7F]", "", stringList)
  if(rmLink){
    post = rm_url(stringList, pattern=pastex("@rm_twitter_url", "@rm_url")) #remove links
  }
  
  post = Corpus(VectorSource(post)) # creating corpus
  post = tm_map(post, content_transformer(tolower))
  
  post <- tm_map(post, stripWhitespace) 
  
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
    post = tm_map(post, removeWords, stopwords("pt"))
  }
  
  if(stemDoc){
    post = tm_map(post, stemDocument)
  }
  
  return(post$content)
}
