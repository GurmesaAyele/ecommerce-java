<%@page import="com.classes.DBConnector"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Create Missing Tables</title>
</head>
<body>
    <h2>Creating Missing Database Tables</h2>
    
    <%
        Connection connection = null;
        try {
            connection = DBConnector.getCon();
            if (connection != null) {
                out.println("<p style='color: green;'>✓ Database connection successful!</p>");
                
                // Create selection_criteria table
                String createSelectionCriteria = 
                    "CREATE TABLE IF NOT EXISTS selection_criteria (" +
                    "criteria_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "vacancyID INT NOT NULL, " +
                    "companyID INT NOT NULL, " +
                    "criteria_type ENUM('Education', 'Experience', 'Skills', 'Certification', 'Language', 'Other') NOT NULL, " +
                    "criteria_description TEXT NOT NULL, " +
                    "priority ENUM('High', 'Medium', 'Low') DEFAULT 'Medium', " +
                    "weightage INT CHECK (weightage BETWEEN 1 AND 100), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (vacancyID) REFERENCES vacancy(vacancyID) ON DELETE CASCADE, " +
                    "FOREIGN KEY (companyID) REFERENCES company(companyID) ON DELETE CASCADE" +
                    ")";
                
                PreparedStatement stmt1 = connection.prepareStatement(createSelectionCriteria);
                stmt1.executeUpdate();
                out.println("<p style='color: green;'>✓ Created selection_criteria table</p>");
                stmt1.close();
                
                // Create interview_feedback table
                String createInterviewFeedback = 
                    "CREATE TABLE IF NOT EXISTS interview_feedback (" +
                    "feedback_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "interview_id INT NOT NULL, " +
                    "technical_score INT CHECK (technical_score BETWEEN 1 AND 10), " +
                    "communication_score INT CHECK (communication_score BETWEEN 1 AND 10), " +
                    "problem_solving_score INT CHECK (problem_solving_score BETWEEN 1 AND 10), " +
                    "cultural_fit_score INT CHECK (cultural_fit_score BETWEEN 1 AND 10), " +
                    "overall_rating ENUM('Excellent', 'Good', 'Average', 'Poor') NOT NULL, " +
                    "strengths TEXT, " +
                    "weaknesses TEXT, " +
                    "recommendation ENUM('Strongly Recommend', 'Recommend', 'Consider', 'Do Not Recommend') NOT NULL, " +
                    "feedback_notes TEXT, " +
                    "interviewer_name VARCHAR(100), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                    ")";
                
                PreparedStatement stmt2 = connection.prepareStatement(createInterviewFeedback);
                stmt2.executeUpdate();
                out.println("<p style='color: green;'>✓ Created interview_feedback table</p>");
                stmt2.close();
                
                // Create notifications table
                String createNotifications = 
                    "CREATE TABLE IF NOT EXISTS notifications (" +
                    "notification_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "recipient_type ENUM('seeker', 'company', 'admin') NOT NULL, " +
                    "recipient_id INT NOT NULL, " +
                    "title VARCHAR(255) NOT NULL, " +
                    "message TEXT NOT NULL, " +
                    "notification_type ENUM('application_status', 'interview_scheduled', 'job_posted', 'system') DEFAULT 'system', " +
                    "is_read BOOLEAN DEFAULT FALSE, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                    ")";
                
                PreparedStatement stmt3 = connection.prepareStatement(createNotifications);
                stmt3.executeUpdate();
                out.println("<p style='color: green;'>✓ Created notifications table</p>");
                stmt3.close();
                
                // Create shortlist table
                String createShortlist = 
                    "CREATE TABLE IF NOT EXISTS shortlist (" +
                    "shortlist_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "applicationID INT NOT NULL, " +
                    "vacancyID INT NOT NULL, " +
                    "companyID INT NOT NULL, " +
                    "seekerID INT NOT NULL, " +
                    "shortlisted_by VARCHAR(100), " +
                    "shortlist_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "notes TEXT, " +
                    "FOREIGN KEY (applicationID) REFERENCES application(applicationID) ON DELETE CASCADE" +
                    ")";
                
                PreparedStatement stmt4 = connection.prepareStatement(createShortlist);
                stmt4.executeUpdate();
                out.println("<p style='color: green;'>✓ Created shortlist table</p>");
                stmt4.close();
                
                // Insert some sample selection criteria
                String insertSample = 
                    "INSERT IGNORE INTO selection_criteria (vacancyID, companyID, criteria_type, criteria_description, priority, weightage) VALUES " +
                    "(1, 1, 'Education', 'Bachelor degree in Computer Science or related field', 'High', 25), " +
                    "(1, 1, 'Experience', 'Minimum 5 years of software development experience', 'High', 30), " +
                    "(1, 1, 'Skills', 'Proficiency in Java, Spring Boot, and MySQL', 'Medium', 20), " +
                    "(1, 1, 'Certification', 'Oracle Java certification preferred', 'Low', 10), " +
                    "(2, 1, 'Education', 'Bachelor degree in Computer Science or related field', 'High', 30), " +
                    "(2, 1, 'Experience', 'Minimum 2 years of frontend development experience', 'High', 25), " +
                    "(2, 1, 'Skills', 'Expert knowledge of React, JavaScript, HTML5, CSS3', 'High', 25)";
                
                PreparedStatement stmt5 = connection.prepareStatement(insertSample);
                stmt5.executeUpdate();
                out.println("<p style='color: green;'>✓ Inserted sample selection criteria</p>");
                stmt5.close();
                
                // Verify tables exist
                DatabaseMetaData metaData = connection.getMetaData();
                String[] tableNames = {"selection_criteria", "interview_feedback", "notifications", "shortlist"};
                
                out.println("<h3>Table Verification:</h3>");
                for (String tableName : tableNames) {
                    ResultSet tables = metaData.getTables(null, null, tableName, null);
                    if (tables.next()) {
                        out.println("<p style='color: green;'>✓ " + tableName + " table exists</p>");
                    } else {
                        out.println("<p style='color: red;'>✗ " + tableName + " table missing</p>");
                    }
                    tables.close();
                }
                
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
    
    <p><a href="test_criteria.jsp">Test Criteria</a> | <a href="vacancies.jsp">Go to Vacancies</a> | <a href="index.jsp">Back to Home</a></p>
</body>
</html>