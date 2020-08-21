library(reshape2)

##grafico sintomas 
qp2 = read.csv("~/Projects/personal/tcc/TCC/r-project/zz.csv")

ggplot(qp2,aes(x = Categoria.Sintomática ,y =Frequência.de.Identificação)) + 
  geom_bar(aes(fill = Abordagem),stat = "identity",position = "dodge") + theme(aspect.ratio = 1.2, legend.position = "top") + labs(y = "Frequência", x="")  + scale_y_continuous(breaks = seq(0, 100, by = 5)) + 
  scale_fill_discrete(name = "Estratégia")

#grafico classificadores QP1

qp1 = read.csv("~/Projects/personal/tcc/TCC/r-project/qp1.csv")

ggplot(qp1,aes(x =Classificador,y = Média.AUC)) + 
  geom_bar(aes(fill = Abordagem),stat = "identity",position = "dodge") + theme(aspect.ratio = 1.2, legend.position = "top") + labs(y = "Média AUC", x="")  + scale_y_continuous(breaks = seq(0, 100, by = 5)) + 
  scale_fill_discrete(name = "Estratégia")


ggplot(infos,aes(x =learner.id,y = auc)) + 
  geom_boxplot(aes(fill = infos$estrategia),stat = "identity",position = "dodge") + theme(aspect.ratio = 1.2, legend.position = "top") + labs(y = "Média AUC", x="")  + scale_y_continuous(breaks = seq(0, 100, by = 5)) + 
  scale_fill_discrete(name = "Estratégia")

final$auc = as.numeric(final$auc)

ggplot(data = final) +
  geom_boxplot(mapping = aes(x = final$learner.id, y = final$auc, fill = estrategia)) + theme(legend.position = "top") + labs(y = "AUC", x="")  + scale_y_continuous(breaks = seq(0, 1, by = 0.05)) + 
  scale_fill_discrete(name = "Estratégia")

#grafico tempo QP1

qp1tempo = read.csv("~/Projects/personal/tcc/TCC/r-project/qp1-2.csv")

ggplot(qp1tempo,aes(x =Classificador,y = qp1tempo$Tempo.Geral.de.Processamento)) + 
  geom_bar(aes(fill = Abordagem),stat = "identity",position = "dodge") + theme(aspect.ratio = 1.2, legend.position = "top") + labs(y = "Média do Tempo Geral", x="")  + scale_y_continuous(breaks = seq(0, 200, by = 5)) + 
  scale_fill_discrete(name = "Estratégia")

final$timetrain = as.numeric(final$timetrain)


ggplot(data = final) +
  geom_boxplot(mapping = aes(x = final$learner.id, y = log(final$timetrain + final$timepredict) , fill = estrategia)) + theme(legend.position = "top") + labs(y = "Tempo Geral de Processamento", x="")  + 
  scale_fill_discrete(name = "Estratégia")


+ scale_y_continuous(breaks = seq(0, 10, by = 5))

#QP3


qp3 = read.csv("~/Projects/personal/tcc/TCC/r-project/qp3.csv")
qp3$label  = factor(qp3$label)
qp3$label = plyr::mapvalues(qp3$label, from = levels(qp3$label),
                                to = c("Nenhum", "Fisiológico", "Comportamental", "Psíquico"))


#ggplot(dataset, aes(x = label, colour = label, fill = label)) + geom_bar() + theme_bw()
g = ggplot(qp3, aes(x = label,  fill = usuario)) + geom_bar(width = 0.5) + theme_bw()
g + theme(aspect.ratio = 0.7) + labs(y = "Quantidade", x = "Categoria Sintomática")  + scale_y_continuous(breaks = seq(0, 650, by = 100)) + scale_fill_grey(start = 0, end = .9)


ggplot(qp3, aes(x =usuario, fill = label)) + 
  geom_bar(position = "dodge") +
  theme(aspect.ratio = 1.2, legend.position = "top") + labs(y = "Quantidade de Identificação de cada Classe ", x="")  +
   scale_y_continuous(breaks = seq(0, 320, by = 20)) + scale_fill_discrete(name = "Classes")


###


bin = read.csv("~/Projects/personal/tcc/TCC/r-project/bin2.csv")
final = read.csv("~/Projects/personal/tcc/TCC/r-project/final.csv")

bin$learner.id  = factor(bin$learner.id)
bin$learner.id = plyr::mapvalues(bin$learner.id, from = levels(bin$learner.id),
                            to = c("svm", "mlp", "rf", "nbayes"))


multi$learner.id  = factor(multi$learner.id)
multi$learner.id = plyr::mapvalues(multi$learner.id, from = levels(multi$learner.id),
                                 to = c("svm", "mlp", "rf", "nbayes"))

multi2 = subset(multi, select = c("learner.id", "auc", "timepredict", "timetrain"))
write.csv(infos, "~/Projects/personal/tcc/TCC/r-project/final.csv", row.names = FALSE)

infos = rbind(bin, multi)


##grafico sintomas 
tecnicas = read.csv("~/Projects/personal/tcc/TCC/r-project/tecnicas.csv")

ggplot(tecnicas, aes(x =tecs)) + 
  geom_bar(position = "dodge") +
  theme(aspect.ratio = 1.2, legend.position = "top") + labs(y = "Quantidade de Identificação de cada Classe ", x="")  +
  scale_y_continuous(breaks = seq(0, 320, by = 20)) + scale_fill_discrete(name = "Classes")


