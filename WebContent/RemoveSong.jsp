<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="AdminHome.html" %>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Remove Song</title>

<script>
function RemoveSongValidation(){
	var artist = document.getElementById("tArtist");
	var album = document.getElementById("tAlbum");
	var songName = document.getElementById("tSongName");
	var message = document.getElementById("lMessage");
	
	if (artist.value == "" || album.value == "" || songName.value == ""){
		lMessage.innerHTML = "Please Enter all Fields";
		return false;
	}
	return true;
}
</script>

<style>
.formDiv{
	margin-left: auto; 
	margin-right:auto; 
	text-align: center;
	width: 50%;
	box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
}

.inputLabel{
	color: black;
	font-family: 'Calibri';
	font-weight: bold;
	font-size: 20px;
}
</style>

</head>

<body style="text-align: center;">

<% 
/* redirect to login page if session is null or not admin */
if (session.getAttribute("id") == null || !session.getAttribute("type").equals("admin")){
	response.sendRedirect("LogIn.jsp");
	return;
}
%>

<div class="formDiv">
<form id="removeSongForm" method="POST" action="FileRemove" onsubmit="return RemoveSongValidation()" >
	<br><br>
	<input type="text" name="artist" id="tArtist" placeholder="Artist Name" >	<br><br>
	<input type="text" name="songName" id="tSongName" placeholder="Song Name" >	<br><br>
	<input type="submit" style="background-color: red;" value="Remove" name="removeSong" class="button" id="tRemoveSong" > <br><br>
</form>

</div>

<label id="lMessage" class="errorLabel" style="background-color: white;"></label>

</body>
</html>