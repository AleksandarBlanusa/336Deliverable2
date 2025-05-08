<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.LocalDate,java.time.format.DateTimeFormatter" %>

<%
    // Get parameters from index.jsp form submission
    String departureAirportCode = request.getParameter("fromAirport");
    String arrivalAirportCode = request.getParameter("toAirport");
    String departureDateStr = request.getParameter("departureDate");
    String isRoundTrip = request.getParameter("tripType");
    String returnDateStr = request.getParameter("returnDate");
    String flexibleDates = request.getParameter("flexibleDates");
    
    // Get filter/sort parameters from potential subsequent requests
    String sortBy = request.getParameter("sortBy");
    String maxPrice = request.getParameter("maxPrice");
    String maxStops = request.getParameter("maxStops");
    String airlines = request.getParameter("airlines");
    
    Connection con = null;
    try {
        // Validate required parameters from original search
        if(departureAirportCode == null || departureAirportCode.isEmpty() || 
           arrivalAirportCode == null || arrivalAirportCode.isEmpty() ||
           departureDateStr == null || departureDateStr.isEmpty()) {
            throw new Exception("Please fill in all required fields");
        }
        
        ApplicationDB db = new ApplicationDB();    
        con = db.getConnection();
        
        // Prepare base query with joins for airport and airline info
        StringBuilder query = new StringBuilder(
            "SELECT f.*, a.airline, ap1.city as origin_city, ap2.city as destination_city " +
            "FROM flights f " +
            "JOIN airline a ON f.airline_id = a.airline_id " +
            "JOIN airports ap1 ON f.origin_airport_code = ap1.airport_code " +
            "JOIN airports ap2 ON f.destination_airport_code = ap2.airport_code " +
            "WHERE f.origin_airport_code = ? AND f.destination_airport_code = ? ");
        
        // Handle date filtering (flexible dates or exact date)
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate departureDate = LocalDate.parse(departureDateStr, formatter);
        
        if("on".equals(flexibleDates)) {
            query.append("AND DATE(f.takeoff_time) BETWEEN ? AND ? ");
        } else {
            query.append("AND DATE(f.takeoff_time) = ? ");
        }
        
        // Add filters if specified
        if(maxPrice != null && !maxPrice.isEmpty()) {
            query.append("AND f.price <= ? ");
        }
        if(maxStops != null && !maxStops.isEmpty()) {
            query.append("AND f.stops <= ? ");
        }
        if(airlines != null && !airlines.isEmpty()) {
            query.append("AND f.airline_id IN (");
            String[] airlineArray = airlines.split(",");
            for(int i = 0; i < airlineArray.length; i++) {
                query.append("?");
                if(i < airlineArray.length - 1) query.append(",");
            }
            query.append(") ");
        }
        
        // Add sorting
        if(sortBy != null && !sortBy.isEmpty()) {
            switch(sortBy) {
                case "price": query.append("ORDER BY f.price "); break;
                case "takeoff": query.append("ORDER BY f.takeoff_time "); break;
                case "landing": query.append("ORDER BY f.landing_time "); break;
                case "duration": query.append("ORDER BY f.duration "); break;
                default: query.append("ORDER BY f.takeoff_time ");
            }
        } else {
            query.append("ORDER BY f.takeoff_time ");
        }
        
        // Execute query with parameters
        PreparedStatement pst = con.prepareStatement(query.toString());
        int paramIndex = 1;
        pst.setString(paramIndex++, departureAirportCode.toUpperCase());
        pst.setString(paramIndex++, arrivalAirportCode.toUpperCase());
        
        if("on".equals(flexibleDates)) {
            pst.setString(paramIndex++, departureDate.minusDays(3).toString());
            pst.setString(paramIndex++, departureDate.plusDays(3).toString());
        } else {
            pst.setString(paramIndex++, departureDate.toString());
        }
        
        if(maxPrice != null && !maxPrice.isEmpty()) {
            pst.setBigDecimal(paramIndex++, new java.math.BigDecimal(maxPrice));
        }
        if(maxStops != null && !maxStops.isEmpty()) {
            pst.setInt(paramIndex++, Integer.parseInt(maxStops));
        }
        if(airlines != null && !airlines.isEmpty()) {
            String[] airlineArray = airlines.split(",");
            for(String airline : airlineArray) {
                pst.setString(paramIndex++, airline);
            }
        }
        
        ResultSet rs = pst.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Flight Search Results</title>
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #f2f2f2; position: sticky; top: 0; }
        .filter-panel { background: #f8f9fa; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .filter-group { margin-bottom: 10px; }
        label { display: inline-block; width: 120px; }
        .search-params { margin-bottom: 20px; font-size: 1.1em; }
   
    .action-buttons {
        margin: 20px 0;
        text-align: center;
    }
    .back-button {
        padding: 10px 20px;
        background-color: #6c757d;
        color: white;
        text-decoration: none;
        border-radius: 4px;
        display: inline-block;
    }
    .back-button:hover {
        background-color: #5a6268;
    }
</style>
</head>
<body>
    <h1>Flight Search Results</h1>
    
    <div class="search-params">
        <strong>Search Criteria:</strong><br>
        <%= departureAirportCode %> to <%= arrivalAirportCode %> | 
        Departure: <%= departureDateStr %>
        <% if("on".equals(isRoundTrip)) { %>
            | Return: <%= returnDateStr %>
        <% } %>
        <% if("on".equals(flexibleDates)) { %>
            (±3 days)
        <% } %>
    </div>
    
    <div class="filter-panel">
        <h3>Refine Results</h3>
        <form method="GET">
            <!-- Maintain original search parameters -->
            <input type="hidden" name="fromAirport" value="<%= departureAirportCode %>">
            <input type="hidden" name="toAirport" value="<%= arrivalAirportCode %>">
            <input type="hidden" name="departureDate" value="<%= departureDateStr %>">
            <input type="hidden" name="isRoundTrip" value="<%= isRoundTrip %>">
            <input type="hidden" name="flexibleDates" value="<%= flexibleDates %>">
            <% if("roundTrip".equals(isRoundTrip)) { %>
                <input type="hidden" name="returnDate" value="<%= returnDateStr %>">
                <input type="hidden" name="tripType" value="<%= isRoundTrip %>">          
           <% } %>
            
            <div class="filter-group">
                <label for="maxPrice">Max Price:</label>
                <input type="number" id="maxPrice" name="maxPrice" value="<%= maxPrice != null ? maxPrice : "" %>" placeholder="Any">
            </div>
            
            <div class="filter-group">
                <label for="maxStops">Max Stops:</label>
                <select id="maxStops" name="maxStops">
                    <option value="">Any</option>
                    <option value="0" <%= "0".equals(maxStops) ? "selected" : "" %>>Non-stop only</option>
                    <option value="1" <%= "1".equals(maxStops) ? "selected" : "" %>>1 stop max</option>
                    <option value="2" <%= "2".equals(maxStops) ? "selected" : "" %>>2 stops max</option>
                </select>
            </div>
            
            <div class="filter-group">
                <label for="airlines">Airlines:</label>
                <select id="airlines" name="airlines" multiple>
                	<option value="all" <%= (airlines == null || airlines.isEmpty()) ? "selected" : "" %>>All Airlines</option>
                    <option value="AA" <%= airlines != null && airlines.contains("AA") ? "selected" : "" %>>American Airlines</option>
                    <option value="DL" <%= airlines != null && airlines.contains("DL") ? "selected" : "" %>>Delta</option>
                    <option value="UA" <%= airlines != null && airlines.contains("UA") ? "selected" : "" %>>United</option>
                    <option value="WN" <%= airlines != null && airlines.contains("WN") ? "selected" : "" %>>Southwest</option>
                    <option value="EK" <%= airlines != null && airlines.contains("EK") ? "Selected" : "" %>>Emirates</option>
                </select>
            </div>
            
            <div class="filter-group">
                <label for="sortBy">Sort By:</label>
                <select id="sortBy" name="sortBy">
                    <option value="takeoff" <%= "takeoff".equals(sortBy) ? "selected" : "" %>>Takeoff Time</option>
                    <option value="landing" <%= "landing".equals(sortBy) ? "selected" : "" %>>Landing Time</option>
                    <option value="duration" <%= "duration".equals(sortBy) ? "selected" : "" %>>Duration</option>
                    <option value="price" <%= "price".equals(sortBy) ? "selected" : "" %>>Price (Low to High)</option>
                </select>
            </div>
            
            <button type="submit">Apply Filters</button>
        </form>
    </div>
    
    <% if(!rs.isBeforeFirst()) { %>
        <div class="no-results">No flights found matching your criteria.</div>
    <% } else { %>
        <table>
            <thead>
                <tr>
                    <th>Flight #</th>
                    <th>Airline</th>
                    <th>Departure</th>
                    <th>Arrival</th>
                    <th>Duration</th>
                    <th>Stops</th>
                    <th>Price</th>
                    <th>Seats</th>
                    <th>Reserve</th>
                </tr>
            </thead>
            <tbody>
                <% while(rs.next()) { %>
                    <tr>
                        <td><%= rs.getString("flight_id") %></td>
                        <td><%= rs.getString("airline") %></td>
                        <td>
                            <%= rs.getString("origin_city") %> (<%= rs.getString("origin_airport_code") %>)<br>
                            <%= rs.getTimestamp("takeoff_time").toLocalDateTime().format(DateTimeFormatter.ofPattern("MMM d, yyyy h:mm a")) %>
                        </td>
                        <td>
                            <%= rs.getString("destination_city") %> (<%= rs.getString("destination_airport_code") %>)<br>
                            <%= rs.getTimestamp("landing_time").toLocalDateTime().format(DateTimeFormatter.ofPattern("MMM d, yyyy h:mm a")) %>
                        </td>
                        <td><%= rs.getInt("duration")/60 %>h <%= rs.getInt("duration")%60 %>m</td>
                        <td><%= rs.getInt("stops") %></td>
                        <td>$<%= String.format("%.2f", rs.getBigDecimal("price")) %></td>
                        <td><%= rs.getInt("available_seats") %></td>
                        <td>
    <form method="post" action="makeReservation.jsp">
        <input type="hidden" name="flight_id" value="<%= rs.getInt("flight_id") %>">
        <select name="seat_class">
            <option value="economy">Economy</option>
            <option value="business">Business</option>
            <option value="first">First</option>
        </select>
        <button type="submit">Reserve</button>
    </form>
</td>
                    
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } %>
    
    <% if("roundtrip".equals(isRoundTrip)) { 
    // Query for return flights (reverse the airports)
    String returnQuery = "SELECT f.*, a.airline, ap1.city as origin_city, ap2.city as destination_city " +
                        "FROM flights f " +
                        "JOIN airline a ON f.airline_id = a.airline_id " +
                        "JOIN airports ap1 ON f.origin_airport_code = ap1.airport_code " +
                        "JOIN airports ap2 ON f.destination_airport_code = ap2.airport_code " +
                        "WHERE f.origin_airport_code = ? AND f.destination_airport_code = ? " +
                        "AND DATE(f.takeoff_time) >= ? ";
    
    if("on".equals(flexibleDates)) {
        returnQuery += "AND DATE(f.takeoff_time) BETWEEN ? AND ? ";
    } else {
        returnQuery += "AND DATE(f.takeoff_time) = ? ";
    }
    
 	// Add filters if specified
    if(maxPrice != null && !maxPrice.isEmpty()) {
        returnQuery += ("AND f.price <= ? ");
    }
    if(maxStops != null && !maxStops.isEmpty()) {
        returnQuery += ("AND f.stops <= ? ");
    }
    if(airlines != null && !airlines.isEmpty() && !"all".equals(airlines)) {
        returnQuery += ("AND f.airline_id = ? ");
    }
    
 	// Add sorting
    if(sortBy != null && !sortBy.isEmpty()) {
        switch(sortBy) {
            case "price": returnQuery += ("ORDER BY f.price "); break;
            case "takeoff": returnQuery += ("ORDER BY f.takeoff_time "); break;
            case "landing": returnQuery += ("ORDER BY f.landing_time "); break;
            case "duration": returnQuery += ("ORDER BY f.duration "); break;
            default: returnQuery += ("ORDER BY f.takeoff_time ");
        }
    } else {
        returnQuery += ("ORDER BY f.takeoff_time ");
    }
    
    PreparedStatement returnPst = con.prepareStatement(returnQuery.toString());
    int returnParamIndex = 1;
    
 // Reverse the airport codes for return flight
    returnPst.setString(returnParamIndex++, arrivalAirportCode.toUpperCase());
    returnPst.setString(returnParamIndex++, departureAirportCode.toUpperCase());
    
    // Parse return date
    LocalDate returnDate = LocalDate.parse(returnDateStr, formatter);
    
    if("on".equals(flexibleDates)) {
        returnPst.setString(returnParamIndex++, returnDate.minusDays(3).toString());
        returnPst.setString(returnParamIndex++, returnDate.plusDays(3).toString());
    } else {
        returnPst.setString(returnParamIndex++, returnDate.toString());
    }
    
    if(maxPrice != null && !maxPrice.isEmpty()) {
        returnPst.setBigDecimal(returnParamIndex++, new java.math.BigDecimal(maxPrice));
    }
    if(maxStops != null && !maxStops.isEmpty()) {
        returnPst.setInt(returnParamIndex++, Integer.parseInt(maxStops));
    }
    if(airlines != null && !airlines.isEmpty() && !"all".equals(airlines)) {
        returnPst.setString(returnParamIndex++, airlines);
    }
    
    ResultSet returnRs = returnPst.executeQuery();
%>

    <h2>Return Flights</h2>
    <table>
        <thead>
            <tr>
                <th>Flight #</th>
                <th>Airline</th>
                <th>Departure</th>
                <th>Arrival</th>
                <th>Duration</th>
                <th>Stops</th>
                <th>Price</th>
                <th>Seats</th>
            </tr>
        </thead>
        <tbody>
        <% if(!returnRs.isBeforeFirst()) { %>
                <tr><td colspan="8">No return flights found</td></tr>
            <% } else { %>
            <% while(returnRs.next()) { %>
                <tr>
                    <td><%= returnRs.getString("flight_id") %></td>
                    <td><%= returnRs.getString("airline") %></td>
                    <td>
                        <%= returnRs.getString("origin_city") %> (<%= returnRs.getString("origin_airport_code") %>)<br>
                        <%= returnRs.getTimestamp("takeoff_time").toLocalDateTime().format(DateTimeFormatter.ofPattern("MMM d, yyyy h:mm a")) %>
                    </td>
                    <td>
                        <%= returnRs.getString("destination_city") %> (<%= returnRs.getString("destination_airport_code") %>)<br>
                        <%= returnRs.getTimestamp("landing_time").toLocalDateTime().format(DateTimeFormatter.ofPattern("MMM d, yyyy h:mm a")) %>
                    </td>
                    <td><%= returnRs.getInt("duration")/60 %>h <%= returnRs.getInt("duration")%60 %>m</td>
                    <td><%= returnRs.getInt("stops") %></td>
                    <td>$<%= String.format("%.2f", returnRs.getBigDecimal("price")) %></td>
                    <td><%= returnRs.getInt("available_seats") %></td>
                </tr>
            <% } %>
          <% } %>
        </tbody>
    </table>
<% } %>
    
    <div class="action-buttons">
        <a href="index.jsp" class="back-button">Back to Search</a>
    </div>
    
</body>
</html>

<%
    } catch (Exception e) {
        out.println("<div class='error'>Error: " + e.getMessage() + "</div>");
    } finally {
        if(con != null) con.close();
    }
%>