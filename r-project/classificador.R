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


# criar uma tarefa de classificacao para o dsPsiquico
task = makeClassifTask(data = dsComportamental, target = "comportamental")
print(task)

# Iniciar um algoritmo para classificar algorithm
#algo = makeLearner(cl = "classif.randomForest", predict.type = "prob")
# algo = makeLearner(cl = "classif.rpart")
algo = makeLearner(cl = "classif.knn")
print(algo)

# Dividir os dados do dataset em treino e teste, e rodar varias permutacoes
#rdesc = makeResampleDesc(method = "CV", iters = 10, stratify = TRUE)
#utilizando por conta do tamanho do dataset
rdesc = makeResampleDesc("Holdout", split = 2/3)

# Medidas de desempenho para avaliar os resultados
measures = list(acc, bac)

# Rodar o algoritmo na tarefa e coletar os resultados
result = resample(learner = algo, task = task, resampling = rdesc,
                  measures = measures, show.info = TRUE)
result

# mostrando o resultado
print(result$aggr)

# Checar as predicoes obtidas pelo algoritmo
result$pred
pred = getRRPredictions(res = result)
print(pred)

# tabela predicoes
table(pred$data[,2:3])

# visualizar as predicoes usando um heatmp
aux = pred$data
df2 = melt(aux, id.vars =c(1,4,5))
df2$id = as.factor(df2$id)
ggplot(data = df2) + geom_tile(aes(x = id, y = variable, fill = value)) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
  scale_fill_manual(values = c("blue", "black", "red"))
