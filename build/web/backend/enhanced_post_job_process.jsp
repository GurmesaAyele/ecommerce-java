<%@page import="java.sql.*"%>
<%@page import="com.classes.DBConnector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String companyID = request.getParameter("companyID");
    String title = request.getParameter("title");
    String category = request.getParameter("category");
    String location = request.getParameter("location");
    String type = request.getParameter("type");
    String experienceLevel = request.getParameter("experience_level");
    String salaryMinStr = request.getParameter("salary_min");
    String salaryMaxStr = request.getParameter("salary_max");
    String applicationDeadline = request.getParameter("application_deadline");
    String description = request.getParameter("description");
    String jobStatus = request.getParameter("job_status");
    String requiredSkillsJson = request.getParameter("required_skills");
    
    response.setContentType("text/html;charset=UTF-8");

    try {
        // Validate required fields
        if (companyID == null || title == null || category == null || location == null || type == null || description == null) {
            response.sendRedirect("../companyProfile.jsp?success=0");
            return;
        }

        // Validate and normalize the job type
        if (type != null) {
            type = type.trim();
            if (!type.equals("Full-time") && !type.equals("Part-time") && 
                !type.equals("Contract") && !type.equals("Internship") && !type.equals("Remote")) {
                type = "Full-time";
            }
        } else {
            type = "Full-time";
        }

        // Parse salary values
        Double salaryMin = null;
        Double salaryMax = null;
        try {
            if (salaryMinStr != null && !salaryMinStr.trim().isEmpty()) {
                salaryMin = Double.parseDouble(salaryMinStr);
            }
            if (salaryMaxStr != null && !salaryMaxStr.trim().isEmpty()) {
                salaryMax = Double.parseDouble(salaryMaxStr);
            }
        } catch (NumberFormatException e) {
            // Invalid salary format, continue without salary range
        }

        // Create salary range string for backward compatibility
        String salaryRange = "";
        if (salaryMin != null && salaryMax != null) {
            salaryRange = "Rs. " + String.format("%.0f", salaryMin) + " - " + String.format("%.0f", salaryMax);
        } else if (salaryMin != null) {
            salaryRange = "Rs. " + String.format("%.0f", salaryMin) + "+";
        } else if (salaryMax != null) {
            salaryRange = "Up to Rs. " + String.format("%.0f", salaryMax);
        } else {
            salaryRange = "Negotiable";
        }

        Connection connection = DBConnector.getCon();
        
        if (connection == null) {
            out.println("<h3>Database Connection Error</h3>");
            out.println("<p>Could not connect to database. Please check WAMP server.</p>");
            out.println("<a href=\"../enhanced_post_job.jsp\">Go Back</a>");
            return;
        }
        
        // Try enhanced insert first, fall back to basic if it fails
        String vacancyQuery;
        PreparedStatement vacancyStmt = null;
        boolean insertSuccess = false;
        
        // First try the enhanced insert
        try {
            vacancyQuery = "INSERT INTO vacancy (companyID, title, category, location, type, experience_level, " +
                          "salary_min, salary_max, application_deadline, description, job_status, salary, " +
                          "required_skills, created_by, posted_date) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,NOW())";
            
            vacancyStmt = connection.prepareStatement(vacancyQuery, Statement.RETURN_GENERATED_KEYS);
            vacancyStmt.setString(1, companyID);
            vacancyStmt.setString(2, title);
            vacancyStmt.setString(3, category);
            vacancyStmt.setString(4, location);
            vacancyStmt.setString(5, type);
            vacancyStmt.setString(6, experienceLevel != null ? experienceLevel : "Entry Level");
            
            if (salaryMin != null) {
                vacancyStmt.setDouble(7, salaryMin);
            } else {
                vacancyStmt.setNull(7, Types.DECIMAL);
            }
            
            if (salaryMax != null) {
                vacancyStmt.setDouble(8, salaryMax);
            } else {
                vacancyStmt.setNull(8, Types.DECIMAL);
            }
            
            if (applicationDeadline != null && !applicationDeadline.trim().isEmpty()) {
                vacancyStmt.setString(9, applicationDeadline);
            } else {
                vacancyStmt.setNull(9, Types.DATE);
            }
            
            vacancyStmt.setString(10, description);
            vacancyStmt.setString(11, jobStatus != null ? jobStatus : "Published");
            vacancyStmt.setString(12, salaryRange);
            vacancyStmt.setString(13, requiredSkillsJson != null ? requiredSkillsJson : "");
            vacancyStmt.setString(14, companyID);
            
            int result = vacancyStmt.executeUpdate();
            if (result > 0) {
                insertSuccess = true;
            }
            
        } catch (SQLException e) {
            // Enhanced columns don't exist, try basic insert
            if (vacancyStmt != null) {
                try {
                    vacancyStmt.close();
                } catch (Exception ex) {}
            }
            
            vacancyQuery = "INSERT INTO vacancy (companyID, title, category, location, type, salary, description, posted_date) VALUES (?,?,?,?,?,?,?,NOW())";
            
            vacancyStmt = connection.prepareStatement(vacancyQuery, Statement.RETURN_GENERATED_KEYS);
            vacancyStmt.setString(1, companyID);
            vacancyStmt.setString(2, title);
            vacancyStmt.setString(3, category);
            vacancyStmt.setString(4, location);
            vacancyStmt.setString(5, type);
            vacancyStmt.setString(6, salaryRange);
            vacancyStmt.setString(7, description);
            
            int result = vacancyStmt.executeUpdate();
            if (result > 0) {
                insertSuccess = true;
            }
        }

        if (insertSuccess) {
            // Get the generated vacancy ID
            ResultSet generatedKeys = vacancyStmt.getGeneratedKeys();
            int vacancyID = 0;
            if (generatedKeys.next()) {
                vacancyID = generatedKeys.getInt(1);
            }
            generatedKeys.close();
            
            // Success - redirect to company profile with success message
            response.sendRedirect("../companyProfile.jsp?success=1&id=" + vacancyID);
            
        } else {
            response.sendRedirect("../companyProfile.jsp?success=0");
        }
        
        if (vacancyStmt != null) {
            vacancyStmt.close();
        }
        connection.close();
        
    } catch (SQLException e) {
        out.println("<h3>Database Error:</h3>");
        out.println("<p>" + e.getMessage() + "</p>");
        out.println("<p>SQL State: " + e.getSQLState() + "</p>");
        out.println("<a href=\"../enhanced_post_job.jsp\">Go Back</a>");
        e.printStackTrace();
    } catch (Exception e) {
        out.println("<h3>Error posting job vacancy:</h3>");
        out.println("<p>Error: " + e.getMessage() + "</p>");
        out.println("<p>Error Type: " + e.getClass().getSimpleName() + "</p>");
        out.println("<a href=\"../enhanced_post_job.jsp\">Go Back</a>");
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Processing Job Post</title>
    </head>
    <body>
        <h1>Processing your job posting...</h1>
    </body>
</html>