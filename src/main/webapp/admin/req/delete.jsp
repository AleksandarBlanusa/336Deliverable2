<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<%
	String userid = request.getParameter("userid");
	
	try{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		
		String query = "DELETE FROM users WHERE user_id = ?";
		
		PreparedStatement pst = con.prepareStatement(query);
		pst.setString(1, userid);
		
		int res = pst.executeUpdate();
		
		if(res > 0){
			out.println("Success! <a href = '../index.jsp'>Go Back</a>");
		}
		
		pst.close();
		con.close();
		
	}catch(Exception e){
        out.println("An unexpected error occurred. Please try again later. <a href='../index.jsp'>Try again</a>");
        e.printStackTrace();
	}
%>