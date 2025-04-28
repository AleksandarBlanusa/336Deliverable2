<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin</title>
</head>
<body>
	
	<h1>
	Manage Users
	</h1>
	
	<p>
	<!-- buttons for other operations go here -->
	</p>
	
	<div>
	<table>
		<tr>
			<td>First Name</td>
			<td>Last Name</td>
			<td>Username</td>
			<td>Email</td>
			<td>Password</td>
		</tr>
	
		<%
		
	        ApplicationDB db = new ApplicationDB();
	        Connection con = db.getConnection();
	        
	        String query = "SELECT * FROM users WHERE NOT role = 'admin'";
	        
	        Statement stmt = con.createStatement();
	        ResultSet rs = stmt.executeQuery(query);
	        
	        while (rs.next()) {
	            String first = rs.getString("firstname");
	            String last = rs.getString("lastname");
	            String username = rs.getString("username");
	            String email = rs.getString("email");
	            String password = rs.getString("password");
	            
	            // Display employee information in table rows
	            out.println("<tr>");
	            out.println("<td>" + first + "</td>");
	            out.println("<td>" + last + "</td>");
	            out.println("<td>" + username + "</td>");
	            out.println("<td>" + email + "</td>");
	            out.println("<td>" + password + "</td>");
	            out.println("<td>");
	            out.println("</td>");
	            out.println("</tr>");
	        }
	        
	        rs.close();
	        stmt.close();
	        con.close();
		%>
		
	</table>
	</div>
</body>
</html>