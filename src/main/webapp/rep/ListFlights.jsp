
<%@ page import="java.sql.*, java.util.*, cs336.pkg.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    AircraftOps ops = new AircraftOps();
    List<Flight> flightList = new ArrayList<>();

    String sortBy = request.getParameter("sort");
    if (sortBy == null || !(sortBy.matches("flight_id|departure_time|landing_time|price"))) {
        sortBy = "flight_id";
    }

    String airportFilter = request.getParameter("airport");

    ApplicationDB db = new ApplicationDB();
    try (Connection conn = db.getConnection()) {
        String query = "SELECT f.*, a.airline AS airline_name, a.airline_id AS airline_code " +
                       "FROM flights f JOIN airline a ON f.airline_id = a.airline_id ";
        if (airportFilter != null && !airportFilter.trim().isEmpty()) {
            query += "WHERE f.origin_airport_code = ? OR f.destination_airport_code = ? ";
        }
        query += "ORDER BY " + sortBy;

        PreparedStatement pst = conn.prepareStatement(query);
        if (airportFilter != null && !airportFilter.trim().isEmpty()) {
            pst.setString(1, airportFilter.toUpperCase());
            pst.setString(2, airportFilter.toUpperCase());
        }
        ResultSet rs = pst.executeQuery();

        while (rs.next()) {
            Flight f = new Flight();
            f.setFlightId(rs.getInt("flight_id"));
            f.setStops(rs.getInt("stops"));
            f.setDepartureTime(rs.getTimestamp("takeoff_time").toLocalDateTime());
            f.setArrivalTime(rs.getTimestamp("landing_time").toLocalDateTime());
            f.setDuration(rs.getInt("duration"));
            f.setDepartureAirportCode(rs.getString("origin_airport_code"));
            f.setArrivalAirportCode(rs.getString("destination_airport_code"));
            f.setAvailableSeats(rs.getInt("available_seats"));
            f.setTotalSeats(rs.getInt("total_seats"));
            f.setBasePrice(rs.getBigDecimal("price"));

            Airline airline = new Airline();
            airline.setAirlineCode(rs.getString("airline_code"));
            airline.setAirlineName(rs.getString("airline_name"));
            f.setAirline(airline);

            flightList.add(f);
        }
    } catch (SQLException e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Flight List</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        th { background-color: #f2f2f2; }
        form.inline { display: inline; }
        button { padding: 6px 12px; font-size: 14px; cursor: pointer; }
    </style>
</head>
<body>

<h1>List of Flights</h1>

<!-- Filter Bar -->
<form method="get" action="ListFlights.jsp">
    <label for="airport">Filter by Airport (From/To):</label>
    <input type="text" name="airport" id="airport" placeholder="e.g. EWR" required>
    <button type="submit">Search</button>
</form>

<% if (airportFilter != null && !airportFilter.isEmpty()) { %>
    <p>Showing flights connected to airport: <strong><%= airportFilter.toUpperCase() %></strong></p>
<% } %>

<table>
    <tr>
        <th><a href="?sort=flight_id">Flight ID</a></th>
        <th>Airline</th>
        <th>Stops</th>
        <th><a href="?sort=takeoff_time">Departure</a></th>
        <th><a href="?sort=landing_time">Arrival</a></th>
        <th>Duration</th>
        <th>From</th>
        <th>To</th>
        <th>Available</th>
        <th>Total</th>
        <th><a href="?sort=price">Price</a></th>
        <th>Actions</th>
    </tr>
    <% for (Flight f : flightList) { %>
    <tr>
        <td><%= f.getFlightId() %></td>
        <td><%= f.getAirline().getAirlineCode() %> - <%= f.getAirline().getAirlineName() %></td>
        <td><%= f.getStops() %></td>
        <td><%= f.getDepartureTime() %></td>
        <td><%= f.getArrivalTime() %></td>
        <td><%= f.getDuration() %> min</td>
        <td><%= f.getDepartureAirportCode() %></td>
        <td><%= f.getArrivalAirportCode() %></td>
        <td><%= f.getAvailableSeats() %></td>
        <td><%= f.getTotalSeats() %></td>
        <td>$<%= f.getBasePrice() %></td>
        <td>
            <form method="post" action="AircraftOps.jsp" class="inline">
                <input type="hidden" name="action" value="deleteFlight">
                <input type="hidden" name="flightId" value="<%= f.getFlightId() %>">
                <button type="submit" onclick="return confirm('Delete flight <%= f.getFlightId() %>?')">Delete</button>
            </form>
        </td>
    </tr>
    <% } %>
</table>

<form action="AircraftOps.jsp" method="get">
    <button type="submit">Back to Manage Flights</button>
</form>

</body>
</html>
