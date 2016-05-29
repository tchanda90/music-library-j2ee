<%@ page language="java" import="java.sql.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- Connect.jsp is included so no need to establish connection again -->
<%@ include file="Connect.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Sign Up Error</title>

</head>

<body>

<%
/* request.getParameter is used to get the value from the previous page's form */
String name = request.getParameter("name");
String email = request.getParameter("email");
String password = request.getParameter("password");

try {
	stmt = conn.createStatement();
	/* 
	if entered email is already in user_tb,
	a primary key violation will occur and an exception will be thrown 
	*/
	stmt.executeUpdate("Insert into User_tb values('"+email+"', '"+name+"', '"+password+"')");
	stmt.close();

	/* 
	if no exception (entered email did not exist in user_tb), 
	creates a session id variable and redirects to home page 
	*/
	
	//splits name by whitespace and keeps only the first name
	name = name.split("\\s+")[0];
	
	session.setAttribute("id", email);
	session.setAttribute("name", name);
	session.setAttribute("type", "user");
	response.sendRedirect("UserHome.jsp");
}
catch(Exception e) {
	%><script>
		alert('Email ID Already Registered. Try Logging In');
		window.location.href = "LogIn.jsp";
	</script><%
	//response.sendRedirect("SignUp.jsp");
}
	
%>

</body>
</html>