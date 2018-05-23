<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.sailu.facebook.TweetUtils" %>
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
          <div class="nav-collapse">
            <ul class="nav custom">
              <li><a href="index.jsp">Home</a></li>
              <li class="active"><a id="friends_tweet" href="./friends.jsp">Friends Tweet</a> </li>
              <li ><a id="friends_top_tweets" href="./top_tweets.jsp">Top Tweets</a> </li>
            </ul>
          </div>
          </div>
</div>
  <h1> Friends Tweet Page</h1><br>
  
<% Cookie[] cookies = request.getCookies();
		String name="";
		if (cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
				Cookie cookie = cookies[i];
				if (cookie.getName().equals("userid")) {
					name = cookie.getValue();
					break;
				}
				else{
				}
			}
		}
		
 %> 
		
		<% 
	    List<Entity> tweets = TweetUtils.getFriendsTweets(name);
	    int num_tweets = tweets.size();
	    if (tweets.isEmpty()) {
		%>
<div class="alert alert-danger">
  <button type="button" class="close" data-dismiss="alert">&times;</button>
  <h4>No tweets..</h4>
   
  
</div>
<% 
} 
	     else {
	    	 for (Entity tweet : tweets) { 
	    			String tweet_text =  (String) tweet.getProperty("text");
	    			String tweet_date = (String) tweet.getProperty("date");
	    			String username = (String) tweet.getProperty("username");
	    			Long count = (Long) tweet.getProperty("count");
	    			String key = KeyFactory.keyToString(tweet.getKey()); 
					String href = "'tweet.jsp?tweet_key=" + key + "'";
					String picture = "'" + (String) tweet.getProperty("picture") + "'";
					%>
	     <div class="container">
        <ul class="list-group">

            <li class="list-group-item ">
              <p>
              	<div>
	                <div id="profile_pic" class="span1"><a href=<%=href%> class="thumbnail"><img src=<%=picture%> alt=""></a>&nbsp; </div>
	                <a class="active" target="_blank" href=<%=href%> ><%=tweet_text%></a>
	            </div>
              </p>
              <br/>
              <br/>
              <br/>
              <p style="min-height: 10px;"></p>
              <p >
                <strong>Created at: <%=tweet_date %></strong>
              </p>
              <p>
                <strong> Posted by: <%=username %></strong> 
              </p>
               <p>
                <strong> View Count : <%=count %></strong> 
              </p>
              </li>


      </ul>
  </div>
	     <% }  
	    	} %>
</body>
</html>