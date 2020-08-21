# Carregando os pacotes necessarios para o script funcionar
library(mlr)
library(ggplot2)
library(reshape2)
library(stringr)

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

# -----------------------------------------
#######psiquico
# -----------------------------------------
cat(" - Psiquico task\n")
psiquico = as.logical(dataset$psiquico)

cat(" - Comportamental task\n")
comportamental = as.logical(dataset$comportamental)

cat(" - Fisiologico task\n")
fisiologico = as.logical(dataset$fisiologico)

dsMultiLabel = data.frame(psiquico, comportamental, fisiologico, vet)

task =  makeMultilabelTask(id = "multi", data = dsMultiLabel, target = c("psiquico", "comportamental", "fisiologico"))

# -----------------------------------------
# -----------------------------------------
sv.lrn  = makeLearner("classif.svm", kernel = "radial")
sv.lrn = makeLearner("classif.svm", id = "svm", predict.type = "prob")
nb.lrn = makeLearner("classif.naiveBayes", id = "nbayes", predict.type = "prob")
mlp.lrn = makeLearner("classif.mlp", id= "mlp", predict.type = "prob")

mlp.lrn = makeMultilabelBinaryRelevanceWrapper(mlp.lrn)
sv.lrn = makeMultilabelBinaryRelevanceWrapper(sv.lrn)
nb.lrn = makeMultilabelBinaryRelevanceWrapper(nb.lrn)

rdesc = makeResampleDesc(method = "RepCV", stratify = FALSE, rep = 10, folds = 10)

# Definir medidas de avaliacao
me = list(multilabel.acc, multilabel.f1)

lrns = list(mlp.lrn, sv.lrn, nb.lrn)


result = mlr::benchmark(learners = sv.lrn, tasks = task, resamplings = rdesc,
                        measures = me, show.info = TRUE)
print(result)

pred = getBMRPredictions(result)

pred


ds.train = dsMultiLabel[1:1500,]
ds.test = dsMultiLabel[1501:2028,]
task =  makeMultilabelTask(id = "multi", data = ds.train, target = c("psiquico", "comportamental", "fisiologico"))
mod = train(mlp.lrn, task = task)

pred = predict(mod, newdata = ds.test)

View(dataset)
performance(pred, measures = me )


getMultilabelBinaryPerformances(pred, measures = list(auc, acc, f1))



