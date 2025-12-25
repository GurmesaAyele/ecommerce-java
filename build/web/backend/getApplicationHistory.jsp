<%@page import="java.sql.*"%>
<%@page import="com.classes.DBConnector"%>
<%@page import="com.classes.seeker"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    seeker seeker = (seeker) session.getAttribute("seeker");
    if (seeker == null) {
        out.println("<div class='alert alert-danger'>Access denied</div>");
        return;
    }
    
    String applicationId = request.getParameter("applicationId");
    if (applicationId == null) {
        out.println("<div class='alert alert-danger'>Invalid application ID</div>");
        return;
    }
    
    try {
        Connection connection = DBConnector.getCon();
        if (connection != null) {
            // First get basic application info
            String appQuery = "SELECT a.*, v.title as job_title, c.companyName " +
                            "FROM application a " +
                            "JOIN vacancy v ON a.vacancyID = v.vacancyID " +
                            "JOIN company c ON a.companyID = c.companyID " +
                            "WHERE a.applicationID = ? AND a.seekerID = ?";
            
            PreparedStatement appStmt = connection.prepareStatement(appQuery);
            appStmt.setString(1, applicationId);
            appStmt.setString(2, seeker.useSeekerID());
            
            ResultSet appRs = appStmt.executeQuery();
            
            if (appRs.next()) {
%>

<div class="mb-3">
    <h6><%= appRs.getString("job_title") %> at <%= appRs.getString("companyName") %></h6>
    <p class="text-muted">Application ID: A<%= String.format("%03d", appRs.getInt("applicationID")) %></p>
</div>

<div class="timeline">
    <!-- Initial Application -->
    <div class="timeline-item">
        <div class="d-flex justify-content-between align-items-start">
            <div>
                <h6 class="mb-1">Application Submitted</h6>
                <p class="mb-1 text-muted">Your application was successfully submitted</p>
                <small class="text-muted"><%= appRs.getTimestamp("applied_date") %></small>
            </div>
            <span class="badge bg-info">Applied</span>
        </div>
    </div>

<%
                // Get status history
                String historyQuery = "SELECT * FROM application_status_history " +
                                    "WHERE applicationID = ? ORDER BY changed_at ASC";
                
                PreparedStatement historyStmt = connection.prepareStatement(historyQuery);
                historyStmt.setString(1, applicationId);
                
                ResultSet historyRs = historyStmt.executeQuery();
                
                while (historyRs.next()) {
                    String newStatus = historyRs.getString("new_status");
                    String changeReason = historyRs.getString("change_reason");
                    Timestamp changedAt = historyRs.getTimestamp("changed_at");
                    
                    String badgeClass = "bg-secondary";
                    String statusIcon = "fas fa-circle";
                    
                    switch (newStatus) {
                        case "Under Review":
                            badgeClass = "bg-warning text-dark";
                            statusIcon = "fas fa-search";
                            break;
                        case "Shortlisted":
                            badgeClass = "bg-success";
                            statusIcon = "fas fa-star";
                            break;
                        case "Interview Scheduled":
                            badgeClass = "bg-primary";
                            statusIcon = "fas fa-calendar";
                            break;
                        case "Interview Completed":
                            badgeClass = "bg-info";
                            statusIcon = "fas fa-check-circle";
                            break;
                        case "Selected":
                            badgeClass = "bg-success";
                            statusIcon = "fas fa-trophy";
                            break;
                        case "Rejected":
                            badgeClass = "bg-danger";
                            statusIcon = "fas fa-times-circle";
                            break;
                        case "Withdrawn":
                            badgeClass = "bg-secondary";
                            statusIcon = "fas fa-undo";
                            break;
                    }
%>
    
    <div class="timeline-item">
        <div class="d-flex justify-content-between align-items-start">
            <div>
                <h6 class="mb-1"><i class="<%= statusIcon %>"></i> <%= newStatus %></h6>
                <% if (changeReason != null && !changeReason.trim().isEmpty()) { %>
                <p class="mb-1 text-muted"><%= changeReason %></p>
                <% } %>
                <small class="text-muted"><%= changedAt %></small>
            </div>
            <span class="badge <%= badgeClass %>"><%= newStatus %></span>
        </div>
    </div>

<%
                }
                
                historyRs.close();
                historyStmt.close();
                
                // Check for interview details if status is Interview Scheduled or Completed
                String currentStatus = appRs.getString("application_status");
                if ("Interview Scheduled".equals(currentStatus) || "Interview Completed".equals(currentStatus)) {
                    String interviewQuery = "SELECT * FROM interview WHERE applicationID = ? ORDER BY created_at DESC LIMIT 1";
                    PreparedStatement intStmt = connection.prepareStatement(interviewQuery);
                    intStmt.setString(1, applicationId);
                    
                    ResultSet intRs = intStmt.executeQuery();
                    
                    if (intRs.next()) {
%>
    
    <div class="timeline-item">
        <div class="card border-primary">
            <div class="card-header bg-primary text-white">
                <h6 class="mb-0"><i class="fas fa-calendar-alt"></i> Interview Details</h6>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <p class="mb-1"><strong>Date:</strong> <%= intRs.getDate("interview_date") %></p>
                        <p class="mb-1"><strong>Time:</strong> <%= intRs.getTime("interview_time") %></p>
                        <p class="mb-1"><strong>Mode:</strong> <%= intRs.getString("interview_mode") %></p>
                    </div>
                    <div class="col-md-6">
                        <p class="mb-1"><strong>Interviewer:</strong> <%= intRs.getString("interviewer_name") %></p>
                        <% if (intRs.getString("meeting_link") != null && !intRs.getString("meeting_link").trim().isEmpty()) { %>
                        <p class="mb-1">
                            <strong>Meeting Link:</strong> 
                            <a href="<%= intRs.getString("meeting_link") %>" target="_blank" class="btn btn-sm btn-primary">
                                <i class="fas fa-video"></i> Join Meeting
                            </a>
                        </p>
                        <% } %>
                        <% if (intRs.getString("interview_location") != null && !intRs.getString("interview_location").trim().isEmpty()) { %>
                        <p class="mb-1"><strong>Location:</strong> <%= intRs.getString("interview_location") %></p>
                        <% } %>
                    </div>
                </div>
                <% if (intRs.getString("feedback") != null && !intRs.getString("feedback").trim().isEmpty()) { %>
                <div class="mt-2 alert alert-info">
                    <strong>Interview Feedback:</strong><br>
                    <%= intRs.getString("feedback") %>
                </div>
                <% } %>
            </div>
        </div>
    </div>

<%
                    }
                    
                    intRs.close();
                    intStmt.close();
                }
%>

</div>

<div class="mt-4">
    <div class="alert alert-info">
        <h6><i class="fas fa-info-circle"></i> Status Meanings:</h6>
        <ul class="mb-0">
            <li><strong>Applied:</strong> Your application has been received</li>
            <li><strong>Under Review:</strong> The recruiter is reviewing your application</li>
            <li><strong>Shortlisted:</strong> You've been shortlisted for further consideration</li>
            <li><strong>Interview Scheduled:</strong> An interview has been scheduled</li>
            <li><strong>Selected:</strong> Congratulations! You've been selected for the position</li>
            <li><strong>Rejected:</strong> Unfortunately, your application was not successful</li>
        </ul>
    </div>
</div>

<%
            } else {
                out.println("<div class='alert alert-danger'>Application not found or access denied</div>");
            }
            
            appRs.close();
            appStmt.close();
            connection.close();
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error loading application history: " + e.getMessage() + "</div>");
        e.printStackTrace();
    }
%>