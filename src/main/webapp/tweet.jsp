<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.EntityNotFoundException" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>FBTweet, from sailaja munagapati</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="FB Tweet Project CS6320">
    <meta name="author" content="sailaja munagapati">

<script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
 <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" ></script>
 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" >
 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" >
 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
 <link href="./css/bootstrap.min.css" media="all" type="text/css" rel="stylesheet">
 <link href="./css/bootstrap-responsive.min.css" media="all" type="text/css" rel="stylesheet">
 <link href="./css/font-awesome.css" rel="stylesheet" >
 
  </head>
  <style>
	.nav > li > a:hover {
    color: black;
}
</style>
  <body>
  
  <div class="navbar navbar-default">
      <div class="container-fluid" style="background-color: #4b68b8;">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </a>
          <a class="brand" href="#">Tweeter</a>
          <div class="btn-group pull-right">
           <a id="fullname"> </a>                     
           </div>
          <div class="nav-collapse">
            <ul class="nav custom">
              <li class="active"><a href="index.jsp">Home</a></li>
              <li><a id="friends_tweet" href="./friends.jsp">Friends Tweet</a> </li>
              <li><a id="friends_top_tweets" href="./top_tweets.jsp">Top Tweets</a> </li>
            </ul>
          </div><!--/.nav-collapse -->
       </div>
  </div>
  
    <div class="container">

  <%
    String tweet_key = request.getParameter("tweet_key");
    if (tweet_key == null) {
    	
    	%>
    	<script type="text/javascript"> msg= "Invalid page..";</script>
    <%
    } else { 
        DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
        Key tw_key = KeyFactory.stringToKey(tweet_key); 
        String tweet_text="", username="", date="";
 
        String count = "";
			Entity tweet = ds.get(tw_key);
			 tweet_text = (String) tweet.getProperty("text");
			 Long newcount = (Long) tweet.getProperty("count");
			 newcount +=1 ;
			 tweet.setProperty("count", newcount);
			 username = (String) tweet.getProperty("username");
			 date = (String) tweet.getProperty("date");
			 ds.put(tweet);
			
			

    %>	
        


        <ul class="list-group">

            <li class="list-group-item list-group-item-success">
              <p>
                <strong> Tweet: <%=tweet_text %> </strong>
              </p>
              <p>
                <strong>Created at: <%=date %></strong>
              </p>
              <p>
                <strong> Posted by: <%=username %></strong> 
              </p>
               <p>
                <strong> View Count : <%=newcount %></strong> 
              </p>
            </li>


      </ul>
  <%
      }
      %>
     </div>   
  
  </body>   
</html>