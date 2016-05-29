<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

<head>

<%@ include file="Index.html" %>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Sign Up</title>

<script>

	function init(){
		var signUpButton = document.getElementById("bSignUp");
		signUpButton.style.background = '#3333ff';
		signUpButton.style.color = 'white';
		signUpButton.style.border = '1px solid #3333ff';
	}	
	
	/* email validation using regular expressions */
	function EmailValidation(){
		var email = document.getElementById("tbEmail");
		email.style.borderColor = 'black';
		var pattern = email.value;
		if (!pattern.match('.+[@].+\.com')){
			email.style.borderColor = 'red';
			document.getElementById("lError").style.color = 'red';
			document.getElementById("lError").innerHTML = "Enter a Valid Email Address";
			return false;
		}
		document.getElementById("lError").innerHTML = "";
		return true;
	}

	/* called when the sign up button is clicked */
	function SignUpValidation(){
		/* create variables to the elements */
		var name = document.getElementById("tbName");
		var email = document.getElementById("tbEmail");
		var password = document.getElementById("tbPassword");
		var confirmPassword = document.getElementById("tbConfirmPassword");
		var error = document.getElementById("lError");
		
		name.style.borderColor = 'black';
		email.style.borderColor = 'black';
		password.style.borderColor = 'black';
		confirmPassword.style.borderColor = 'black';
		error.style.color = 'red';
		
		/* 
		If any of the inputs are empty, displays an error message and returns false.
		Returning false prevents the form from being submitted
		*/
		if (name.value == "" || email.value == "" || password.value == "" || confirmPassword.value == ""){
			if (name.value == ""){
				name.style.borderColor = 'red';
			}
			if (email.value == ""){
				email.style.borderColor = 'red';
			}
			if (password.value == ""){
				password.style.borderColor = 'red';
			}
			if (confirmPassword.value == ""){
				confirmPassword.style.borderColor = 'red';
			}
	        error.innerHTML = "Please Fill Out All Fields";
	        return false;
	    }   
		
		
		/* checks if passwords match; displays an error if they don't, and returns false */
	    if (password.value != confirmPassword.value){
	    	password.style.borderColor = 'red';
	    	confirmPassword.style.borderColor = 'red';
	        error.innerHTML = "Passwords Don't Match";
	    	return false;
	    }
		
		/* submits the form; this is reached if the above if conditions are false */
		return true;
	}
	
</script>

</head>

<body onload="init()">

<div class="fadeIn">

<form id="signUpForm" method="POST" action="SignUpCheck.jsp" onsubmit="return SignUpValidation()" ></form>

<table class="topTable">
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<input type="text" form="signUpForm" name="name" id="tbName" placeholder="Enter your Name" >
		</td>
	</tr>
	
	<tr>
		<td>&nbsp;</td>
	</tr>
	
	<tr>
		<td>
			<input type="text" form="signUpForm" name="email" id="tbEmail" placeholder="Enter your Email" oninput="EmailValidation()" >
		</td>
	</tr>
	
	<tr>
		<td>&nbsp;</td>
	</tr>
	
	<tr>
		<td>
			<input type="password" form="signUpForm" name="password" id="tbPassword" placeholder="Enter a Password"  >
		</td>
	</tr>
	
	<tr>
		<td>&nbsp;</td>
	</tr>
	
	<tr>
		<td>
			<input type="password" form="signUpForm" name="confirmPassword" id="tbConfirmPassword" placeholder="Confirm Password" >
		</td>
	</tr>
	
	<tr>
		<td>&nbsp;</td>
	</tr>
	
	<tr>
		<td>
			<input type="submit" class="button" form="signUpForm" value="Sign Up" >
		</td>
	</tr>
	
	<tr>
		<td>&nbsp;</td>
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