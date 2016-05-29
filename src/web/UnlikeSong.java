package web;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class UnlikeSong
 */
@WebServlet("/UnlikeSong")
public class UnlikeSong extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public UnlikeSong() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String songId = request.getParameter("likeId");
		String email = request.getParameter("sessionId");
		Connection conn = Connect.getConnection();
		
		try{
		    PreparedStatement pst = conn.prepareStatement("Delete From Likes_Tb Where Email = ? and Song_Id = ?");
		    pst.setString(1, email);
		    pst.setString(2, songId);
		    PreparedStatement pst1 = conn.prepareStatement("Update Song_Tb Set Likes = Likes - 1 Where Song_Id = ?");
		    pst1.setString(1, songId);
		    
		    pst.executeUpdate();
		    pst1.executeUpdate();
		    conn.close();
		    request.setAttribute("message", "Song Successfully Unliked");
		    
		    response.setContentType("text/xml");
            response.setHeader("Cache-Control", "no-cache");
            response.getWriter().write("<valid>available</valid>");
		}
		catch(Exception e){
			System.out.println("Unlike Song Exception: "+ e);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
