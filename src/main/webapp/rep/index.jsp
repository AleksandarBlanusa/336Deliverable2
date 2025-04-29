<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
  
<%
    String username = (String) session.getAttribute("username");
    String firstname = (String) session.getAttribute("firstname");
    String role = (String) session.getAttribute("role");
    if (username != null && firstname != null) {
        out.println("Welcome " + firstname + ", You are an " + role + "<br><br>");
        out.println("<a href='../logout.jsp'>Log out</a><br><br>");
    } else {
        response.sendRedirect("../login.jsp"); 
    }
%>

		<form action="./CustomerRep.jsp" method="get">
            <button type="submit">Go to Customer Rep Page</button>
        </form>
        
        <form action="./AircraftOps.jsp" method="get">
            <button type="submit">Go to Aircraft Operations Page</button>
        </form>
