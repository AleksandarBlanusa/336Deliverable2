<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<a href='../index.jsp'>Go Back</a>

<%
	String user = (String) session.getAttribute("username");
	
	if (user == null) {
		response.sendRedirect("../../login.jsp"); 
		return;
	}
	
	String first = request.getParameter("firstname");
	String last = request.getParameter("lastname");

	try{
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
        String query = "select * from reservations join users on reservations.user_id = users.user_id where firstname = ? and lastname = ?";
        
     	PreparedStatement pst = con.prepareStatement(query);
	    pst.setString(1, first);
	    pst.setString(2, last);
		
	    ResultSet rs = pst.executeQuery();
	    boolean hasResults = false;

	    	out.println ("<table>");
			out.println("<tr>");
			out.println("<td>Reservation_id</td>");	
			out.println("<td>User_id</td>");	
			out.println("<td>Name</td>");
			out.println("<td>Flight_id</td>");
			out.println("<td>Seat Class</td>");
			out.println("<td>Status</td>");
			out.println("<td>Reservation Date</td>");
			out.println("</tr>");
	    	
			while(rs.next()){
				hasResults = true;
				
				String res_id = rs.getString("reservation_id");
				String userid = rs.getString("user_id");
				String firstname = rs.getString("users.firstname");
				String lastname = rs.getString("users.lastname");
				String flight_id = rs.getString("flight_id");
				String seat = rs.getString("seat_class");
				String status = rs.getString("status");
				String date = rs.getString("reservation_date");
				
	
	            out.println("<tr>");
	            out.println("<td>" + res_id + "</td>");
	            out.println("<td>" + userid + "</td>");
	            out.println("<td>" + first + " " + last +"</td>");
	            out.println("<td>" + flight_id + "</td>");
	            out.println("<td>" + seat + "</td>");
	            out.println("<td>" + status + "</td>");
	            out.println("<td>" + date + "</td>");
	            out.println("</tr>");
	            
	            
		}
			
		out.println("</table>");
		
		if (!hasResults) {
		    out.println("No reservations found for a customer with this name: " + first + " " + last);
		}
		
	    rs.close();
	    pst.close();
	    con.close();
		
	} catch (Exception e){
		out.println("Unable to connect to DB. Please try again later.");
	    e.printStackTrace();
	}

%>
