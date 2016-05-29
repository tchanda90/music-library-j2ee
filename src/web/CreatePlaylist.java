package web;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

/**
 * Servlet implementation class AddToPlaylist
 */
@WebServlet("/CreatePlaylist")
public class CreatePlaylist extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public CreatePlaylist() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String playlistId = "p";
		String playlistName = request.getParameter("pName");
		String email = request.getParameter("sessionId");
		
		Connection conn = Connect.getConnection();
		
		response.setContentType("text/xml");
        response.setHeader("Cache-Control", "no-cache");
		
		try{
			int id = 1;
			PreparedStatement preparedSt = conn.prepareStatement("Select Count(Playlist_Id) From Playlist_Tb") ;
			ResultSet rs = preparedSt.executeQuery();
			
			if (rs.next()){
				id = rs.getInt(1);
			}
			++id;
			
			playlistId += id;
			
		    PreparedStatement pst = conn.prepareStatement("Insert Into Playlist_Tb(Playlist_Id, Playlist_Name, Email) Values(?, ?, ?)");
		    pst.setString(1, playlistId);
		    pst.setString(2, playlistName);
		    pst.setString(3, email);

		    pst.executeUpdate();
		    conn.close();
            response.getWriter().write("<valid>available</valid>");
            response.sendRedirect("Playlists.jsp");
		}
		catch(Exception e){
			System.out.println("Create Playlist Exception: " + e);
			response.sendRedirect("UserHome.jsp");
			response.getWriter().write("<valid>failed</valid>");
		}	
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
