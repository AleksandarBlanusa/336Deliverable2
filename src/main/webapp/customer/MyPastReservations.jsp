<%@ page import="java.sql.*, java.util.*, cs336.pkg.ApplicationDB" %>
<%@ page session="true" %>
<jsp:useBean id="db" class="cs336.pkg.ApplicationDB" scope="page" />

<%
String username = (String) session.getAttribute("username");
if (username == null) {
    response.sendRedirect("login.jsp");
    return;
}

Connection con = db.getConnection();

// Get user_id from session or query
PreparedStatement userStmt = con.prepareStatement("SELECT user_id FROM users WHERE username = ?");
userStmt.setString(1, username);
ResultSet userRs = userStmt.executeQuery();

int userId = -1;
if (userRs.next()) {
    userId = userRs.getInt("user_id");
} else {
    out.println("<p style='color:red;'>User not found.</p>");
    return;
}

// Query reservations
PreparedStatement resStmt = con.prepareStatement(
    "SELECT r.*, f.origin_airport_code, f.destination_airport_code, f.takeoff_time, f.landing_time " +
    "FROM reservations r JOIN flights f ON r.flight_id = f.flight_id " +
    "WHERE r.user_id = ? ORDER BY r.reservation_date DESC"
);
resStmt.setInt(1, userId);
ResultSet resRs = resStmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Past Reservations</title>
    <style>
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
        body { font-family: Arial, sans-serif; margin: 20px; }
        button { margin-top: 20px; padding: 10px 15px; font-size: 16px; }
    </style>
</head>
<body>
    <h2>My Past Reservations</h2>
    <%
    if (!resRs.isBeforeFirst()) {
    %>
        <p>You have no reservations yet.</p>
    <%
    } else {
    %>
        <table>
            <tr>
                <th>Reservation ID</th>
                <th>Flight</th>
                <th>From</th>
                <th>To</th>
                <th>Takeoff</th>
                <th>Landing</th>
                <th>Class</th>
                <th>Status</th>
                <th>Date Reserved</th>
                <th>Action</th>
            </tr>
            <%
            while (resRs.next()) {
            %>
            <tr>
                <td><%= resRs.getInt("reservation_id") %></td>
                <td><%= resRs.getInt("flight_id") %></td>
                <td><%= resRs.getString("origin_airport_code") %></td>
                <td><%= resRs.getString("destination_airport_code") %></td>
                <td><%= resRs.getTimestamp("takeoff_time") %></td>
                <td><%= resRs.getTimestamp("landing_time") %></td>
                <td><%= resRs.getString("seat_class") %></td>
                <td><%= resRs.getString("status") %></td>
                <td><%= resRs.getTimestamp("reservation_date") %></td>
                		 <td>
<%
    String seatClass = resRs.getString("seat_class");
    String status = resRs.getString("status");

    if ("reserved".equalsIgnoreCase(status) && 
        ("business".equalsIgnoreCase(seatClass) || "first".equalsIgnoreCase(seatClass))) {
%>
    <form method="post" action="CancelReservation.jsp">
        <input type="hidden" name="reservation_id" value="<%= resRs.getInt("reservation_id") %>">
        <input type="hidden" name="flight_id" value="<%= resRs.getInt("flight_id") %>">
        <button type="submit">Cancel</button>
    </form>
<% } else { %>
    <em>Cannot Cancel</em>
<% } %>
</td>
            </tr>
            <%
            }
            %>
        </table>
    <%
    }
    %>

    <form action="index.jsp">
        <button type="submit">Back to Home</button>
    </form>
</body>
</html>

<%
db.closeConnection(con);
%>
