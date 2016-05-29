<%@ page import="java.sql.*" language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
	Connection conn = null;
	ResultSet result = null;
	Statement stmt = null;
	try{		
	    Class.forName("oracle.jdbc.driver.OracleDriver");
	    conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "tchanda90", "123");
	}
	catch(Exception e) {
		out.print("DataBase Error " + e);
	}
%>

</body>
</html>