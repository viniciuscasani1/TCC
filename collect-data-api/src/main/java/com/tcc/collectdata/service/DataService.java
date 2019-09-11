package com.tcc.collectdata.service;

import com.tcc.collectdata.dto.ItemClasse;
import com.tcc.collectdata.repository.OrdemRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import twitter4j.Status;

import javax.inject.Inject;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;

/**
 * @author Vinicius Casani
 **/
@Service
@Transactional
public class DataService {

    private final TwitterDataService twitterDataService;

    @Inject
    private final OrdemRepository ordemRepository;

    @Inject
    public DataService(TwitterDataService twitterDataService,
                    OrdemRepository ordemRepository) {
        this.twitterDataService = twitterDataService;
        this.ordemRepository = ordemRepository;
    }

    private void writeFile(List<String> lines) throws IOException {

        List<String> dados = new ArrayList<>();

        for (String line : lines) {

            String dado = getInfo(line);

            if (!dado.equals("text")) {

                String classe = getClasse(line);

                for (String resultado : readTweets(dado)) {

                    dados.add(resultado + "|" + classe);

                    Files.write(Paths.get(
                            "/Users/vinicius.casani/Projects/personal/tcc/collect-data/src/main/java/com/tcc/collectdata/dados.csv"),
                            Collections.singletonList(resultado + "|" + classe),
                            Charset.defaultCharset(), StandardOpenOption.APPEND);
                }

            }

        }
    }

    public void categorizarTweet() throws IOException {

        List<String> linhas = Files.readAllLines(
                        Paths.get("/Users/vinicius.casani/Projects/personal/tcc/collect-data/src/main/java/com/tcc/collectdata/dados.csv"));

        List<String> as = new ArrayList<>();
        for (String s : linhas) {

            as.add(getInfo(s));
        }

        categorizarString(as);
    }

    private List<String> readTweets(String label) {

        return twitterDataService.searchtweetsString(label);

    }

    private String getInfo(String s) {

        return s.split(",")[0];
    }

    private String getClasse(String s) {

        return s.split(",")[1];
    }

    private List<String> comportamentalList() {

        List<String> list = new ArrayList<>();

        list.add("afastar de pessoas");
        list.add("acabar com a vida");
        list.add("acabar com a existência");
        list.add("chega de existir");
        list.add("chega de viver");
        list.add("Não vejo mais graça em viver");
        list.add("depreciado");
        list.add("desdenhado");
        list.add("desejar desaparecer");
        list.add("desejar falarecer");
        list.add("desejo desaparecer");
        list.add("desejo falecer");
        list.add("desmerecido");
        list.add("desvalorizado");
        list.add("dificuldade de sair de casa");
        list.add("diminuido");
        list.add("distanciar de pessoas");
        list.add("evitar de sair");
        list.add("evitar pessoas");
        list.add("menosprezado");
        list.add("não consigo sair de casa");
        list.add("não desejo mais sair");
        list.add("não desejo sair de casa");
        list.add("não quero sair");
        list.add("não desejo ver pessoas");
        list.add("não faz sentido existir");
        list.add("não faz sentido viver");
        list.add("nao quero existir");
        list.add("não quero mais sair");
        list.add("não quero sair de casa");
        list.add("não quero ver pessoas");
        list.add("não quero viver");
        list.add("não sou capaz de sair de casa");
        list.add("querer desaparecer");
        list.add("querer falecer");
        list.add("querer morrer");
        list.add("quero desaparecer");
        list.add("quero falecer");
        list.add("quero morrer");
        list.add("rebaixado");
        list.add("sou um estorvo");
        list.add("sou um fardo");
        list.add("sou um incômodo");
        list.add("sou um peso");

        return list;
    }

