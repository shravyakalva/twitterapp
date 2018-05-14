<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Shravya's Twitter App</title>
</head>
<body>
	<script>
  window.fbAsyncInit = function() {
    FB.init({
      appId      : '389424051490492',
      xfbml      : true,
      version    : 'v2.9'
    });
    FB.AppEvents.logPageView();
    
  };

  (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "//connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));



function onLogin(response) {
  if (response.status == 'connected') {
    FB.api('/me?fields=first_name', function(data) {
      var welcomeBlock = document.getElementById('fb-welcome');
      welcomeBlock.innerHTML = 'Hello, ' + data.first_name + '!';
    });
  }
}

FB.getLoginStatus(function(response) {
  
  if (response.status == 'connected') {
    onLogin(response);
  } else {
    
    FB.login(function(response) {
      onLogin(response);
    }, {scope: 'user_friends, email'});
  }
});


</script>
 <script>    
    	function testAPI(){
    		console.log('Welcome! Fetching your information.... ');
            FB.api('/me', function (response) {
            	debugger;
                console.log('Successful login for: ' + response.name);                                               
                document.getElementById('status').innerHTML = 'Thanks for logging in, ' + response.name + '!';                
            }, { scope: 'user_birthday' });            
            FB.api('/me', {fields: 'birthday'}, function(response) {            	  
            	  debugger;
            	  var dateString = response.birthday;
            	  var dateParts = dateString.split("/");
            	  var dateObject = new Date(dateParts[2], dateParts[0] - 1, dateParts[1]);            	 
                  document.getElementById('DOB').innerHTML = 'Your Birth day is : ' + dateObject.toString();
                  
                  
                  var ageDifMs = Date.now() - dateObject.getTime();
                  var ageDate = new Date(ageDifMs); 
                  document.getElementById('age').innerHTML = 'Your age is : ' + Math.abs(ageDate.getUTCFullYear() - 1970);                  
            })
    	}
    	
    	function statusChangeCallback(response){
    		console.log('Function : statusChangeCallback');
            console.log(response);            
            if (response.status === 'connected') {	              
                testAPI();
            } else if (response.status === 'not_authorized') {	
                document.getElementById('status').innerHTML = 'Please log into this app.';
            } else {
                
                document.getElementById('status').innerHTML = 'Please log into Facebook.';
            }
    	}
    	</script>


<script>

function postToFacebook() {
	var body = 'Reading JS SDK documentation';
	FB.api('/me/feed', 'post', { message: 'Hello' }, function(response) {
	  if (!response || response.error) {
	    alert(response.error);
	  } else {
	    alert('Post ID: ' + response.id);
	  }
	});
}
</script>


<h3>facebook exercise by Shravya Kalva</h3>

<a href="#" onClick="postToFeed()">Post to Feed</a>
<br>

<script>

function postToFeed() {
	FB.ui({
		  method: 'feed',
		  link: 'https://apps.facebook.com/389424051490492/tweets.jsp',
		  caption: 'Posting to feed',
		}, function(response){});
}
</script>
<br>
<a href="#" onClick="publishToFeed()">Publish to Facebook</a>
<script>
function publishToFeed() {
FB.login(function()
		{   FB.api('/me/feed', 'post', {message: 'Hello, world!'});  }, {scope: 'publish_actions'});
}
</script>
<script>
 function testMessageCreate() {
            console.log('Posting a message to user feed.... ');
            
            FB.login(function () {
                var typed_text = document.getElementById("message_text").value;
                FB.api('/me/feed', 'post', { message: typed_text });
                document.getElementById('theText').innerHTML = 'Thanks for posting the message' + typed_text;
            }, { scope: 'publish_actions,email,public_profile,user_birthday', return_scopes: true});
        } 
        (function(d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) return;
            js = d.createElement(s); js.id = id;
            js.src = "//connect.facebook.net/en_US/sdk.js";
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));
    </script>
        
    <fb:login-button scope="public_profile,email" onlogin="checkLoginState();">
    </fb:login-button>

    <div id="status">
    </div>
   
    <input type="text" value="" id="message_text" />
    <input type="button" value="enter" onclick="testMessageCreate();" />
    <br><br>

 <fb:login-button scope="public_profile,email,user_friends" onlogin="checkLoginState();">
   </fb:login-button>
   <br></br>
   <div id="tweet" style="display:none"/>
   <form action="/store" method="get">
   <input type="submit" value="Try Tweet Application" id="tapp" onclick="location.href='/tweets.jsp?'"/>
   <input type="hidden" value="uname" id="uname" name="uname"/>
   </form>
   </div>
</body>
</html>