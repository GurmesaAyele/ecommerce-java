<%@page import="com.classes.Admin"%>
<%@page import="java.sql.*"%>
<%@page import="com.classes.DBConnector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect("adminLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Admin - Company Recruitment Reports</title>
    <link rel="stylesheet" type="text/css" href="css/stylesheet.css?v=<%= System.currentTimeMillis() %>">
    <link href="css/bootstrap.min.css?v=<%= System.currentTimeMillis() %>" rel="stylesheet">
    <script src="https://kit.fontawesome.com/0008de2df6.js" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <header id="header">
        <nav class="navbar navbar-expand-lg navbar-light">
            <div class="container-fluid">
                <a class="navbar-brand" href="adminProfile.jsp">
                    <img src="images/trendhireLogo.jpg?v=<%= System.currentTimeMillis() %>" class="main-logo" alt="Logo" style="max-width: 150px; max-height: 100px;">
                </a>
                <div class="collapse navbar-collapse">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item"><a class="nav-link" href="adminProfile.jsp">Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" href="adminCompany.jsp">Companies</a></li>
                        <li class="nav-item"><a class="nav-link active" href="adminRecruitmentReports.jsp">Reports</a></li>
                        <li class="nav-item"><a class="nav-link" href="backend/logout.jsp">Logout</a></li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>

    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-12">
                <h2><i class="fas fa-chart-line"></i> Company Recruitment Performance Reports</h2>
                <p class="text-muted">Overview of all companies' recruitment activities and performance</p>
            </div>
        </div>

        <!-- Overall System Metrics -->
        <div class="row mb-4">
            <%
                Connection connection = null;
                try {
                    connection = DBConnector.getCon();
                    
                    // Total system metrics
                    PreparedStatement totalStmt = connection.prepareStatement(
                        "SELECT " +
                        "(SELECT COUNT(*) FROM company WHERE status = 'active') as total_companies, " +
                        "(SELECT COUNT(*) FROM vacancy WHERE job_status = 'Active') as total_vacancies, " +
                        "(SELECT COUNT(*) FROM application) as total_applications, " +
                        "(SELECT COUNT(*) FROM application WHERE application_status = 'Selected') as total_hires");
                    ResultSet totalRs = totalStmt.executeQuery();
                    
                    int totalCompanies = 0, totalVacancies = 0, totalApplications = 0, totalHires = 0;
                    if (totalRs.next()) {
                        totalCompanies = totalRs.getInt("total_companies");
                        totalVacancies = totalRs.getInt("total_vacancies");
                        totalApplications = totalRs.getInt("total_applications");
                        totalHires = totalRs.getInt("total_hires");
                    }
                    totalRs.close();
                    totalStmt.close();
            %>

            <div class="col-md-3">
                <div class="card bg-primary text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h4><%= totalCompanies %></h4>
                                <p class="mb-0">Active Companies</p>
                            </div>
                            <div class="align-self-center">
                                <i class="fas fa-building fa-2x"></i>
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
                                <h4><%= totalVacancies %></h4>
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
                <div class="card bg-warning text-white">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <h4><%= totalHires %></h4>
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

        <!-- Company Performance Table -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-table"></i> Company Performance Rankings</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Rank</th>
                                        <th>Company Name</th>
                                        <th>Active Vacancies</th>
                                        <th>Total Applications</th>
                                        <th>Interviews</th>
                                        <th>Hires</th>
                                        <th>Success Rate</th>
                                        <th>Performance Level</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        PreparedStatement companyStmt = connection.prepareStatement(
                                            "SELECT c.companyID, c.companyName, c.companyCategory, " +
                                            "COUNT(DISTINCT v.vacancyID) as active_vacancies, " +
                                            "COUNT(DISTINCT a.applicationID) as total_applications, " +
                                            "COUNT(DISTINCT i.interviewID) as total_interviews, " +
                                            "SUM(CASE WHEN a.application_status = 'Selected' THEN 1 ELSE 0 END) as total_hires " +
                                            "FROM company c " +
                                            "LEFT JOIN vacancy v ON c.companyID = v.companyID AND v.job_status = 'Active' " +
                                            "LEFT JOIN application a ON c.companyID = a.companyID " +
                                            "LEFT JOIN interview i ON c.companyID = i.companyID " +
                                            "WHERE c.status = 'active' " +
                                            "GROUP BY c.companyID, c.companyName, c.companyCategory " +
                                            "ORDER BY total_hires DESC, total_applications DESC");
                                        ResultSet companyRs = companyStmt.executeQuery();

                                        int rank = 1;
                                        while (companyRs.next()) {
                                            int activeVacancies = companyRs.getInt("active_vacancies");
                                            int totalApps = companyRs.getInt("total_applications");
                                            int totalInterviews = companyRs.getInt("total_interviews");
                                            int companyHires = companyRs.getInt("total_hires");
                                            
                                            double successRate = totalApps > 0 ? (companyHires * 100.0 / totalApps) : 0;
                                            
                                            // Determine performance level
                                            String performanceLevel = "";
                                            String levelClass = "";
                                            if (successRate >= 20) {
                                                performanceLevel = "Excellent";
                                                levelClass = "bg-success";
                                            } else if (successRate >= 15) {
                                                performanceLevel = "Very Good";
                                                levelClass = "bg-info";
                                            } else if (successRate >= 10) {
                                                performanceLevel = "Good";
                                                levelClass = "bg-primary";
                                            } else if (successRate >= 5) {
                                                performanceLevel = "Average";
                                                levelClass = "bg-warning";
                                            } else {
                                                performanceLevel = "Needs Improvement";
                                                levelClass = "bg-danger";
                                            }
                                    %>
                                    <tr>
                                        <td>
                                            <% if (rank <= 3) { %>
                                            <span class="badge bg-warning"><%= rank %></span>
                                            <% } else { %>
                                            <%= rank %>
                                            <% } %>
                                        </td>
                                        <td>
                                            <strong><%= companyRs.getString("companyName") %></strong><br>
                                            <small class="text-muted"><%= companyRs.getString("companyCategory") %></small>
                                        </td>
                                        <td><%= activeVacancies %></td>
                                        <td><%= totalApps %></td>
                                        <td><%= totalInterviews %></td>
                                        <td><%= companyHires %></td>
                                        <td><%= String.format("%.1f%%", successRate) %></td>
                                        <td>
                                            <span class="badge <%= levelClass %>">
                                                <%= performanceLevel %>
                                            </span>
                                        </td>
                                        <td>
                                            <a href="adminCompany.jsp?companyId=<%= companyRs.getInt("companyID") %>" 
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-eye"></i> View Details
                                            </a>
                                        </td>
                                    </tr>
                                    <%
                                            rank++;
                                        }
                                        companyRs.close();
                                        companyStmt.close();
                                    %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Performance Level Legend -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h6><i class="fas fa-info-circle"></i> Performance Level Criteria</h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-2">
                                <span class="badge bg-success">Excellent</span><br>
                                <small>≥20% Success Rate</small>
                            </div>
                            <div class="col-md-2">
                                <span class="badge bg-info">Very Good</span><br>
                                <small>15-19% Success Rate</small>
                            </div>
                            <div class="col-md-2">
                                <span class="badge bg-primary">Good</span><br>
                                <small>10-14% Success Rate</small>
                            </div>
                            <div class="col-md-2">
                                <span class="badge bg-warning">Average</span><br>
                                <small>5-9% Success Rate</small>
                            </div>
                            <div class="col-md-2">
                                <span class="badge bg-danger">Needs Improvement</span><br>
                                <small><5% Success Rate</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger'>Error loading reports: " + e.getMessage() + "</div>");
                    e.printStackTrace();
                } finally {
                    if (connection != null) connection.close();
                }
        %>
    </div>
</body>
</html>