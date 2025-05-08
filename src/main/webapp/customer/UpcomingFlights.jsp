<%@ page import="java.sql.*, java.time.*, java.time.format.DateTimeFormatter" %>
<%@ page session="true" %>
<jsp:useBean id="db" class="cs336.pkg.ApplicationDB" scope="page" />

<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    Connection con = db.getConnection();

    String query = "SELECT f.flight_id, f.takeoff_time, f.landing_time, f.origin_airport_code, f.destination_airport_code, f.duration, f.stops, f.price, a.airline " +
            "FROM flights f " +
            "JOIN airline a ON f.airline_id = a.airline_id " +
            "WHERE f.takeoff_time >= NOW() " +
            "ORDER BY f.takeoff_time ASC";


    PreparedStatement pst = con.prepareStatement(query);
    ResultSet rs = pst.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Upcoming Flights</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        th { background-color: #f4f4f4; }
    </style>
</head>
<body>
    <h1>All Upcoming Flights</h1>

    <table>
        <thead>
            <tr>
                <th>Flight #</th>
                <th>Airline</th>
                <th>Takeoff Time</th>
                <th>Landing Time</th>
                <th>From</th>
                <th>To</th>
                <th>Duration</th>
                <th>Stops</th>
                <th>Price ($)</th>
            </tr>
        </thead>
        <tbody>
            <%
                DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm");
                while (rs.next()) {
            %>
                <tr>
                    <td><%= rs.getString("flight_number") %></td>
                    <td><%= rs.getString("airline") %></td>
                    <td><%= rs.getTimestamp("takeoff_time").toLocalDateTime().format(dtf) %></td>
                    <td><%= rs.getTimestamp("landing_time").toLocalDateTime().format(dtf) %></td>
                    <td><%= rs.getString("origin_airport_code") %></td>
                    <td><%= rs.getString("destination_airport_code") %></td>
                    <td><%= rs.getInt("duration") / 60 %>h <%= rs.getInt("duration") % 60 %>m</td>
                    <td><%= rs.getInt("stops") %></td>
                    <td><%= rs.getBigDecimal("price") %></td>
                </tr>
            <% } %>
        </tbody>
    </table>

    <br>
    <form action="index.jsp" method="get">
        <button type="submit">Back to Home</button>
    </form>
</body>
</html>

<%
    rs.close();
    pst.close();
    con.close();
%>
