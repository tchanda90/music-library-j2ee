<%@ page language="java" import="java.sql.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="Home.html" %>
<%@ include file="Connect.jsp" %>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Likes</title>

<script>
	function init(){
		<%
		/* redirect to login page if session type is null or not user */
		if (session.getAttribute("id") == null || !session.getAttribute("type").equals("user")){
			response.sendRedirect("LogIn.jsp");
			return;
		}
		%>
		
		/* changes the navigation button "Likes" to yellow */
		var likesButton = document.getElementById("bLikes");
		likesButton.style.color = '#ffcc00';
		likesButton.style.textDecoration = 'underline';
	}
	
	var xmlHttp;
	var likeId;
	var sessionId;
	var likes;
	var wrapperId;
	var songName;
	
	//the buttonId parameter is the songId of the Unlike button clicked
	function startRequest(buttonId, session, wId, song)
	{
		likeId = buttonId;
		sessionId = session;
		wrapperId = wId;
		songName = song;
		
		xmlHttp = new XMLHttpRequest();

		//Passes songId, sessionId to LikeSong.java as Query String
	  	xmlHttp.open("GET", "UnlikeSong?likeId="+likeId+"&sessionId="+sessionId ,true)
	  	xmlHttp.onreadystatechange = handleStateChange;
	  	xmlHttp.send(null);
	}
	
	function handleStateChange(){
	    if(xmlHttp.readyState == 4){
	        if(xmlHttp.status == 200){
	        	var message =  
		            xmlHttp.responseXML.getElementsByTagName("valid")[0].childNodes[0].nodeValue;
	        	  	
	        	var div = document.getElementById(wrapperId);
	        	if (message == 'available'){
	        		div.parentNode.removeChild(div);
	        		alert('Removed ' + songName + ' from Likes');
				} 
	        }
	        else{
	           alert("Error loading pagen"+ xmlHttp.status + ":" + xmlHttp.statusText);
	        }
	    }
	}		


	var songId;
	var pId;
	var playlistName;
	
	function createPlaylist(sessionId)
	{
		playlistName = prompt("Enter a Playlist Name");
		
		if (playlistName == null){
			return false;
		}

		xmlHttp = new XMLHttpRequest();

		//Passes songId, sessionId to LikeSong.java as Query String
	  	xmlHttp.open("GET", "CreatePlaylist?pName="+playlistName+"&sessionId="+sessionId , false);
	  	xmlHttp.onreadystatechange = handleStateChange2;
	  	xmlHttp.send(null);
	}
	
	function handleStateChange2(){
	    if(xmlHttp.readyState == 4){
	        if(xmlHttp.status == 200){
	        	var message =  
		            xmlHttp.responseXML
		                    .getElementsByTagName("valid")[0]
		                    .childNodes[0].nodeValue;
	        	  	
	        	var button = document.getElementById(likeId);
	        	
	        	if (message == 'available'){
	        		alert("Playlist '" + playlistName + "' Created");
				}      
	        	else{
	        		alert("Playlist '" + playlistName + "' Already Exists");
	        	}
	        }
	        else{
	           alert("Error loading page "+ xmlHttp.status + ":" + xmlHttp.statusText);
	        }
	    }
	}
	
	function clicker(_songId, _songName){
		songId = _songId;
		var thediv = document.getElementById('displaybox');
		
		if (thediv.style.display == "none"){
			thediv.style.display = '';
		} 
		else{
			/* set the buttons that have been 'Added' to normal again */
			var x = document.getElementById("displaybox");
			var y = x.getElementsByTagName("button");
			var i;
			for (i = 0; i < y.length; i++) {
			    y[i].style.background = 'white';
			    y[i].style.color = '#000066';
			    y[i].innerHTML = 'Add';
			}
			thediv.style.display = "none";
		}
		return false;
	}	
	
	function AddToPlaylist(button){		

		pId = button.id;
		
		xmlHttp1 = new XMLHttpRequest();

		//Passes songId, sessionId to AddToPlaylist.java as Query String
	  	xmlHttp1.open("GET", "AddToPlaylist?buttonId="+button.id+"&songId="+songId , false);
	  	xmlHttp1.onreadystatechange = handleStateChange1;
	  	xmlHttp1.send(null);
	}
	
	function handleStateChange1(){
	    if(xmlHttp1.readyState == 4){
	        if(xmlHttp1.status == 200){
	        	var message =  
		            xmlHttp1.responseXML.getElementsByTagName("valid")[0].childNodes[0].nodeValue;
	        	
	        	var button = document.getElementById(pId);
	        	if (message == 'available'){
	        		button.style.background = 'green';
	        		button.style.color = 'white';
	        		button.innerHTML = 'Added';
				}        	
	        	else{
	        		alert('Already Added');
	        	}
	        }
	        else{
	           alert("Error loading pagen"+ xmlHttp.status + ":" + xmlHttp.statusText);
	        }
	    }
	}	
	
