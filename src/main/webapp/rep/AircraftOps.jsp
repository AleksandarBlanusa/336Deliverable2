<%@ page import="java.sql.*, java.math.BigDecimal, cs336.pkg.AircraftOps, cs336.pkg.Aircraft, cs336.pkg.Airport, cs336.pkg.Flight" %>
<%
    String action = request.getParameter("action");
    AircraftOps ops = new AircraftOps();
    Connection conn = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/336project", "root", "M0stW4nted03");

        if ("addAircraft".equals(action)) {
            String model = request.getParameter("model");
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            ops.addAircraft(conn, new Aircraft(0, model, capacity, 0));
            request.setAttribute("message", "Aircraft added successfully.");

        } else if ("editAircraft".equals(action)) {
            int id = Integer.parseInt(request.getParameter("aircraftId"));
            String model = request.getParameter("newModel");
            int cap = Integer.parseInt(request.getParameter("newCapacity"));
            ops.editAircraft(conn, id, new Aircraft(id, model, cap, 0));
            request.setAttribute("message", "Aircraft edited successfully.");

        } else if ("deleteAircraft".equals(action)) {
            int id = Integer.parseInt(request.getParameter("aircraftId"));
            ops.deleteAircraft(conn, id);
            request.setAttribute("message", "Aircraft deleted successfully.");

        } else if ("addAirport".equals(action)) {
            String code = request.getParameter("airportCode");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            ops.addAirport(conn, new Airport(0, code, city, state));
            request.setAttribute("message", "Airport added successfully.");

        } else if ("editAirport".equals(action)) {
            String oldCode = request.getParameter("oldAirportCode");
            String name = request.getParameter("newAirportName");
            String city = request.getParameter("newCity");
            String state = request.getParameter("newState");
            ops.editAirport(conn, oldCode, new Airport(0, oldCode, city, state));
            request.setAttribute("message", "Airport edited successfully.");

        } else if ("deleteAirport".equals(action)) {
            String code = request.getParameter("airportCode");
            ops.deleteAirport(conn, code);
            request.setAttribute("message", "Airport deleted successfully.");

        } else if ("addFlight".equals(action)) {
            String airline = request.getParameter("airlineCode");
            int stops = Integer.parseInt(request.getParameter("stops"));
            Timestamp dep = Timestamp.valueOf(request.getParameter("departureTime").replace("T", " ") + ":00");
            Timestamp arr = Timestamp.valueOf(request.getParameter("arrivalTime").replace("T", " ") + ":00");
            int duration = Integer.parseInt(request.getParameter("duration"));
            String origin = request.getParameter("originCode");
            String dest = request.getParameter("destCode");
            int avail = Integer.parseInt(request.getParameter("availableSeats"));
            int total = Integer.parseInt(request.getParameter("totalSeats"));
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            Flight f = new Flight();
            f.setAirlineCode(airline);
            f.setStops(stops);
            f.setDepartureTime(dep.toLocalDateTime());
            f.setArrivalTime(arr.toLocalDateTime());
            f.setDuration(duration);
            f.setDepartureAirportCode(origin);
            f.setArrivalAirportCode(dest);
            f.setAvailableSeats(avail);
            f.setTotalSeats(total);
            f.setBasePrice(price);
            ops.addFlight(conn, f);
            request.setAttribute("message", "Flight added successfully.");
        }

    } catch (Exception e) {
        request.setAttribute("message", "Error: " + e.getMessage());
    } finally {
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Aircraft Operations</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        h2 { margin-top: 30px; }
        form { margin-bottom: 20px; }
        input, select { padding: 8px; width: 300px; margin-bottom: 10px; }
        button { padding: 10px 20px; font-size: 16px; cursor: pointer; }
    </style>
</head>
<body>

<h1>Aircraft Operations</h1>

<% if (request.getAttribute("message") != null) { %>
    <p style="color: green;"><%= request.getAttribute("message") %></p>
<% } %>

<!-- Aircraft: Add -->
<h2>Add Aircraft</h2>
<form action="AircraftOps.jsp" method="post">
    <input type="hidden" name="action" value="addAircraft">
    <label>Aircraft Name:</label><br>
    <input type="text" name="model" required><br>
    <label>Capacity:</label><br>
    <input type="number" name="capacity" required><br>
    <button type="submit">Add Aircraft</button>
</form>

<!-- Aircraft: Edit -->
<h2>Edit Aircraft</h2>
<form action="AircraftOps.jsp" method="post">
    <input type="hidden" name="action" value="editAircraft">
    <label>Aircraft ID:</label><br>
    <input type="number" name="aircraftId" required><br>
    <label>New Model:</label><br>
    <input type="text" name="newModel" required><br>
    <label>New Capacity:</label><br>
    <input type="number" name="newCapacity" required><br>
    <button type="submit">Edit Aircraft</button>
</form>

<!-- Aircraft: Delete -->
<h2>Delete Aircraft</h2>
<form action="AircraftOps.jsp" method="post">
    <input type="hidden" name="action" value="deleteAircraft">
    <label>Aircraft ID:</label><br>
    <input type="number" name="aircraftId" required><br>
    <button type="submit">Delete Aircraft</button>
</form>

<!-- Airport: Add -->
<h2>Add Airport</h2>
<form action="AircraftOps.jsp" method="post">
    <input type="hidden" name="action" value="addAirport"> 
    <label>Airport Code:</label><br>
    <input type="text" name="airportCode" maxlength="3" required><br>
    <label>City:</label><br>
    <input type="text" name="city" required><br>
    <label>State:</label><br>
    <input type="text" name="state" required><br>
    <button type="submit">Add Airport</button>
</form>


<!-- Airport: Edit -->
<h2>Edit Airport</h2>
<form action="AircraftOps.jsp" method="post">
    <input type="hidden" name="action" value="editAirport">
    <label>Airport Code (unchanged):</label><br>
    <input type="text" name="oldAirportCode" maxlength="3" required><br>
    <label>New City:</label><br>
    <input type="text" name="newCity" required><br>
    <label>New State:</label><br>
    <input type="text" name="newState" required><br>    
    <button type="submit">Edit Airport</button>
</form>


<!-- Airport: Delete -->
<h2>Delete Airport</h2>
<form action="AircraftOps.jsp" method="post">
    <input type="hidden" name="action" value="deleteAirport">
    <label>Airport Code:</label><br>
    <input type="text" name="airportCode" maxlength="3" required><br>
    <button type="submit">Delete Airport</button>
</form>

<!-- Flight: Add -->
<h2>Add Flight</h2>
<form action="AircraftOps.jsp" method="post">
    <input type="hidden" name="action" value="addFlight">
    <label>Airline Code:</label><br>
    <input type="text" name="airlineCode" required><br>
    <label>Stops:</label><br>
    <input type="number" name="stops" required><br>
    <label>Departure Time (YYYY-MM-DDTHH:MM):</label><br>
    <input type="datetime-local" name="departureTime" required><br>
    <label>Arrival Time (YYYY-MM-DDTHH:MM):</label><br>
    <input type="datetime-local" name="arrivalTime" required><br>
    <label>Duration (mins):</label><br>
    <input type="number" name="duration" required><br>
    <label>Origin Airport Code:</label><br>
    <input type="text" name="originCode" required><br>
    <label>Destination Airport Code:</label><br>
    <input type="text" name="destCode" required><br>
    <label>Available Seats:</label><br>
    <input type="number" name="availableSeats" required><br>
    <label>Total Seats:</label><br>
    <input type="number" name="totalSeats" required><br>
    <label>Price ($):</label><br>
    <input type="number" name="price" step="0.01" required><br>
    <button type="submit">Add Flight</button>
</form>

<!-- Back Button -->
<h2>Manage Airports and Flights</h2>
<form action="index.jsp" method="get">
    <button type="submit">Go Back to Home</button>
</form>

</body>
</html>
