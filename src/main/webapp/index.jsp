<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.sailu.facebook.TweetUtils" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Social Web Portal</title>

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
 <div id="fb-root"></div>
<script>
function statusChangeCallback(response) {
	console.log('statusChangeCallback');
	console.log(response);
	if (response.status === 'connected') {
		var msg=document.getElementById('main_tweet_db');
		msg.style.display='';
		var login_div=document.getElementById('status');
		login_div.style.display='none';
		testAPI();
	} else if (response.status === 'not_authorized') {
		var msg=document.getElementById('main_tweet_db');
		msg.style.display='none';
		profile.style.display='none';
		document.cookie = "userid=" ;
		document.cookie = "username=";
	} else {
		var msg=document.getElementById('main_tweet_db');
		msg.style.display='none';
		profile.style.display='none';
		document.cookie = "userid=" ;
		document.cookie = "username=";
	}
}

var login_event = function(response) {
	var msg=document.getElementById('main_tweet_db');
	msg.style.display='';
	var login_div=document.getElementById('status');
	login_div.style.display='none';
}

var logout_event = function(response) {
	var msg=document.getElementById('main_tweet_db');
	msg.style.display='none';
	var login_div=document.getElementById('status');
	login_div.style.display='';
	document.cookie = "userid=" ;
	document.cookie = "username=";

}
  function checkLoginState() {
    FB.getLoginStatus(function(response) {
      statusChangeCallback(response);
    });
  }


window.fbAsyncInit = function() {
    FB.init({
	   	appId      : '444930192586004',
      	cookie     : true,  // enable cookies to allow the server to access 
      	xfbml      : true,
      	version    : 'v2.1'
    });  
	FB.getLoginStatus(function(response) {
	    statusChangeCallback(response);
	});
	FB.Event.subscribe('auth.statusChange', function(response) {
    	if (response.status === 'connected') {
       		login_event();
    	} else if (response.status === 'not_authorized') {
         	logout_event();
    	} else {
    		logout_event();
    	}
	});

};	  

(function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "//connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));
   
var post = function() {
	var text = document.getElementById('tweet_text').value;
	console.log("value of text is " + text);
	FB.api('/me/feed', 'post', { message: text }, function(response) {
		if (!response || response.error) {
		    console.log(response.error.message);
		} else {
		    location.reload();
		}
	});
}


function share() {
	var tweet_text = document.getElementById('tweet_text').value;
	var userid = document.getElementById('userid').value;
	var username = document.getElementById('username').value;
	var picture = document.getElementById('picture').value;
	var msg_tweet = "true";

	var post_data = {
			  tweet_text: tweet_text,
			  userid: userid  , 
			  username: username,
			 picture: picture,
			 msg_tweet : "true"
	};
	$.post( "Tweet", post_data, function(data) {
		console.log(data);
		var key = data;
		var url = window.location.href ;
		if (url.search("localhost")!==-1) {
			url = "https://facebook.com/";
		}
		var share_url = url + "tweet.jsp?tweet_key=" + key ;
		var dict = {
				  method: 'send',
				  link: share_url  , 
				  caption: 'tweet',
				 description: 'Dialogs provide a simple, consistent interface for applications to interface with users.'
		};

		FB.ui( dict ,
		   function(response) {
				if (response && response.success) {
					location.reload();
				}
			}
		);	

	});
}
var profile_url = "";
function testAPI() {
	console.log('Welcome! Fetching your information.... ');
	FB.api('/me', function(response) {
		console.log('Successful login for: ' + response.name);
		console.log('response is ' + JSON.stringify(response));
		document.getElementById('profile_pic').innerHTML = '<a href="#" class="thumbnail"><img src="http://graph.facebook.com/' + response.id + '/picture?type=large" /></a>';
		document.getElementById('fullname').innerText = response.name;
		document.getElementById('fullname_head').innerText = response.name;
		profile_url = 'https://facebook.com/' + response.id;
		localStorage.profile_url = profile_url;
		document.getElementById('picture').value = 'http://graph.facebook.com/' + response.id + '/picture';
		document.getElementById('userid').value =  response.id;
		document.getElementById('username').value =  response.name.split(" ")[0];
		document.cookie = "userid=" + response.id;
		document.cookie = "username=" + response.name.split(" ")[0];
		document.cookie = "profile=" + "https://facebook.com/" + response.id;
		document.cookie = "picture=" + "http://graph.facebook.com/" + response.id + "/picture?type=large";
	});
}
</script>



<div id ="status" class="well" style="width:800px; margin:0 auto;">
  <h1 class="lead"><strong>Welcome to Tweeter App by Sailaja Munagapati </strong> </h1>
  <p>This app lets you post your tweets to facebook or share with friends :) </p>
  <p>You need to login with your facebook account to continue...</p>

