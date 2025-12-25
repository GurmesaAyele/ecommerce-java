<%@page import="com.classes.company"%>
<%@page import="java.sql.*"%>
<%@page import="com.classes.DBConnector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    company company = (company) session.getAttribute("company");
    if (company == null) {
        response.sendRedirect("../companyLogin.jsp");
        return;
    }

    String vacancyID = request.getParameter("vacancyID");
    String criteriaType = request.getParameter("criteriaType");
    String criteriaDescription = request.getParameter("criteriaDescription");
    String priority = request.getParameter("priority");
    String weightage = request.getParameter("weightage");

    Connection connection = null;
    try {
        connection = DBConnector.getCon();
        
        String insertQuery = "INSERT INTO selection_criteria (vacancyID, companyID, criteria_type, " +
                           "criteria_description, priority, weightage, created_at) " +
                           "VALUES (?, ?, ?, ?, ?, ?, NOW())";
        
        PreparedStatement stmt = connection.prepareStatement(insertQuery);
        stmt.setString(1, vacancyID);
        stmt.setString(2, String.valueOf(company.getCompanyID()));
        stmt.setString(3, criteriaType);
        stmt.setString(4, criteriaDescription);
        stmt.setString(5, priority);
        stmt.setString(6, weightage);
        
        int result = stmt.executeUpdate();
        stmt.close();
        
        if (result > 0) {
            response.sendRedirect("../selectionCriteria.jsp?success=1");
        } else {
            response.sendRedirect("../selectionCriteria.jsp?error=1");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("../selectionCriteria.jsp?error=2");
    } finally {
        if (connection != null) connection.close();
    }
%>