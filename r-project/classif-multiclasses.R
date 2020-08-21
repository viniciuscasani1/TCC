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

dataset = dados[1:2008,]

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
#######Multiclasse
# -----------------------------------------
cat(" - Multiclasse task\n")
label = dataset$label
dsLabel = data.frame(label, vet)
tk1 =  makeClassifTask(data = dsLabel, target = "label")

tasks = list(tk1)

# -----------------------------------------
# -----------------------------------------
sv.lrn = makeLearner("classif.svm", id = "svm", predict.type = "prob")
nb.lrn = makeLearner("classif.naiveBayes", id = "nbayes", predict.type = "prob")
mlp.lrn = makeLearner("classif.mlp", id= "mlp", predict.type = "prob")
rf.lrn = makeLearner("classif.randomForest", id="rf", predict.type = "prob")

rdesc = makeResampleDesc(method = "RepCV", stratify = TRUE, rep = 10, folds = 10)

# Definir medidas de avaliacao
me = list(acc, bac, multiclass.au1u, timepredict, timetrain )

lrns = list(mlp.lrn, sv.lrn, nb.lrn, rf.lrn)

result = mlr::benchmark(learners =lrns, tasks = tasks, resamplings = rdesc,
                        measures = me, show.info = TRUE)
print(result)

getPredictionResponse(result)

getBMRPredictions(result)

tvalue = data.frame(getBMRPredictions(result))


task = makeClassifTask(data = dsTrain, target ="dtTrain.psiquico")

mod = train(sv.lrn, task)

task_test <- makeClassifTask(id = "New Data Test",
                             data = dsTest, target = "dtTeste.psiquico")

result_rf <- predict(mod, task_test)

final = tvalue[order(tvalue$dsLabel.mlp.truth),,drop=FALSE]

View(final$dsLabel.mlp.truth)

final = data.frame(final$dsLabel.mlp.truth, final$dsLabel.mlp.response)

write.csv(final, "~/Projects/personal/tcc/TCC/r-project/zz.csv", row.names = FALSE)


zz = read.csv("~/Projects/personal/tcc/TCC/r-project/ds.csv")

zz$resp = ifelse(zz$final.dsLabel.mlp.truth == zz$final.dsLabel.mlp.response, "S", "N" )


write.csv(ds, "~/Projects/personal/tcc/TCC/r-project/ds.csv", row.names = FALSE)

multi = data.frame(result)

attach(multi)

ds = data.frame(multi$learner.id, multi$multiclass.au1u)

ds[1:200,]

wilcox.test(class~auc, data = zz)

result2

View(ds[1:100,]$multi.multiclass.au1u)

g = generateCritDifferencesData(result2, measure = auc, p.value = 0.05,
                            baseline = NULL, test = "nemenyi")
g
plotCritDifferences(g) + coord_cartesian(xlim = c(-1,5), ylim = c(0,2))


plotROCCurves(pred)

pred = getBMRPredictions(result)

df = generateThreshVsPerfData(pred, measures = list(auc))


##
