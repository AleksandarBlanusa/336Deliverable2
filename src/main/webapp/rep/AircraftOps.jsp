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

<!-- Aircraft: Add -->
<h2>Add Aircraft</h2>
<form action="rep/AircraftOpsServlet" method="post">
    <input type="hidden" name="action" value="addAircraft">
    <label>Aircraft Name:</label><br>
    <input type="text" name="model" required><br>
    <label>Capacity:</label><br>
    <input type="number" name="capacity" required><br>
    <button type="submit">Add Aircraft</button>
</form>

<!-- Aircraft: Edit -->
<h2>Edit Aircraft</h2>
<form action="rep/AircraftOpsServlet" method="post">
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
<form action="rep/AircraftOpsServlet" method="post">
    <input type="hidden" name="action" value="deleteAircraft">
    <label>Aircraft ID:</label><br>
    <input type="number" name="aircraftId" required><br>
    <button type="submit">Delete Aircraft</button>
</form>

<!-- Airport: Add -->
<h2>Add Airport</h2>
<form action="rep/AircraftOpsServlet" method="post">
    <input type="hidden" name="action" value="addAirport">
    <label>Airport Code:</label><br>
    <input type="text" name="airportCode" maxlength="3" required><br>
    <label>City:</label><br>
    <input type="text" name="city" required><br>
    <button type="submit">Add Airport</button>
</form>

<!-- Airport: Edit -->
<h2>Edit Airport</h2>
<form action="rep/AircraftOpsServlet" method="post">
    <input type="hidden" name="action" value="editAirport">
    <label>Old Airport Code:</label><br>
    <input type="text" name="oldAirportCode" maxlength="3" required><br>
    <label>New City Name:</label><br>
    <input type="text" name="newCity" required><br>
    <button type="submit">Edit Airport</button>
</form>

<!-- Airport: Delete -->
<h2>Delete Airport</h2>
<form action="rep/AircraftOpsServlet" method="post">
    <input type="hidden" name="action" value="deleteAirport">
    <label>Airport Code:</label><br>
    <input type="text" name="airportCode" maxlength="3" required><br>
    <button type="submit">Delete Airport</button>
</form>

<!-- Flight: Add -->
<h2>Add Flight</h2>
<form action="rep/AircraftOpsServlet" method="post">
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

<!-- Flight: Edit and Delete can follow similar pattern -->

<!-- Back Button -->
<h2>Manage Airports and Flights</h2>
<form action="index.jsp" method="get">
    <button type="submit">Go Back to Home</button>
</form>

</body>
</html>
