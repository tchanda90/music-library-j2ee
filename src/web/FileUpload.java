package web;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
 * Servlet implementation class FileUpload
 */
@WebServlet("/FileUpload")
public class FileUpload extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private final String UPLOAD_DIRECTORY = "C:\\My Files\\Code\\J2EE\\Projects\\AudioCloud\\WebContent\\Music";

    public FileUpload() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String fileName = null;
		String imageName = null;
    	String artist = null;
    	String album = null;
    	String genre = null;
    	String songName = null;
    	String songPath = null;
    	String imagePath = null;
    	int songId;

        //process only if multipart content
        if(ServletFileUpload.isMultipartContent(request)){
            try {
                List<FileItem> multiparts = new ServletFileUpload(
                   new DiskFileItemFactory()).parseRequest(request);
                int file = 1;
	            for(FileItem item : multiparts){
	            	if(!item.isFormField()){
	            		//file
	            		if (file == 1){
	            			++file;
	            			fileName = new File(item.getName()).getName();
		            		item.write( new File(UPLOAD_DIRECTORY + File.separator + fileName));
	            		}
	            		else{
	            			imageName = new File(item.getName()).getName();
		            		item.write( new File(UPLOAD_DIRECTORY + File.separator + imageName));
	            		}     		
	            	}
	            	else{
	            		//form fields
	            		if(item.getFieldName().equals("songName"))
	            			songName = item.getString();
	            		if(item.getFieldName().equals("artist"))
	            			artist = item.getString();
	            		if(item.getFieldName().equals("album"))
	            			album = item.getString();
	            		if(item.getFieldName().equals("album"))
	            			album = item.getString();
	            		if (item.getFieldName().equals("genre"))
	            			genre = item.getString();
	            	}
	            }
	            //File uploaded successfully
	            request.setAttribute("message", "File Uploaded Successfully");
            }
            catch (Exception e) {
                request.setAttribute("message", "File Upload Failed due to " + e);
                return;
            }

        }
        else{
            request.setAttribute("message",
                                 "Sorry this Servlet only handles file upload request");
            return;
        }

        request.getRequestDispatcher("/result.jsp").forward(request, response);

        /* Following code inserts an entry in the database */
        Connection conn = null;
	    try{
	    	conn = Connect.getConnection();
			songPath = new String(UPLOAD_DIRECTORY).concat(File.separator).concat(fileName);
			imagePath = new String(UPLOAD_DIRECTORY).concat(File.separator).concat(imageName);
	    	songId = 0;
		    PreparedStatement pst1 = conn.prepareStatement("Select Max(CAST(Song_Id AS INT)) From Song_Tb");
		    ResultSet rs1 = pst1.executeQuery();
		   
		    if(rs1.next())
		    	songId = rs1.getInt(1);
		    ++songId;
		    
		    PreparedStatement pst = conn.prepareStatement("Insert into Song_Tb(Song_Id, Artist, Album, Song_Name, Song_Path, Image_Path, Genre) Values(?, ?, ?, ?, ?, ?, ?)");
		
		    pst.setString(1, Integer.toString(songId));
		    pst.setString(2, artist);
		    pst.setString(3, album);
		    pst.setString(4, songName);
		    pst.setString(5, songPath);
		    pst.setString(6, imagePath);
		    pst.setString(7, genre);
		
		    pst.executeUpdate();

		    conn.close();
	
	    }
	    catch(Exception e){
	        System.out.println("File Upload Exception " + e);
	        return;
	    }
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
