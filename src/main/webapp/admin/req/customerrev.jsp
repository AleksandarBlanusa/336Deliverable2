<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<a href='../index.jsp'>Go Back</a><br>
<p>Airline Revenue Ordered by Revenue</p>

<%
	String user = (String) session.getAttribute("username");
	
	if (user == null) {
		response.sendRedirect("../../login.jsp"); 
		return;
	}
	

	try{
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
        String query = "Select temp.airline, temp.airline_id, Sum(revenue) as rev from (SELECT f.airline_id, a.airline, (total_seats - available_seats) AS tickets_sold, (total_seats*price) as revenue FROM flights f join airline a on f.airline_id = a.airline_id ORDER BY revenue DESC) as temp group by temp.airline_id order by rev desc";
        
     	PreparedStatement pst = con.prepareStatement(query);
	    ResultSet rs = pst.executeQuery();

	    	out.println ("<table>");
			out.println("<tr>");
			out.println("<td>Airline</td>");	
			out.println("<td>Airline Id</td>");	
			out.println("<td>Revenue</td>");
			out.println("</tr>");
	    	
			while(rs.next()){
				
				String airline = rs.getString("airline");
				String airline_id = rs.getString("airline_id");
				String rev = rs.getString("rev");

	            out.println("<tr>");
	            out.println("<td>" + airline + "</td>");
	            out.println("<td>" + airline_id + "</td>");
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