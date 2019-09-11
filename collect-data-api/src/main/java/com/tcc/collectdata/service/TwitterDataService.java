package com.tcc.collectdata.service;

import org.springframework.stereotype.Service;
import twitter4j.*;

import java.util.List;
import java.util.stream.Collectors;

/**
 * @author Vinicius Casani
 **/

@Service
public class TwitterDataService {

    public Twitter getTwitterinstance() {

	return TwitterFactory.getSingleton();

    }

    public String createTweet(String tweet) throws TwitterException {
	Twitter twitter = getTwitterinstance();
	Status status = twitter.updateStatus("creating baeldung API");
	return status.getText();
    }

    public List<String> getTimeLine() throws TwitterException {
	Twitter twitter = getTwitterinstance();
	List<Status> statuses = twitter.getHomeTimeline();
	return statuses.stream().map(
			Status::getText).collect(
			Collectors.toList());
    }

    public String sendDirectMessage(String recipientName, String msg) throws TwitterException {
	Twitter twitter = getTwitterinstance();
	DirectMessage message = twitter.sendDirectMessage(recipientName, msg);
	return message.getText();
    }

    public List<String> searchtweetsString(String ds) {

	return searchtweets(ds).stream().map(
			Status::getText).collect(
			Collectors.toList());
    }

    public List<Status> searchtweets(String ds) {
	Twitter twitter = getTwitterinstance();
	Query query = new Query(ds);
	QueryResult result = null;
	try {
	    result = twitter.search(query);
	} catch (TwitterException e) {
	    e.printStackTrace();
	}

	return result.getTweets();
    }

    public void streamFeed() {

	StatusListener listener = new StatusListener() {

	    @Override
	    public void onException(Exception e) {
		e.printStackTrace();
	    }

	    @Override
	    public void onDeletionNotice(StatusDeletionNotice arg) {
		System.out.println("Got a status deletion notice id:" + arg.getStatusId());
	    }

	    @Override
	    public void onScrubGeo(long userId, long upToStatusId) {
		System.out.println("Got scrub_geo event userId:" + userId + " upToStatusId:" + upToStatusId);
	    }

	    @Override
	    public void onStallWarning(StallWarning warning) {
		System.out.println("Got stall warning:" + warning);
	    }

	    @Override
	    public void onStatus(Status status) {
		System.out.println(status.getUser().getName() + " : " + status.getText());
	    }

	    @Override
	    public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
		System.out.println("Got track limitation notice:" + numberOfLimitedStatuses);
	    }
	};

	TwitterStream twitterStream = new TwitterStreamFactory().getInstance();

	twitterStream.addListener(listener);

	twitterStream.sample();

    }

}
