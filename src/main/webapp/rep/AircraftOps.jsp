<%@ page import="java.sql.*, java.math.BigDecimal, cs336.pkg.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    String action = request.getParameter("action");
    AircraftOps ops = new AircraftOps();
    ApplicationDB db = new ApplicationDB();
    Connection conn = null;

    try {
        conn = db.getConnection();

        if ("addAircraft".equals(action)) {
            String model = request.getParameter("model");
            int capacity = Integer.parseInt(request.getParameter("capacity"));
            ops.addAircraft(conn, new Aircraft(0, model, capacity));
            response.sendRedirect("ListAircrafts.jsp");
            return;

        } else if ("editAircraft".equals(action)) {
            int id = Integer.parseInt(request.getParameter("aircraftId"));
            String model = request.getParameter("newModel");
            int cap = Integer.parseInt(request.getParameter("newCapacity"));
            ops.addAircraft(conn, new Aircraft(0, model, cap));
            response.sendRedirect("ListAircrafts.jsp");
            return;

        } else if ("deleteAircraft".equals(action)) {
            int id = Integer.parseInt(request.getParameter("aircraftId"));
            ops.deleteAircraft(conn, id);
            response.sendRedirect("ListAircrafts.jsp");
            return;

        } else if ("addAirport".equals(action)) {
            String code = request.getParameter("airportCode");
            String city = request.getParameter("city");
            String state = request.getParameter("state");
            ops.addAirport(conn, new Airport(0, code, city, state));
            response.sendRedirect("ListAirports.jsp");
            return;

        } else if ("editAirport".equals(action)) {
            String oldCode = request.getParameter("oldAirportCode");
            String city = request.getParameter("newCity");
            String state = request.getParameter("newState");
            ops.editAirport(conn, oldCode, new Airport(0, oldCode, city, state));
            response.sendRedirect("ListAirports.jsp");
            return;

        } else if ("deleteAirport".equals(action)) {
            String code = request.getParameter("airportCode");
            ops.deleteAirport(conn, code);
            response.sendRedirect("ListAirports.jsp");
            return;

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
            response.sendRedirect("ListFlights.jsp");
            return;

        } else if ("deleteFlight".equals(action)) {
            int id = Integer.parseInt(request.getParameter("flightId"));
            ops.deleteFlight(conn, id);
            response.sendRedirect("ListFlights.jsp");
            return;
        }

    } catch (Exception e) {
        request.setAttribute("message", "Error: " + e.getMessage());
        e.printStackTrace();
    } finally {
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>

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

<h1>Manage Aircrafts, Airports, and Flights</h1>

<% if (request.getAttribute("message") != null) { %>
    <div style="color: red;"><%= request.getAttribute("message") %></div>
<% } %>

<% if (action == null) { %>

    <!-- View Lists -->
    <div style="margin-bottom: 20px;">
        <form action="ListAircrafts.jsp" method="get" style="display:inline;">
            <button type="submit">View All Aircrafts</button>
        </form>

        <form action="ListAirports.jsp" method="get" style="display:inline; margin-left:10px;">
            <button type="submit">View All Airports</button>
        </form>

        <form action="ListFlights.jsp" method="get" style="display:inline; margin-left:10px;">
            <button type="submit">View All Flights</button>
        </form>
    </div>

    <!-- Add Aircraft -->
    <h2>Add Aircraft</h2>
    <form method="post" action="AircraftOps.jsp">
        <input type="hidden" name="action" value="addAircraft">
        <label>Model:</label><br>
        <input type="text" name="model" required><br>
        <label>Capacity:</label><br>
        <input type="number" name="capacity" required><br>
        <button type="submit">Add Aircraft</button>
    </form>

    <!-- Edit Aircraft -->
    <h2>Edit Aircraft</h2>
    <form method="post" action="AircraftOps.jsp">
        <input type="hidden" name="action" value="editAircraft">
        <label>Aircraft ID:</label><br>
        <input type="number" name="aircraftId" required><br>
        <label>New Model:</label><br>
        <input type="text" name="newModel" required><br>
        <label>New Capacity:</label><br>
        <input type="number" name="newCapacity" required><br>
        <button type="submit">Edit Aircraft</button>
    </form>

    <!-- Delete Aircraft -->
    <h2>Delete Aircraft</h2>
    <form method="post" action="AircraftOps.jsp">
        <input type="hidden" name="action" value="deleteAircraft">
        <label>Aircraft ID:</label><br>
        <input type="number" name="aircraftId" required><br>
        <button type="submit">Delete Aircraft</button>
    </form>

    <!-- Add Airport -->
    <h2>Add Airport</h2>
    <form method="post" action="AircraftOps.jsp">
        <input type="hidden" name="action" value="addAirport">
        <label>Airport Code:</label><br>
        <input type="text" name="airportCode" maxlength="3" required><br>
        <label>City:</label><br>
        <input type="text" name="city" required><br>
        <label>State:</label><br>
        <input type="text" name="state" required><br>
        <button type="submit">Add Airport</button>
    </form>

    <!-- Edit Airport -->
    <h2>Edit Airport</h2>
    <form method="post" action="AircraftOps.jsp">
        <input type="hidden" name="action" value="editAirport">
        <label>Old Airport Code:</label><br>
        <input type="text" name="oldAirportCode" maxlength="3" required><br>
        <label>New City:</label><br>
        <input type="text" name="newCity" required><br>
        <label>New State:</label><br>
        <input type="text" name="newState" required><br>
        <button type="submit">Edit Airport</button>
    </form>

    <!-- Delete Airport -->
    <h2>Delete Airport</h2>
    <form method="post" action="AircraftOps.jsp">
        <input type="hidden" name="action" value="deleteAirport">
        <label>Airport Code:</label><br>
        <input type="text" name="airportCode" maxlength="3" required><br>
        <button type="submit">Delete Airport</button>
    </form>

    <!-- Add Flight -->
    <h2>Add Flight</h2>
    <form method="post" action="AircraftOps.jsp">
        <input type="hidden" name="action" value="addFlight">

        <label>Airline Code:</label><br>
        <select name="airlineCode" required>
            <option value="AA">American Airlines</option>
            <option value="DL">Delta</option>
            <option value="EK">Emirates</option>
            <option value="UA">United</option>
            <option value="WN">Southwest</option>
        </select><br>

        <label>Stops:</label><br>
        <input type="number" name="stops" required><br>

        <label>Departure Time:</label><br>
        <input type="datetime-local" name="departureTime" required><br>

        <label>Arrival Time:</label><br>
        <input type="datetime-local" name="arrivalTime" required><br>

        <label>Duration (mins):</label><br>
        <input type="number" name="duration" required><br>

        <label>Origin Airport Code:</label><br>
        <select name="originCode" required>
            <option value="BOS">Boston</option>
            <option value="EWR">Newark</option>
            <option value="ORD">Chicago</option>
            <option value="RDU">Raleigh</option>
        </select><br>

        <label>Destination Airport Code:</label><br>
        <select name="destCode" required>
            <option value="BOS">Boston</option>
            <option value="EWR">Newark</option>
            <option value="ORD">Chicago</option>
            <option value="RDU">Raleigh</option>
        </select><br>

        <label>Available Seats:</label><br>
        <input type="number" name="availableSeats" required><br>

        <label>Total Seats:</label><br>
        <input type="number" name="totalSeats" required><br>

        <label>Price ($):</label><br>
        <input type="number" name="price" step="0.01" required><br>

        <button type="submit">Add Flight</button>
    </form>

<% } %>

<!-- Go back -->
<form action="index.jsp" method="get">
    <button type="submit">Go Back to Home</button>
</form>

</body>
</html>
