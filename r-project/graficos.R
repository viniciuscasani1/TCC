#carregar libs
library(ggplot2)

#carrega arquivos
source("request_server.R")

dataset = dataset()

View(dataset1)

ggplot(data = dataset1) + geom_bar(mapping = aes(x = validadoEspec, fill = validadoEspec))

