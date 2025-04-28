<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

    <%
        String user = (String) session.getAttribute("username");
    	String firstname = (String) session.getAttribute("firstname");
    	String role = (String) session.getAttribute("role");
    	
        if (user == null || firstname == null) {
        	response.sendRedirect("../login.jsp"); 
        	return;
        }
    %>

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
	<p><a href='../logout.jsp'>Log out</a></p>
	
	<p>
	<a href = "./add-user.jsp">Add User</a>
	</p>
	
	<div>
	<table>
		<tr>
			<td>User_id</td>
			<td>First Name</td>
			<td>Last Name</td>
			<td>Username</td>
			<td>Email</td>
			<td>Password</td>
			<td>Role</td>
		</tr>
	
		<%
		
	        ApplicationDB db = new ApplicationDB();
	        Connection con = db.getConnection();
	        
	        String query = "SELECT * FROM users WHERE NOT role = 'admin'";
	        
	        Statement stmt = con.createStatement();
	        ResultSet rs = stmt.executeQuery(query);
	        
	        while (rs.next()) {
	        	String userid = rs.getString("user_id");
	            String first = rs.getString("firstname");
	            String last = rs.getString("lastname");
	            String username = rs.getString("username");
	            String email = rs.getString("email");
	            String password = rs.getString("password");
	            String user_role = rs.getString("role"); 
	            
	            // Display employee information in table rows
	            out.println("<tr>");
	            out.println("<td>" + userid + "</td>");
	            out.println("<td>" + first + "</td>");
	            out.println("<td>" + last + "</td>");
	            out.println("<td>" + username + "</td>");
	            out.println("<td>" + email + "</td>");
	            out.println("<td>" + password + "</td>");
	            out.println("<td>" + user_role + "</td>");
	            out.println("<td>");
	            out.println("<button onclick=\"location.href='./edit.jsp?userid=" + userid + "'\">Edit</button>");
	            out.println("<button onclick=\"location.href='./req/delete.jsp?userid=" + userid + "'\">Delete</button>");
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