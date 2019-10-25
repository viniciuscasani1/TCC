# Carregando os pacotes necessarios para o script funcionar
library(mlr)
library(ggplot2)
library(reshape2)
library(stringr)

#carrega arquivos
source("request_server.R")
source("pre-processing.R")

#busca dados no servidor
dados = getDataset()

dataset = dados

#pre-processamento
aux <- preProcess(dataset$tweet, stemDoc = TRUE, rmNum = TRUE, rmPont = TRUE, rmSpace = TRUE, rmStopWords = TRUE)

TwogramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
teste = Corpus(VectorSource(aux))
twogramMatrix<-TermDocumentMatrix(teste, control=list(tokenize=TwogramTokenizer))

twoFreq<-findFreqTerms(twogramMatrix,lowfreq=10)
twogramRowSum<-as.matrix(twogramMatrix[twoFreq,])
tdm = as.matrix(twogramRowSum)

#twogramRowSum1<-rowSums(as.matrix(twogramMatrix[twoFreq,]))

barplot(twogramRowSum1[1:20], horiz=F, cex.names=0.8, xlab="twograms",
        ylab="Frequency",las=2,names.arg=names(twogramRowSum1[1:20]), 
        main="Top 20 twogram with the highest frequency")

wordcloud(names(twogramRowSum1), twogramRowSum1, max.words = 100, colors = brewer.pal(6, "Dark2"))

vet = t(tdm)
#######psiquico
psiquico = dataset$psiquico

dsPsiquico = data.frame(psiquico, vet)

tk =  makeClassifTask(data = dsPsiquico, target = "psiquico")
sv.lrn = makeLearner("classif.svm", id = "svm", predict.type = "prob")


rdesc = makeResampleDesc(method = "RepCV", stratify = TRUE, rep = 2, folds = 10)

# Definir medidas de avaliacao
me = list(acc, bac, auc, f1, ppv, tpr)

result = resample(learner = lg.lrn, task = tk, resampling = rdesc,
                   measures = me, show.info = TRUE)

pred = getRRPredictions(res = result)
calculateConfusionMatrix(pred)

#######comportamental
comportamental = dataset$comportamental

dsComportamental = data.frame(comportamental, vet)

tk =  makeClassifTask(data = dsComportamental, target = "comportamental")
sv.lrn = makeLearner("classif.svm", id = "svm", predict.type = "prob")


rdesc = makeResampleDesc(method = "RepCV", stratify = TRUE, rep = 10, folds = 10)

# Definir medidas de avaliacao
me = list(acc, bac, auc)

resultComp = resample(learner = sv.lrn, task = tk, resampling = rdesc,
                  measures = me, show.info = TRUE)

predComp = getRRPredictions(res = resultComp)
calculateConfusionMatrix(predComp)

#######fisiologico
xx99999 = dataset$fisiologico

dsFisiologico = data.frame(xx99999, vet)

tk =  makeClassifTask(data = dsFisiologico, target = "xx99999")
sv.lrn = makeLearner("classif.svm", id = "svm", predict.type = "prob")


rdesc = makeResampleDesc(method = "RepCV", stratify = TRUE, rep = 10, folds = 10)

# Definir medidas de avaliacao
me = list(acc, bac, auc)

resultFisio = resample(learner = sv.lrn, task = tk, resampling = rdesc,
                      measures = me, show.info = TRUE)

predFisio = getRRPredictions(res = resultFisio)
calculateConfusionMatrix(predFisio)

###

tst = read.csv("tst.csv", encoding = "UTF-8")
ds = datateste

aux <- preProcess(qq$tweet, stemDoc = TRUE, rmNum = TRUE, rmPont = TRUE, rmSpace = TRUE, rmStopWords = TRUE)

TwogramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
vet = Corpus(VectorSource(aux))
twogramMatrix<-TermDocumentMatrix(vet, control=list(tokenize=TwogramTokenizer))

twoFreq<-findFreqTerms(twogramMatrix,lowfreq=10)
twogramRowSum<-as.matrix(twogramMatrix[twoFreq,])
tdm = as.matrix(twogramRowSum)
vet = t(tdm)

psi = ds$psiquico
df = data.frame(psi, vet)

task = makeClassifTask(data = df, target ="psi")

mod = train(sv.lrn, task)

psi = tst$psiquico

tweet = tst$tweet

qq = data.frame(psi, tweet)

predc = predict(mod, newdata = qq)

View(vet)


n = getTaskSize(task)
train.set = seq(1, n, by = 2)
test.set = seq(2, n, by = 2)
mod = train(sv.lrn, task = task, subset = train.set)


task.pred = predict(mod, task = task, subset = test.set)

View(as.data.frame(task.pred))

calculateConfusionMatrix(task.pred, relative = TRUE)


plotLearnerPrediction(sv.lrn, task = task)
