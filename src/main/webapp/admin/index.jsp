<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

    <%
        String username = (String) session.getAttribute("username");
    	String role = (String) session.getAttribute("role");
        if (username != null) {
            out.println("Welcome " + username + ", You are an " + role);
            out.println("<a href='../logout.jsp'>Log out</a>");
        } else {
            response.sendRedirect("../login.jsp"); 
        }
    %>