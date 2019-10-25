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
dataset$tweet <- preProcess(dataset$tweet, stemDoc = TRUE, rmNum = TRUE, rmPont = TRUE, rmSpace = TRUE, rmStopWords = TRUE)

ds.train = dataset[1:1500,]

cat(" - Tokenizer\n")
TwogramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
train = Corpus(VectorSource(ds.train$tweet))
trainMatrix<-TermDocumentMatrix(train)

twoFreq<-findFreqTerms(trainMatrix,lowfreq=10)
trainMatrix<-as.matrix(trainMatrix[twoFreq,])
tdm = as.matrix(trainMatrix)

vetTrain = t(tdm)



ds.test = dataset[1501:2028,]

cat(" - Tokenizer\n")
TwogramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
test = Corpus(VectorSource(ds.test$tweet))
testnMatrix<-TermDocumentMatrix(test)

twoFreq<-findFreqTerms(testnMatrix,lowfreq=10)
testnMatrix<-as.matrix(testnMatrix[twoFreq,])
tdm = as.matrix(testnMatrix)

vetTest = t(tdm)
# -----------------------------------------
#######psiquico
# -----------------------------------------
train.df <- data.frame(vetTrain[,intersect(colnames(vetTrain), colnames(vetTest))])
test.df <- data.frame(vetTest[,intersect(colnames(vetTest), colnames(vetTrain))])

train.df = vetTrain

cat(" - Psiquico ttask\n")
psiquico = ds.train$psiquico
dsPsiquico = data.frame(psiquico, train.df)
tk1 =  makeClassifTask(data = dsPsiquico, target = "psiquico")

sv.lrn = makeLearner("classif.svm", id = "svm", predict.type = "prob")
mod = train(sv.lrn, task = tk1)

psiquico = ds.test$psiquico
psi.test = data.frame(psiquico, test.df)

pred = predict(mod, newdata = psi.test)

View(dataset)
performance(pred, measures = me )

View(train.df)

View(test.df)

#####
