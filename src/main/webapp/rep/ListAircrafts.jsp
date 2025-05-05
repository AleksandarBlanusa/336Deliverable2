<%@ page import="java.sql.*, java.util.*, cs336.pkg.AircraftOps, cs336.pkg.Aircraft" %>
<%
    AircraftOps ops = new AircraftOps();
    List<Aircraft> aircraftList = new ArrayList<>();

    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/336project", "root", "M0stW4nted03")) {
        aircraftList = ops.getAllAircrafts(conn);
    } catch (SQLException e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>List of Aircrafts</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        table { border-collapse: collapse; width: 80%; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>

<h1>List of Aircrafts</h1>

<table>
    <tr>
        <th>ID</th>
        <th>Model</th>
        <th>Capacity</th>
    </tr>
    <% for (Aircraft ac : aircraftList) { %>
    <tr>
        <td><%= ac.getAircraftId() %></td>
        <td><%= ac.getModel() %></td>
        <td><%= ac.getCapacity() %></td>
    </tr>
    <% } %>
</table>

<br>
<form action="AircraftOps.jsp" method="get">
    <button type="submit">Back to Manage Aircrafts</button>
</form>

</body>
</html>
