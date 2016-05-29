<%@ page language="java" import="java.sql.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="Home.html" %>
<%@ include file="Connect.jsp" %>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Search</title>

<script type="text/javascript">

	var xmlHttp;
	var likeId;
	var sessionId;
	var likes;
	
	//the buttonId parameter is the songId of the like button clicked
	function startRequest(buttonId, session, numberOfLikes)
	{
		likeId = buttonId;
		sessionId = session;
		likes = ++numberOfLikes;
		
		xmlHttp = new XMLHttpRequest();

		//Passes songId, sessionId to LikeSong.java as Query String
	  	xmlHttp.open("GET", "LikeSong?likeId="+likeId+"&sessionId="+sessionId ,true)
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
	           alert("Error loading pagen"+ xmlHttp.status + ":" + xmlHttp.statusText);
	        }
	    }
	}	
	
	
	
	function clicker(_songId){
		songId = _songId;
		var thediv = document.getElementById('displaybox');
		
		if (thediv.style.display == "none"){
			thediv.style.display = '';
		} else{
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

</head>

<body>

	<%
		/* redirect to login page if session type is null or not user */
		if (session.getAttribute("id") == null || !session.getAttribute("type").equals("user")){
			response.sendRedirect("LogIn.jsp");
			return;
		}
		
		/* the search query is retrieved */
		String qs = request.getParameter("searchQuery");
		/* 
		* query string is converted to lowercase becase Oracle DB does not support case-insensitive search
		* after qs is in lower case, a select statement is executed
		* the column data are converted to lower case in sql to be matched with qs
		*/
		if (qs != null)
			qs = qs.toLowerCase();			
		String email = session.getAttribute("id").toString();
		Statement statement = conn.createStatement() ;
		ResultSet rs = statement.executeQuery("Select Song_Id, Artist, Album, Song_Name, Likes From Song_Tb Where LOWER(Artist) LIKE '%"+qs+"%' or LOWER(Album) LIKE '%"+qs+"%' or LOWER(Song_Name) LIKE '%"+qs+"%'");
    
		/* the logged in user's name is retrieved so that a greeting can be shown */
		Statement st = conn.createStatement();
    	ResultSet rs1 = st.executeQuery("Select Name From User_Tb Where Email = '"+email+"'");
    	String name = "User";
    	if (rs1.next()){
    		//split first and last names, and store only first name in the name variable
    		name = rs1.getString(1);
    		String[] nameArray = name.split("\\s+");
    		name = nameArray[0];
    	}
    %>
    
    
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
		<% qs = request.getParameter("searchQuery"); %>
		document.getElementById("message").innerHTML = "Search Results For " + "<%out.print(qs);%>";
	</script>
	
	<br>
	
	<%	
	    Statement playlistSt = conn.createStatement() ;
		ResultSet playlistRs = playlistSt.executeQuery("Select Playlist_Id, Playlist_Name From Playlist_Tb Where Email = '" + email + "'");   	
    %>
    
    <div id="displaybox" class="playlistBox" style="display: none; text-align: center; ">
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
		
	<div class="resultsDiv" >
	<br>
		<% while(rs.next()){ %>
		<div class="wrapperDiv" >
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
						<input id="<%= rs.getString(1) %>" type="button" value="Like <%= rs.getString(5) %>" class="smallTransparentButton" onclick="startRequest('<%= rs.getString(1) %>', '<%= session.getAttribute("id") %>', '<%= rs.getString(5) %>')" >
		            </form>
		            
		            <div style="float: right;" >
						<button class="smallTransparentButton" onclick='return clicker(<%= rs.getString(1) %>);' >Add To</button>
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
        <% } %>      
	</div>

</body>
</html>