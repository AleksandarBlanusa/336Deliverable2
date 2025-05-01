<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

    <%
        String username = (String) session.getAttribute("username");
    	String firstname = (String) session.getAttribute("firstname");
    	String role = (String) session.getAttribute("role");
        if (username != null && firstname != null) {
            out.println("Welcome " + firstname + ", You are an " + role);
            out.println("<a href='../logout.jsp'>Log out</a>");
        } else {
            response.sendRedirect("../login.jsp"); 
        }
    %>
    
    <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flight Search</title>
</head>
<body>
    <h2>Search for Flights</h2>
    <form action="searchFlights" method="POST">
        <!-- Departure Airport -->
        <label for="fromAirport">From Airport:</label>
        <input type="text" id="fromAirport" name="fromAirport" required><br>

        <!-- Arrival Airport -->
        <label for="toAirport">To Airport:</label>
        <input type="text" id="toAirport" name="toAirport" required><br>

        <!-- Departure Date -->
        <label for="departureDate">Departure Date:</label>
        <input type="date" id="departureDate" name="departureDate" required><br>

        <!-- Round-trip checkbox -->
        <label for="isRoundTrip">Round Trip?</label>
        <input type="checkbox" id="isRoundTrip" name="isRoundTrip"><br>

        <!-- Return Date (only shown if round-trip is selected) -->
        <label for="returnDate">Return Date:</label>
        <input type="date" id="returnDate" name="returnDate"><br>

        <button type="submit">Search Flights</button>
    </form>
</body>
</html>
    