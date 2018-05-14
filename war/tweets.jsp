<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query.Filter"%>
<%@ page import="com.google.appengine.api.datastore.Query.FilterPredicate"%>
<%@ page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="twitter.css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Shravya's Twitter App</title>
<style>
label textarea{
 vertical-align: middle;
}
</style>
</head>
<body>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	getUserDetails();
});
</script>
   <nav>
   	<ul>
   		<li><a href="tweets.jsp">Tweets</a></li>
   		<li><a href="friends.jsp">Friends</a></li>
   		<li><a href="toptweets.jsp">Top Tweets</a></li>
   	</ul>
   	</nav>
   	
   	<p align="justify">
   	
   		<h2 align="center"></h2>
   		<div id="display_tweet" display="inline" style ="width:60%; margin: 0 auto;">
   		<!--  <iframe onload="getUserDetails()" src="#" width="0" height="0" scrolling="no"></iframe> -->
   			<form action="/store" method="post">
   			<div >
   				<div>
   				<p class="formfield">
   				<label for="message">Type your tweet here: </label>
   				<textarea align ="center" id="message" name="message" rows="7" cols="70" id="message" onchange="getUserDetails()"></textarea>
   				<input type="hidden" id="Username" name="Username"/>
   				<input type="hidden" id="UserId" name="UserId"/>
   				<input type="hidden" id="image" name="image"/>
   				</p>
   				</div>
   				<div style="width:500px;margin: 2% auto;">
	   			<ul>	
		   			<li style="display: block; padding: 10px 10px;"><input type="button" id="post" value="post on timeline" onclick="create_message();">    			
		   			<li style="display: block; padding: 10px 10px;"><input type="button" id="send" value="Send Message" onclick="sendmessage();"> 
		   			<li style="display: block; padding: 10px 20px;"><input type="submit" value="Post Tweet" /></li>	
		   		</ul>
		   		</div>
		   		</div>
   			</form>
   		 </div>	
   		 <script type="text/javascript">
   		
   		 </script>
   		 <br>
   		 
   		<%
   		   String name=(String)session.getAttribute("name");
   		   DatastoreService ds=DatastoreServiceFactory.getDatastoreService();
   		   Filter keyfilter = new FilterPredicate("Username",FilterOperator.EQUAL,name); 
   		   Query q= new Query("twitter"); 
   		   List<Entity> tweets = ds.prepare(q).asList(FetchOptions.Builder.withLimit(30));
   		 
   		 %>
   		 <div style="height: 200px; overflow: auto;">
   		 <table align="center" id="tblid" >
   		 <tbody>
   		 <tr>
   		 <th style="font-size:16px">
   		 Tweet
   		 </th>
   		 <th style="font-size:16px">
   		 Tweet By
   		 </th>
         <th>
         <form action="${pageContext.request.contextPath}/delete" method="post">
  			<input type="submit" value="Delete"/>
  			<input type="hidden" id="delete" name="delete"/>  
  	    </form>
         </th>
   		 </tr>
 		 <% 
   		   for(Entity twitter: tweets)
   			{ 
  				  String message=(String)twitter.getProperty("TweetMessage");
  				  String usrname=(String)twitter.getProperty("Username"); 
  				  String usrid=(String)twitter.getProperty("userID");
  				  String image=(String)twitter.getProperty("picture");
  				  
  	   	  %>
            	<tr align="center"> 
  				<td>
  				<%=message %>
  				</td>
  				<td>
  				<%=usrname %>
  			   </td>
  			   <td hidden="true"> <%= KeyFactory.keyToString(twitter.getKey()) %> </td>
  			   <td>
  			   &nbsp;&nbsp;&nbsp;<input type="checkbox" id="chkbox" name="chkbox" onclick="deleteTweet()"/>
  			   </td>
  			   </tr>
   		
        <%  }  %>
      
        </tbody>
        </table>
        </div>
   	<div id="the_Text">
   	</div>
   	<div id="the msg">
   	</div>
   	<div id="the name">
   	</div>
   	</p>
   	<!--<script type="text/javascript" src="fb.js"></script>-->
   	<script type="text/javascript">
   	 
   	function showform()
   	{
   		document.getElementById('display_tweet').style.display='inline';
   		getUserDetails();
   	}
   	function create_message()
   	{
   		var tweetmessage=document.getElementById('message').value;
   		post_tweet(tweetmessage);
   	}
   	function sendmessage()
   	{
   		send_message();
   	}
   	function deleteTweet()
   	{
   		var table = document.getElementById("tblid");
   		var rows = table.getElementsByTagName("tr");
   		for (i = 0; i < rows.length; i++) {
   	        var currentRow = table.rows[i];
   	        var createHandler=
   	        	function(row) 
   	            {
   	                return function() { 
   	                                        var cell = row.getElementsByTagName("td")[2];
   	                                        var id = cell.innerText;
   	                                        document.getElementById('delete').value=id;
   	                                        
   	                                 };
   	            };
   	        currentRow.onclick = createHandler(currentRow);
   	    }
   	}
   	
 function post_tweet(tweetmessage)
   	{
	 
	 document.getElementById('post').checked=false;
   	FB.login(function() {
   	       
   		    
   			FB.api('/me/feed', 'post', {message: tweetmessage});
   			
   	    }, {scope: 'publish_actions'});
   	
   	}
 function getUserDetails()
 {
 		FB.api('/me?fields=name,id,picture',function(response){
 			document.getElementById('Username').value=response.name;
 			document.getElementById('UserId').value=response.id;
 			document.getElementById('uname').value=response.name;
 			document.getElementById('image').value=response.picture.data.url;
 		});
 }
 function send_message()
 {
	 document.getElementById('send').checked=false;
 		FB.ui({
 		method: 'share',
 		href:'https://apps.facebook.com/389424051490492/tweets.jsp'
 		});		
 }
 window.fbAsyncInit = function() {
	  FB.init({
	        appId : '389424051490492',
	        cookie : true, 
	        xfbml : true, 
	        version : 'v2.5' 
	  });
	  
	  function checkLoginState() {
	      FB.getLoginStatus(function(response) {
	            statusChangeCallback(response);
	      });
	}
	  
	 
	  
	  function statusChangeCallback(response) {
	      console.log('statusChangeCallback');
	      console.log(response);
	      
	      if (response.status === 'connected') {
	            
	       } else if (response.status === 'not_authorized') {
	            
	             document.getElementById('status').innerHTML = 'Please log ' +'into this app.';
	       } else {
	             
	             document.getElementById('status').innerHTML = 'Please log ' + 'into Facebook.';
	       }
	}
	  
	  FB.getLoginStatus(function(response) {
	        statusChangeCallback(response);
	        },{scope:'user_friends,user_birthday,email,publish_actions'});
	  };
	
	  (function(d, s, id) {
	        var js, fjs = d.getElementsByTagName(s)[0];
	        if (d.getElementById(id)) return;
	        js = d.createElement(s); js.id = id;
	        js.src = "//connect.facebook.net/en_US/sdk.js";
	        fjs.parentNode.insertBefore(js, fjs);
	  }(document, 'script', 'facebook-jssdk'));
   	 	
   	</script>
</body>
</html>