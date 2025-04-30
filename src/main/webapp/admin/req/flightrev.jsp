<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<a href='../index.jsp'>Go Back</a><br>
<p>Flight Revenue Ordered by Revenue</p>

<%
	String user = (String) session.getAttribute("username");
	
	if (user == null) {
		response.sendRedirect("../../login.jsp"); 
		return;
	}
	

	try{
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
        String query = "SELECT *, (total_seats - available_seats) AS tickets_sold, (total_seats*price) as revenue FROM flights join aircrafts on flights.aircraft_id = aircrafts.aircraft_id ORDER BY revenue DESC";
        
     	PreparedStatement pst = con.prepareStatement(query);
	    ResultSet rs = pst.executeQuery();

	    	out.println ("<table>");
			out.println("<tr>");
			out.println("<td>Flight Id</td>");	
			out.println("<td>Airline Id</td>");	
			out.println("<td>Takeoff Time</td>");
			out.println("<td>Landing Time</td>");
			out.println("<td>Duration (Minutes)</td>");
			out.println("<td>Route</td>");
			out.println("<td>Tickets Sold</td>");
			out.println("<td>Revenue</td>");
			out.println("</tr>");
	    	
			while(rs.next()){
				
				String flight_id = rs.getString("flight_id");
				String airline_id = rs.getString("airline_id");
				String ttime = rs.getString("takeoff_time");
				String ltime = rs.getString("landing_time");
				String duration = rs.getString("duration");
				String origin = rs.getString("origin_airport_code");
				String des = rs.getString("destination_airport_code");
				String tik_sold = rs.getString("tickets_sold");
				String rev = rs.getString("revenue");

	            out.println("<tr>");
	            out.println("<td>" + flight_id + "</td>");
	            out.println("<td>" + airline_id + "</td>");
	            out.println("<td>" + ttime + "</td>");
	            out.println("<td>" + ltime + "</td>");
	            out.println("<td>" + duration + "</td>");
	            out.println("<td>" + origin + "->" + des + "</td>");
	            out.println("<td>" + tik_sold + "</td>");
	            out.println("<td>" + rev + "</td>");
	            out.println("</tr>");
	            
	            
		}
			
		out.println("</table>");
		
	    rs.close();
	    pst.close();
	    con.close();
		
	} catch (Exception e){
		out.println("Unable to connect to DB. Please try again later.");
	    e.printStackTrace();
	}

%>