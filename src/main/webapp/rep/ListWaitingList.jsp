<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    List<Map<String, Object>> waitlist = new ArrayList<>();
    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/336project", "root", "M0stW4nted03");
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

<html>
<head><title>Waiting List</title></head>
<body>
<h1>Waiting List</h1>
<table border="1">
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

<form action="index.jsp" method="get">
    <button type="submit">Back to Home</button>
</form>
</body>
</html>
