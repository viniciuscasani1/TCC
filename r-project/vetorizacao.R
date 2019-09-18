#carrega arquivos
source("request_server.R")

library(text2vec)

library(superml)
library(mlr)

dataset1 = dataset()

View(dataset1)

sentences = dataset1[,1]


tf_object = TfIdfVectorizer$new(max_df=1, min_df=1, max_features=1, smooth_idf=TRUE)

tf_object$fit(sentences)
tf_matrix = tf_object$transform(sentences)
tf_matrix = tf_object$fit_transform(sentences)

View(tf_matrix)

fisio = dataset1[,3]

df_union1<-merge(fisio,tf_matrix,all=TRUE)
View(df_union1)

colnames(tf_matrix)

# Criar uma tarefa de classificacao
task = makeClassifTask(data = dataset1, target = "psiquico")

# Criar uma lista de algoritmos (learners)
lrns = list(
  makeLearner("classif.lda", id = "lda"),                    # LDA - algoritmo linear
  makeLearner("classif.svm", id = "svm"),                    # SVM
  makeLearner("classif.rpart", id = "rpart"),                # DT  - arvore de decisao
  makeLearner("classif.randomForest", id = "randomForest")   # RF  - random Forest 
)

algo =  makeLearner("classif.svm", id = "svm")
rdesc = makeResampleDesc(method = "CV", iters = 10, stratify = TRUE)

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