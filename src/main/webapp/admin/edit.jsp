<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

    <%
        String user = (String) session.getAttribute("username");
    	String firstname = (String) session.getAttribute("firstname");
    	String role = (String) session.getAttribute("role");
    	
        if (user == null || firstname == null) {
        	response.sendRedirect("../login.jsp"); 
        	return;
        }
    %>
    
<html>
<head>
    <title>Edit User</title>
</head>
<body>
    <h2>Edit User</h2>
    <p><a href='./index.jsp'>Back</a></p>
    
    <%
        String userid = request.getParameter("userid");
        
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();
            
            // Fetch employee details based on ssn
            String query = "SELECT * FROM users WHERE user_id = ?";
            PreparedStatement pstmt = con.prepareStatement(query);
            pstmt.setString(1, userid);
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                // Retrieve employee details
                String first = rs.getString("firstname");
                String last = rs.getString("lastname");
                String username = rs.getString("username");
                String email = rs.getString("email");
                String password = rs.getString("password");
                
                // Display form to update employee information
                %>
                <form method = "POST" action = "./req/edit.jsp">
					
					<label for="userid">UserId: <%=userid %> </label>
					<input type="hidden" name="userid" id="userid" value=<%=userid%>>
					<br>
					
					
					<label for="firstname">First Name: </label>
					<input type="text" name="firstname" id="firstname" value=<%=first%>>
					<br>
					
					<label for="lastname">Last Name: </label>
					<input type="text" name="lastname" id="lastname" value=<%=last%>>
					<br>
					
					<label for="username">Username: </label>
					<input type="text" name="username" id="username" value=<%=username%>>
					<br>
					
					<label for="email">Email: </label>
					<input type="text" name="email" id="email" value=<%=email%>>
					<br>
					
					<label for="password">Password: </label>
					<input type="text" name="password" id="password" value=<%=password%>>
					<br>
					
					<input type="submit" value="submit">
					
				</form>
                <%
            }
            
            rs.close();
            pstmt.close();
            con.close();
            
        } catch (SQLException e) {
            out.println("Error fetching data from database. Please try again later.");
            e.printStackTrace();
        }
    %>
</body>
</html>