<fb:login-button size="xlarge" autologoutlink="true" scope="public_profile,email,publish_actions,user_friends" onlogin="checkLoginState();">
</fb:login-button>
</div>


<% 
	Cookie[] cookies = request.getCookies();
	String userid="", username="",picture="";
	if (cookies != null) {
		for (int i = 0; i < cookies.length; i++) {
			Cookie cookie = cookies[i];
			if (cookie.getName().equals("userid")) {
				userid = cookie.getValue();
			}

			if (cookie.getName().equals("username")) {
				username = cookie.getValue();
			}

			if (cookie.getName().equals("picture")) {
				picture = cookie.getValue();
			}
		}
	}
%>
		
<div class="navbar navbar-default">
		<div class="container-fluid" style="background-color: #4b68b8;">
        	<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
           		<span class="icon-bar"></span>
           		<span class="icon-bar"></span>
           		<span class="icon-bar"></span>
         	</a>
         	<a class="brand" href="#">Social Network Application</a>
         	<div class="btn-group pull-right">
          		<strong> <div id="fullname" style="display:inline"></div> </strong> 
               	<fb:login-button size="large" autologoutlink="true" scope="public_profile,email,publish_actions,user_friends" onlogin="checkLoginState();">
				</fb:login-button>                      
          	</div>
         	<div class="nav-collapse">
           		<ul class="nav custom">
             		<li class="active"><a href="#">Home</a></li>
             		<li><a id="friends_tweet" href="./friends.jsp">Friends Tweet</a> </li>
             		<li><a id="friends_top_tweets" href="./top_tweets.jsp">Top Tweets</a> </li>
           		</ul>
         	</div><!--/.nav-collapse -->
      </div>
</div>

<div id="main_tweet_db" class="container" style="display:none;">
	<div class="row">
   		<div class="span">
   				
    	<div class="row">
      		<div class="span ">
        		<div class="row">
          			<div id="profile_pic" class="span1"><a href="#" class="thumbnail"><img src="./img/user.jpg" alt=""></a></div>
          			<div class="span3">
            			<h3><a id="fullname_head"> </a></h3>
            			<span id="num_tweets" class=" badge badge-warning">0 tweets</span> <span class=" badge badge-info">0 followers</span>          
           			</div>
       			</div>
      		</div>
   		</div>
   		<br/>
    		<div class="row">
    		  <div class="span">
      			<form method="post" action="Tweet" name="post_tweet" id="post_tweet" accept-charset="UTF-8">        
      				<input type="hidden" name="userid" id="userid" value=""/>
      				<input type="hidden" name="username" id="username" value=""/>
      				<input type="hidden" name="picture" id="picture" value=""/>                  
     	 			<div style="display:inline">
     	 				<textarea class="span4" id="tweet_text" name="tweet_text" rows="5" placeholder="Type in your new tweet"></textarea>
        			</div>
        			<div>
        				<input type="submit" name="post_btn" value="Post New Tweet" class="btn btn-primary" onclick="post()" />
        				
        				<input type="button" name="share_btn" value="Share with friends" class="btn btn-primary" onclick="share()"/>
        			</div>
        		</form>     
         	  </div>
    		</div> 
    	<!--  -->
    	<br/>
    	<div class="container">
    		<div class="row">
  				<div class="span" >
        			<p class="lead"> Your Tweets:</p>
            		  <hr />
<%
    List<Entity> tweets = TweetUtils.getTweetsByUserId(userid);
    int num_tweets = tweets.size();
    if (tweets.isEmpty()) {
%>
<div class="alert alert-danger"> <p> No tweets to be shown yet</p>
</div>
<%
}
else { 
%>
	<script type="text/javascript"> console.log(<%=num_tweets%>);document.getElementById("num_tweets").innerText = "<%=num_tweets%> tweets";</script>
<% 
	for (Entity tweet : tweets) { 
		String tweet_text =  (String) tweet.getProperty("text");
		String tweet_date = (String) tweet.getProperty("date");
		String key = KeyFactory.keyToString(tweet.getKey());
		String href = "'tweet.jsp?tweet_key=" + key + "'";
%>
    		  <div>
            <a class="active" href=<%=href%> ><%=tweet_text%></a>
            <form method="post" action="Delete" name="delete_tweet" accept-charset="UTF-8">     
            <input type="hidden" name="tweet_key" id="tweet_key" value="<%=key%>"/>  
            <br/>  
            <span class="badge pull-right">At <%=tweet_date%></span>
            <p>&nbsp;</p>
            <input type="submit" class="btn btn-danger" value="Delete"/>
            </form>
    		</div>      
    		   <hr />
<% 
  } 
%>
  
    </div>
    </div>
    </div>
    
    
<% } %>
    
  </div>
  </div>
  
</div>
    <script src="./js/jquery-1.7.2.min.js"></script>
    <script src="./js/bootstrap.min.js"></script>
    <script src="./js/charcounter.js"></script>
  </body>
</html>