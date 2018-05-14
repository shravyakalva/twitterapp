<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
</head>
<body>
   <nav>
   	<ul>
   		<li><a href="tweets.jsp">Tweets</a></li>
   		<li><a href="friends.jsp">Friends</a></li>
   		<li><a href="toptweets.jsp">Top Tweets</a></li>
   	</ul>
   	</nav>
   	</br>
   	<input type="hidden" id="friendname" name="friendname"/>
   	<input type="hidden" id="friendid" name="friendid"/>  
   	
	<div id="friendslist" style="float:left;width:20%;overflow:auto;">
   	<h2 align="center"> Friends List</h2> 
   	<br> <br>
        
        <div>
        <table id="friendList">
        <tr>
        <td id="userfriends">
        </td>
        <td id="img">
        </td>
        </tr>
        </table>
		</div>
   	
   	</div>
   <%
   		String name=(String)session.getAttribute("name");
		DatastoreService ds= DatastoreServiceFactory.getDatastoreService();
		Filter key = new FilterPredicate("Username",FilterOperator.NOT_EQUAL,name); 
		Query q= new Query("twitter").setFilter(key);
    	List<Entity> tweets= ds.prepare(q).asList(FetchOptions.Builder.withLimit(30));
   	%>
   	     <div style="height: 500px; overflow: auto; float:left;width:55%; ">
   	     <h2 align="center">Tweets by Friends</h2>
   		 <table align="center" id="tableId">
   		 <tbody>
   		 <tr>
   		 <th style="font-size:16px">
   		 Tweet
   		 </th>
   		 <th style="font-size:16px">
   		 Tweet By
   		 </th>
   		 
   		 <th>View Count</th>
   		 <br> </br>
   		  </tr>
 		 <% 
   		   for(Entity twitter: tweets)
   			{ 
  				  String message=(String)twitter.getProperty("TweetMessage");
  				  String usrname=(String)twitter.getProperty("Username"); 
  				  
   	  
  	   	  %>
            	<tr align="center"> 
  				<td>
  				<a target="_blank" href="update?tID=<%= KeyFactory.keyToString(twitter.getKey())%>"><%=message %></a>
  				</td>
  				<td>
  				<%=usrname %>
  			   </td>
  			   
  			   <td hidden="true"> <%= KeyFactory.keyToString(twitter.getKey()) %> </td>
  			   <td>
				<%=twitter.getProperty("visit_counter") %>
  			   </td>
  			   </tr>
        <%  }  %>
      
        </tbody>
        </table>
        
        </div>
        
 
<!-- <script type="text/javascript" src="fb.js"></script>-->
 <script src="https://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">
window.fbAsyncInit = function() {
	  FB.init({
	        appId : '389424051490492',
	        cookie : true, 
	        xfbml : true, 
	        version : 'v2.5' 
	  });
	  
	  
	  function statusChangeCallback(response) {
	      console.log('statusChangeCallback');
	      console.log(response);
	      
	      if (response.status === 'connected') {
	            
	            FB.api('/me/friends?fields=name,id,picture',function(response){
	            	friends(response);
	            })
	            
	       } else if (response.status === 'not_authorized') {
	            
	             document.getElementById('status').innerHTML = 'Please log ' +'into this app.';
	       } else {
	            
	             document.getElementById('status').innerHTML = 'Please log ' + 'into Facebook.';
	       }
	}  
	  
	  FB.getLoginStatus(function(response) {
	        statusChangeCallback(response);
	        FB.login(function (response){
	        			
	        		},{scope:'user_friends,email,user_birthday'});
	        });
};
(function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
function friends(response)
{
	var friendsList = response.data;
	var size = friendsList.length;
	  var friendName;
	  var friendId;
	  var picture= response;
	 // alert(size);
	  $(".friends").append("<p>"+size+"</p>");
	  for(var index=0;index<size;index++){
	  friendName= friendsList[index].name;
	  friendId = friendsList[index].id;
	  picture = friendsList[index].picture.data.url;
	   	var txt=  $("<table><tr><td id='names'></td></tr></table>").append(friendName);
	   	$("#userfriends").append(txt);
	   	var img =  $("<img id='pic'>");
	   	img.attr('src',picture);
	   
	   	img.appendTo("#userfriends");
	   	
	  }
}
function addRowHandlers() 
{
    var table = document.getElementById("tableId");
    var rows = table.getElementsByTagName("tr");
    for (i = 0; i < rows.length; i++) {
        var currentRow = table.rows[i];
        var createClickHandler = 
            function(row) 
            {
                return function() { 
                                        var msg = row.getElementsByTagName("td")[0];
                                        var name = row.getElementByTagName("td")[1];
                                        var key = row.getElementByTagName("td")[2];
                                        var message = msg.innerHTML;
                                        var uname = name.innerHTML;
                                        var keyval = key.innerHTML;
                                        alert("Tweet:" +message+ "By: "+uname);
                                 };
            };
        currentRow.onclick = createClickHandler(currentRow);
    }
}
</script>
</body>
</html>