<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Flight Search</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .search-container { 
            max-width: 600px; 
            margin: 20px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .form-group { margin-bottom: 15px; }
        label { display: inline-block; width: 150px; font-weight: bold; }
        input[type="text"], input[type="date"], select {
            padding: 8px;
            width: 200px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        button {
            padding: 10px 20px;
            background-color: #0066cc;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover { background-color: #0052a3; }
        .flex-options { margin: 15px 0; }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Flight Search</h1>
        <a href="../logout.jsp" style="color: #0066cc;">Logout</a>
    </div>

    <div class="search-container">
        <form action="SearchFlights.jsp" method="GET">
            <!-- Route Information -->
            <div class="form-group">
                <label for="fromAirport">Departure Airport:</label>
                <input type="text" id="fromAirport" name="fromAirport" 
                       placeholder="3-letter code (e.g. ORD)" required>
            </div>
            
            <div class="form-group">
                <label for="toAirport">Arrival Airport:</label>
                <input type="text" id="toAirport" name="toAirport" 
                       placeholder="3-letter code (e.g. EWR)" required>
            </div>

            <!-- Date Selection -->
            <div class="form-group">
                <label for="departureDate">Departure Date:</label>
                <input type="date" id="departureDate" name="departureDate" required>
            </div>

            <!-- Trip Type -->
            <div class="form-group">
                <label>Trip Type:</label>
                <div style="display: inline-block;">
                    <input type="radio" id="oneWay" name="tripType" value="oneway" checked 
                           onclick="document.getElementById('returnDateGroup').style.display='none'">
                    <label for="oneWay" style="width: auto;">One Way</label>
                    
                    <input type="radio" id="roundTrip" name="tripType" value="roundtrip"
                           onclick="document.getElementById('returnDateGroup').style.display='block'">
                    <label for="roundTrip" style="width: auto;">Round Trip</label>
                </div>
            </div>

            <!-- Return Date (hidden by default) -->
            <div class="form-group" id="returnDateGroup" style="display: none;">
                <label for="returnDate">Return Date:</label>
                <input type="date" id="returnDate" name="returnDate">
            </div>

            <!-- Flexible Dates -->
            <div class="flex-options">
                <input type="checkbox" id="flexibleDates" name="flexibleDates">
                <label for="flexibleDates" style="width: auto; font-weight: normal;">
                    Show flights ±3 days from selected date
                </label>
            </div>

            <button type="submit">Search Flights</button>
        </form>
    </div>

    <script>
        // Set default departure date to today
        document.getElementById('departureDate').valueAsDate = new Date();
        
        // Set minimum date to today for both date fields CHANGE THIS TO TEST OUT STUFF
  //    const today = new Date().toISOString().split('T')[0];
   //   document.getElementById('departureDate').min = today;
   //   document.getElementById('returnDate').min = today;
        
        // Auto-set return date to 7 days after departure
        document.getElementById('departureDate').addEventListener('change', function() {
            const departureDate = new Date(this.value);
            const returnDate = new Date(departureDate);
            returnDate.setDate(returnDate.getDate() + 7);
            document.getElementById('returnDate').valueAsDate = returnDate;
        });
    </script>
    <%
    String role = (String) session.getAttribute("role");
%>

<% if ("customer".equals(role)) { %>
    <div style="text-align: center; margin-top: 40px;">
        <form action="askQuestion.jsp" method="get" style="display: inline;">
            <button type="submit">Ask a Question</button>
        </form>

        <form action="myQuestions.jsp" method="get" style="display: inline;">
            <button type="submit">View My Questions & Answers</button>
        </form>
        
        <form action="MyPastReservations.jsp" method="get" style="display: inline;">
            <button type="submit">View Past Reservations</button>
        </form>
        <form action="UpcomingFlights.jsp" method="get" style="display: inline;">
   			<button type="submit">View Upcoming Flights</button>
		</form>
		
        
    </div>
<% } %>
    
</body>
</html>