<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<jsp:useBean id="db" class="cs336.pkg.ApplicationDB" scope="page" />

<%
String username = (String) session.getAttribute("username");
if (username == null) {
    response.sendRedirect("login.jsp");
    return;
}

int reservationId = Integer.parseInt(request.getParameter("reservation_id"));
int flightId = Integer.parseInt(request.getParameter("flight_id"));

Connection con = db.getConnection();

// Step 1: Cancel the reservation
PreparedStatement cancel = con.prepareStatement("UPDATE reservations SET status = 'cancelled' WHERE reservation_id = ?");
cancel.setInt(1, reservationId);
int updated = cancel.executeUpdate();

boolean promoted = false;

if (updated > 0) {
    // Step 2: Increase available seats
    PreparedStatement updateSeats = con.prepareStatement("UPDATE flights SET available_seats = available_seats + 1 WHERE flight_id = ?");
    updateSeats.setInt(1, flightId);
    updateSeats.executeUpdate();

    // Step 3: Notify waiting list
    PreparedStatement waitlistQuery = con.prepareStatement(
        "SELECT u.firstname, u.lastname, u.email FROM waiting_list w JOIN users u ON w.user_id = u.user_id WHERE w.flight_id = ?"
    );
    waitlistQuery.setInt(1, flightId);
    ResultSet rs = waitlistQuery.executeQuery();

    out.println("<h3 style='color:green;'>Reservation cancelled successfully.</h3>");
    out.println("<h4>Waiting list notifications sent to:</h4>");
    out.println("<ul>");
    while (rs.next()) {
        String fname = rs.getString("firstname");
        String lname = rs.getString("lastname");
        String email = rs.getString("email");  // use this if you want to email later
        out.println("<li>" + fname + " " + lname + " (" + email + ") - Seat available now!</li>");
    }
    out.println("</ul>");
} else {
    out.println("<p style='color:red;'>Could not cancel the reservation.</p>");
}
%>

<form action="MyPastReservations.jsp">
    <button type="submit">Back to My Reservations</button>
</form>
