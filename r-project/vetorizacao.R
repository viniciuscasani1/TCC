library(text2vec)
library(superml)

vetorizar <- function(sentencas){
  print(23)
  #cria vetorização
  tf_object = TfIdfVectorizer$new(max_df=1, min_df=0.5, max_features=1, smooth_idf=TRUE)
  #realiza a vetorização das sentenças
  tf_object$fit(sentencas)
  #tf_matrix = tf_object$transform(sentencas)
  tf_matrix = tf_object$fit_transform(sentencas)
  
  return(tf_matrix)
}
