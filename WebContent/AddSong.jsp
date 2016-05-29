<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="AdminHome.html" %>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Add Song</title>

<script>

function AddSongValidation(){
	var artist = document.getElementById("tArtist");
	var album = document.getElementById("tAlbum");
	var genre = document.getElementById("tGenre");
	var songName = document.getElementById("tSongName");
	var songFile = document.getElementById("tSongFile");
	var songImage = document.getElementById("tSongImage");
	var message = document.getElementById("lMessage");
	
	if (artist.value == "" || songImage.value == "" || album.value == "" || songName.value == "" || songFile.value == ""){
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
	background-color: white;
}

.inputLabel{
	color: black;
	font-family: 'Calibri';
	font-weight: bold;
	font-size: 20px;
}
</style>

</head>
<body style="text-align: center; background-color: #f1f1f1;">

<% 
/* redirect to login page if session is null or not admin */
if (session.getAttribute("id") == null || !session.getAttribute("type").equals("admin")){
	response.sendRedirect("LogIn.jsp");
	return;
}
%>

<div class="formDiv">
<form id="addSongForm" method="POST" onsubmit="return AddSongValidation()" action="FileUpload" enctype="multipart/form-data" >
	<br><br>
	<input type="text" name="artist" id="tArtist" placeholder="Artist Name" >	<br><br>
	<input type="text" name="album" id="tAlbum" placeholder="Album Name" >	<br><br>
	<select style="width: 457px;" name="genre">
		<option value="Select Genre" selected="selected" disabled="disabled">Select Genre</option>
		<option value="Alternative">Alternative</option>
		<option value="Blues">Blues</option>
		<option value="Classical">Classical</option>
		<option value="Country">Country</option>
		<option value="Electronic">Electronic</option>
		<option value="Folk">Folk</option>
		<option value="Jazz">Jazz</option>
		<option value="Metal">Metal</option>
		<option value="Pop">Pop</option>
		<option value="Rock">Rock</option>
		<option value="Soundtrack">Soundtrack</option>	
		<option value="Other">Other</option>				
	</select> <br><br>
	<input type="text" name="songName" id="tSongName" placeholder="Song Name" >	<br><br>
	<label class="inputLabel">Song File</label> <input type="file" name="songFile" id="tSongFile" >	<br><br>
	<label class="inputLabel">Image File</label> <input type="file" name="songImage" id="tSongImage" >	<br><br>
	<input type="submit" value="Upload" name="addSong" class="button" id="tAddSong" >	<br><br>
</form>

</div>

<label id="lMessage" class="errorLabel" style="background-color: white;"></label>

</body>
</html>