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

datateste = read.csv("dataset.csv")

View(datateste)

dados = datateste

#extrai apenas as sentenças para vetorizar
sentencas = dados[,1]

sentencas = preProcess(sentencas, stemDoc = TRUE)

#extrai coluna comportamental
comportamental = dados[,2]

#extrai coluna fisiologico
fisiologico = dados[,3]

#extrai coluna psiquico
psiquico = dados[,4]

#vetoriza as sentenças retornando uma matriz
vetores = vetorizar(sentencas)

#cria um dataset referente ao comportamental e os vetores
dsComportamental = data.frame(comportamental, vetores)

#cria um dataset referente ao fisiologico e os vetores
dsfisiologico = data.frame(fisiologico, vetores)

#cria um dataset referente ao psiquico e os vetores
dsPsiquico = data.frame(psiquico, vetores)

tasks = list(
  makeClassifTask(data = dsComportamental, target = "comportamental"),
  makeClassifTask(data = dsfisiologico, target = "fisiologico"),
  makeClassifTask(data = dsPsiquico, target = "psiquico")
)

# Criar uma lista de algoritmos (learners)
lrns = list(                   # LDA - algoritmo linear
  makeLearner("classif.svm", id = "svm"),  
  makeLearner("classif.naiveBayes", id = "nbayes")                # DT  - arvore de decisao
)

#rdesc = makeResampleDesc("CV", iters = 10, stratify = TRUE)
rdesc = makeResampleDesc(method = "RepCV", stratify = TRUE, rep = 10, folds = 10)

# Definir medidas de avaliacao
me = list(acc, bac)


# Rodar os algoritmos na tarefa definida
bmr = benchmark(learners = lrns, tasks = tasks, resamplings = rdesc, 
                measures = me, show.info = TRUE)
print(bmr)

# Plotar os resultados (boxplots)
plotBMRBoxplots(bmr, measure = acc, style = "violin",
                order.lrn = getBMRLearnerIds(bmr)) + aes(color = learner.id)

plotBMRBoxplots(bmr, measure = acc, style = "box",
                order.lrn = getBMRLearnerIds(bmr)) +
  aes(color = learner.id) 
getBMRMeasures(bmr)
# demais plots?
