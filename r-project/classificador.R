# Carregando os pacotes necessarios para o script funcionar
library(mlr)
library(ggplot2)
library(reshape2)

#carrega arquivos
source("vetorizacao.R")
source("request_server.R")
source("pre-processing.R")

#busca dados no servidor
dados = getDataset()

#write.csv(dados, "C://dev/tcc/TCC/r-project/dataset.csv", row.names = FALSE)
#write.csv(dados, "~/Projects/personal/tcc/TCC/r-project/dataset.csv", row.names = FALSE)

datateste = read.csv("dataset.csv")

dataset = dados

View(sentencas)

dados = datateste

#extrai apenas as sentenças para vetorizar
sentencas = dados[,1]

sentencas = preProcess(sentencas, stemDoc = TRUE, rmNum = TRUE, rmPont = TRUE, rmSpace = TRUE, rmStopWords = TRUE)

#extrai coluna comportamental
comportamental = dados[,2]

#extrai coluna fisiologico
fisiologico = dados[,3]

#extrai coluna psiquico
psiquico = dados[,4]

#vetoriza as sentenças retornando uma matriz
vetores = vetorizar(sentencas)

View(vetores)

#cria um dataset referente ao comportamental e os vetores
dsComportamental = data.frame(comportamental, sentencas)

#cria um dataset referente ao fisiologico e os vetores
dsfisiologico = data.frame(fisiologico, sentencas)

#cria um dataset referente ao psiquico e os vetores
dsPsiquico = data.frame(psiquico, aux)

ggplot(data = dsfisiologico) + geom_bar(mapping = aes(x = fisiologico, fill = fisiologico))

tasks = list(

  makeClassifTask(data = dsfisiologico, target = "fisiologico"),
  makeClassifTask(data = dsPsiquico, target = "psiquico")
)

tk=  makeClassifTask(data = dsPsiquico, target = "psiquico")

# Criar uma lista de algoritmos (learners)
lrns = makeLearner("classif.naiveBayes", id = "nbayes")
sv.lrn = makeLearner("classif.svm", id = "svm", predict.type = "prob")

rdesc = makeResampleDesc(method = "RepCV", stratify = TRUE, rep = 10, folds = 10)

# Definir medidas de avaliacao
me = list(acc, bac)

# Rodar os algoritmos na tarefa definida
#bmr = resample(learner = lrns, tasks = tk, resamplings = rdesc, 
 #               measures = me, show.info = TRUE, keep.pred = TRUE)

result = resample(learner = sv.lrn, task = tk, resampling = rdesc,
                  measures = me, show.info = TRUE)
print(result)

# mostrando o resultado
print(result$aggr)

# Checar as predicoes obtidas pelo algoritmo
result$pred
pred = getRRPredictions(res = result)
print(pred)

calculateConfusionMatrix(pred)

# Plotar os resultados (boxplots)
plotBMRBoxplots(bmr, measure = acc, style = "violin",
                order.lrn = getBMRLearnerIds(bmr)) + aes(color = learner.id)

plotBMRBoxplots(bmr, measure = acc, style = "box",
                order.lrn = getBMRLearnerIds(bmr)) +
  aes(color = learner.id) 
# demais plots?

