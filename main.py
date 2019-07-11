import pandas as pd
from sklearn import svm
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics import classification_report
import csv
from itertools import izip_longest as zip_longest


def write_list_to_file(kernel, resultCompor, resultPsic, resultFisio):
    """Write the list to csv file."""
    resultFile = 'results/resultados.csv'
    rows = [kernel, resultCompor, resultPsic, resultFisio]
    export_data = zip_longest(*rows, fillvalue='')
    with open(resultFile, "w") as myfile:
        wr = csv.writer(myfile)
        wr.writerow(("Kernel", "Resultado Comportamental", "Resultado Psiquico", "Resultado Fisiologico"))
        wr.writerows(export_data)
        myfile.close()


class principal:
    # train Data
    trainData = pd.read_csv("dataset.csv")
    # test Data
    testData = pd.read_csv("test.csv")

    stopwords = ['de',
                 'a',
                 'o',
                 'que',
                 'e',
                 'do',
                 'da',
                 'em',
                 'um',
                 'para',
                 'e',
                 'com',
                 'uma',
                 'os',
                 'no',
                 'se',
                 'na',
                 'por',
                 'mais',
                 'as',
                 'dos',
                 'como',
                 'mas',
                 'foi',
                 'ao',
                 'ele',
                 'das',
                 'tem',
                 'a',
                 'seu',
                 'sua',
                 'ou',
                 'ser',
                 'quando',
                 'ha',
                 'nos',
                 'ja',
                 'esta',
                 'tambem',
                 'so',
                 'pelo',
                 'pela',
                 'ate',
                 'isso',
                 'ela',
                 'entre',
                 'era',
                 'depois',
                 'sem',
                 'mesmo',
                 'aos',
                 'ter',
                 'seus',
                 'quem',
                 'nas',
                 'me',
                 'esse',
                 'eles',
                 'estao',
                 'voce',
                 'tinha',
                 'foram',
                 'essa',
                 'num',
                 'nem',
                 'suas',
                 'as',
                 'minha',
                 'tem',
                 'numa',
                 'pelos',
                 'elas',
                 'havia',
                 'seja',
                 'qual',
                 'sera',
                 'nos',
                 'tenho',
                 'lhe',
                 'deles',
                 'essas',
                 'esses',
                 'pelas',
                 'este',
                 'fosse',
                 'dele',
                 'tu',
                 'te',
                 'voces',
                 'vos',
                 'lhes',
                 'teu',
                 'tua',
                 'teus',
                 'tuas',
                 'nosso',
                 'nossa',
                 'nossos',
                 'nossas',
                 'dela',
                 'delas',
                 'esta',
                 'estes',
                 'estas',
                 'aquele',
                 'aquela',
                 'aqueles',
                 'aquelas',
                 'isto',
                 'aquilo',
                 'estou',
                 'esta',
                 'estamos',
                 'estao',
                 'estive',
                 'esteve',
                 'estivemos',
                 'estiveram',
                 'estava',
                 'estavamos',
                 'estavam',
                 'estivera',
                 'estiveramos',
                 'esteja',
                 'estejamos',
                 'estejam',
                 'estivesse',
                 'estivessemos',
                 'estivessem',
                 'estiver',
                 'estivermos',
                 'estiverem',
                 'hei',
                 'ha',
                 'havemos',
                 'hao',
                 'houve',
                 'houvemos',
                 'houveram',
                 'houvera',
                 'houveramos',
                 'haja',
                 'hajamos',
                 'hajam',
                 'houvesse',
                 'houvessemos',
                 'houvessem',
                 'houver',
                 'houvermos',
                 'houverem',
                 'houverei',
                 'houvera',
                 'houveremos',
                 'houverao',
                 'houveria',
                 'houveriamos',
                 'houveriam',
                 'somos',
                 'sao',
                 'era',
                 'eramos',
                 'eram',
                 'fui',
                 'foi',
                 'fomos',
                 'foram',
                 'fora',
                 'foramos',
                 'seja',
                 'sejamos',
                 'sejam',
                 'fosse',
                 'fossemos',
                 'fossem',
                 'for',
                 'formos',
                 'forem',
                 'serei',
                 'sera',
                 'seremos',
                 'serao',
                 'seria',
                 'seriamos',
                 'seriam',
                 'tenho',
                 'tem',
                 'temos',
                 'tem',
                 'tinha',
                 'tinhamos',
                 'tinham',
                 'tive',
                 'teve',
                 'tivemos',
                 'tiveram',
                 'tivera',
                 'tiveramos',
                 'tenha',
                 'tenhamos',
                 'tenham',
                 'tivesse',
                 'tivessemos',
                 'tivessem',
                 'tiver',
                 'tivermos',
                 'tiverem',
                 'terei',
                 'tera',
                 'teremos',
                 'terao',
                 'teria',
                 'teriamos',
                 'teriam']

    # Cria os vetores de caracteristicas, para executar sem remover stopwords basta remover o parametro
    vectorizer = TfidfVectorizer(sublinear_tf=True,
                                 use_idf=True,
                                 strip_accents='ascii',
                                 stop_words=stopwords)
    train_vectors = vectorizer.fit_transform(trainData['text'])
    test_vectors = vectorizer.transform(testData['text'])

    nexec = 29
    kernels = []
    resultPisc = []
    resultComport = []
    resultFisio = []
    conta = 0
    while (conta <= nexec):
        conta += 1
        print('\n\nkernel linear')

        # Atribui o kernel linear no SVM
        classifier_linear = svm.SVC(kernel='linear')
        classifier_linear.fit(train_vectors, trainData['classificacao'])
        prediction_linear = classifier_linear.predict(test_vectors)

        report_linear = classification_report(testData['label'], prediction_linear, output_dict=True)
        print('comportamental: ', report_linear['comportamental'])
        print('psiquico: ', report_linear['psiquico'])
        print('fisiologico: ', report_linear['fisiologico'])

        # adiciona resultados nas listas
        kernels.append('Linear')
        resultPisc.append(report_linear['psiquico'])
        resultComport.append(report_linear['comportamental'])
        resultFisio.append(report_linear['fisiologico'])

        # Atribui o kernel rbf no SVM
        print('\n\nkernel rbf')
        classifier_rbf = svm.SVC(kernel='rbf', gamma='scale')
        classifier_rbf.fit(train_vectors, trainData['classificacao'])
        prediction_rbf = classifier_rbf.predict(test_vectors)

        report_rbf = classification_report(testData['label'], prediction_rbf, output_dict=True)
        print('comportamental: ', report_rbf['comportamental'])
        print('psiquico: ', report_rbf['psiquico'])
        print('fisiologico: ', report_rbf['fisiologico'])

        # adiciona resultados nas listas
        kernels.append('RBF')
        resultPisc.append(report_rbf['psiquico'])
        resultComport.append(report_rbf['comportamental'])
        resultFisio.append(report_rbf['fisiologico'])

        # Atribui o kernel Polynomial no SVM
        print('\n\nkernel polynomial')
        classifier_poly = svm.SVC(kernel='poly', gamma='scale')
        classifier_poly.fit(train_vectors, trainData['classificacao'])
        prediction_poly = classifier_poly.predict(test_vectors)

        report_poly = classification_report(testData['label'], prediction_poly, output_dict=True)
        print('comportamental: ', report_poly['comportamental'])
        print('psiquico: ', report_poly['psiquico'])
        print('fisiologico: ', report_poly['fisiologico'])

        # adiciona resultados nas listas
        kernels.append('Polynomial')
        resultPisc.append(report_poly['psiquico'])
        resultComport.append(report_poly['comportamental'])
        resultFisio.append(report_poly['fisiologico'])

        # Atribui o kernel sigmoid no SVM
        print('\n\nkernel sigmoid')
        classifier_sig = svm.SVC(kernel='sigmoid', gamma='scale')
        classifier_sig.fit(train_vectors, trainData['classificacao'])
        prediction_sig = classifier_sig.predict(test_vectors)

        report_sig = classification_report(testData['label'], prediction_sig, output_dict=True)
        print('comportamental: ', report_sig['comportamental'])
        print('psiquico: ', report_sig['psiquico'])
        print('fisiologico: ', report_sig['fisiologico'])

        # adiciona resultados nas listas
        kernels.append('Sigmoid')
        resultPisc.append(report_sig['psiquico'])
        resultComport.append(report_sig['comportamental'])
        resultFisio.append(report_sig['fisiologico'])
    else:
        write_list_to_file(kernels, resultComport, resultPisc, resultFisio)


if __name__ == '__main__':
    principal
