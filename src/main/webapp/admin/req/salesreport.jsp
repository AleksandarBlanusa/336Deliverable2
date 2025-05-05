<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
	String user = (String) session.getAttribute("username");
	
	if (user == null) {
		response.sendRedirect("../../login.jsp"); 
		return;
	}
	
	String month = request.getParameter("month");
%>

<a href='../index.jsp'>Go Back</a><br>

<h3>Sales Report for 
	<% 
	out.println(month);
	%>
</h3>

<%
	int month_int = 0;

	switch (month) {
	case "January":
		month_int = 1;
		break;
	case "February":
		month_int = 2;
		break;
	case "March":
		month_int = 3;
		break;
	case "April":
		month_int = 4;
		break;
	case "May":
		month_int = 5;
		break;
	case "June":
		month_int = 6;
		break;
	case "July":
		month_int = 7;
		break;
	case "August":
		month_int = 8;
		break;
	case "September":
		month_int = 9;
		break;
	case "October":
		month_int = 10;
		break;
	case "November":
		month_int = 11;
		break;
	case "December":
		month_int = 12;
		break;
	}
	
	try{
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
		String query = "SELECT (SELECT COUNT(*) FROM Flights WHERE MONTH(takeoff_time) = ?) AS total_flights, (SELECT COUNT(*) FROM Reservations r JOIN Flights f2 ON r.flight_id = f2.flight_id WHERE MONTH(f2.takeoff_time) = ?) AS total_reservations, SUM(f.total_seats - f.available_seats) AS total_tickets_sold, SUM((f.total_seats - f.available_seats) * f.price) AS total_revenue FROM Flights f WHERE MONTH(f.takeoff_time) = ?";
	    PreparedStatement pst = con.prepareStatement(query);
    	pst.setInt(1, month_int);
    	pst.setInt(2, month_int);
    	pst.setInt(3, month_int);
	
	    ResultSet rs = pst.executeQuery();

    	out.println ("<table>");
		out.println("<tr>");
		out.println("<td>Total Flights</td>");
		out.println("<td>Total Reservations</td>");
		out.println("<td>Total Tickets Sold</td>");
		out.println("<td>Total Revenue</td>");
		out.println("</tr>");
	    	
			while(rs.next()){
				
				String flights = rs.getString("total_flights");
				String res = rs.getString("total_reservations");
				String tik_sold = rs.getString("total_tickets_sold");
				String rev = rs.getString("total_revenue");

	            out.println("<tr>");
	            out.println("<td>" + flights + "</td>");
	            out.println("<td>" + res + "</td>");
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
