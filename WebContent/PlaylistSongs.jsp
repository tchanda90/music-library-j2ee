<%@ page language="java" import="java.sql.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="Home.html" %>
<%@ include file="Connect.jsp" %>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Playlist Songs</title>

<script>
	function init(){
		<%
		
		/* Retrives the playlist chosen in the previous page, and selects all songs in that playlist */
		String email = session.getAttribute("id").toString();
		String playlistId = request.getParameter("playlistId");
		String playlistName = request.getParameter("playlistName");
		
		Statement playlistSt = conn.createStatement() ;
		ResultSet rs = null;
		if (playlistId != null){
			rs = playlistSt.executeQuery("Select Song_Id, Artist, Album, Song_Name, Likes From Song_Tb Where Song_Id In (Select Song_Id From Playlist_Songs Where Playlist_Id = '" + playlistId.toString() + "')");
		}
		else{
			response.sendRedirect("Playlists.jsp");
			return;
		}

		%>
	}
	
	
	var xmlHttp;
	var sessionId;
	var wrapperId;
	var songName;	
	
	function Remove(_songId, _songName, _playlistId, _wrapperId){
		wrapperId = _wrapperId;
		songName = _songName
		xmlHttp = new XMLHttpRequest();

		//Passes songId, sessionId to RemoveFromPlaylist.java as Query String
	  	xmlHttp.open("GET", "RemoveFromPlaylist?songId="+_songId+"&playlistId="+_playlistId, false)
	  	xmlHttp.onreadystatechange = handleStateChange1;
	  	xmlHttp.send(null);
	}
	
	function handleStateChange1(){
	    if(xmlHttp.readyState == 4){
	        if(xmlHttp.status == 200){
	        	var message =  
		            xmlHttp.responseXML.getElementsByTagName("valid")[0].childNodes[0].nodeValue;
	        	  	
	        	var div = document.getElementById(wrapperId);
	        	if (message == 'available'){
	        		div.parentNode.removeChild(div);
	        		alert('Removed ' + songName + ' from Playlist');
				} 
	        }
	        else{
	           alert("Error loading pagen"+ xmlHttp.status + ":" + xmlHttp.statusText);
	        }
	    }
	}		
	
	
	
	//the buttonId parameter is the songId of the Like button clicked
	function startRequest(buttonId, session, wId, sName, numberOfLikes)
	{
		likeId = buttonId;
		sessionId = session;
		wrapperId = wId;
		songName = sName;
		likes = ++numberOfLikes;
		
		xmlHttp = new XMLHttpRequest();

		//Passes songId, sessionId to LikeSong.java as Query String
	  	xmlHttp.open("GET", "LikeSong?likeId="+likeId+"&sessionId="+sessionId , false);
	  	xmlHttp.onreadystatechange = handleStateChange;
	  	xmlHttp.send(null);
	}
	
	function handleStateChange(){
	    if(xmlHttp.readyState == 4){
	        if(xmlHttp.status == 200){
	        	var message =  
		            xmlHttp.responseXML
		                    .getElementsByTagName("valid")[0]
		                    .childNodes[0].nodeValue;
	        	  	
	        	var button = document.getElementById(likeId);
	        	
	        	if (message == 'available'){
	        		button.style.background = 'green';
	        		button.style.color = 'white';
					button.value = 'Liked ' + likes;
				}      
	        	else{
	        		alert('Already Liked');
	        	}
	        }
	        else{
	           alert("Error loading page "+ xmlHttp.status + ":" + xmlHttp.statusText);
	        }
	    }
	}


</script>

</head>

<body onload="init()">

	<script type="text/javascript">
    	/* greeting message displayed using js */
    	var fName = "<%=session.getAttribute("name").toString()%>" ;
    	document.getElementById("welcome").innerHTML = 'Hi, ' + fName;
    </script>

	<br>
	<div class="searchMessageDiv">
		<label id="message" class="searchMessageLabel"></label>
	</div>
	
	<script>
		// Script to retrieve the search query and display a message above the search results
		document.getElementById("message").innerHTML = "Playlist: " + "<%out.print(playlistName);%>";
	</script>
	
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
						<input id="<%= rs.getString(1) %>" type="button" value="Like <%= rs.getString(5) %>" class="smallTransparentButton" onclick="startRequest('<%= rs.getString(1) %>', '<%= session.getAttribute("id") %>', '<%= wrapperId %>', '<%= rs.getString(4) %>', '<%= rs.getString(5) %>')" >
		            </form>
		            
		            <form style="float: right;" >
						<input type="button" id="<%= rs.getString(1) %>" value="Remove" onclick="Remove('<%= rs.getString(1) %>', '<%= rs.getString(4) %>', '<%= playlistId.toString() %>', '<%= wrapperId %>')" class="smallTransparentButton"  >
		            </form>		            
		            
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