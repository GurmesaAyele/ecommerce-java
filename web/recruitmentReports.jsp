<%@page import="com.classes.company"%>
<%@page import="java.sql.*"%>
<%@page import="com.classes.DBConnector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Declare variables at page level
    String statusLabelsStr = "'No Data'";
    String statusDataStr = "0";
    
    company company = (company) session.getAttribute("company");
    if (company == null) {
        response.sendRedirect("companyLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Recruitment Performance Reports</title>
    <link rel="stylesheet" type="text/css" href="css/stylesheet.css?v=<%= System.currentTimeMillis() %>">
    <link href="css/bootstrap.min.css?v=<%= System.currentTimeMillis() %>" rel="stylesheet">
    <script src="https://kit.fontawesome.com/0008de2df6.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

    <header id="header">
        <nav class="navbar navbar-expand-lg navbar-light">
            <div class="container-fluid">
                <a class="navbar-brand" href="companyProfile.jsp">
                    <img src="images/trendhireLogo.jpg?v=<%= System.currentTimeMillis() %>" class="main-logo" alt="Logo" style="max-width: 150px; max-height: 100px;">
                </a>
                <div class="collapse navbar-collapse">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item"><a class="nav-link" href="companyProfile.jsp">Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" href="manageApplications.jsp">Applications</a></li>
                        <li class="nav-item"><a class="nav-link active" href="recruitmentReports.jsp">Reports</a></li>
                        <li class="nav-item"><a class="nav-link" href="backend/logout.jsp">Logout</a></li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>

    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-12">
                <h2><i class="fas fa-chart-bar"></i> Recruitment Performance Reports</h2>
                <p class="text-muted">Comprehensive analytics for your recruitment process</p>
            </div>
        </div>

        <%
            Connection connection = null;
            try {
                connection = DBConnector.getCon();
                String companyId = String.valueOf(company.getCompanyID());
        %>

        <!-- Key Metrics Cards -->
        <div class="row mb-4">
            <%
                // Total Applications
                PreparedStatement totalAppsStmt = connection.prepareStatement(
                    "SELECT COUNT(*) as total FROM application WHERE companyID = ?");
                totalAppsStmt.setString(1, companyId);
                ResultSet totalAppsRs = totalAppsStmt.executeQuery();
                int totalApplications = 0;
                if (totalAppsRs.next()) totalApplications = totalAppsRs.getInt("total");

                // Active Vacancies
                PreparedStatement activeVacStmt = connection.prepareStatement(
                    "SELECT COUNT(*) as total FROM vacancy WHERE companyID = ? AND job_status = 'Active'");
                activeVacStmt.setString(1, companyId);
                ResultSet activeVacRs = activeVacStmt.executeQuery();
                int activeVacancies = 0;
                if (activeVacRs.next()) activeVacancies = activeVacRs.getInt("total");

                // Interviews Scheduled
                PreparedStatement interviewsStmt = connection.prepareStatement(
                    "SELECT COUNT(*) as total FROM interview WHERE companyID = ?");
                interviewsStmt.setString(1, companyId);
                ResultSet interviewsRs = interviewsStmt.executeQuery();
                int totalInterviews = 0;
                if (interviewsRs.next()) totalInterviews = interviewsRs.getInt("total");

                // Successful Hires
                PreparedStatement hiresStmt = connection.prepareStatement(
                    "SELECT COUNT(*) as total FROM application WHERE companyID = ? AND application_status = 'Selected'");
                hiresStmt.setString(1, companyId);
                ResultSet hiresRs = hiresStmt.executeQuery();
                int successfulHires = 0;
                if (hiresRs.next()) successfulHires = hiresRs.getInt("total");
            %>

            <div class="col-md-3">
                <div class="card bg-primary text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h4><%= totalApplications %></h4>
                                <p class="mb-0">Total Applications</p>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-file-alt fa-2x"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h4><%= activeVacancies %></h4>
                                <p class="mb-0">Active Vacancies</p>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-briefcase fa-2x"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card bg-info text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h4><%= totalInterviews %></h4>
                                <p class="mb-0">Interviews Scheduled</p>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-calendar fa-2x"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-3">
                <div class="card bg-warning text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h4><%= successfulHires %></h4>
                                <p class="mb-0">Successful Hires</p>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-user-check fa-2x"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Application Status Distribution -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-pie-chart"></i> Application Status Distribution</h5>
                    </div>
                    <div class="card-body">
                        <canvas id="statusChart" width="400" height="200"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-chart-line"></i> Monthly Application Trends</h5>
                    </div>
                    <div class="card-body">
                        <canvas id="trendsChart" width="400" height="200"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recruitment Performance Table -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-table"></i> Vacancy Performance Details</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Vacancy Title</th>
                                        <th>Applications</th>
                                        <th>Shortlisted</th>
                                        <th>Interviewed</th>
                                        <th>Selected</th>
                                        <th>Success Rate</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        PreparedStatement vacancyStmt = connection.prepareStatement(
                                            "SELECT v.vacancyID, v.title, v.job_status, " +
                                            "COUNT(a.applicationID) as total_apps, " +
                                            "SUM(CASE WHEN a.application_status = 'Shortlisted' THEN 1 ELSE 0 END) as shortlisted, " +
                                            "SUM(CASE WHEN a.application_status = 'Interview Scheduled' OR a.application_status = 'Interview Completed' THEN 1 ELSE 0 END) as interviewed, " +
                                            "SUM(CASE WHEN a.application_status = 'Selected' THEN 1 ELSE 0 END) as selected " +
                                            "FROM vacancy v LEFT JOIN application a ON v.vacancyID = a.vacancyID " +
                                            "WHERE v.companyID = ? GROUP BY v.vacancyID, v.title, v.job_status");
                                        vacancyStmt.setString(1, companyId);
                                        ResultSet vacancyRs = vacancyStmt.executeQuery();

                                        while (vacancyRs.next()) {
                                            int totalApps = vacancyRs.getInt("total_apps");
                                            int shortlisted = vacancyRs.getInt("shortlisted");
                                            int interviewed = vacancyRs.getInt("interviewed");
                                            int selected = vacancyRs.getInt("selected");
                                            double successRate = totalApps > 0 ? (selected * 100.0 / totalApps) : 0;
                                    %>
                                    <tr>
                                        <td><%= vacancyRs.getString("title") %></td>
                                        <td><%= totalApps %></td>
                                        <td><%= shortlisted %></td>
                                        <td><%= interviewed %></td>
                                        <td><%= selected %></td>
                                        <td><%= String.format("%.1f%%", successRate) %></td>
                                        <td>
                                            <span class="badge <%= "Active".equals(vacancyRs.getString("job_status")) ? "bg-success" : "bg-secondary" %>">
                                                <%= vacancyRs.getString("job_status") %>
                                            </span>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                        vacancyRs.close();
                                        vacancyStmt.close();
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%
                // Get status distribution data for chart
                try {
                    PreparedStatement statusStmt = connection.prepareStatement(
                        "SELECT application_status, COUNT(*) as count FROM application WHERE companyID = ? GROUP BY application_status");
                    statusStmt.setString(1, companyId);
                    ResultSet statusRs = statusStmt.executeQuery();
                    
                    StringBuilder statusLabels = new StringBuilder();
                    StringBuilder statusData = new StringBuilder();
                    
                    while (statusRs.next()) {
                        if (statusLabels.length() > 0) {
                            statusLabels.append(",");
                            statusData.append(",");
                        }
                        statusLabels.append("'").append(statusRs.getString("application_status")).append("'");
                        statusData.append(statusRs.getInt("count"));
                    }
                    statusRs.close();
                    statusStmt.close();
                    
                    // Set the page-level variables
                    if (statusLabels.length() > 0) {
                        statusLabelsStr = statusLabels.toString();
                        statusDataStr = statusData.toString();
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger'>Error loading chart data: " + e.getMessage() + "</div>");
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error loading reports: " + e.getMessage() + "</div>");
                e.printStackTrace();
            } finally {
                if (connection != null) connection.close();
            }
        %>
    </div>

    <script>
        // Status Distribution Chart
        const statusCtx = document.getElementById('statusChart').getContext('2d');
        new Chart(statusCtx, {
            type: 'doughnut',
            data: {
                labels: [<%= statusLabelsStr %>],
                datasets: [{
                    data: [<%= statusDataStr %>],
                    backgroundColor: [
                        '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40'
                    ]
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });

        // Monthly Trends Chart (placeholder data)
        const trendsCtx = document.getElementById('trendsChart').getContext('2d');
        new Chart(trendsCtx, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [{
                    label: 'Applications',
                    data: [12, 19, 15, 25, 22, 30],
                    borderColor: '#36A2EB',
                    tension: 0.1
                }, {
                    label: 'Hires',
                    data: [2, 3, 2, 4, 3, 5],
                    borderColor: '#4BC0C0',
                    tension: 0.1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
</body>
</html>