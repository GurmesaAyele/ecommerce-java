<%@page import="java.sql.*"%>
<%@page import="com.classes.DBConnector"%>
<%@page import="com.classes.seeker"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    seeker seeker = (seeker) session.getAttribute("seeker");
    if (seeker == null) {
        out.println("error: Access denied");
        return;
    }
    
    String applicationId = request.getParameter("applicationId");
    if (applicationId == null) {
        out.println("error: Invalid application ID");
        return;
    }
    
    response.setContentType("text/html;charset=UTF-8");
    
    try {
        Connection connection = DBConnector.getCon();
        
        if (connection == null) {
            out.println("error: Database connection failed");
            return;
        }
        
        // First verify the application belongs to this seeker and can be withdrawn
        String checkQuery = "SELECT application_status FROM application WHERE applicationID = ? AND seekerID = ?";
        PreparedStatement checkStmt = connection.prepareStatement(checkQuery);
        checkStmt.setString(1, applicationId);
        checkStmt.setString(2, seeker.useSeekerID());
        
        ResultSet checkRs = checkStmt.executeQuery();
        
        if (!checkRs.next()) {
            out.println("error: Application not found or access denied");
            checkRs.close();
            checkStmt.close();
            connection.close();
            return;
        }
        
        String currentStatus = checkRs.getString("application_status");
        checkRs.close();
        checkStmt.close();
        
        // Check if application can be withdrawn
        if ("Selected".equals(currentStatus) || "Rejected".equals(currentStatus) || "Withdrawn".equals(currentStatus)) {
            out.println("error: Cannot withdraw application with status: " + currentStatus);
            connection.close();
            return;
        }
        
        // Update application status to Withdrawn
        String updateQuery = "UPDATE application SET application_status = 'Withdrawn', " +
                           "recruiter_notes = CONCAT(COALESCE(recruiter_notes, ''), '\nApplication withdrawn by candidate'), " +
                           "status_updated_at = NOW() WHERE applicationID = ?";
        
        PreparedStatement updateStmt = connection.prepareStatement(updateQuery);
        updateStmt.setString(1, applicationId);
        
        int result = updateStmt.executeUpdate();
        
        if (result > 0) {
            // Update old status field for backward compatibility
            String oldStatusQuery = "UPDATE application SET status = 'Rejected' WHERE applicationID = ?";
            PreparedStatement oldStmt = connection.prepareStatement(oldStatusQuery);
            oldStmt.setString(1, applicationId);
            oldStmt.executeUpdate();
            oldStmt.close();
            
            // Insert status history record
            String historyQuery = "INSERT INTO application_status_history (applicationID, old_status, new_status, " +
                                 "change_reason, changed_at) VALUES (?, ?, 'Withdrawn', " +
                                 "'Application withdrawn by candidate', NOW())";
            PreparedStatement historyStmt = connection.prepareStatement(historyQuery);
            historyStmt.setString(1, applicationId);
            historyStmt.setString(2, currentStatus);
            historyStmt.executeUpdate();
            historyStmt.close();
            
            out.println("success");
        } else {
            out.println("error: Failed to withdraw application");
        }
        
        updateStmt.close();
        connection.close();
        
    } catch (SQLException e) {
        out.println("error: " + e.getMessage());
        e.printStackTrace();
    } catch (Exception e) {
        out.println("error: " + e.getMessage());
        e.printStackTrace();
    }
%>