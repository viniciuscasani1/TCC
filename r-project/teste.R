source("pre-processing.R")


sentencas <- remove_html_tags(sentencas)

# tokenize
sentencas <- custom_tokenizer(sentencas)
dat_all$tags <- custom_tokenizer(dat_all$tags)
dat_all$title <- custom_tokenizer(dat_all$title)

sentencas = dados[,1]

library(dplyr)
library(stringr)
library(tidytext)

teste <- data_frame(line = 1:length(sentencas), text = sentencas, category = dataset$psiquico)

stack_words <- teste %>%
  unnest_tokens(word, text) %>%
  count(category, word, sort = TRUE) %>%
  ungroup()

stack_words <- stack_words %>%
  bind_tf_idf(word, category, n) 

stack_words

potential_tag <- plot_stack %>%
  filter(category=="psiquico")
potential_tag = as.character(potential_tag$word)
potential_tag

plot_stack <- stack_words %>%
  arrange(desc(tf_idf)) %>%
  mutate(word = factor(word, levels = rev(unique(word)))) %>%
  mutate(category = factor(category, levels = c("psiquico")))

View(stack_words)

data = " dsad dsa dsa dsa dsa d"

aux = sentencas

library(stringr)
aux = str_replace(sentencas,"kkkkk","")
View(aux)

aux = preProcess(aux, stemDoc = TRUE, rmNum = TRUE, rmPont = TRUE, rmSpace = TRUE, rmStopWords = TRUE)

dim(aux)
aux = vetorizar(aux)
