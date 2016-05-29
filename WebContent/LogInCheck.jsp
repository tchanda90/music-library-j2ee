<%@ page language="java" import="java.sql.*" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Log In</title>

<!-- Connect.jsp is included so no need to establish connection again -->
<%@ include file="Connect.jsp" %>

</head>

<body>
<%
/* request.getParameter is used to get the value from the previous page's form */
String email = request.getParameter("email");
String password = request.getParameter("password");

PreparedStatement pst = null;
ResultSet rs = null;

try {
	
	/* checks admin_tb for a match */
	pst = conn.prepareStatement("Select Email, Password From Admin_Tb Where Email=? and Password=?");
	pst.setString(1, email);
	pst.setString(2, password);
	/* stores result in rs */
	rs = pst.executeQuery();
	
	/* 
	*if a row matched (rs.next() returns non zero), 
	*creates session id and type variable, and redirects to admin home page  
	*/
	if (rs.next()){
		session.setAttribute("id", email);
		session.setAttribute("type", "admin");
		response.sendRedirect("AddSong.jsp");
	}
	

	/* 
	*this is reached if admin table didn't produce a match
	*checks user_tb for a match 
	*/
	pst = conn.prepareStatement("Select Email, Name, Password From User_Tb Where Email=? and Password=?");
	pst.setString(1, email);
	pst.setString(2, password);
	/* stores result in rs */
	rs = pst.executeQuery();

	/* 
	*if a row matched (rs.next() returns non zero), 
	*creates session id and type variables, and redirects to user home page  
	*/
	
	if (rs.next()){
		String name = rs.getString(2);
		//splits name by whitespace and keeps only the first name
		name = name.split("\\s+")[0];
		
		session.setAttribute("id", email);
		session.setAttribute("name", name);
		session.setAttribute("type", "user");
		response.sendRedirect("UserHome.jsp");
	}
	else{
		%><script>
			window.alert('Incorrect Email/Password');
			window.location.href = "LogIn.jsp";
		</script><%
	}
}
catch(Exception e) {
	out.println(e);
}

%>
</body>
</html>