<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>

	</head>
	
<h1>Login</h1>

<div>
<form method = "POST" action = "./loginreq.jsp">

	<label for="username">Username: </label>
	<input type="text" name="username" id="username" placeholder="Username">
	<br>
	
	<label for="password">Password: </label>
	<input type="text" name="password" id="password" placeholder="Password">
	<br>
	
	<input type="submit" value="submit">
	
</form>
<p>Don't have an account? <a href = "./create.jsp">Create Account</a></p>
</div>
</body>
</html>