<%@ page import="java.sql.*, java.util.*, cs336.pkg.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    AircraftOps ops = new AircraftOps();
    List<Airport> airportList = new ArrayList<>();

    ApplicationDB db = new ApplicationDB();
    try (Connection conn = db.getConnection()) {
        airportList = ops.getAllAirports(conn);
    } catch (SQLException e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>List of Airports</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #f2f2f2; }
        form.inline { display: inline; }
        button { padding: 6px 12px; }
    </style>
</head>
<body>

<h1>List of Airports</h1>

<table>
    <tr>
        <th>ID</th>
        <th>Code</th>
        <th>City</th>
        <th>State</th>
        <th>Actions</th>
    </tr>
    <% for (Airport ap : airportList) { %>
    <tr>
        <td><%= ap.getAirportId() %></td>
        <td><%= ap.getAirportCode() %></td>
        <td><%= ap.getCity() %></td>
        <td><%= ap.getState() %></td>
        <td>
            <form method="post" action="AircraftOps.jsp" class="inline">
                <input type="hidden" name="action" value="deleteAirport">
                <input type="hidden" name="airportCode" value="<%= ap.getAirportCode() %>">
                <button type="submit" onclick="return confirm('Delete airport <%= ap.getAirportCode() %>?')">Delete</button>
            </form>
        </td>
    </tr>
    <% } %>
</table>

<form action="AircraftOps.jsp" method="get">
    <button type="submit">Back to Manage Airports</button>
</form>

</body>
</html>
