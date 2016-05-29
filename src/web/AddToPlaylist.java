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
 * Servlet implementation class AddToPlaylist
 */
@WebServlet("/AddToPlaylist")
public class AddToPlaylist extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddToPlaylist() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String songId = request.getParameter("songId");
		String playlistId = request.getParameter("buttonId");
		
		Connection conn = Connect.getConnection();
		
		response.setContentType("text/xml");
        response.setHeader("Cache-Control", "no-cache");
		
		try{
		    PreparedStatement pst = conn.prepareStatement("Insert Into Playlist_Songs(Playlist_Id, Song_Id) Values(?, ?)");
		    pst.setString(1, playlistId);
		    pst.setString(2, songId);

		    pst.executeUpdate();
		    conn.close();
            response.getWriter().write("<valid>available</valid>");
		}
		catch(Exception e){
			System.out.println("Add to Playlist Exception: " + e);
			response.getWriter().write("<valid>failed</valid>");
		}	
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
