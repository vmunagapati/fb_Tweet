package com.sailu.facebook;

import java.util.List;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Query;

public class TweetUtils {
	/* retrieves list of tweets of a user */
	public static List<Entity> getTweetsByUserId(String userId){
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	    
	    Query query = new Query("Tweet");
	    query.addFilter("userid",
	            Query.FilterOperator.EQUAL,
	            userId);
	    query.addSort("date", Query.SortDirection.DESCENDING);
	    List<Entity> tweets = datastore.prepare(query).asList(FetchOptions.Builder.withChunkSize(2000));
	    return tweets;
	}

	/*retrives list of tweets order by view count*/
	public static List<Entity> getTopTweets(String userId){
	    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	    
	    Query query = new Query("Tweet");
	    query.addFilter("userid",
	            Query.FilterOperator.NOT_EQUAL,
	            userId);
	    query.addSort("userid");
	    query.addSort("count", Query.SortDirection.DESCENDING);
	    
	    
	    List<Entity> tweets = datastore.prepare(query).asList(FetchOptions.Builder.withChunkSize(2000));
	    return tweets;
	}
	/*retrives list of tweets of friends order*/
	public static List<Entity> getFriendsTweets(String userId){
		  DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		  
		    Query query = new Query("Tweet");
		    query.addFilter("userid",
		            Query.FilterOperator.NOT_EQUAL,
		            userId);
		    List<Entity> tweets = datastore.prepare(query).asList(FetchOptions.Builder.withChunkSize(2000));
		    return tweets;
	}
}
