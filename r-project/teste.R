library(dplyr)
library(stringr)
library(tidytext)



stack_words <- orginal %>%
  tidytext::unnest_tokens(word, text) %>%
  dplyr::count(category, word, sort = TRUE) %>%
  dplyr::ungroup()

stack_words <- stack_words %>%
  bind_tf_idf(word, category, n) 

stack_words

library(wordcloud)
orginal <- data_frame(line = 1:length(dataset$tweet), text = dataset$tweet, category = dataset$psiquico)

stack_words <- orginal %>%
  ungroup() %>%
  unnest_tokens(word, text)

dark2 <- brewer.pal(6, "Dark2")  # Used for the color in wordcloud
stack_words %>%
  filter(category== 0)  %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100,colors = dark2,rot.per = 0.2))
