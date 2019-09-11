package com.tcc.collectdata.controller;

import com.tcc.collectdata.dto.Item;
import com.tcc.collectdata.dto.ItemClasse;
import com.tcc.collectdata.service.DataService;
import com.tcc.collectdata.service.TwitterDataService;
import org.springframework.web.bind.annotation.*;

import javax.inject.Inject;
import java.util.List;

/**
 * @author Vinicius Casani
 **/
@RestController
@RequestMapping("data")
public class DataController {

    private final TwitterDataService twitterDataService;

    private final DataService dataService;

    @Inject
    public DataController(TwitterDataService twitterDataService, DataService dataService) {
        this.twitterDataService = twitterDataService;
        this.dataService = dataService;
    }

    @RequestMapping(method = RequestMethod.GET, value = "{ds}")
    public List<ItemClasse> getTweets(@PathVariable("ds") String ds) {

        return dataService.findTweetsCategorizados(ds);
    }

    @RequestMapping(method = RequestMethod.GET)
    public List<ItemClasse> findAll() {

        return dataService.listar();
    }

    @RequestMapping(method = RequestMethod.POST, path = "categorizar")
    public List<ItemClasse> categorizar(@RequestBody Item item) {

        return dataService.categorizarString(item.getData());
    }


}