</script>

<style>
#displaybox {
	z-index: 10000;
	opacity: 1;   /*supported by current Mozilla, Safari, and Opera*/ 
	background-color: white;
	border: 1px solid black;
	border-radius: 10px;
	padding: 20px;
	margin: auto;
	position: fixed; top: 20%; bottom: 20%; left: 20%; right: 20%; width: 50%; height: 50%; text-align:center; vertical-align: middle;
}
</style>


</head>

<body onload="init()">

	<script type="text/javascript">
    	/* greeting message displayed using js */
    	var fName = "<%=session.getAttribute("name").toString()%>" ;
    	document.getElementById("welcome").innerHTML = 'Hi, ' + fName;
    </script>
	
	<%
		/* Get liked songs and store in rs */
		String email = session.getAttribute("id").toString();
		Statement statement = conn.createStatement() ;
		ResultSet rs = statement.executeQuery("SELECT Song_Tb.Song_Id, Song_Tb.Artist, Song_Tb.Album, Song_Tb.Song_Name, Song_Tb.Likes FROM Song_Tb INNER JOIN Likes_Tb ON Song_Tb.Song_Id = Likes_Tb.Song_Id WHERE Likes_Tb.Email = '"+email+"'");
    	
	    Statement playlistSt = conn.createStatement() ;
		ResultSet playlistRs = playlistSt.executeQuery("Select Playlist_Id, Playlist_Name From Playlist_Tb Where Email = '" + email + "'");   	
    %>
    
    <div id="displaybox" style="display: none; text-align: center; ">
    	<br>
    	
    	<div>
	   	<form method="Post" action="CreatePlaylist">
			<input type="hidden" name="sessionId" value="<%= session.getAttribute("id") %>" >
			<label class="inputLabel" style="font-weight: normal;" >Create New Playlist</label>
			<input id="tbPlaylistName" type="text" name="pName" >
			<input type="submit" value="Create" class="playlistSmallButton">
		</form>
    	</div>
    	<br>
    	 <% while (playlistRs.next()){ %>
    	 <div>
    		<label style="float: left; font-weight: normal;" class="playlistLabel"> <%= playlistRs.getString(2) %> </label>
    		<button style="float: right;" id="<%= playlistRs.getString(1) %>" onclick="AddToPlaylist(this);" class="smallTransparentButton" >Add</button>
    		<br>
    		<br>
    		<br>
    	</div>
    	 <% } %>
    	 <br>
    	 <a href='#' style="font-family: 'Calibri'; margin: 0 auto;" onclick='return clicker();'>Close Window</a>
    </div>
   
    
	<br>
	<div class="resultsDiv" >
	<br>
		<% 
		int wrapperId = 10000; 
		while(rs.next()){ 
		%>
		<div class="wrapperDiv" id="<%=wrapperId%>" >
			<div class="imageDiv">
				<object data="Music/<%= rs.getString(4) %>.jpg" class="imageObject" >
					<img src="Music/MusicAlt.jpg" alt="MusicAlt.jpg" class="altImage" />
				</object>
			</div>
			
			<div class="songDiv">
				<div class="artistDiv"> <%= rs.getString(2) %> </div>
		        <div class="songNameDiv"> <%= rs.getString(4) %> </div>
		        
		         <div class="buttonDiv">
		            <form style="float: right;" >
						<input type="button" id="<%= rs.getString(1) %>" value="Unlike <%= rs.getString(5) %>" class="smallTransparentButton" onclick="startRequest('<%= rs.getString(1) %>', '<%= session.getAttribute("id") %>', '<%= wrapperId %>', '<%= rs.getString(4) %>')" >
		            </form>
		            
		            <div style="float: right;" >
						<button class="smallTransparentButton" onclick='return clicker(<%= rs.getString(1) %>, "<%= rs.getString(4) %>");' >Add To</button>
		            </div>
		            
		            <form style="float: right;" method="post" action="FileDownload" >
		            	<input type="hidden" name="songName" value="<%= rs.getString(4) %>" >
			        	<input type="submit" value="Download" class="smallTransparentButton" >
					</form>
				</div>
				
				<div class="audioDiv">
		            <audio controls="controls" style="width: 99%;">
					<source src="Music/<%= rs.getString(4) %>.mp3" type="audio/mp3" />
						Your Browser is not Supported
					</audio>
				</div>
			</div>
			<div style="padding: 5%;"></div>
		</div>
        <% 
        --wrapperId;
        } 
        %>       
	</div>


</body>
</html>