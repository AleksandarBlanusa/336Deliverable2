<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Reservations</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        form { margin-bottom: 20px; }
        input, select { padding: 10px; width: 200px; margin-bottom: 10px; }
        button { padding: 10px 20px; font-size: 16px; cursor: pointer; }
    </style>
</head>
<body>
    <h1>Customer Reservations</h1>

    <h2>Make Reservation</h2>
    <form action="CustomerRepServlet" method="post">
        <label for="flightId">Flight ID:</label><br>
        <input type="number" id="flightId" name="flightId" required><br>

        <label for="customerId">Customer ID:</label><br>
        <input type="number" id="customerId" name="customerId" required><br>

        <button type="submit" name="action" value="makeReservation">Make Reservation</button>
    </form>

    <h2>Edit Reservation</h2>
    <form action="CustomerRepServlet" method="post">
        <label for="oldCustomerId">Old Customer ID:</label><br>
        <input type="number" id="oldCustomerId" name="oldCustomerId" required><br>

        <label for="newCustomerId">New Customer ID:</label><br>
        <input type="number" id="newCustomerId" name="newCustomerId" required><br>

        <label for="newCustomerName">New Customer Name:</label><br>
        <input type="text" id="newCustomerName" name="newCustomerName" required><br>

        <button type="submit" name="action" value="editReservation">Edit Reservation</button>
    </form>

    <h2>Cancel Reservation</h2>
    <form action="CustomerRepServlet" method="post">
        <label for="cancelCustomerId">Customer ID:</label><br>
        <input type="number" id="cancelCustomerId" name="cancelCustomerId" required><br>

        <button type="submit" name="action" value="cancelReservation">Cancel Reservation</button>
    </form>

    <h2>Reply to User Questions</h2>
    <form action="CustomerRepServlet" method="post">
        <label for="userQuestion">Question:</label><br>
        <input type="text" id="userQuestion" name="userQuestion" required><br>

        <button type="submit" name="action" value="replyToUser">Reply</button>
    </form>

    <h2>View Waiting List</h2>
    <table border="1">
        <tr><th>Customer ID</th><th>Name</th></tr>
        <% 
            // Assuming the waiting list is available in the request scope
            List<Customer> waitingList = (List<Customer>) request.getAttribute("waitingList");
            if (waitingList != null) {
                for (Customer customer : waitingList) {
        %>
                    <tr>
                        <td><%= customer.getCustomerId() %></td>
                        <td><%= customer.getFirstName() + " " + customer.getLastName() %></td>
                    </tr>
        <%  
                }
            } 
        %>
    </table>
</body>
</html>
