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
 * Servlet implementation class RemovePlaylist
 */
@WebServlet("/RemovePlaylist")
public class RemovePlaylist extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public RemovePlaylist() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String playlistId = request.getParameter("playlistId");
		
		Connection conn = Connect.getConnection();
		
		try{
		    PreparedStatement pst = conn.prepareStatement("Delete From Playlist_Tb Where Playlist_Id = ?");
		    PreparedStatement pst1 = conn.prepareStatement("Delete From Playlist_Songs Where Playlist_Id = ?");
		    pst.setString(1, playlistId);
		    pst1.setString(1, playlistId);
		    pst.executeUpdate();
		    pst1.executeUpdate();
		    conn.close();
		    response.sendRedirect("Playlists.jsp");
		}
		catch(Exception e){
			System.out.println("Remove Playlist Exception: " + e);
		    response.sendRedirect("Playlists.jsp");
		}	
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
