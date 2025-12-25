<%@page import="com.classes.DBConnector"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Database Connection Test</title>
</head>
<body>
    <h2>Database Connection Test</h2>
    
    <%
        Connection connection = null;
        try {
            connection = DBConnector.getCon();
            if (connection != null) {
                out.println("<p style='color: green;'>✓ Database connection successful!</p>");
                
                // Test if selection_criteria table exists
                DatabaseMetaData metaData = connection.getMetaData();
                ResultSet tables = metaData.getTables(null, null, "selection_criteria", null);
                if (tables.next()) {
                    out.println("<p style='color: green;'>✓ selection_criteria table exists!</p>");
                    
                    // Count records in selection_criteria
                    PreparedStatement countStmt = connection.prepareStatement("SELECT COUNT(*) as count FROM selection_criteria");
                    ResultSet countRs = countStmt.executeQuery();
                    if (countRs.next()) {
                        int count = countRs.getInt("count");
                        out.println("<p>Total selection criteria records: " + count + "</p>");
                    }
                    countRs.close();
                    countStmt.close();
                } else {
                    out.println("<p style='color: red;'>✗ selection_criteria table does not exist!</p>");
                }
                tables.close();
                
                // Test vacancy table
                PreparedStatement vacancyStmt = connection.prepareStatement("SELECT COUNT(*) as count FROM vacancy");
                ResultSet vacancyRs = vacancyStmt.executeQuery();
                if (vacancyRs.next()) {
                    int count = vacancyRs.getInt("count");
                    out.println("<p>Total vacancy records: " + count + "</p>");
                }
                vacancyRs.close();
                vacancyStmt.close();
                
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