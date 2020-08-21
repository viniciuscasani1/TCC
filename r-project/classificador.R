# Carregando os pacotes necessarios para o script funcionar
library(mlr)
library(ggplot2)
library(reshape2)
library(stringr)
library(iterators)

#carrega arquivos
source("request_server.R")
source("pre-processing.R")

#busca dados no servidor
cat(" - Downloading dataset\n")
dados = getDataset()

dataset = dados

d1 =  dataset[1:2008,]
d2 = dataset[3122:3273,]

new = rbind(d1, d2)

#pre-processamento
cat(" - Preprocessing\n")
aux <- preProcess(new$tweet, stemDoc = TRUE, rmNum = TRUE, rmPont = TRUE, rmSpace = TRUE, rmStopWords = TRUE)

cat(" - Tokenizer\n")
TwogramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
teste = as.VCorpus(aux)
twogramMatrix<-TermDocumentMatrix(teste)

twoFreq<-findFreqTerms(twogramMatrix,lowfreq=20)
twogramRowSum<-as.matrix(twogramMatrix[twoFreq,])
tdm = as.matrix(twogramRowSum)

vet = t(tdm)
# -----------------------------------------
#######Multiclasse
# -----------------------------------------
cat(" - Multiclasse task\n")
label = new$label
dsLabel = data.frame(label, vet)


# Definir medidas de avaliacao
me = list(acc, bac, multiclass.au1u)
###
psi.train = dsLabel[1:2008,]
psi.test = dsLabel[2009:2160,]
tk1 =  makeClassifTask(data = psi.train, target = "label")

sv.lrn = makeLearner("classif.svm", id = "svm", predict.type = "prob")
mod = train(sv.lrn, task = tk1)

pred = predict(mod, newdata = psi.test)

performance(pred, measures = me )

calculateConfusionMatrix(pred)

resp = (getPredictionResponse(pred))

View(resp)

id = new$idTweet
user = dataset$idUsuario
ids = data.frame(id)
ids = ids[2009:2160,]

fim = data.frame(resp, ids)

write.csv(fim, "~/Projects/personal/tcc/TCC/r-project/result.csv", row.names = FALSE)

