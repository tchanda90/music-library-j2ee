package web;

import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Connect
 */
@WebServlet("/Connect")
public class Connect extends HttpServlet {
	private static final long serialVersionUID = 1L;
	public static Connection conn = null;
    public Connect() {
        super();
    }

    public static Connection getConnection(){
    	try{		
    	    Class.forName("oracle.jdbc.driver.OracleDriver");
    	    conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "tchanda90", "123");
    	}
    	catch(Exception e) {
    		System.out.println("DataBase Error " + e);
    	}
    	return conn;
    }

}
