<%@page import="java.sql.*"%>
<%@page import="com.classes.DBConnector"%>
<%@page import="com.classes.company"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    company company = (company) session.getAttribute("company");
    if (company == null) {
        out.println("error: Not logged in");
        return;
    }
    
    String applicationId = request.getParameter("applicationId");
    String date = request.getParameter("date");
    String time = request.getParameter("time");
    String mode = request.getParameter("mode");
    String location = request.getParameter("location");
    String interviewer = request.getParameter("interviewer");
    
    response.setContentType("text/html;charset=UTF-8");
    
    try {
        Connection connection = DBConnector.getCon();
        
        if (connection == null) {
            out.println("error: Database connection failed");
            return;
        }
        
        // Get application details
        String appQuery = "SELECT vacancyID, seekerID FROM application WHERE applicationID = ?";
        PreparedStatement appStmt = connection.prepareStatement(appQuery);
        appStmt.setString(1, applicationId);
        ResultSet appRs = appStmt.executeQuery();
        
        if (!appRs.next()) {
            out.println("error: Application not found");
            return;
        }
        
        int vacancyID = appRs.getInt("vacancyID");
        int seekerID = appRs.getInt("seekerID");
        appRs.close();
        appStmt.close();
        
        // Insert interview record
        String interviewQuery = "INSERT INTO interview (applicationID, vacancyID, seekerID, companyID, " +
                               "interviewer_name, interview_date, interview_time, interview_mode, " +
                               "interview_location, meeting_link, interview_status, created_at) " +
                               "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'Scheduled', NOW())";
        
        PreparedStatement interviewStmt = connection.prepareStatement(interviewQuery);
        interviewStmt.setString(1, applicationId);
        interviewStmt.setInt(2, vacancyID);
        interviewStmt.setInt(3, seekerID);
        interviewStmt.setString(4, String.valueOf(company.getCompanyID()));
        interviewStmt.setString(5, interviewer);
        interviewStmt.setString(6, date);
        interviewStmt.setString(7, time);
        interviewStmt.setString(8, mode);
        
        if ("Online".equals(mode)) {
            interviewStmt.setString(9, "Online Meeting");
            interviewStmt.setString(10, location); // Meeting link
        } else {
            interviewStmt.setString(9, location); // Physical location
            interviewStmt.setString(10, null);
        }
        
        int result = interviewStmt.executeUpdate();
        
        if (result > 0) {
            // Update application status to "Interview Scheduled"
            String statusQuery = "UPDATE application SET application_status = 'Interview Scheduled', " +
                               "status_updated_at = NOW() WHERE applicationID = ?";
            PreparedStatement statusStmt = connection.prepareStatement(statusQuery);
            statusStmt.setString(1, applicationId);
            statusStmt.executeUpdate();
            statusStmt.close();
            
            // Update old status field for backward compatibility
            String oldStatusQuery = "UPDATE application SET status = 'Under Review' WHERE applicationID = ?";
            PreparedStatement oldStmt = connection.prepareStatement(oldStatusQuery);
            oldStmt.setString(1, applicationId);
            oldStmt.executeUpdate();
            oldStmt.close();
            
            // Insert status history
            String historyQuery = "INSERT INTO application_status_history (applicationID, new_status, " +
                                 "change_reason, changed_at) VALUES (?, 'Interview Scheduled', " +
                                 "'Interview scheduled for " + date + " at " + time + "', NOW())";
            PreparedStatement historyStmt = connection.prepareStatement(historyQuery);
            historyStmt.setString(1, applicationId);
            historyStmt.executeUpdate();
            historyStmt.close();
            
            out.println("success");
        } else {
            out.println("error: Failed to schedule interview");
        }
        
        interviewStmt.close();
        connection.close();
        
    } catch (SQLException e) {
        out.println("error: " + e.getMessage());
        e.printStackTrace();
    } catch (Exception e) {
        out.println("error: " + e.getMessage());
        e.printStackTrace();
    }
%>