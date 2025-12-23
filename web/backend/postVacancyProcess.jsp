<%-- 
    Document   : companyRegistrationProcess
    Created on : Aug 7, 2023, 6:25:13 PM
    Author     : HP
--%>

<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
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
        
        String query = "INSERT INTO vacancy (companyID, title, category, location, type, salary, description) VALUES (?,?,?,?,?,?,?)";

        PreparedStatement statement = connection.prepareStatement(query);
        statement.setString(1, companyID);
        statement.setString(2, title);
        statement.setString(3, category);
        statement.setString(4, location);
        statement.setString(5, type);
        statement.setString(6, salary);
        statement.setString(7, description);

        int result = statement.executeUpdate();

        if (result > 0) {
            response.sendRedirect("../companyProfile.jsp?success=1");
        } else {
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
