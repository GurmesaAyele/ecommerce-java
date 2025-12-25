<%@page import="com.classes.DBConnector"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Insert Test Criteria</title>
</head>
<body>
    <h2>Inserting Test Selection Criteria</h2>
    
    <%
        Connection connection = null;
        try {
            connection = DBConnector.getCon();
            if (connection != null) {
                // Insert test criteria for vacancy ID 1 (assuming it exists)
                PreparedStatement stmt = connection.prepareStatement(
                    "INSERT INTO selection_criteria (vacancyID, companyID, criteria_type, criteria_description, priority, weightage) VALUES (?, ?, ?, ?, ?, ?)");
                
                // Test criteria 1
                stmt.setInt(1, 1); // vacancyID
                stmt.setInt(2, 1); // companyID
                stmt.setString(3, "Education");
                stmt.setString(4, "Bachelor's degree in Computer Science or related field");
                stmt.setString(5, "High");
                stmt.setInt(6, 30);
                stmt.addBatch();
                
                // Test criteria 2
                stmt.setInt(1, 1);
                stmt.setInt(2, 1);
                stmt.setString(3, "Experience");
                stmt.setString(4, "Minimum 3 years of Java development experience");
                stmt.setString(5, "High");
                stmt.setInt(6, 25);
                stmt.addBatch();
                
                // Test criteria 3
                stmt.setInt(1, 1);
                stmt.setInt(2, 1);
                stmt.setString(3, "Skills");
                stmt.setString(4, "Proficiency in Spring Boot and MySQL");
                stmt.setString(5, "Medium");
                stmt.setInt(6, 20);
                stmt.addBatch();
                
                int[] results = stmt.executeBatch();
                out.println("<p style='color: green;'>✓ Inserted " + results.length + " test criteria successfully!</p>");
                
                stmt.close();
                
                // Verify insertion
                PreparedStatement verifyStmt = connection.prepareStatement(
                    "SELECT * FROM selection_criteria WHERE vacancyID = 1");
                ResultSet rs = verifyStmt.executeQuery();
                
                out.println("<h3>Inserted Criteria:</h3>");
                out.println("<table border='1' style='border-collapse: collapse;'>");
                out.println("<tr><th>Type</th><th>Description</th><th>Priority</th><th>Weightage</th></tr>");
                
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("criteria_type") + "</td>");
                    out.println("<td>" + rs.getString("criteria_description") + "</td>");
                    out.println("<td>" + rs.getString("priority") + "</td>");
                    out.println("<td>" + rs.getInt("weightage") + "</td>");
                    out.println("</tr>");
                }
                out.println("</table>");
                
                rs.close();
                verifyStmt.close();
                
            } else {
                out.println("<p style='color: red;'>✗ Database connection failed!</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color: red;'>✗ Error: " + e.getMessage() + "</p>");
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
    
    <p><a href="vacancies.jsp">Go to Vacancies</a> | <a href="index.jsp">Back to Home</a></p>
</body>
</html>