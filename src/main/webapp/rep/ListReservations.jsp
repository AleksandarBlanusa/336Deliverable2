<%@ page import="java.sql.*, java.util.*, cs336.pkg.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    List<Map<String, Object>> reservations = new ArrayList<>();
    ApplicationDB db = new ApplicationDB();
    try (Connection conn = db.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(
            "SELECT r.reservation_id, u.firstname, u.lastname, r.flight_id, r.seat_class, r.status, r.reservation_date " +
            "FROM reservations r JOIN users u ON r.user_id = u.user_id " +
            "ORDER BY r.reservation_date DESC")) {

        while (rs.next()) {
            Map<String, Object> row = new HashMap<>();
            row.put("id", rs.getInt("reservation_id"));
            row.put("name", rs.getString("firstname") + " " + rs.getString("lastname"));
            row.put("flightId", rs.getInt("flight_id"));
            row.put("seat", rs.getString("seat_class"));
            row.put("status", rs.getString("status"));
            row.put("date", rs.getTimestamp("reservation_date"));
            reservations.add(row);
        }
    } catch (SQLException e) {
        out.println("<p style='color:red;'>Error loading reservations: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Reservations</title>
    <style>
        table { border-collapse: collapse; width: 80%; margin-top: 20px; }
        th, td { border: 1px solid black; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
        body { font-family: Arial, sans-serif; padding: 20px; }
        button { margin-top: 20px; padding: 10px 15px; font-size: 16px; }
    </style>
</head>
<body>
    <h1>Reservation List</h1>

    <table>
        <tr><th>ID</th><th>User</th><th>Flight</th><th>Seat</th><th>Status</th><th>Date</th></tr>
        <% for (Map<String, Object> r : reservations) { %>
            <tr>
                <td><%= r.get("id") %></td>
                <td><%= r.get("name") %></td>
                <td><%= r.get("flightId") %></td>
                <td><%= r.get("seat") %></td>
                <td><%= r.get("status") %></td>
                <td><%= r.get("date") %></td>
            </tr>
        <% } %>
    </table>

    <form action="index.jsp">
        <button type="submit">Back to Home</button>
    </form>
</body>
</html>
