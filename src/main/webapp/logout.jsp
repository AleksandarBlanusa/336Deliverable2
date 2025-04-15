<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<%
	HttpSession currentSession = request.getSession(false); 
	if (currentSession != null) {
	    currentSession.invalidate();
	}
	
	out.println("You have been logged out! <a href='./login.jsp'>login here</a>");

%>