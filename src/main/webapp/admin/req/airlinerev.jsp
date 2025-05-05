<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<a href='../index.jsp'>Go Back</a><br>
<p>Airline Revenue Ordered by Revenue</p>

<form method="get" action="airlinerev.jsp">
    <label for="airline">Search by Airline ID:</label>
    <input type="text" name="airline" id="airline" placeholder="Enter Airline ID" />
    <input type="submit" value="submit" />
    
</form>
<form method="get" action="airlinerev.jsp">
    <input type="submit" value="reset" />
</form>

<%
	String user = (String) session.getAttribute("username");
	
	if (user == null) {
		response.sendRedirect("../../login.jsp"); 
		return;
	}
	
	String searchairline = request.getParameter("airline");
	try{
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
        String query = "Select temp.airline, temp.airline_id, Sum(revenue) as rev, sum(tickets_sold) as total_tickets_sold, count(*) as num_flights from (SELECT f.airline_id, a.airline, (total_seats - available_seats) AS tickets_sold, ((total_seats - available_seats)*price) as revenue FROM flights f join airline a on f.airline_id = a.airline_id ORDER BY revenue DESC) as temp group by temp.airline_id order by rev desc";
     	PreparedStatement pst = con.prepareStatement(query);
     	
     	if (searchairline != null){
     		query = "Select temp.airline, temp.airline_id, Sum(revenue) as rev, sum(tickets_sold) as total_tickets_sold, count(*) as num_flights from (SELECT f.airline_id, a.airline, (total_seats - available_seats) AS tickets_sold, ((total_seats - available_seats)*price) as revenue FROM flights f join airline a on f.airline_id = a.airline_id ORDER BY revenue DESC) as temp where airline_id = ? group by temp.airline_id";
     		pst = con.prepareStatement(query);
     		pst.setString(1, searchairline);
     	}
     	
     	
     	
	    ResultSet rs = pst.executeQuery();

	    	out.println ("<table>");
			out.println("<tr>");
			out.println("<td>Airline</td>");	
			out.println("<td>Airline_Id</td>");	
			out.println("<td>Total_Tickets_Sold</td>");
			out.println("<td>Number_of_Flights</td>");	
			out.println("<td>Revenue</td>");
			out.println("</tr>");
	    	
			while(rs.next()){
				
				String airline = rs.getString("airline");
				String airline_id = rs.getString("airline_id");
				String ttik = rs.getString("total_tickets_sold");
				String num_f = rs.getString("num_flights");
				String rev = rs.getString("rev");

	            out.println("<tr>");
	            out.println("<td>" + airline + "</td>");
	            out.println("<td>" + airline_id + "</td>");
	            out.println("<td>" + ttik + "</td>");
	            out.println("<td>" + num_f + "</td>");
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