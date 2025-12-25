<%@page import="com.classes.seeker"%>
<%@page import="java.sql.*"%>
<%@page import="com.classes.DBConnector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Notifications</title>
    <link rel="stylesheet" type="text/css" href="css/stylesheet.css?v=<%= System.currentTimeMillis() %>">
    <link href="css/bootstrap.min.css?v=<%= System.currentTimeMillis() %>" rel="stylesheet">
    <script src="https://kit.fontawesome.com/0008de2df6.js" crossorigin="anonymous"></script>
</head>
<body>
    <%
        seeker seeker = (seeker) session.getAttribute("seeker");
        if (seeker == null) {
            response.sendRedirect("seekerLogin.jsp");
            return;
        }
    %>

    <header id="header">
        <nav class="navbar navbar-expand-lg navbar-light">
            <div class="container-fluid">
                <a class="navbar-brand" href="userprofile.jsp">
                    <img src="images/trendhireLogo.jpg?v=<%= System.currentTimeMillis() %>" class="main-logo" alt="Logo" style="max-width: 150px; max-height: 100px;">
                </a>
                <div class="collapse navbar-collapse">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item"><a class="nav-link" href="userprofile.jsp">Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" href="userApplication.jsp">My Applications</a></li>
                        <li class="nav-item"><a class="nav-link active" href="candidateNotifications.jsp">Notifications</a></li>
                        <li class="nav-item"><a class="nav-link" href="backend/logout.jsp">Logout</a></li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>

    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-12">
                <h2><i class="fas fa-bell"></i> Your Notifications</h2>
                <p class="text-muted">Stay updated with your application status changes</p>
            </div>
        </div>

        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5><i class="fas fa-inbox"></i> Recent Notifications</h5>
                        <button class="btn btn-sm btn-outline-primary" onclick="markAllAsRead()">
                            <i class="fas fa-check-double"></i> Mark All as Read
                        </button>
                    </div>
                    <div class="card-body">
                        <%
                            Connection connection = null;
                            try {
                                connection = DBConnector.getCon();
                                
                                PreparedStatement notifStmt = connection.prepareStatement(
                                    "SELECT n.*, v.title as vacancy_title, c.companyName " +
                                    "FROM notifications n " +
                                    "LEFT JOIN vacancy v ON n.vacancy_id = v.vacancyID " +
                                    "LEFT JOIN company c ON n.company_id = c.companyID " +
                                    "WHERE n.recipient_type = 'seeker' AND n.recipient_id = ? " +
                                    "ORDER BY n.created_at DESC LIMIT 20");
                                notifStmt.setInt(1, seeker.getSeekerID());
                                ResultSet notifRs = notifStmt.executeQuery();
                                
                                boolean hasNotifications = false;
                                while (notifRs.next()) {
                                    hasNotifications = true;
                                    String notificationType = notifRs.getString("notification_type");
                                    boolean isRead = notifRs.getBoolean("is_read");
                                    
                                    String iconClass = "";
                                    String badgeClass = "";
                                    
                                    switch (notificationType) {
                                        case "Application Status Change":
                                            iconClass = "fas fa-sync-alt text-primary";
                                            badgeClass = "bg-primary";
                                            break;
                                        case "Interview Scheduled":
                                            iconClass = "fas fa-calendar text-success";
                                            badgeClass = "bg-success";
                                            break;
                                        case "Application Accepted":
                                            iconClass = "fas fa-check-circle text-success";
                                            badgeClass = "bg-success";
                                            break;
                                        case "Application Rejected":
                                            iconClass = "fas fa-times-circle text-danger";
                                            badgeClass = "bg-danger";
                                            break;
                                        default:
                                            iconClass = "fas fa-info-circle text-info";
                                            badgeClass = "bg-info";
                                    }
                        %>
                        <div class="notification-item <%= !isRead ? "unread" : "" %> mb-3 p-3 border rounded">
                            <div class="row align-items-center">
                                <div class="col-md-1 text-center">
                                    <i class="<%= iconClass %> fa-2x"></i>
                                </div>
                                <div class="col-md-8">
                                    <h6 class="mb-1">
                                        <%= notifRs.getString("title") %>
                                        <% if (!isRead) { %>
                                        <span class="badge bg-warning ms-2">New</span>
                                        <% } %>
                                    </h6>
                                    <p class="mb-1"><%= notifRs.getString("message") %></p>
                                    <% if (notifRs.getString("vacancy_title") != null) { %>
                                    <small class="text-muted">
                                        <i class="fas fa-briefcase"></i> <%= notifRs.getString("vacancy_title") %>
                                        <% if (notifRs.getString("companyName") != null) { %>
                                        at <%= notifRs.getString("companyName") %>
                                        <% } %>
                                    </small>
                                    <% } %>
                                </div>
                                <div class="col-md-2 text-end">
                                    <small class="text-muted">
                                        <%= notifRs.getTimestamp("created_at") %>
                                    </small>
                                </div>
                                <div class="col-md-1 text-end">
                                    <% if (!isRead) { %>
                                    <button class="btn btn-sm btn-outline-primary" 
                                            onclick="markAsRead(<%= notifRs.getInt("notification_id") %>)">
                                        <i class="fas fa-check"></i>
                                    </button>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                        <%
                                }
                                
                                if (!hasNotifications) {
                        %>
                        <div class="text-center py-5">
                            <i class="fas fa-bell-slash fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No notifications yet</h5>
                            <p class="text-muted">You'll receive notifications when there are updates to your applications.</p>
                        </div>
                        <%
                                }
                                
                                notifRs.close();
                                notifStmt.close();
                            } catch (Exception e) {
                                out.println("<div class='alert alert-danger'>Error loading notifications: " + e.getMessage() + "</div>");
                                e.printStackTrace();
                            } finally {
                                if (connection != null) connection.close();
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Notification Preferences -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-cog"></i> Notification Preferences</h5>
                    </div>
                    <div class="card-body">
                        <form action="backend/updateNotificationPreferences.jsp" method="POST">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-check mb-2">
                                        <input class="form-check-input" type="checkbox" id="statusChanges" name="preferences" value="status_changes" checked>
                                        <label class="form-check-label" for="statusChanges">
                                            Application status changes
                                        </label>
                                    </div>
                                    <div class="form-check mb-2">
                                        <input class="form-check-input" type="checkbox" id="interviews" name="preferences" value="interviews" checked>
                                        <label class="form-check-label" for="interviews">
                                            Interview scheduling
                                        </label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-check mb-2">
                                        <input class="form-check-input" type="checkbox" id="newJobs" name="preferences" value="new_jobs" checked>
                                        <label class="form-check-label" for="newJobs">
                                            New job opportunities
                                        </label>
                                    </div>
                                    <div class="form-check mb-2">
                                        <input class="form-check-input" type="checkbox" id="reminders" name="preferences" value="reminders" checked>
                                        <label class="form-check-label" for="reminders">
                                            Application reminders
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary mt-3">
                                <i class="fas fa-save"></i> Save Preferences
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        .notification-item.unread {
            background-color: #f8f9fa;
            border-left: 4px solid #007bff !important;
        }
        
        .notification-item:hover {
            background-color: #f1f3f4;
        }
    </style>

    <script>
        function markAsRead(notificationId) {
            fetch('backend/markNotificationRead.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'notificationId=' + notificationId
            }).then(() => {
                location.reload();
            });
        }

        function markAllAsRead() {
            fetch('backend/markAllNotificationsRead.jsp', {
                method: 'POST'
            }).then(() => {
                location.reload();
            });
        }
    </script>
</body>
</html>