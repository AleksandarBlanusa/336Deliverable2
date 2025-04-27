<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%		
		String firstname = request.getParameter("firstname");
		String lastname = request.getParameter("lastname");
		String username = request.getParameter("username");
		String email = request.getParameter("email");
		String pass = request.getParameter("password");
		String role = request.getParameter("user");
		
		
		try{
			if (username.equals("admin")) throw new NoSuchFieldException();
			
			if (firstname.isEmpty() || lastname.isEmpty() || username.isEmpty() ||email.isEmpty() || pass.isEmpty() || role == null) throw new SQLSyntaxErrorException();
			
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	
			
	        String query = "select * from users where username = ? ";
	        
	     	PreparedStatement pst = con.prepareStatement(query);
		    pst.setString(1, username);
		    
		    ResultSet rs = pst.executeQuery();
		    
		    if (rs.next()) {
				out.println("Username already being used! <a href='./create.jsp'>try again</a>");
		    }
		    
		    query = "select * from users where email = ? ";
		    
	     	pst = con.prepareStatement(query);
		    pst.setString(1, username);
		    
		   	rs = pst.executeQuery();
						
			if (rs.next()){
				out.println("Email already being used! <a href='./create.jsp'>try again</a>");
			}
			
			query = "INSERT INTO users (firstname, lastname, username, email, password, role) VALUES (?, ?, ?, ?, ?, ?)";
			
			pst = con.prepareStatement(query);
			pst.setString(1, firstname);
			pst.setString(2, lastname);
			pst.setString(3, username);
			pst.setString(4, email);
			pst.setString(5, pass);
			pst.setString(6, role);
			
						
			int count = pst.executeUpdate();
			
			if (count != 0){
				out.println("Account made! <a href='./login.jsp'>login</a>");
			} else {
				out.println("Error ... Unable to create account");
			}
						
			
		    rs.close();
		    pst.close();
		    con.close();
		        		
		        		
		}catch(NoSuchFieldException e){
			out.print("Cannot make an admin account! <a href='./create.jsp'>try again</a>");
			e.printStackTrace();
		}catch(SQLSyntaxErrorException e){
			out.println("Enter all information. <a href='./create.jsp'>try again</a>");
		    e.printStackTrace();		
			
		} catch (Exception e) {
		    // Handle other exceptions
		    out.println("Unable to connect to DB. Please try again later.");
		    e.printStackTrace();
		}
		%>