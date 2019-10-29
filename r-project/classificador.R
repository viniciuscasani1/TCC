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
dsPsiquico = data.frame(psiquico, vet)

cat(" - Comportamental task\n")
comportamental = as.logical(dataset$comportamental)

cat(" - Fisiologico task\n")
fisiologico = as.logical(dataset$fisiologico)

dsMultiLabel = data.frame(psiquico, comportamental, fisiologico, vet)

task =  makeMultilabelTask(id = "multi", data = dsMultiLabel, target = c("psiquico", "comportamental", "fisiologico"))
# -----------------------------------------
# -----------------------------------------
mlp.lrn = makeLearner("classif.mlp", id= "mlp", predict.type = "prob")
sv.lrn = makeLearner("classif.svm", id = "svm", predict.type = "prob")
rdesc = makeResampleDesc(method = "RepCV", stratify = FALSE, rep = 10, folds = 10)

mlp.lrn = makeMultilabelBinaryRelevanceWrapper(mlp.lrn)
sv.lrn = makeMultilabelBinaryRelevanceWrapper(sv.lrn)
sv.lrn = makeMultilabelBinaryRelevanceWrapper(sv.lrn)

# Definir medidas de avaliacao
me = list(acc, bac, auc, f1)

lrns = list(mlp.lrn, sv.lrn)

result = mlr::benchmark(learners = lrns, tasks = task, resamplings = rdesc,
                        measures = me, show.info = TRUE)
print(result)

###

psi.train = dsPsiquico[1:2008,]
psi.test = dsPsiquico[2009:2142,]
tk1 =  makeClassifTask(data = psi.train, target = "psiquico")

sv.lrn = makeLearner("classif.svm", id = "svm", predict.type = "prob")
mod = train(sv.lrn, task = tk1)

psi.t

pred = predict(mod, newdata = psi.test)

View(dataset)
performance(pred, measures = me )

View(data.frame(pred))

calculateConfusionMatrix(pred)

View(dataset)
