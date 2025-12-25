<%-- 
    Document   : postVacancyProcess
    Created on : Aug 7, 2023, 6:25:13 PM
    Author     : HP
--%>

<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="com.classes.DBConnector"%>
<%@page import="com.classes.MD5"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String companyID = request.getParameter("companyID");
    String title = request.getParameter("title");
    String category = request.getParameter("category");
    String location = request.getParameter("location");
    String type = request.getParameter("type");
    String salary = request.getParameter("salary");
    String description = request.getParameter("description");
    
    // Get selection criteria arrays
    String[] criteriaTypes = request.getParameterValues("criteria_type[]");
    String[] criteriaDescriptions = request.getParameterValues("criteria_description[]");
    String[] criteriaPriorities = request.getParameterValues("criteria_priority[]");
    String[] criteriaWeightages = request.getParameterValues("criteria_weightage[]");
    
    response.setContentType("text/html;charset=UTF-8");

    try {
        // Validate and normalize the job type
        if (type != null) {
            type = type.trim();
            // Map common variations to database enum values
            if (type.equalsIgnoreCase("fulltime") || type.equalsIgnoreCase("full time")) {
                type = "Full-time";
            } else if (type.equalsIgnoreCase("parttime") || type.equalsIgnoreCase("part time")) {
                type = "Part-time";
            } else if (type.equalsIgnoreCase("contract")) {
                type = "Contract";
            } else if (type.equalsIgnoreCase("internship")) {
                type = "Internship";
            } else if (type.equalsIgnoreCase("remote")) {
                type = "Remote";
            }
            
            // Validate that type is one of the allowed values
            if (!type.equals("Full-time") && !type.equals("Part-time") && 
                !type.equals("Contract") && !type.equals("Internship") && !type.equals("Remote")) {
                type = "Full-time"; // Default to Full-time if invalid
            }
        } else {
            type = "Full-time"; // Default value
        }

        Connection connection = DBConnector.getCon();
        
        if (connection == null) {
            response.sendRedirect("../companyProfile.jsp?error=db");
            return;
        }
        
        // Start transaction
        connection.setAutoCommit(false);
        
        // Insert vacancy and get the generated ID
        String query = "INSERT INTO vacancy (companyID, title, category, location, type, salary, description) VALUES (?,?,?,?,?,?,?)";
        PreparedStatement statement = connection.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);
        statement.setString(1, companyID);
        statement.setString(2, title);
        statement.setString(3, category);
        statement.setString(4, location);
        statement.setString(5, type);
        statement.setString(6, salary);
        statement.setString(7, description);

        int result = statement.executeUpdate();
        
        if (result > 0) {
            // Get the generated vacancy ID
            ResultSet generatedKeys = statement.getGeneratedKeys();
            int vacancyID = 0;
            if (generatedKeys.next()) {
                vacancyID = generatedKeys.getInt(1);
            }
            
            // Insert selection criteria if provided
            if (criteriaTypes != null && criteriaTypes.length > 0) {
                String criteriaQuery = "INSERT INTO selection_criteria (vacancyID, companyID, criteria_type, criteria_description, priority, weightage) VALUES (?,?,?,?,?,?)";
                PreparedStatement criteriaStmt = connection.prepareStatement(criteriaQuery);
                
                for (int i = 0; i < criteriaTypes.length; i++) {
                    // Only insert if both type and description are provided
                    if (criteriaTypes[i] != null && !criteriaTypes[i].trim().isEmpty() && 
                        criteriaDescriptions[i] != null && !criteriaDescriptions[i].trim().isEmpty()) {
                        
                        criteriaStmt.setInt(1, vacancyID);
                        criteriaStmt.setString(2, companyID);
                        criteriaStmt.setString(3, criteriaTypes[i]);
                        criteriaStmt.setString(4, criteriaDescriptions[i]);
                        criteriaStmt.setString(5, criteriaPriorities[i] != null ? criteriaPriorities[i] : "Medium");
                        
                        // Handle weightage - set to 0 if not provided or invalid
                        int weightage = 0;
                        if (criteriaWeightages[i] != null && !criteriaWeightages[i].trim().isEmpty()) {
                            try {
                                weightage = Integer.parseInt(criteriaWeightages[i]);
                                if (weightage < 1 || weightage > 100) {
                                    weightage = 0; // Set to 0 if out of range
                                }
                            } catch (NumberFormatException e) {
                                weightage = 0; // Set to 0 if not a valid number
                            }
                        }
                        criteriaStmt.setInt(6, weightage);
                        
                        criteriaStmt.addBatch();
                    }
                }
                
                criteriaStmt.executeBatch();
                criteriaStmt.close();
            }
            
            // Commit transaction
            connection.commit();
            response.sendRedirect("../companyProfile.jsp?success=1");
        } else {
            connection.rollback();
            response.sendRedirect("../companyProfile.jsp?success=0");
        }
        
        statement.close();
        connection.close();
        
    } catch (Exception e) {
        // Log the error for debugging
        out.println("<h3>Error posting job vacancy:</h3>");
        out.println("<p>Error: " + e.getMessage() + "</p>");
        out.println("<p>Job Type received: '" + request.getParameter("type") + "'</p>");
        out.println("<p>Valid types: Full-time, Part-time, Contract, Internship, Remote</p>");
        out.println("<a href='../companyProfile.jsp'>Go Back</a>");
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>
