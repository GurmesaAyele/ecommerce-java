<%@page import="java.sql.*"%>
<%@page import="com.classes.DBConnector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String applicationId = request.getParameter("applicationId");
    String status = request.getParameter("status");
    String notes = request.getParameter("notes");
    String updateNotesOnly = request.getParameter("updateNotesOnly");
    
    response.setContentType("text/html;charset=UTF-8");
    
    try {
        Connection connection = DBConnector.getCon();
        
        if (connection == null) {
            out.println("error: Database connection failed");
            return;
        }
        
        String query;
        PreparedStatement stmt;
        
        if ("true".equals(updateNotesOnly)) {
            // Update only notes
            query = "UPDATE application SET recruiter_notes = ?, status_updated_at = NOW() WHERE applicationID = ?";
            stmt = connection.prepareStatement(query);
            stmt.setString(1, notes);
            stmt.setString(2, applicationId);
        } else {
            // Update status and notes
            query = "UPDATE application SET application_status = ?, recruiter_notes = ?, status_updated_at = NOW() WHERE applicationID = ?";
            stmt = connection.prepareStatement(query);
            stmt.setString(1, status);
            stmt.setString(2, notes != null ? notes : "");
            stmt.setString(3, applicationId);
        }
        
        int result = stmt.executeUpdate();
        
        if (result > 0) {
            // Also update the old status field for backward compatibility
            if (!"true".equals(updateNotesOnly)) {
                String oldStatusQuery = "UPDATE application SET status = ? WHERE applicationID = ?";
                PreparedStatement oldStmt = connection.prepareStatement(oldStatusQuery);
                
                // Map new status to old status values
                String oldStatus = "Waiting";
                if ("Selected".equals(status)) {
                    oldStatus = "Accepted";
                } else if ("Rejected".equals(status)) {
                    oldStatus = "Rejected";
                } else if ("Under Review".equals(status) || "Shortlisted".equals(status) || "Interview Scheduled".equals(status)) {
                    oldStatus = "Under Review";
                }
                
                oldStmt.setString(1, oldStatus);
                oldStmt.setString(2, applicationId);
                oldStmt.executeUpdate();
                oldStmt.close();
            }
            
            // Insert status history record
            if (!"true".equals(updateNotesOnly)) {
                String historyQuery = "INSERT INTO application_status_history (applicationID, new_status, change_reason, changed_at) VALUES (?, ?, ?, NOW())";
                PreparedStatement historyStmt = connection.prepareStatement(historyQuery);
                historyStmt.setString(1, applicationId);
                historyStmt.setString(2, status);
                historyStmt.setString(3, notes != null ? notes : "Status updated by recruiter");
                historyStmt.executeUpdate();
                historyStmt.close();
            }
            
            out.println("success");
        } else {
            out.println("error: Update failed");
        }
        
        stmt.close();
        connection.close();
        
    } catch (SQLException e) {
        out.println("error: " + e.getMessage());
        e.printStackTrace();
    } catch (Exception e) {
        out.println("error: " + e.getMessage());
        e.printStackTrace();
    }
%>