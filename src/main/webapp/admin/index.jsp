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
	
	<h1>Admin</h1>
	
	<p><a href='../logout.jsp'>Log out</a></p>
	
	<div>
	<h1>Manage Users</h1>
	<p>
	<a href = "./add-user.jsp">Add User</a>
	</p>
	
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
	<div>
	<h1>Reservations</h1>
	<h2>By Flight ID</h2>
	<form method="post" action="./req/res_flightid.jsp">
	<label for="firstname">Flight ID: </label>
	<input type="text" name="flightid" id="flightid" placeholder="Enter Flight ID" required>
	<input type="submit" value="submit">
	</form>
	<h2>By Customer Name</h2>
	<form method="post" action="./req/res_custname.jsp">
	<label for="firstname">First Name: </label>
	<input type="text" name="firstname" id="firstname" placeholder="Enter Customer First Name" required><br/>
	<label for="lastname">Last Name: </label>
	<input type="text" name="lastname" id="lastname" placeholder="Enter Customer Last Name" required><br/>
	<input type="submit" value="submit">
	</form>
	</div>
	
	<div>
	<h1>Revenue</h1>
	
	<h3>Revenue by Flight</h3>
	<form method="post" action="./req/flightrev.jsp">
	<input type="submit" value="Get Flight Revenue">
	</form>
	
	<h3>Revenue by Airline</h3>
	<form method="post" action="./req/airlinerev.jsp">
	<input type="submit" value="Get Airline Revenue">
	</form>
	
	<h3>Revenue by Customer</h3>
	<form method="post" action="./req/customerrev.jsp">
	<input type="submit" value="Get Customer Revenue">
	</form>
	</div>
	<div>
	<h1>Reports</h1>
	<h3>Most Active Flights</h3>
	<form method="post" action="./req/activeflights.jsp">
	<input type="submit" value="Get Most Active Flights">
	</form>
	
	<h3>Sales Report by Month</h3>
	<form method="post" action="./req/salesreport.jsp">
	<label for="month">Choose a Month:</label>
	<select id="month" name="month">
	  <option value="January">January</option>
	  <option value="February">February</option>
	  <option value="March">March</option>
	  <option value="April">April</option>
	  <option value="May">May</option>
	  <option value="June">June</option>
	  <option value="July">July</option>
	  <option value="August">August</option>
	  <option value="September">September</option>
	  <option value="October">October</option>
	  <option value="November">November</option>
	  <option value="December">December</option>
	</select>
	<input type="submit" value="Get Sales Report">
	</form>
	</div>
	
</body>
</html>