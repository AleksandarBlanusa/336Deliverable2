<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<jsp:useBean id="db" class="cs336.pkg.ApplicationDB" scope="page" />

<%
String username = (String) session.getAttribute("username");
if (username == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>

<html>
<head><title>Ask a Question</title></head>
<body>
    <h2>Ask a Question About a Flight</h2>
    <form method="post">
        Flight ID: <input type="number" name="flight_id" required /><br/><br/>
        Question: <br/>
        <textarea name="question" rows="5" cols="60" required></textarea><br/><br/>
        <input type="submit" value="Submit Question" />
    </form>

<%
if ("POST".equalsIgnoreCase(request.getMethod())) {
    int flightId = Integer.parseInt(request.getParameter("flight_id"));
    String questionText = request.getParameter("question");

    Connection con = db.getConnection();
    PreparedStatement ps = con.prepareStatement("SELECT user_id FROM users WHERE username = ?");
    ps.setString(1, username);
    ResultSet rs = ps.executeQuery();
    int userId = -1;
    if (rs.next()) userId = rs.getInt("user_id");

    if (userId != -1) {
        PreparedStatement insert = con.prepareStatement(
            "INSERT INTO questions (user_id, flight_id, question_text) VALUES (?, ?, ?)"
        );
        insert.setInt(1, userId);
        insert.setInt(2, flightId);
        insert.setString(3, questionText);
        insert.executeUpdate();
        out.println("<p style='color:green;'>Question submitted successfully.</p>");
    } else {
        out.println("<p style='color:red;'>User not found.</p>");
    }
}
%>
</body>
<div style="text-align: center; margin-top: 30px;">
    <form action="index.jsp" method="get">
        <button type="submit">Go Back to Home</button>
    </form>
</div>

</html>
