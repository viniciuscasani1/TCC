# Carregando os pacotes necessarios para o script funcionar
library(mlr)
library(ggplot2)
library(reshape2)
library(stringr)
library(tm)
library(RWeka)
#carrega arquivos
source("request_server.R")
source("pre-processing.R")

#busca dados no servidor
cat(" - Downloading dataset\n")
dados = getDataset()

dataset = dados

dataset = dataset[1:2008,]

#pre-processamento
cat(" - Preprocessing\n")
aux <- preProcess(dataset$tweet, stemDoc = TRUE, rmNum = TRUE, rmPont = TRUE, rmSpace = TRUE, rmStopWords = TRUE)

cat(" - Tokenizer\n")
TwogramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
teste = as.VCorpus(aux)
twogramMatrix <- TermDocumentMatrix(teste)


twoFreq<-findFreqTerms(twogramMatrix,lowfreq=10)
twogramRowSum<-as.matrix(twogramMatrix[twoFreq,])
tdm = as.matrix(twogramRowSum)

vet = t(tdm)

View(as.matrix(twogramMatrix))

View(vet)
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
rf.lrn = makeLearner("classif.randomForest", id="rf", predict.type = "prob")

rdesc = makeResampleDesc(method = "RepCV", stratify = TRUE, rep = 10, folds = 10)

# Definir medidas de avaliacao
me = list(acc, bac, auc,  timepredict, timetrain )

lrns = list(sv.lrn, nb.lrn, mlp.lrn, rf.lrn)

result2 = mlr::benchmark(learners = lrns, tasks = tasks, resamplings = rdesc,
                        measures = me, show.info = TRUE)
print(result)

resultfinal = result

##


result2
perf = getBMRPerformances(resultfinal, as.df = TRUE)

dsPerf = data.frame(perf$learner.id, perf$timetrain)

print(dsPerf)  


library("ggpubr")
ggboxplot(dsPerf, x = "perf.learner.id", y = "perf.timetrain", 
          color = "perf.learner.id", palette = c("#00AFBB", "#E7B800"),
          order = c("svm", "rf"),
          ylab = "Weight", xlab = "Groups")  
  
friedmanTestBMR(result)


g = generateCritDifferencesData(result, p.value = 0.05, test = "nemenyi")

g  



plotCritDifferences(g) + coord_cartesian(xlim = c(-1,5), ylim = c(0,2)) +
  scale_colour_manual(values = c("svm" = "#F8766D", "nbayes" = "#00BA38", "mlp" = "#619CFF", "rf" = "#8B0000"))


install.packages("PairedData")

svm <- subset(dsPerf,  group == "svm", perf.timetrain,
                 drop = TRUE)
# subset weight data after treatment
rf <- subset(dsPerf,  group == "rf", perf.timetrain,
                drop = TRUE)



pd <- paired(before, after)
plot(pd, type = "profile") + theme_bw()


View(perf)


write.csv(result, "~/Projects/personal/tcc/TCC/r-project/resultmulti.csv", row.names = FALSE)

qp2 = read.csv("~/Projects/personal/tcc/TCC/r-project/zz.csv")

li = data.frame(qp2$auc, qp2$task.id)


a = data.frame(getBMRPredictions(result2))


final = a[order(final$a.dsLabel.mlp.truth),,drop=FALSE]



fcomp = data.frame(a$dsComportamental.mlp.truth, a$dsComportamental.mlp.response)

ffisio = data.frame(a$dsFisiologico.mlp.truth, a$dsFisiologico.mlp.response)

ggplot(li, aes(x = qp2$id, y = qp2$media, colour = qp2$tipo, fill=qp2$tipo)) + geom_bar(stat="identity") + theme_bw() + theme(aspect.ratio = 1.2) + labs(y = "AUC Média", x = "Categoria Sintomática")  + scale_y_continuous(breaks = seq(0, 100, by = 5))




bin1$resp = ifelse(bin1$a.dsLabel.mlp.truth ==bin1$a.dsLabel.mlp.response, "S", "N" )

