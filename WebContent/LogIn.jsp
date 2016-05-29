<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>


<head>

<%@ include file="Index.html" %>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<title>Log In</title>


<script>

function init(){
	var logInButton = document.getElementById("bLogIn");
	logInButton.style.background = '#3333ff';
	logInButton.style.color = 'white';
	logInButton.style.border = '1px solid #3333ff';
}

/* called when the log in button is clicked */
function LogInValidation(){
	/* create variables to the elements */
	var email = document.getElementById("tbEmail");
	var password = document.getElementById("tbPassword");
	var error = document.getElementById("lError");
	
	email.style.borderColor = 'black';
	password.style.borderColor = 'black';
	
	/* 
	if email/password is empty, displays an appropriate error and returns false.
	Returning false prevents the form from being submitted
	*/
	if (email.value == "" && password.value == ""){
        email.style.borderColor = 'red';
        password.style.borderColor = 'red';
        error.innerHTML = "Please Enter Both Email and Password";
		return false;
	}
	if (email.value == ""){
		email.style.borderColor = 'red';
        error.innerHTML = "Please Enter Email";
        return false;
	}
	if (password.value == ""){
		password.style.border = '2px solid red';
        error.innerHTML = "Please Enter Password";
        return false;
	}
	/* if both are not empty, returns true, and the form is submitted */
	return true;
}

</script>

</head>



<body onload="init()">

<div class="fadeIn">
<form id="logInForm" method="POST" action="LogInCheck.jsp" onsubmit="return LogInValidation()"></form>

<table class="topTable">
	<tr>
		<td>&nbsp;</td>
	</tr>
	
	<tr>
		<td>
			<input type="text" form="logInForm" name="email" id="tbEmail" placeholder="Enter your Email" >
		</td>
	</tr>
	
	<tr>
		<td></td>
	</tr>
	
	<tr>
		<td>
			<input type="password" form="logInForm" name="password" id="tbPassword" placeholder="Enter your Password" >
		</td>
	</tr>
	
	<tr>
		<td></td>
	</tr>
	
	<tr>
		<td>
			<input type="submit" form="logInForm" class="button" value="Log In" >
		</td>
	</tr>
	
	<tr>
		<td></td>
	</tr>
	
	<tr>
		<td>
			<label id="lError" class="errorLabel"></label>
		</td>
	</tr>
</table>

</div>

</body>
</html>