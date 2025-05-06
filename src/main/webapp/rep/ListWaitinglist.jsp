<%@ page import="java.sql.*, java.util.*, cs336.pkg.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    List<Map<String, Object>> waitlist = new ArrayList<>();
    ApplicationDB db = new ApplicationDB();
    try (Connection conn = db.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(
            "SELECT w.user_id, w.flight_id, u.firstname, u.lastname, w.added_date " +
            "FROM waiting_list w JOIN users u ON w.user_id = u.user_id " +
            "ORDER BY w.added_date ASC")) {

        while (rs.next()) {
            Map<String, Object> row = new HashMap<>();
            row.put("userId", rs.getInt("user_id"));
            row.put("flightId", rs.getInt("flight_id"));
            row.put("firstname", rs.getString("firstname"));
            row.put("lastname", rs.getString("lastname"));
            row.put("date", rs.getTimestamp("added_date"));
            waitlist.add(row);
        }
    } catch (SQLException e) {
        out.println("<p style='color:red;'>Error loading waiting list: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Waiting List</title>
    <style>
        table { border-collapse: collapse; width: 80%; margin-top: 20px; }
        th, td { border: 1px solid black; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
        body { font-family: Arial, sans-serif; padding: 20px; }
        button { margin-top: 20px; padding: 10px 15px; font-size: 16px; }
    </style>
</head>
<body>
    <h1>Waiting List</h1>

    <table>
        <tr><th>User ID</th><th>Full Name</th><th>Flight ID</th><th>Added Date</th></tr>
        <% for (Map<String, Object> r : waitlist) { %>
            <tr>
                <td><%= r.get("userId") %></td>
                <td><%= r.get("firstname") %> <%= r.get("lastname") %></td>
                <td><%= r.get("flightId") %></td>
                <td><%= r.get("date") %></td>
            </tr>
        <% } %>
    </table>

    <form action="CustomerRep.jsp" method="get">
        <button type="submit">Back to Home</button>
    </form>
</body>
</html>
