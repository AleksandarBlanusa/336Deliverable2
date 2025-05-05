<%@ page import="java.sql.*, java.util.*, cs336.pkg.Airport, cs336.pkg.AircraftOps" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Airport List</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>

<h1>List of Airports</h1>

<%
    AircraftOps ops = new AircraftOps();
    List<Airport> airportList = new ArrayList<>();

    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/336project", "root", "M0stW4nted03")) {
        airportList = ops.getAllAirports(conn);
    } catch (SQLException e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>

<table>
    <tr>
        <th>Airport ID</th>
        <th>Code</th>
        <th>City</th>
        <th>State</th>
    </tr>
    <%
        for (Airport ap : airportList) {
    %>
    <tr>
        <td><%= ap.getAirportId() %></td>
        <td><%= ap.getAirportCode() %></td>
        <td><%= ap.getCity() %></td>
        <td><%= ap.getState() %></td>
    </tr>
    <%
        }
    %>
</table>

<form action="AircraftOps.jsp" method="get">
    <button type="submit">Back to Manage Airports</button>
</form>

</body>
</html>
