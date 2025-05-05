<%@ page import="java.sql.*, java.util.*, cs336.pkg.AircraftOps, cs336.pkg.Flight, cs336.pkg.Airport" %>
<%
    AircraftOps ops = new AircraftOps();
    List<Airport> airports = new ArrayList<>();
    List<Flight> departing = new ArrayList<>();
    List<Flight> arriving = new ArrayList<>();
    String filter = request.getParameter("airportCode");

    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/336project", "root", "M0stW4nted03")) {
        airports = ops.getAllAirports(conn);
        if (filter != null && !filter.isEmpty()) {
            departing = ops.getDepartingFlights(conn, filter);
            arriving = ops.getArrivingFlights(conn, filter);
        } else {
            // If no filter, show all flights
            departing = ops.getAllFlights(conn);
        }
    } catch (SQLException e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>List of Flights</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: left; }
        th { background-color: #f0f0f0; }
        button { padding: 5px 10px; }
        select, form { margin-bottom: 20px; }
    </style>
</head>
<body>

<h1>List of Flights</h1>

<!-- Filter Form -->
<form method="get" action="ListFlights.jsp">
    <label>Filter by Airport Code:</label>
    <select name="airportCode">
        <option value="">-- All Airports --</option>
        <% for (Airport ap : airports) { %>
            <option value="<%= ap.getAirportCode() %>" <%= (ap.getAirportCode().equals(filter)) ? "selected" : "" %>>
                <%= ap.getAirportCode() %> - <%= ap.getCity() %>, <%= ap.getState() %>
            </option>
        <% } %>
    </select>
    <button type="submit">Filter</button>
</form>

<% if (filter != null && !filter.isEmpty()) { %>
    <h2>Flights Departing from <%= filter %></h2>
<% } %>

<table>
    <tr>
        <th>ID</th><th>Airline</th><th>Origin</th><th>Destination</th><th>Departure</th>
        <th>Arrival</th><th>Stops</th><th>Duration</th><th>Available</th><th>Total</th><th>Price</th><th>Delete</th>
    </tr>
    <% for (Flight flight : departing) { %>
        <tr>
            <td><%= flight.getFlightId() %></td>
            <td><%= flight.getAirlineCode() %></td>
            <td><%= flight.getDepartureAirportCode() %></td>
            <td><%= flight.getArrivalAirportCode() %></td>
            <td><%= flight.getDepartureTime() %></td>
            <td><%= flight.getArrivalTime() %></td>
            <td><%= flight.getStops() %></td>
            <td><%= flight.getDuration() %></td>
            <td><%= flight.getAvailableSeats() %></td>
            <td><%= flight.getTotalSeats() %></td>
            <td>$<%= flight.getBasePrice() %></td>
            <td>
                <form action="AircraftOps.jsp" method="post" onsubmit="return confirm('Delete flight <%= flight.getFlightId() %>?');">
                    <input type="hidden" name="action" value="deleteFlight">
                    <input type="hidden" name="flightId" value="<%= flight.getFlightId() %>">
                    <button type="submit">Delete</button>
                </form>
            </td>
        </tr>
    <% } %>
</table>

<% if (filter != null && !filter.isEmpty()) { %>
    <h2>Flights Arriving at <%= filter %></h2>
    <table>
        <tr>
            <th>ID</th><th>Airline</th><th>Origin</th><th>Destination</th><th>Departure</th>
            <th>Arrival</th><th>Stops</th><th>Duration</th>
        </tr>
        <% for (Flight flight : arriving) { %>
            <tr>
                <td><%= flight.getFlightId() %></td>
                <td><%= flight.getAirlineCode() %></td>
                <td><%= flight.getDepartureAirportCode() %></td>
                <td><%= flight.getArrivalAirportCode() %></td>
                <td><%= flight.getDepartureTime() %></td>
                <td><%= flight.getArrivalTime() %></td>
                <td><%= flight.getStops() %></td>
                <td><%= flight.getDuration() %></td>
            </tr>
        <% } %>
    </table>
<% } %>

<form action="AircraftOps.jsp" method="get">
    <button type="submit">Back to Manage Aircrafts</button>
</form>

</body>
</html>
