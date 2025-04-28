<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<%		


		String user = (String) session.getAttribute("username");
		String first = (String) session.getAttribute("firstname");
		String role = (String) session.getAttribute("role");
		
		if (user == null || first == null) {
			response.sendRedirect("../login.jsp"); 
			return;
		}

		String userid = request.getParameter("userid");
		String firstname = request.getParameter("firstname");
		String lastname = request.getParameter("lastname");
		String username = request.getParameter("username");
		String email = request.getParameter("email");
		String pass = request.getParameter("password");
		
		
		try{
			if (firstname.isEmpty() || lastname.isEmpty() || username.isEmpty() ||email.isEmpty() || pass.isEmpty()) throw new SQLSyntaxErrorException();
			
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			
	        String query = "select * from users where username = ? and user_id != ?";
	        
	     	PreparedStatement pst = con.prepareStatement(query);
		    pst.setString(1, username);
		    pst.setString(2, userid);
		    
		    ResultSet rs = pst.executeQuery();
		    
		    if (rs.next()) {
				out.println("Username already being used! <a href='../edit.jsp?userid=" + userid + "'>try again</a>");
				return;
		    }
		    
		    query = "select * from users where email = ? and user_id != ?";
		    
	     	pst = con.prepareStatement(query);
		    pst.setString(1, email);
			pst.setString(2, userid);
		    
		   	rs = pst.executeQuery();
						
			if (rs.next()){
				out.println("Email already being used! <a href='../edit.jsp?userid=" + userid + "'>try again</a>");
				return;
			}
			
			query = "UPDATE users SET firstname = ?, lastname = ?, username = ?, email = ?, password = ? WHERE user_id = ?";
			
			pst = con.prepareStatement(query);
			pst.setString(1, firstname);
			pst.setString(2, lastname);
			pst.setString(3, username);
			pst.setString(4, email);
			pst.setString(5, pass);
			pst.setString(6, userid);
			
			
			int count = pst.executeUpdate();
			
			if (count != 0){
				response.sendRedirect("../index.jsp");
			}
						
			
		    rs.close();
		    pst.close();
		    con.close();
		        		

		}catch(SQLSyntaxErrorException e){
			out.println("Enter all information. <a href='../edit.jsp'>try again</a>");
		    e.printStackTrace();		
			
		} catch (Exception e) {
		    // Handle other exceptions
		    out.println("Unable to connect to DB. Please try again later.");
		    e.printStackTrace();
		}
		%>