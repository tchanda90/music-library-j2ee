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
 * Servlet implementation class RemoveFromPlaylist
 */
@WebServlet("/RemoveFromPlaylist")
public class RemoveFromPlaylist extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public RemoveFromPlaylist() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String songId = request.getParameter("songId");
		String playlistId = request.getParameter("playlistId");
		
		Connection conn = Connect.getConnection();
		
		response.setContentType("text/xml");
        response.setHeader("Cache-Control", "no-cache");
		
		try{
		    PreparedStatement pst = conn.prepareStatement("Delete From Playlist_Songs Where Playlist_Id = '" + playlistId + "' and Song_Id = '" + songId + "'");
		    pst.executeUpdate();
		    conn.close();
            response.getWriter().write("<valid>available</valid>");
		}
		catch(Exception e){
			System.out.println("Remove From Playlist Exception: " + e);
			response.getWriter().write("<valid>failed</valid>");
		}	
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
