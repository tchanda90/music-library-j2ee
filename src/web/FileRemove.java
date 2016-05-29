package web;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

/**
 * Servlet implementation class FileRemove
 */
@WebServlet("/FileRemove")
public class FileRemove extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private final String UPLOAD_DIRECTORY = "C:\\My Files\\Code\\J2EE\\Projects\\AudioCloud\\WebContent\\Music";

    public FileRemove() {
        super();
    }
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	String artist = request.getParameter("artist");;
    	String songName = request.getParameter("songName");
    	
    	System.out.println("Song Name: " + songName);
    	System.out.println("Song Artist: " + artist);
    	
    	File deleteFile = new File(UPLOAD_DIRECTORY + File.separator + songName + ".mp3") ;
    	File deleteImage = new File(UPLOAD_DIRECTORY + File.separator + songName + ".jpg") ;
    	
    	if( deleteFile.exists() ){
    		deleteFile.delete();
    		request.setAttribute("message", "File Deleted Successfully");
    	}
    	else{
    		request.setAttribute("message", "File Doesn't Exist");
    	}
    	if( deleteImage.exists() ){
    		deleteImage.delete();
    		request.setAttribute("message", "File Deleted Successfully");
    	}
    	else{
    		request.setAttribute("message", "File Doesn't Exist");
    	}
    	
    	request.getRequestDispatcher("/result.jsp").forward(request, response);
    	
    	/* Remove entry from the database */
    	Connection conn = null;
    	Connection conn1 = null;
    	Connection conn2 = null;
    	Connection conn3 = null;
	    try{
	    	//delete from song_tb
	    	conn = Connect.getConnection();	    
		    PreparedStatement pst = conn.prepareStatement("Delete From Song_Tb Where LOWER(Artist) = ? and LOWER(Song_Name) = ?");
		    pst.setString(1, artist.toLowerCase());
		    pst.setString(2, songName.toLowerCase());
		    pst.executeQuery();
		    
		    //get song_id
		    conn1 = Connect.getConnection();
		    PreparedStatement pst1 = conn1.prepareStatement("Select Song_Id From Song_Tb Where LOWER(Song_Name) = ?");
		    pst1.setString(1, songName.toLowerCase());
		    ResultSet rs = pst1.executeQuery();
		    
		    System.out.println("Deleted from song_tb");

		    String songId = null;
		    if (rs.next()){
		    	songId = rs.getString(1);
		    }
		    
		    System.out.println("Song Id: " + songId);
		    
		    //delete from likes_tb
		    conn2 = Connect.getConnection();
		    PreparedStatement pst2 = conn2.prepareStatement("Delete From Likes_Tb Where Song_Id = ?");
		    pst2.setString(1, songId);
		    pst2.executeQuery();
		    
		    System.out.println("Deleted from likes_tb");
		    
		    //delete from playlist_songs
		    conn3 = Connect.getConnection();
		    PreparedStatement pst3 = conn3.prepareStatement("Delete From Playlist_Songs Where Song_Id = ?");
		    pst3.setString(1, songId);
		    pst3.executeQuery();
		    
		    System.out.println("Deleted from playlist_songs");
	    }
	    catch(Exception e){
	    	System.out.println("File Remove Exception: " + e);
	    }
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
