<%@ page import="java.sql.*, java.util.*, cs336.pkg.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    AircraftOps ops = new AircraftOps();
    List<Aircraft> aircraftList = new ArrayList<>();

    ApplicationDB db = new ApplicationDB();
    try (Connection conn = db.getConnection()) {
        aircraftList = ops.getAllAircrafts(conn);
    } catch (SQLException e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>List of Aircrafts</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        table { border-collapse: collapse; width: 80%; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        form.inline { display: inline; }
        button { padding: 6px 12px; }
    </style>
</head>
<body>

<h1>List of Aircrafts</h1>

<table>
    <tr>
        <th>ID</th>
        <th>Model</th>
        <th>Capacity</th>
        <th>Actions</th>
    </tr>
    <% for (Aircraft ac : aircraftList) { %>
    <tr>
        <td><%= ac.getAircraftId() %></td>
        <td><%= ac.getModel() %></td>
        <td><%= ac.getCapacity() %></td>
        <td>
            <form method="post" action="AircraftOps.jsp" class="inline">
                <input type="hidden" name="action" value="deleteAircraft">
                <input type="hidden" name="aircraftId" value="<%= ac.getAircraftId() %>">
                <button type="submit" onclick="return confirm('Delete aircraft <%= ac.getAircraftId() %>?')">Delete</button>
            </form>
        </td>
    </tr>
    <% } %>
</table>

<form action="AircraftOps.jsp" method="get">
    <button type="submit">Back to Manage Aircrafts</button>
</form>

</body>
</html>
