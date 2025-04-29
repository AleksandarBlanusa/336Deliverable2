<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aircraft Operations</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        form { margin-bottom: 20px; }
        input, select { padding: 10px; width: 200px; margin-bottom: 10px; }
        button { padding: 10px 20px; font-size: 16px; cursor: pointer; }
    </style>
</head>
<body>
    <h1>Aircraft Operations</h1>

    <h2>Add Aircraft</h2>
    <form action="AircraftOpsServlet" method="post">
        <label for="aircraftName">Aircraft Name:</label><br>
        <input type="text" id="aircraftName" name="aircraftName" required><br>

        <label for="aircraftCapacity">Capacity:</label><br>
        <input type="number" id="aircraftCapacity" name="aircraftCapacity" required><br>

        <button type="submit" name="action" value="addAircraft">Add Aircraft</button>
    </form>

    <h2>Edit Aircraft</h2>
    <form action="AircraftOpsServlet" method="post">
        <label for="oldAircraftName">Old Aircraft Name:</label><br>
        <input type="text" id="oldAircraftName" name="oldAircraftName" required><br>

        <label for="newAircraftName">New Aircraft Name:</label><br>
        <input type="text" id="newAircraftName" name="newAircraftName" required><br>

        <label for="newAircraftCapacity">New Capacity:</label><br>
        <input type="number" id="newAircraftCapacity" name="newAircraftCapacity" required><br>

        <button type="submit" name="action" value="editAircraft">Edit Aircraft</button>
    </form>

    <h2>Delete Aircraft</h2>
    <form action="AircraftOpsServlet" method="post">
        <label for="deleteAircraftName">Aircraft Name:</label><br>
        <input type="text" id="deleteAircraftName" name="deleteAircraftName" required><br>

        <button type="submit" name="action" value="deleteAircraft">Delete Aircraft</button>
    </form>

    <h2>Manage Airports and Flights</h2>
    <!-- Similar forms for managing airports and flights can be added here -->
    
    <form action="index.jsp" method="get">
        <button type="submit">Go Back to Home</button>
    </form>
</body>
</html>
