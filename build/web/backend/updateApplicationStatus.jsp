<%@page import="java.sql.*"%>
<%@page import="com.classes.DBConnector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String applicationId = request.getParameter("applicationId");
    String status = request.getParameter("status");
    String notes = request.getParameter("notes");
    
    response.setContentType("text/html;charset=UTF-8");
    
    try {
        Connection connection = DBConnector.getCon();
        
        if (connection == null) {
            out.println("error: Database connection failed");
            return;
        }
        
        // Map display status to database status values
        String dbStatus = "Waiting";
        if ("Selected".equals(status) || "Accepted".equals(status)) {
            dbStatus = "Accepted";
        } else if ("Rejected".equals(status)) {
            dbStatus = "Rejected";
        } else if ("Applied".equals(status) || "Waiting".equals(status)) {
            dbStatus = "Waiting";
        }
        
        // Update status in the original database structure
        String query = "UPDATE application SET status = ? WHERE applicationID = ?";
        PreparedStatement stmt = connection.prepareStatement(query);
        stmt.setString(1, dbStatus);
        stmt.setString(2, applicationId);
        
        int result = stmt.executeUpdate();
        
        if (result > 0) {
            out.println("success");
        } else {
            out.println("error: No application found with ID " + applicationId);
        }
        
        stmt.close();
        connection.close();
        
    } catch (Exception e) {
        e.printStackTrace();
        out.println("error: " + e.getMessage());
    }
%>
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