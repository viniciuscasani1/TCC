library(tm)
library(RWeka)

data("crude")
crude = preProcess(dataset$tweet, stemDoc = TRUE, rmNum = TRUE, rmPont = TRUE, rmSpace = TRUE, rmStopWords = TRUE)
TwogramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
crude <- as.VCorpus(crude)
crude <- tm_map(crude, stripWhitespace)
crude <- tm_map(crude, content_transformer(tolower))
crude <- tm_map(crude, removeWords, stopwords("english"))
crude <- tm_map(crude, stemDocument)
# Sets the default number of threads to use
options(mc.cores=1)

tdm <- TermDocumentMatrix(crude, control=list(tokenize = TwogramTokenizer))

findFreqTerms(tdm, lowfreq = 10)
