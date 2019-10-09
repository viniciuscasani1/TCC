#carregar libs
library(httr)
library(rlist)
library(jsonlite)

#carrega api na variavel
server <- function(url) {
  return(handle("https://collect-data-api.herokuapp.com/api"))
}

#converte dados para JSON
convertToJson <- function(dados){
  text<-httr::content(dados,as="text")
  return( fromJSON(text))
}

#consulta todos os dados do dataset 
getDados <- function(){
  dados <- GET(handle = server(), path = "/api/data/validados", timeout= 4000000)
 return(convertToJson(dados))
}


getDataset <- function(){
  json <- getDados()
  #converte para dataframe
  json <- lapply(json, function(x) {
    x[sapply(x, is.null)] <- NA
    unlist(x)
  })
  
  #converte para table
  dt<-as.data.frame(do.call("cbind", json))
  return(dt)
}

