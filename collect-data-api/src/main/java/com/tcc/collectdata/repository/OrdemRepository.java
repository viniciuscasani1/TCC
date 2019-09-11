package com.tcc.collectdata.repository;

import com.tcc.collectdata.dto.ItemClasse;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author vinicius.casani
 * @version 1.0
 * @since 29/01/2019.
 */
@Repository
public class OrdemRepository extends AbstractRepository {

    public List<ItemClasse> listar() {

	return super.query("select * from TWEET", (resultSet, i) -> {
	    ItemClasse ordem = new ItemClasse();
	    ordem.setComportamental(resultSet.getBoolean("COMPORTAMENTAL"));
	    ordem.setPsiquico(resultSet.getBoolean("PSIQUICO"));
	    ordem.setFisiologico(resultSet.getBoolean("FISIOLOGICO"));
	    ordem.setTweet(resultSet.getString("DS_TWEET"));
	    ordem.setIdUsuario(resultSet.getString("USUARIO"));
	    ordem.setDhTweet(resultSet.getDate("DH_TWEET"));
	    return ordem;
	});
    }

    public ItemClasse save(ItemClasse itemClasse) {
	Map<String, Object> parameters = new HashMap<>();
	parameters.put("comportamental", itemClasse.getComportamental() ? 1 : 0);
	parameters.put("fisiologico", itemClasse.getFisiologico() ? 1 : 0);
	parameters.put("psiquico", itemClasse.getPsiquico() ? 1 : 0);
	parameters.put("ds_tweet", itemClasse.getTweet());
	parameters.put("dh_tweet", itemClasse.getDhTweet());
	parameters.put("user", itemClasse.getIdUsuario());

	Long id = super.insert(
			"INSERT INTO TWEET (COMPORTAMENTAL, PSIQUICO, FISIOLOGICO, DS_TWEET, DH_TWEET, USUARIO) "
					+ "VALUES ( :comportamental, :psiquico, :fisiologico, :ds_tweet, :dh_tweet, :user )",
			parameters, "id_tweet");
//	ordem.setIdOrdem(id);
	return itemClasse;
    }
//
//    public void update(Ordem ordem) {
//	Map<String, Object> parameters = new HashMap<>();
//	parameters.put("id_ordem", ordem.getIdOrdem());
//	parameters.put("status", ordem.getStatus());
//
//	super.update("UPDATE TB_ORDEM SET STATUS = :status WHERE ID_ORDEM = :id_ordem", parameters);
//    }

}
