<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<a href='../index.jsp'>Go Back</a><br>
<p>Customer Revenue Ordered by Revenue. Users with 0.00 revenue don't show up here. Top row is the user with the most revenue</p>

<form method="get" action="customerrev.jsp">
    <label for="customerid">Search by Customer ID:</label>
    <input type="text" name="customerid" id="customerid" placeholder="Enter Customer ID" />
    <input type="submit" value="submit" />
    
</form>
<form method="get" action="customerrev.jsp">
    <input type="submit" value="reset" />
</form>
<%
	String user = (String) session.getAttribute("username");
	
	if (user == null) {
		response.sendRedirect("../../login.jsp"); 
		return;
	}
	
	String customerid = request.getParameter("customerid");
	
	try{
		
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();	
		
        String query = "Select user_id, name, SUM(price) as rev, count(*) as num_res from (select * , CONCAT(firstname, ' ', lastname) as name from reservations r join users u using (user_id) join flights f using (flight_id) where status = 'reserved') as t group by user_id order by rev desc";
        
     	PreparedStatement pst = con.prepareStatement(query);
     	
     	if (customerid != null){
     		query = "Select user_id, name, SUM(price) as rev, count(*) as num_res from (select * , CONCAT(firstname, ' ', lastname) as name from reservations r join users u using (user_id) join flights f using (flight_id) where status = 'reserved') as t where user_id = ? group by user_id order by rev desc";
     		pst = con.prepareStatement(query);
     		pst.setString(1, customerid);
     	}
     	
     	
     	
	    ResultSet rs = pst.executeQuery();

	    	out.println ("<table>");
			out.println("<tr>");
			out.println("<td>User ID</td>");	
			out.println("<td>Name</td>");
			out.println("<td># of Reservations</td>");	
			out.println("<td>Revenue</td>");
			
			out.println("</tr>");
	    	
			while(rs.next()){
				
				String id = rs.getString("user_id");
				String name = rs.getString("name");
				String rev = rs.getString("rev");
				String num_res = rs.getString("num_res");

	            out.println("<tr>");
	            out.println("<td>" + id + "</td>");
	            out.println("<td>" + name + "</td>");
	            out.println("<td>" + num_res + "</td>");
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