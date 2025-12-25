<%@page import="com.classes.DBConnector"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Check Interview Table</title>
</head>
<body>
    <h2>Interview Table Structure</h2>
    
    <%
        Connection connection = null;
        try {
            connection = DBConnector.getCon();
            if (connection != null) {
                out.println("<p style='color: green;'>✓ Database connection successful!</p>");
                
                // Check if interview table exists
                DatabaseMetaData metaData = connection.getMetaData();
                ResultSet tables = metaData.getTables(null, null, "interview", null);
                if (tables.next()) {
                    out.println("<p style='color: green;'>✓ interview table exists</p>");
                    
                    // Get column information
                    ResultSet columns = metaData.getColumns(null, null, "interview", null);
                    out.println("<h3>Interview Table Columns:</h3>");
                    out.println("<table border='1' style='border-collapse: collapse;'>");
                    out.println("<tr><th>Column Name</th><th>Data Type</th><th>Nullable</th></tr>");
                    
                    while (columns.next()) {
                        String columnName = columns.getString("COLUMN_NAME");
                        String dataType = columns.getString("TYPE_NAME");
                        String nullable = columns.getString("IS_NULLABLE");
                        out.println("<tr><td>" + columnName + "</td><td>" + dataType + "</td><td>" + nullable + "</td></tr>");
                    }
                    out.println("</table>");
                    columns.close();
                    
                    // Show sample data
                    PreparedStatement stmt = connection.prepareStatement("SELECT * FROM interview LIMIT 5");
                    ResultSet rs = stmt.executeQuery();
                    ResultSetMetaData rsmd = rs.getMetaData();
                    int columnCount = rsmd.getColumnCount();
                    
                    out.println("<h3>Sample Data:</h3>");
                    out.println("<table border='1' style='border-collapse: collapse;'>");
                    out.println("<tr>");
                    for (int i = 1; i <= columnCount; i++) {
                        out.println("<th>" + rsmd.getColumnName(i) + "</th>");
                    }
                    out.println("</tr>");
                    
                    while (rs.next()) {
                        out.println("<tr>");
                        for (int i = 1; i <= columnCount; i++) {
                            out.println("<td>" + rs.getString(i) + "</td>");
                        }
                        out.println("</tr>");
                    }
                    out.println("</table>");
                    
                    rs.close();
                    stmt.close();
                    
                } else {
                    out.println("<p style='color: red;'>✗ interview table does not exist!</p>");
                    
                    // Create interview table
                    String createInterview = 
                        "CREATE TABLE IF NOT EXISTS interview (" +
                        "interviewID INT AUTO_INCREMENT PRIMARY KEY, " +
                        "applicationID INT NOT NULL, " +
                        "vacancyID INT NOT NULL, " +
                        "companyID INT NOT NULL, " +
                        "seekerID INT NOT NULL, " +
                        "interview_date DATETIME, " +
                        "interview_time TIME, " +
                        "interview_location VARCHAR(255), " +
                        "interview_type ENUM('In-person', 'Video Call', 'Phone Call') DEFAULT 'In-person', " +
                        "interview_status ENUM('Scheduled', 'Completed', 'Cancelled', 'Rescheduled') DEFAULT 'Scheduled', " +
                        "interviewer_name VARCHAR(100), " +
                        "notes TEXT, " +
                        "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                        "FOREIGN KEY (applicationID) REFERENCES application(applicationID) ON DELETE CASCADE" +
                        ")";
                    
                    PreparedStatement createStmt = connection.prepareStatement(createInterview);
                    createStmt.executeUpdate();
                    out.println("<p style='color: green;'>✓ Created interview table</p>");
                    createStmt.close();
                }
                tables.close();
                
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
    
    <p><a href="adminRecruitmentReports.jsp">Back to Reports</a> | <a href="index.jsp">Home</a></p>
</body>
</html>