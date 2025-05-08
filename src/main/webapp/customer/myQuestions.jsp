<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<jsp:useBean id="db" class="cs336.pkg.ApplicationDB" scope="page" />

<%
String username = (String) session.getAttribute("username");
if (username == null) {
    response.sendRedirect("login.jsp");
    return;
}

String keyword = request.getParameter("keyword");
%>

<html>
<head>
    <title>My Questions & Answers</title>
    <style>
        .qa-block {
            border: 1px solid #ccc;
            padding: 10px;
            margin: 10px auto;
            max-width: 800px;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .qa-block strong {
            display: inline-block;
            width: 100px;
        }
    </style>
</head>
<body>

<h2>My Questions and Answers</h2>

<!-- Search Form -->
<form method="get" action="myQuestions.jsp" style="margin-bottom: 20px;">
    <label for="keyword">Search keyword:</label>
    <input type="text" name="keyword" id="keyword" value="<%= keyword != null ? keyword : "" %>" style="padding: 6px; width: 300px;">
    <button type="submit" style="padding: 6px 12px;">Search</button>
</form>

<%
Connection con = db.getConnection();
PreparedStatement ps = con.prepareStatement("SELECT user_id FROM users WHERE username = ?");
ps.setString(1, username);
ResultSet rs = ps.executeQuery();

int userId = -1;
if (rs.next()) userId = rs.getInt("user_id");

if (userId != -1) {
    String sql = "SELECT q.question_text, q.answer_text, f.flight_id " +
                 "FROM questions q JOIN flights f ON q.flight_id = f.flight_id " +
                 "WHERE q.user_id = ?";
    if (keyword != null && !keyword.trim().isEmpty()) {
        sql += " AND (q.question_text LIKE ? OR q.answer_text LIKE ?)";
    }

    PreparedStatement query = con.prepareStatement(sql);
    query.setInt(1, userId);
    if (keyword != null && !keyword.trim().isEmpty()) {
        query.setString(2, "%" + keyword + "%");
        query.setString(3, "%" + keyword + "%");
    }

    ResultSet results = query.executeQuery();

    boolean hasResults = false;
    while (results.next()) {
        hasResults = true;
        String q = results.getString("question_text");
        String a = results.getString("answer_text");
        int flight = results.getInt("flight_id");
%>
        <div class="qa-block">
            <div><strong>Flight ID:</strong> <%= flight %></div>
            <div><strong>Question:</strong> <%= q %></div>
            <div><strong>Answer:</strong> <%= a != null ? a : "<i>Not answered yet</i>" %></div>
        </div>
<%
    }
    if (!hasResults) {
        out.println("<p>No matching questions or answers found.</p>");
    }
}
%>

<!-- Go Back Button -->
<div style="text-align: center; margin-top: 30px;">
    <form action="index.jsp" method="get">
        <button type="submit" style="padding: 10px 20px; background-color: #0066cc; color: white; border: none; border-radius: 4px; font-size: 16px;">
            Go Back to Home
        </button>
    </form>
</div>

</body>
</html>
