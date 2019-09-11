package com.tcc.collectdata.dto;

import java.io.Serializable;
import java.util.List;

public class Item implements Serializable {

    private List<String> data;

    public List<String> getData() {
        return data;
    }

    public void setData(List<String> data) {
        this.data = data;
    }
}
