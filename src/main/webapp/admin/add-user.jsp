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

<html>
	
	<h1>Add user</h1>
	<p><a href='./index.jsp'>Back</a></p>

	<div>
		<form method = "POST" action = "./req/add.jsp">
		
			<label for="firstname">First Name: </label>
			<input type="text" name="firstname" id="firstname" placeholder="First Name" required>
			<br>
			
			<label for="lastname">Last Name: </label>
			<input type="text" name="lastname" id="lastname" placeholder="Last Name" required>
			<br>
			
			<label for="username">Username: </label>
			<input type="text" name="username" id="username" placeholder="Username" required>
			<br>
			
			<label for="email">Email: </label>
			<input type="text" name="email" id="email" placeholder="Email" required>
			<br>
			
			<label for="password">Password: </label>
			<input type="text" name="password" id="password" placeholder="Password" required>
			<br>
			
			<input type="radio" name="user" id="customer_rep" value="customer_rep" required>
			<label for="employee">Customer Rep</label>
			
			<input type="radio" name="user" id="customer" value="customer">
			<label for="customer">Customer</label>
			<br>
			
			<input type="submit" value="submit">
			
		</form>
	</div>
</html>