    private List<String> psiquicoList() {

        List<String> list = new ArrayList<>();

        list.add("abatido");
        list.add("aborrecido");
        list.add("a culpa é minha");
        list.add("ânimo");
        list.add("ânimo abalado");
        list.add("ânimo arruinado");
        list.add("ânimo comprometido");
        list.add("ânimo debilitado");
        list.add("ânimo destruido");
        list.add("ânimo enfraquecido");
        list.add("ânimo instável");
        list.add("ausência de alegria");
        list.add("ausência de ânimo");
        list.add("ausência de desejo");
        list.add("ausência de disposição");
        list.add("ausência de felicidade");
        list.add("ausência de humor");
        list.add("ausência de prazer");
        list.add("ausência de temperamento");
        list.add("chateado");
        list.add("culpado");
        list.add("depressão");
        list.add("depressivo");
        list.add("deprimido");
        list.add("desanimado");
        list.add("desânimo");
        list.add("desânimo sem motivo");
        list.add("desgraça");
        list.add("desimportante");
        list.add("desinteressante");
        list.add("desmotivado");
        list.add("disposição abalada");
        list.add("disposição arruinada");
        list.add("disposição comprometida");
        list.add("disposição debilitada");
        list.add("disposição destruida");
        list.add("disposição enfraquecida");
        list.add("disposição instável");
        list.add("estimulo");
        list.add("estressado");
        list.add("falta de alegria");
        list.add("falta de ânimo");
        list.add("falta de atenção");
        list.add("falta de concentração");
        list.add("falta de cuidado");
        list.add("falta de dedicação");
        list.add("falta de desejo");
        list.add("falta de disposição");
        list.add("falta de estimulo");
        list.add("falta de graça");
        list.add("falta de humor");
        list.add("falta de importância");
        list.add("falta de interesse");
        list.add("falta de motivação");
        list.add("falta de paciência");
        list.add("falta de prazer");
        list.add("falta de razão");
        list.add("falta de sensibilidade");
        list.add("falta de sentido");
        list.add("falta de significado");
        list.add("falta de temperamento");
        list.add("falta de tolerância");
        list.add("falta de vontade");
        list.add("falta felicidade");
        list.add("fracassado");
        list.add("frustrado");
        list.add("humor abalado");
        list.add("humor abatido");
        list.add("humor arruinado");
        list.add("humor comprometido");
        list.add("humor debilitado");
        list.add("humor depressivo");
        list.add("humor deprimido");
        list.add("humor destruído");
        list.add("humor enfraquecido");
        list.add("humor instável");
        list.add("humor melancólico");
        list.add("incentivo");
        list.add("indisposição");
        list.add("inexistência de ânimo");
        list.add("inexistência de disposição");
        list.add("inexistência de humor");
        list.add("inexistência de temperamento");
        list.add("infelicidade");
        list.add("infelicidade profunda");
        list.add("infeliz");
        list.add("infeliz sem motivo");
        list.add("inútil");
        list.add("melancólico");
        list.add("me sinto culpada");
        list.add("motivação");
        list.add("nada tem razão pra mim");
        list.add("nada tem sentido para mim");
        list.add("nada tem significado pra mim");
        list.add("não sinto alegria");
        list.add("não sinto curiosidade por nada");
        list.add("não sinto desejo");
        list.add("não sinto disposição por nada");
        list.add("não sinto felicidade");
        list.add("não sinto humor");
        list.add("não sinto interesse por nada");
        list.add("não sinto nada");
        list.add("não sinto prazer");
        list.add("não sou importante");
        list.add("não tenho desejo");
        list.add("não tenho valor");
        list.add("não tenho vontade");
        list.add("pra baixo");
        list.add("sem afeto");
        list.add("sem alegria");
        list.add("sem amor");
        list.add("sem animação");
        list.add("sem ânimo");
        list.add("sem ânimo de fazer");
        list.add("sem desejo");
        list.add("sem desejo de fazer");
        list.add("sem disposição");
        list.add("sem emoção");
        list.add("sem entusiasmo");
        list.add("sem estimulo");
        list.add("sem felicidade");
        list.add("sem graça");
        list.add("sem humor");
        list.add("sem importância");
        list.add("sem incentivo");
        list.add("sem interesse");
        list.add("sem motivação");
        list.add("sem prazer");
        list.add("sem razão");
        list.add("sem satisfação");
        list.add("sem sentido");
        list.add("sem sentimento");
        list.add("sem significado");
        list.add("sem valor");
        list.add("sem vontade");
        list.add("sem vontade de fazer");
        list.add("sentimento de culpa");
        list.add("sentimento de tristeza");
        list.add("sinto muita culpa");
        list.add("só depressão");
        list.add("só desânimo");
        list.add("só infelicidade");
        list.add("só tristeza");
        list.add("temperamento abalado");
        list.add("temperamento arruinado");
        list.add("temperamento comprometido");
        list.add("temperamento debilitado");
        list.add("temperamento destruido");
        list.add("temperamento enfraquecido");
        list.add("temperamento instável");
        list.add("triste");
        list.add("triste sem motivo");
        list.add("tristeza");
        list.add("tristeza profunda");

        return list;
    }

