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

    String interviewId = request.getParameter("interviewId");
    String technicalScore = request.getParameter("technical_score");
    String communicationScore = request.getParameter("communication_score");
    String problemSolvingScore = request.getParameter("problem_solving_score");
    String culturalFitScore = request.getParameter("cultural_fit_score");
    String experienceScore = request.getParameter("experience_score");
    String overallScore = request.getParameter("overall_score");
    String strengths = request.getParameter("strengths");
    String weaknesses = request.getParameter("weaknesses");
    String additionalComments = request.getParameter("additional_comments");
    String recommendation = request.getParameter("recommendation");

    Connection connection = null;
    try {
        connection = DBConnector.getCon();
        
        // Calculate average score
        double avgScore = (Double.parseDouble(technicalScore) + 
                          Double.parseDouble(communicationScore) + 
                          Double.parseDouble(problemSolvingScore) + 
                          Double.parseDouble(culturalFitScore) + 
                          Double.parseDouble(experienceScore) + 
                          Double.parseDouble(overallScore)) / 6.0;
        
        // Update interview with feedback
        String updateQuery = "UPDATE interview SET " +
                           "technical_score = ?, communication_score = ?, problem_solving_score = ?, " +
                           "cultural_fit_score = ?, experience_score = ?, overall_score = ?, " +
                           "average_score = ?, strengths = ?, weaknesses = ?, " +
                           "additional_comments = ?, recommendation = ?, " +
                           "interview_status = 'Completed', feedback_date = NOW() " +
                           "WHERE interview_id = ? AND companyID = ?";
        
        PreparedStatement stmt = connection.prepareStatement(updateQuery);
        stmt.setString(1, technicalScore);
        stmt.setString(2, communicationScore);
        stmt.setString(3, problemSolvingScore);
        stmt.setString(4, culturalFitScore);
        stmt.setString(5, experienceScore);
        stmt.setString(6, overallScore);
        stmt.setDouble(7, avgScore);
        stmt.setString(8, strengths);
        stmt.setString(9, weaknesses);
        stmt.setString(10, additionalComments);
        stmt.setString(11, recommendation);
        stmt.setString(12, interviewId);
        stmt.setString(13, String.valueOf(company.getCompanyID()));
        
        int result = stmt.executeUpdate();
        stmt.close();
        
        if (result > 0) {
            // Update application status to Interview Completed
            PreparedStatement appStmt = connection.prepareStatement(
                "UPDATE application SET application_status = 'Interview Completed', " +
                "status_updated_at = NOW() WHERE applicationID = " +
                "(SELECT applicationID FROM interview WHERE interview_id = ?)");
            appStmt.setString(1, interviewId);
            appStmt.executeUpdate();
            appStmt.close();
            
            response.sendRedirect("../manageApplications.jsp?feedback_saved=1");
        } else {
            response.sendRedirect("../interviewFeedback.jsp?interviewId=" + interviewId + "&error=1");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("../interviewFeedback.jsp?interviewId=" + interviewId + "&error=2");
    } finally {
        if (connection != null) connection.close();
    }
%>