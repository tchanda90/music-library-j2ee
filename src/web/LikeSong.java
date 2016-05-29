package web;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.*;

/**
 * Servlet implementation class LikeSong
 */
@WebServlet("/LikeSong")
public class LikeSong extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public LikeSong() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String songId = request.getParameter("likeId");
		String email = request.getParameter("sessionId");
		
		Connection conn = Connect.getConnection();
		
		response.setContentType("text/xml");
        response.setHeader("Cache-Control", "no-cache");
		
		try{
		    PreparedStatement pst = conn.prepareStatement("Insert Into Likes_Tb Values(?, ?)");
		    pst.setString(1, email);
		    pst.setString(2, songId);
		    PreparedStatement pst1 = conn.prepareStatement("Update Song_Tb Set Likes = Likes + 1 Where Song_Id = ?");
		    pst1.setString(1, songId);
		    
		    pst.executeUpdate();
		    pst1.executeUpdate();
		    conn.close();
            response.getWriter().write("<valid>available</valid>");
		}
		catch(Exception e){
			System.out.println("Like Song Exception: " + e);
			response.getWriter().write("<valid>failed</valid>");
		}	
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
