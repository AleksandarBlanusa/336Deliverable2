<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page session="true" %>
<jsp:useBean id="db" class="cs336.pkg.ApplicationDB" scope="page" />

<%
String username = (String) session.getAttribute("username");
if (username == null) {
    response.sendRedirect("login.jsp");
    return;
}

int flightId = Integer.parseInt(request.getParameter("flight_id"));
String seatClass = request.getParameter("seat_class");

Connection con = db.getConnection();

// Get user ID
PreparedStatement ps = con.prepareStatement("SELECT user_id FROM users WHERE username = ?");
ps.setString(1, username);
ResultSet rs = ps.executeQuery();

int userId = -1;
if (rs.next()) userId = rs.getInt("user_id");

// Check available seats
PreparedStatement seatCheck = con.prepareStatement("SELECT available_seats FROM flights WHERE flight_id = ?");
seatCheck.setInt(1, flightId);
ResultSet seatRs = seatCheck.executeQuery();

if (seatRs.next()) {
    int availableSeats = seatRs.getInt("available_seats");

    if (availableSeats > 0) {
        // Reserve ticket
        PreparedStatement insert = con.prepareStatement(
            "INSERT INTO reservations (user_id, flight_id, seat_class, status) VALUES (?, ?, ?, 'reserved')"
        );
        insert.setInt(1, userId);
        insert.setInt(2, flightId);
        insert.setString(3, seatClass);
        insert.executeUpdate();

        // Decrease available seats
        PreparedStatement updateSeats = con.prepareStatement("UPDATE flights SET available_seats = available_seats - 1 WHERE flight_id = ?");
        updateSeats.setInt(1, flightId);
        updateSeats.executeUpdate();

        out.println("<h3 style='color:green;'>Ticket reserved successfully!</h3>");
    } else {
        // Add to waiting list
        PreparedStatement wait = con.prepareStatement("INSERT INTO waiting_list (user_id, flight_id) VALUES (?, ?)");
        wait.setInt(1, userId);
        wait.setInt(2, flightId);
        wait.executeUpdate();

        out.println("<h3 style='color:orange;'>Flight is full. You've been added to the waiting list.</h3>");
    }
} else {
    out.println("<p style='color:red;'>Flight not found.</p>");
}
%>

<!-- Go Back Button -->
<div style="margin-top: 20px;">
    <form action="index.jsp" method="get">
        <button type="submit">Go Back to Home</button>
    </form>
</div>
