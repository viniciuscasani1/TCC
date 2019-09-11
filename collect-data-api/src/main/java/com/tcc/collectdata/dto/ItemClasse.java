package com.tcc.collectdata.dto;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.Objects;

/**
 * @author Vinicius Casani
 **/
public class ItemClasse implements Serializable {

    private String tweet;

    private Boolean comportamental;

    private Boolean fisiologico;

    private Boolean psiquico;

    private Date dhTweet;

    private String idUsuario;

    public ItemClasse(String tweet, Boolean comportamental, Boolean fisiologico, Boolean psiquico) {
        this.tweet = tweet;
        this.comportamental = comportamental;
        this.fisiologico = fisiologico;
        this.psiquico = psiquico;
    }

    public ItemClasse() {
    }

    public String getTweet() {
        return tweet;
    }

    public void setTweet(String tweet) {
        this.tweet = tweet;
    }

    public Boolean getComportamental() {
        return comportamental;
    }

    public void setComportamental(Boolean comportamental) {
        this.comportamental = comportamental;
    }

    public Boolean getFisiologico() {
        return fisiologico;
    }

    public void setFisiologico(Boolean fisiologico) {
        this.fisiologico = fisiologico;
    }

    public Boolean getPsiquico() {
        return psiquico;
    }

    public void setPsiquico(Boolean psiquico) {
        this.psiquico = psiquico;
    }

    public Date getDhTweet() {
        return dhTweet;
    }

    public void setDhTweet(Date dhTweet) {
        this.dhTweet = dhTweet;
    }

    public String getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(String idUsuario) {
        this.idUsuario = idUsuario;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof ItemClasse)) return false;
        ItemClasse that = (ItemClasse) o;
        return getTweet().equals(that.getTweet());
    }

    @Override
    public int hashCode() {
        return Objects.hash(getTweet());
    }
}
