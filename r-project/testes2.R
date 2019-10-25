# Carregando os pacotes necessarios para o script funcionar
library(mlr)
library(ggplot2)
library(reshape2)
library(stringr)
library(tm)

#carrega arquivos
source("request_server.R")
source("pre-processing.R")

#busca dados no servidor
cat(" - Downloading dataset\n")
dados = getDataset()

dataset = dados

#pre-processamento
cat(" - Preprocessing\n")
aux <- preProcess(dataset$tweet, stemDoc = TRUE, rmNum = TRUE, rmPont = TRUE, rmSpace = TRUE, rmStopWords = TRUE)

cat(" - Tokenizer\n")
TwogramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
teste = Corpus(VectorSource(aux))
twogramMatrix<-TermDocumentMatrix(teste)

twoFreq<-findFreqTerms(twogramMatrix,lowfreq=10)
twogramRowSum<-as.matrix(twogramMatrix[twoFreq,])
tdm = as.matrix(twogramRowSum)

vet = t(tdm)

View(twogramMatrix)
# -----------------------------------------
#######psiquico
# -----------------------------------------
cat(" - Psiquico task\n")
psiquico = dataset$psiquico
dsPsiquico = data.frame(psiquico, vet)
tk1 =  makeClassifTask(data = dsPsiquico, target = "psiquico")

cat(" - Comportamental task\n")
comportamental = dataset$comportamental
dsComportamental = data.frame(comportamental, vet)
tk2 =  makeClassifTask(data = dsComportamental, target = "comportamental")

cat(" - Fisiologico task\n")
fisiologico = dataset$fisiologico
dsFisiologico = data.frame(fisiologico, vet)
tk3 =  makeClassifTask(data = dsFisiologico, target = "fisiologico")

tasks = list(tk1, tk2, tk3)

# -----------------------------------------
# -----------------------------------------
sv.lrn = makeLearner("classif.svm", id = "svm", predict.type = "prob")
nb.lrn = makeLearner("classif.naiveBayes", id = "nbayes", predict.type = "prob")
mlp.lrn = makeLearner("classif.mlp", id= "mlp", predict.type = "prob")

rdesc = makeResampleDesc(method = "RepCV", stratify = TRUE, rep = 10, folds = 10)

# Definir medidas de avaliacao
me = list(acc, bac, auc, f1)

lrns = list(mlp.lrn, sv.lrn, nb.lrn)

result = mlr::benchmark(learners = lrns, tasks = tasks, resamplings = rdesc,
                   measures = me, show.info = TRUE)
print(result)

##