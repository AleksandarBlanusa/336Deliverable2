<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="cs336.pkg.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Reservations</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        form { margin-bottom: 20px; }
        input, select { padding: 10px; width: 200px; margin-bottom: 10px; }
        button { padding: 10px 20px; font-size: 16px; cursor: pointer; }
    </style>
</head>
<body>
    <h1>User Reservations</h1>

    <h2>Make Reservation</h2>
    <form action="CustomerRepServlet" method="post">
        <label for="flightId">Flight ID:</label><br>
        <input type="number" id="flightId" name="flightId" required><br>

        <label for="userId">User ID:</label><br>
        <input type="number" id="userId" name="userId" required><br>

        <button type="submit" name="action" value="makeReservation">Make Reservation</button>
    </form>

    <h2>Edit Reservation</h2>
    <form action="CustomerRepServlet" method="post">
        <label for="oldUserId">Old User ID:</label><br>
        <input type="number" id="oldUserId" name="oldUserId" required><br>

        <label for="newUserId">New User ID:</label><br>
        <input type="number" id="newUserId" name="newUserId" required><br>

        <label for="newUserName">New User Name:</label><br>
        <input type="text" id="newUserName" name="newUserName" required><br>

        <button type="submit" name="action" value="editReservation">Edit Reservation</button>
    </form>

    <h2>Cancel Reservation</h2>
    <form action="CustomerRepServlet" method="post">
        <label for="cancelUserId">User ID:</label><br>
        <input type="number" id="cancelUserId" name="cancelUserId" required><br>

        <button type="submit" name="action" value="cancelReservation">Cancel Reservation</button>
    </form>

    <!-- Reply to User Questions -->
<h2>Reply to User Questions</h2>

<table border="1">
    <tr><th>Question ID</th><th>User ID</th><th>Flight ID</th><th>Question</th><th>Status</th></tr>
<%
    List<Map<String, Object>> pendingQuestions = (List<Map<String, Object>>) request.getAttribute("pendingQuestions");
    if (pendingQuestions != null) {
        for (Map<String, Object> question : pendingQuestions) {
%>
    <tr>
        <td><%= question.get("question_id") %></td>
        <td><%= question.get("user_id") %></td>
        <td><%= question.get("flight_id") %></td>
        <td><%= question.get("question_text") %></td>
        <td><%= ((int)question.get("answered") == 0 ? "Pending" : "Answered") %></td>
    </tr>
<%
        }
    }
%>
</table>

<!-- Form to reply -->
<form action="CustomerRepServlet" method="post">
    <label>Your Answer:</label><br>
    <textarea name="answerText" rows="4" required></textarea><br>

    <button type="submit" name="action" value="replyToUser">Submit Answer</button>
</form>

    <h2>View Waiting List</h2>
    <table border="1">
        <tr><th>User ID</th><th>Name</th></tr>
        <% 
            List<User> waitingList = (List<User>) request.getAttribute("waitingList");
            if (waitingList != null) {
                for (User user : waitingList) {
        %>
                    <tr>
                        <td><%= user.getUserId() %></td>
                        <td><%= user.getFullName() %></td>
                    </tr>
        <%  
                }
            } 
        %>
    </table>

    <form action="index.jsp" method="get">
        <button type="submit">Go Back to Home</button>
    </form>

</body>
</html>
