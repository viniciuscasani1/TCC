# Carregando os pacotes necessarios para o script funcionar
library(mlr)
library(ggplot2)
library(reshape2)

datateste = read.csv("dataset.csv")

#extrai apenas as sentenças para vetorizar
sentencas = datateste[,1]

#pre-processamento
sentencas = preProcess(sentencas, stemDoc = TRUE, rmNum = TRUE, rmPont = TRUE, rmSpace = TRUE)

#extrai coluna label
label = datateste[,9]


#vetoriza as sentenças retornando uma matriz
vetores = vetorizar(sentencas)

View(label)

dataset = data.frame(label, vetores)


tasks = list(
  makeClassifTask(data = dataset, target = "label")
)

# Criar uma lista de algoritmos (learners)
lrns = list(                   # LDA - algoritmo linear
  makeLearner("classif.svm", id = "svm")
)


#rdesc = makeResampleDesc("CV", iters = 10, stratify = TRUE)
rdesc = makeResampleDesc(method = "RepCV", stratify = TRUE, rep = 10, folds = 3)

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
