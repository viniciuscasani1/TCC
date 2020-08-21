library(PMCMR)

result

tst = dataset

tst[,c("idUsuario") := NULL]

a = subset(tst, select = c("tweet", "idTweet", "fisiologico", "comportamental", "psiquico", "label", "dhTweet", "validadoEspec"))

ds = data.frame(resutl2)

View(a)
multi = write.csv(tst, "~/Projects/personal/tcc/TCC/r-project/qp1-2.csv")
a = posthoc.kruskal.nemenyi.test(multi$Média.AUC~factor(multi$Classificador) , data = multi, method = "Chisquare") 

a

=?posthoc.friedman.nemenyi.test


a
result
