<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
	String departureAirportCode = request.getParameter("fromAirport");
	String arrivalAirportCode = request.getParameter("toAirport");
	datetime departureDate = request.getParameter("departureDate");
	checkbox roundTrip = request.getParameter("isRoundTrip");
	datetime returnDate = request.getParameter("returnDate");
	
	try
	{
		if(departureAirport.isEmpty() || arrivalAirport.isEmpty() || departureDate.isEmpty() 
				|| (roundTrip.isChecked() && returnDate.isEmpty()) 
				|| (!roundTrip.isChecked() && !returnDate.isEmpty())) throw new SQLSyntaxErrorException();
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		//Find departure airport
		String query = "select * from flights where origin_airport_code = ?";
		
		PreparedStatement pst = con.prepareStatement(query);
		pst.setString(1,departureAirportCode);
		
		ResultSet rs = pst.executeQuery();
		
		if(rs.next())
		{
			out.println("Airport does not exist.");
		}
		
		//Find arrival Airport
		query = "select * from flights where destination_airport_code = ?";
		
		pst = con.prepareStatement(query);
	    pst.setString(1, arrivalAirportCode);
	    
	    rs = pst.executeQuery();
	    
	    if(rs.next())
	    {
	    	out.println("Airport does not exist.");
	    }
	    
	    //Find flight if not round trip
	    if(!roundTrip.isChecked())
	    {
	    	query = "SELECT flight_id FROM flights ORDER BY origin_airport_code";
	    	pst = con.prepareStatement(query);
	    	rs = pst.executeQuery();
	    	
	    	while(rs.next())
	    	{
	    		if(rs.getString("origin_airport_code") == departureAirportCode
	    				&& rs.getString("destination_airport_code") == departureAirportCode
	    				&& rs.getString("takeoff_time") == departureDate)
	    		{
	    			out.println("<td>" + rs.getString("flight_id") + "</td>");
	    		}
	    	}
	    }
	    
	    //Find flight if round trip
	    //if(roundTrip.isChecked())
	    
		
	}catch (Exception e) {
		    out.println("Unable to connect to DB. Please try again later.");
		    e.printStackTrace();
		}
	
	
	
%>