    private List<String> fisicoList() {

        List<String> list = new ArrayList<>();

        list.add("dificuldade de adormecer");
        list.add("dificuldade de cochilar");
        list.add("dificuldade de dormir");
        list.add("falta de apetite");
        list.add("falta de energia");
        list.add("falta de fome");
        list.add("não consigo comer");
        list.add("insônia");
        list.add("não sinto sono");
        list.add("muito cansado");
        list.add("muito desgastado");
        list.add("muito esgotado");
        list.add("muito exausto");
        list.add("perda de apetite");
        list.add("perda de fome");
        list.add("sem apetite");
        list.add("sem energia");
        list.add("sem fome");
        list.add("sempre cansado");
        list.add("sempre desgastado");
        list.add("sempre esgotado");
        list.add("sempre exausto");
        list.add("sem sono");
        list.add("não consigo dormir");
        list.add("problemas pra dormir");

        return list;

    }

    public List<ItemClasse> categorizarString(List<String> sentencas) {

        List<String> novas = new ArrayList<>(
                new HashSet<>(sentencas));

        List<ItemClasse> items = new ArrayList<>();

        for (String sentenca : novas) {

            ItemClasse itemClasse = new ItemClasse(sentenca, false, false, false);

            if (verificaExistencia(comportamentalList(), sentenca)) {

                itemClasse.setComportamental(true);
            }
            if (verificaExistencia(psiquicoList(), sentenca)) {

                itemClasse.setPsiquico(true);
            }

            if (verificaExistencia(fisicoList(), sentenca)) {

                itemClasse.setFisiologico(true);
            }

            saveTweet(itemClasse);

            items.add(itemClasse);
        }
        return items;
    }

    public List<ItemClasse> categorizar(List<ItemClasse> items) {

        List<ItemClasse> novas = new ArrayList<>(
                new HashSet<>(items));

        for (ItemClasse itemClasse : novas) {

            if (verificaExistencia(comportamentalList(), itemClasse.getTweet())) {

                itemClasse.setComportamental(true);
            }
            if (verificaExistencia(psiquicoList(), itemClasse.getTweet())) {

                itemClasse.setPsiquico(true);
            }

            if (verificaExistencia(fisicoList(), itemClasse.getTweet())) {

                itemClasse.setFisiologico(true);
            }

            saveTweet(itemClasse);

            items.add(itemClasse);
        }
        return items;
    }

    public List<ItemClasse> findTweetsCategorizados(String ds) {

        List<Status> tweets = twitterDataService.searchtweets(ds);

        List<ItemClasse> itemClasses = convert(tweets);

        return categorizar(itemClasses);
    }

    private List<ItemClasse> convert(List<Status> statusList) {

        List<String> controle = new ArrayList<>();

        List<ItemClasse> itemClasses = new ArrayList<>();

        statusList.forEach(status -> {
            if(!status.isRetweet() &&!controle.contains(status.getText().toLowerCase())) {
                itemClasses.add(convert(status));
                controle.add(status.getText().toLowerCase());
            }
        });

        return itemClasses;
    }

    private ItemClasse convert(Status status) {

        ItemClasse itemClasse = new ItemClasse();

        itemClasse.setComportamental(false);
        itemClasse.setFisiologico(false);
        itemClasse.setPsiquico(false);
        itemClasse.setTweet(status.getText().replaceAll(".\n", " "));
        itemClasse.setDhTweet(status.getCreatedAt());
        itemClasse.setIdUsuario(status.getUser().getScreenName());

        return itemClasse;
    }

    public Boolean verificaExistencia(List<String> datas, String sentenca) {


        for (String data : datas) {

            if (removeDiacriticalMarks(sentenca.toLowerCase()).contains(removeDiacriticalMarks(data.toLowerCase()))) {
                return true;
            }
        }
        return false;

    }

    public static String removeDiacriticalMarks(String string) {
        return Normalizer.normalize(string, Normalizer.Form.NFD)
                .replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
    }

    public void saveTweet(ItemClasse itemClasse){

        ordemRepository.save(itemClasse);

    }

    public List<ItemClasse> listar(){

        return ordemRepository.listar();
    }
}
