

library(reshape2)
library(ggplot2)

dataset = read.csv("dataset.csv")
dataset$tweet = as.character(dataset$tweet)

dim(dataset) # 1093 linhas, 9 colunas

# renaming labels
dataset$label = factor(dataset$label)
dataset$label = plyr::mapvalues(dataset$label, from = levels(dataset$label),
  to = c("nenhum", "fisio", "comport", "psiq", "fisio_psiq", "fisio_comport", "psiq_comport"))

ggplot(dataset, aes(x = label, colour = label, fill = label)) + geom_bar() + theme_bw()
g = g + theme(axis.text.x = element_text(angle = 90, vjust = .5, hjust = 1, size = 9))

ggplot(data = dsfisiologico) + geom_bar(mapping = aes(x = fisiologico, fill = fisiologico))
# gsave(g, file = "classDistribution.png")
# Saving 6.44 x 3.37 in image

# > ncol(vetores)
# [1] 3202
# > nrow(vetores)
# [1] 660

# > table(datateste$label)

  # 0   1   2   3   4   5   6
# 437  60  33  94  13   3  20

# ----------------------------------------------------------------
# ----------------------------------------------------------------

library(text2vec)
library(superml)
library(SnowballC)
library(tm)
library(wordcloud)
library (devtools)
library(qdapRegex)

source("vetorizacao.R")
source("pre-processing.R")

sentencas = preProcess(dataset[,1], stemDoc = TRUE, rmNum = TRUE, rmPont = TRUE, rmSpace = TRUE, rmStopWords = TRUE)
aux = vetorizar(sentencas)

df = cor(data.matrix(aux))
hc = caret::findCorrelation(df, cutoff = 0.95, verbose = FALSE)

if(length(hc) > 0) {
  cat(" - removing correlated features\n")
  aux = cbind(aux[,-c(hc)])
}

after = aux
dim(after)
# 660 1476
#1093 2123
#1093 4028
#1093 2123

# ------------------------------------------------------------------------
# ------------------------------------------------------------------------

df1 = cbind(aux, dataset$psiquico)
colnames(df1)[ncol(df1)] = "psiquico"

#removendo duplicated examples
remv = which(duplicated(df1))
if(length(remv) != 0) {
  cat(" - removing duplicated examples\n")
  df1 = df1[-remv,]
}

dim(df1)
# 633 1477
df1 = as.data.frame(df1)
ggplot(data = df1) + geom_bar(mapping = aes(x = psiquico, fill = psiquico))

# table(df1$fisiologico)
#   0   1
# 557  76

library(mlr)
colnames(df1) = make.names(colnames(df1), unique = TRUE)
df1$psiquico = as.factor(df1$psiquico)
tk    = makeClassifTask(data = df1, target = "psiquico")
me    = list(acc, bac, auc)

nb.lrn = makeLearner("classif.naiveBayes", id = "nbayes", predict.type = "prob")
nn.lrn = makeLearner("classif.kknn", id = "knn", predict.type = "prob")
dt.lrn = makeLearner("classif.rpart", id = "dt", predict.type = "prob")
gl.lrn = makeLearner("classif.glmnet", id = "glm", predict.type = "prob")
sv.lrn = makeLearner("classif.svm", id = "svm", predict.type = "prob")
#rf.lrn = makeLearner("classif.randomForest", id = "rf", predict.type = "prob")

nb2 = mlr::makeSMOTEWrapper(learner = nb.lrn, sw.rate = 2)
nn2 = mlr::makeSMOTEWrapper(learner = nn.lrn, sw.rate = 2)
dt2 = mlr::makeSMOTEWrapper(learner = dt.lrn, sw.rate = 2)
gl2 = mlr::makeSMOTEWrapper(learner = gl.lrn, sw.rate = 2)
sv2 = mlr::makeSMOTEWrapper(learner = sv.lrn, sw.rate = 2)
#rf2 = mlr::makeSMOTEWrapper(learner = rf.lrn, sw.rate = 2)

learners = list(nb.lrn, nn.lrn, dt.lrn, gl.lrn, sv.lrn,
  nb2, nn2, dt2, gl2, sv2)

learners = list(sv.lrn, sv2)

learners = sv.lrn

rdesc = makeResampleDesc(method = "RepCV", stratify = TRUE, rep = 10, folds = 10)
result = benchmark(learner = learners, tasks = tk, resamplings = rdesc,
                  measures = me, show.info = TRUE)
print(result)
print(result)

result = resample(learner = learners, task = tk, resampling = rdesc,
                  measures = me, show.info = TRUE)


# Checar as predicoes obtidas pelo algoritmo
result$pred
pred = getRRPredictions(res = result)
print(pred)
calculateConfusionMatrix(pred)
# Learner: nbayes
# Aggr perf: acc.test.mean=0.1200186,bac.test.mean=0.5000000
# Runtime: 249.222

#> table(pred$data$truth, pred$data$response)
#       0    1
#  0    0 5570
#  1    0  760

# ------------------------------------------------------------------------
# ------------------------------------------------------------------------

# https://www.rdocumentation.org/packages/superml/versions/0.4.0
# CountVectorizer: Create Bag of Words model
# TfidfVectorizer: Create TF-IDF feature model (using)

# https://abndistro.com/post/2019/02/17/text-classification-using-text2vec/
# https://www.kaggle.com/narae78/predict-tags-with-tf-idf-method

# ------------------------------------------------------------------------
# ------------------------------------------------------------------------
