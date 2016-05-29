<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="Home.html" %>
<%@ include file="Connect.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Playlists</title>

<script>
	function init(){
		
		/* changes the navigation button "Playlists" to yellow */
		var playlistsButton = document.getElementById("bPlaylists");
		playlistsButton.style.color = '#ffcc00';
		playlistsButton.style.textDecoration = 'underline';
		
		
		<%
		
		/* redirect to login page if session type is null or not user */
		if (session.getAttribute("id") == null || !session.getAttribute("type").equals("user")){
			response.sendRedirect("LogIn.jsp");
			return;
		}
		
		/* Get saved playlists and store in playlistRs */
		String email = session.getAttribute("id").toString();
		String name = session.getAttribute("name").toString();
		String playlistId = request.getParameter("playlists");
		
		Statement playlistSt = conn.createStatement() ;
		ResultSet playlistRs = null;
		if (playlistId != "null"){
			playlistRs = playlistSt.executeQuery("Select Playlist_Id, Playlist_Name From Playlist_Tb Where Email = '" + email + "'");
		}
		
		/* Get playlist from dropdown menu and retrieve songs from that playlist */
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery("Select Song_Id, Artist, Album, Song_Name, Likes From Song_Tb Where Song_Id In (Select Song_Id From Playlist_Songs Where Playlist_Id = '"+playlistId+"')");

		%>
	}
	
	function Validate(){
		if (document.getElementById("tbPlaylistName").value == ""){
			return false;
		}
		return true;
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
	
	<div class="resultsDiv" >
	<br>
	<div class="wrapperDiv" >
		<form method="Post" action="CreatePlaylist" onsubmit="return Validate()">
			<input type="hidden" name="sessionId" value="<%= session.getAttribute("id") %>" >
			<label class="inputLabel" style="font-weight: normal;" >Create New Playlist</label>
			<input type="text" id="tbPlaylistName" name="pName" >
			<input type="submit" value="Create" class="playlistSmallButton">
		</form>
	</div>
	<br>
		<% while(playlistRs.next()){ %>
		<div class="wrapperDiv" >
			<div>
			<form id="viewPlaylistSongsForm" action="PlaylistSongs.jsp">
				<input type="hidden" name="playlistId" value="<%= playlistRs.getString(1) %>" >
				<input type="submit" name="playlistName" class="playlistButton" value="<%= playlistRs.getString(2) %>" >
			</form>
			</div>
			<div class="buttonDiv">
			<form id="removePlaylistForm" action="RemovePlaylist">
				<input type="hidden" name="playlistId" value="<%= playlistRs.getString(1) %>" >
				<input type="submit" value="Delete" class="smallTransparentButton">
			</form>
			</div>
			
			<div style="padding: 5%;"></div>
		</div>
        <% } %>       
	</div>
	

</body>
</html>