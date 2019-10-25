dtTeste = read.csv("tst.csv", encoding = "UTF-8")
dtTrain = read.csv("dataset.csv", encoding = "UTF-8")

#preprocess train
prep <- preProcess(dtTrain$tweet, stemDoc = TRUE, rmNum = TRUE, rmPont = TRUE, rmSpace = TRUE, rmStopWords = TRUE)

TwogramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
vet = Corpus(VectorSource(prep))
twogramMatrix<-TermDocumentMatrix(vet, control=list(tokenize=TwogramTokenizer))

twoFreq<-findFreqTerms(twogramMatrix,lowfreq=10)
twogramRowSum<-as.matrix(twogramMatrix[twoFreq,])
tdm = as.matrix(twogramRowSum)
vet = t(tdm)

#cria dataset treino
dsTrain = data.frame(dtTrain$psiquico, vet)

#preprocess test
prepTest <- preProcess(dtTeste$tweet, stemDoc = TRUE, rmNum = TRUE, rmPont = TRUE, rmSpace = TRUE, rmStopWords = TRUE)

TwogramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
vetTest = Corpus(VectorSource(prepTest))
twogramMatrixTest<-TermDocumentMatrix(vetTest, control=list(tokenize=TwogramTokenizer))

twoFreq<-findFreqTerms(twogramMatrixTest,lowfreq=10))
twogramRowSumTest<-as.matrix(twogramMatrixTest[twoFreq,])
tdmTest = as.matrix(twogramRowSumTest)
vetTest = t(tdmTest)

#cria dataset treino
dsTest = data.frame(dtTeste$psiquico, vetTest)

View(dsTest)

task = makeClassifTask(data = dsTrain, target ="dtTrain.psiquico")

mod = train(sv.lrn, task)

task_test <- makeClassifTask(id = "New Data Test",
                             data = dsTest, target = "dtTeste.psiquico")

result_rf <- predict(mod, task_test)


str(dsTest)

str(dsTrain)
