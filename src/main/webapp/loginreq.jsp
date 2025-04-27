<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
		String username = request.getParameter("username");
		String pass = request.getParameter("password");
		
		
		
		try{
			if (username.isEmpty() || pass.isEmpty()) throw new SQLSyntaxErrorException();
			
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			
	        String query = "select * from users where username = ? and password = ?";
	        
	     	PreparedStatement pst = con.prepareStatement(query);
		    pst.setString(1, username);
		    pst.setString(2, pass);
		    
		    ResultSet rs = pst.executeQuery();
		    
		    
		    if (rs.next()) {
		    	String role = rs.getString("role");
		    	String firstname = rs.getString("firstname");
		    	session.setAttribute("username", username);
		    	session.setAttribute("firstname", firstname);
		    	session.setAttribute("role", role);
		    	
		        if (role.equalsIgnoreCase("customer")) {
		        	response.sendRedirect("./customer/index.jsp");
		        } else if(role.equalsIgnoreCase("customer_rep")){
		        	response.sendRedirect("./rep/index.jsp");
		        }else if(role.equalsIgnoreCase("admin")){
		        	response.sendRedirect("./admin/index.jsp");
		        }
		        return;
		    } else {
		        out.println("Invalid username or password <a href='./login.jsp'>try again</a>");
		    }
			
		    rs.close();
		    pst.close();
		    con.close();
		        		
		        		
		}catch(SQLSyntaxErrorException e){
			out.println("Enter all information. <a href='./login.jsp'>try again</a>");
		    e.printStackTrace();		
			
		} catch (Exception e) {
		    // Handle other exceptions
		    out.println("Unable to connect to DB. Please try again later.");
		    e.printStackTrace();
		}
		%>