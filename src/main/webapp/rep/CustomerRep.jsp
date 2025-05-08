<%@ page import="java.sql.*, java.util.*, cs336.pkg.CustomerRep, cs336.pkg.User" %>

<%
	
	

    String action = request.getParameter("action");
    CustomerRep rep = new CustomerRep();  // Use your CustomerRep class
    List<Map<String, Object>> pendingQuestions = rep.getPendingQuestions();
	request.setAttribute("pendingQuestions", pendingQuestions);

    if (action != null) {
    	if ("makeReservation".equals(action)) {
    	    int flightId = Integer.parseInt(request.getParameter("flightId"));
    	    int userId = Integer.parseInt(request.getParameter("userId"));
    	    boolean success = rep.makeReservation(flightId, userId, "economy");
    	    request.setAttribute("message", success ? "Reservation made successfully!" : "Flight full. Added to waiting list.");
    	    if (success) {
    	        response.sendRedirect("ListReservations.jsp");
    	        return;
    	    }
    	    
    	} else if ("editReservation".equals(action)) {
    	    int flightId = Integer.parseInt(request.getParameter("flightId"));
    	    int oldUserId = Integer.parseInt(request.getParameter("oldUserId"));
    	    int newUserId = Integer.parseInt(request.getParameter("newUserId"));
    	    rep.editReservation(flightId, oldUserId, newUserId);
    	    request.setAttribute("message", "Reservation updated successfully.");
    	    response.sendRedirect("ListReservations.jsp");
    	    return;
    	    
    	} else if ("cancelReservation".equals(action)) {
    	    int flightId = Integer.parseInt(request.getParameter("flightId"));
    	    int userId = Integer.parseInt(request.getParameter("cancelUserId"));
    	    rep.cancelReservation(flightId, userId);
    	    request.setAttribute("message", "Reservation canceled and seat released.");
    	    response.sendRedirect("ListReservations.jsp");
    	    return;
    	    
    	} else if ("replyToUser".equals(action)) {
            int questionId = Integer.parseInt(request.getParameter("questionId"));
            String answerText = request.getParameter("answerText");
            rep.replyToUser(questionId, answerText);
            response.sendRedirect("CustomerRep.jsp");
            return;
        }
    }
%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Reservations</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        form { margin-bottom: 20px; }
        input, textarea, select { padding: 10px; width: 300px; margin-bottom: 10px; }
        button { padding: 10px 20px; font-size: 16px; cursor: pointer; }
    </style>
</head>
<body>


	<h2>Navigation</h2>
	<form action="./ListReservations.jsp" method="get" style="display:inline;">
    	<button type="submit">View All Reservations</button>
	</form>

	<form action="ListWaitinglist.jsp" method="get" style="display:inline;">
    	<button type="submit">View Waiting List</button>
	</form>


    <h1>User Reservations</h1>

    <!-- Display message if exists -->
    <% if (request.getAttribute("message") != null) { %>
        <p style="color: green;"><%= request.getAttribute("message") %></p>
    <% } %>

    <h2>Make Reservation</h2>
    <form action="CustomerRep.jsp" method="post">
        <label>Flight ID:</label><br>
        <input type="number" name="flightId" required><br>

        <label>User ID:</label><br>
        <input type="number" name="userId" required><br>

        <button type="submit" name="action" value="makeReservation">Make Reservation</button>
    </form>

    <h2>Edit Reservation</h2>
    <form action="CustomerRep.jsp" method="post">
        <label>Flight ID:</label><br>
        <input type="number" name="flightId" required><br>

        <label>Old User ID:</label><br>
        <input type="number" name="oldUserId" required><br>

        <label>New User ID:</label><br>
        <input type="number" name="newUserId" required><br>

        <button type="submit" name="action" value="editReservation">Edit Reservation</button>
    </form>

    <h2>Cancel Reservation</h2>
    <form action="CustomerRep.jsp" method="post">
        <label>Flight ID:</label><br>
        <input type="number" name="flightId" required><br>

        <label>User ID:</label><br>
        <input type="number" name="cancelUserId" required><br>

        <button type="submit" name="action" value="cancelReservation">Cancel Reservation</button>
    </form>

    <h2>Reply to User Questions</h2>

    <table border="1">
    <tr>
        <th>QID</th>
        <th>User</th>
        <th>Email</th>
        <th>Flight</th>
        <th>Question</th>
        <th>Status</th>
    </tr>
    <%
        if (pendingQuestions != null && !pendingQuestions.isEmpty()) {
            for (Map<String, Object> q : pendingQuestions) {
    %>
        <tr>
            <td><%= q.get("question_id") %></td>
            <td><%= q.get("firstname") %> <%= q.get("lastname") %></td>
            <td><%= q.get("email") %></td>
            <td><%= q.get("flight_id") %></td>
            <td><%= q.get("question_text") %></td>
            <td><%= ((int) q.get("answered") == 0 ? "Pending" : "Answered") %></td>
        </tr>
    <%
            }
        } else {
    %>
        <tr><td colspan="6" style="text-align:center;">No pending questions found.</td></tr>
    <%
        }
    %>
</table>


    <!-- Form to reply -->
    <form action="CustomerRep.jsp" method="post">
        <label>Question ID:</label><br>
        <input type="number" name="questionId" required><br>

        <label>Your Answer:</label><br>
        <textarea name="answerText" rows="4" required></textarea><br>

        <button type="submit" name="action" value="replyToUser">Submit Answer</button>
    </form>

    <form action="index.jsp" method="get">
        <button type="submit">Go Back to Home</button>
    </form>

</body>
</html>
