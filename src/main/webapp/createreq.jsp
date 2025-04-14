<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
		String username = request.getParameter("username");
		String pass = request.getParameter("password");
		String role = request.getParameter("user");
		
		
		try{
			if (username.isEmpty() || pass.isEmpty() || role == null) throw new SQLSyntaxErrorException();
			
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			
	        String query = "select * from " + role + " where username = ? ";
	        
	     	PreparedStatement pst = con.prepareStatement(query);
		    pst.setString(1, username);
		    
		    ResultSet rs = pst.executeQuery();
		    
		    if (rs.next()) {
				out.println("Username already being used! <a href='./create.jsp'>try again</a>");
		    }else {
		    
				query = "INSERT INTO " + role + " (username, password) VALUES (?, ?)";
				
				pst = con.prepareStatement(query);
				pst.setString(1, username);
				pst.setString(2, pass);
				
							
				int count = pst.executeUpdate();
				
				if (count > 0){
					out.println("Account made! <a href='./index.jsp'>login</a>");
				} else {
					out.println("Error ... Unable to create account");
				}	
			}			
			
		    rs.close();
		    pst.close();
		    con.close();
		        		
		        		
		}catch(SQLSyntaxErrorException e){
			out.println("Enter all information. <a href='./create.jsp'>try again</a>");
		    e.printStackTrace();		
			
		} catch (Exception e) {
		    // Handle other exceptions
		    out.println("Unable to connect to DB. Please try again later.");
		    e.printStackTrace();
		}
		%>