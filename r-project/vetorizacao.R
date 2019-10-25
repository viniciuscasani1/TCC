library(text2vec)
library(superml)

vetorizar <- function(sentencas, max= 1, min = 1, feat = 1){
  print(max)
  print(min)
  print(feat)
  #cria vetorização
  tf_object = TfIdfVectorizer$new(max_df=max, min_df=min, max_features=feat, smooth_idf=TRUE)
  #realiza a vetorização das sentenças
  tf_object$fit(sentencas)
  #tf_matrix = tf_object$transform(sentencas)
  tf_matrix = tf_object$fit_transform(sentencas)
  
  return(tf_matrix)
}
