#carregar libs
library(ggplot2)

#carrega arquivos
source("request_server.R")

dataset = dataset()

View(dataset)

ggplot(data = data1) + geom_bar(mapping = aes(x = psiquico, fill = psiquico))

