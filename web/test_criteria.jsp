<%@page import="com.classes.DBConnector"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Test Selection Criteria</title>
</head>
<body>
    <h2>Selection Criteria Test</h2>
    
    <%
        Connection connection = null;
        try {
            connection = DBConnector.getCon();
            if (connection != null) {
                out.println("<p style='color: green;'>✓ Database connection successful!</p>");
                
                // Check if selection_criteria table exists and has data
                PreparedStatement stmt = connection.prepareStatement("SELECT COUNT(*) as count FROM selection_criteria");
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    int count = rs.getInt("count");
                    out.println("<p>Total selection criteria records: " + count + "</p>");
                }
                rs.close();
                stmt.close();
                
                // Show all selection criteria
                PreparedStatement allStmt = connection.prepareStatement(
                    "SELECT sc.*, v.title as job_title, c.companyName " +
                    "FROM selection_criteria sc " +
                    "JOIN vacancy v ON sc.vacancyID = v.vacancyID " +
                    "JOIN company c ON sc.companyID = c.companyID " +
                    "ORDER BY sc.vacancyID DESC LIMIT 10");
                ResultSet allRs = allStmt.executeQuery();
                
                out.println("<h3>Recent Selection Criteria:</h3>");
                out.println("<table border='1' style='border-collapse: collapse; width: 100%;'>");
                out.println("<tr><th>Vacancy ID</th><th>Job Title</th><th>Company</th><th>Type</th><th>Description</th><th>Priority</th><th>Weightage</th></tr>");
                
                while (allRs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + allRs.getInt("vacancyID") + "</td>");
                    out.println("<td>" + allRs.getString("job_title") + "</td>");
                    out.println("<td>" + allRs.getString("companyName") + "</td>");
                    out.println("<td>" + allRs.getString("criteria_type") + "</td>");
                    out.println("<td>" + allRs.getString("criteria_description") + "</td>");
                    out.println("<td>" + allRs.getString("priority") + "</td>");
                    out.println("<td>" + allRs.getInt("weightage") + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
                
                allRs.close();
                allStmt.close();
                
            } else {
                out.println("<p style='color: red;'>✗ Database connection failed!</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color: red;'>✗ Database error: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    out.println("<p style='color: red;'>Error closing connection: " + e.getMessage() + "</p>");
                }
            }
        }
    %>
    
    <p><a href="index.jsp">Back to Home</a></p>
</body>
</html>