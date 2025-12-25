<%@page import="com.classes.company"%>
<%@page import="java.sql.*"%>
<%@page import="com.classes.DBConnector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Selection Criteria Management</title>
    <link rel="stylesheet" type="text/css" href="css/stylesheet.css?v=<%= System.currentTimeMillis() %>">
    <link href="css/bootstrap.min.css?v=<%= System.currentTimeMillis() %>" rel="stylesheet">
    <script src="https://kit.fontawesome.com/0008de2df6.js" crossorigin="anonymous"></script>
</head>
<body>
    <%
        company company = (company) session.getAttribute("company");
        if (company == null) {
            response.sendRedirect("companyLogin.jsp");
            return;
        }
    %>

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
                        <li class="nav-item"><a class="nav-link active" href="selectionCriteria.jsp">Selection Criteria</a></li>
                        <li class="nav-item"><a class="nav-link" href="backend/logout.jsp">Logout</a></li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>

    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-12">
                <h2><i class="fas fa-filter"></i> Selection Criteria Management</h2>
                <p class="text-muted">Define and manage selection criteria for your job vacancies</p>
            </div>
        </div>

        <!-- Add New Criteria Form -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-plus"></i> Add New Selection Criteria</h5>
                    </div>
                    <div class="card-body">
                        <form action="backend/saveSelectionCriteria.jsp" method="POST">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="vacancySelect" class="form-label">Select Vacancy</label>
                                        <select class="form-select" id="vacancySelect" name="vacancyID" required>
                                            <option value="">Choose a vacancy...</option>
                                            <%
                                                Connection connection = DBConnector.getCon();
                                                PreparedStatement vacStmt = connection.prepareStatement(
                                                    "SELECT vacancyID, title FROM vacancy WHERE companyID = ? AND job_status = 'Active'");
                                                vacStmt.setString(1, String.valueOf(company.getCompanyID()));
                                                ResultSet vacRs = vacStmt.executeQuery();
                                                while (vacRs.next()) {
                                            %>
                                            <option value="<%= vacRs.getInt("vacancyID") %>"><%= vacRs.getString("title") %></option>
                                            <%
                                                }
                                                vacRs.close();
                                                vacStmt.close();
                                            %>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="criteriaType" class="form-label">Criteria Type</label>
                                        <select class="form-select" id="criteriaType" name="criteriaType" required>
                                            <option value="">Select type...</option>
                                            <option value="Education">Education</option>
                                            <option value="Experience">Experience</option>
                                            <option value="Skills">Skills</option>
                                            <option value="Certification">Certification</option>
                                            <option value="Language">Language</option>
                                            <option value="Other">Other</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-8">
                                    <div class="mb-3">
                                        <label for="criteriaDescription" class="form-label">Criteria Description</label>
                                        <input type="text" class="form-control" id="criteriaDescription" name="criteriaDescription" 
                                               placeholder="e.g., Bachelor's degree in Computer Science" required>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="mb-3">
                                        <label for="priority" class="form-label">Priority</label>
                                        <select class="form-select" id="priority" name="priority" required>
                                            <option value="High">High (Must Have)</option>
                                            <option value="Medium">Medium (Preferred)</option>
                                            <option value="Low">Low (Nice to Have)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="weightage" class="form-label">Weightage (%)</label>
                                <input type="number" class="form-control" id="weightage" name="weightage" 
                                       min="1" max="100" placeholder="Enter weightage percentage" required>
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> Save Criteria
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Existing Criteria -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-list"></i> Existing Selection Criteria</h5>
                    </div>
                    <div class="card-body">
                        <%
                            try {
                                PreparedStatement criteriaStmt = connection.prepareStatement(
                                    "SELECT sc.*, v.title as vacancy_title FROM selection_criteria sc " +
                                    "JOIN vacancy v ON sc.vacancyID = v.vacancyID " +
                                    "WHERE v.companyID = ? ORDER BY v.title, sc.priority DESC, sc.weightage DESC");
                                criteriaStmt.setString(1, String.valueOf(company.getCompanyID()));
                                ResultSet criteriaRs = criteriaStmt.executeQuery();

                                String currentVacancy = "";
                                while (criteriaRs.next()) {
                                    String vacancyTitle = criteriaRs.getString("vacancy_title");
                                    if (!vacancyTitle.equals(currentVacancy)) {
                                        if (!currentVacancy.isEmpty()) {
                                            out.println("</div></div>");
                                        }
                                        currentVacancy = vacancyTitle;
                        %>
                        <div class="vacancy-group mb-4">
                            <h6 class="text-primary"><i class="fas fa-briefcase"></i> <%= vacancyTitle %></h6>
                            <div class="criteria-list">
                        <%
                                    }
                                    String priorityClass = "";
                                    String priorityIcon = "";
                                    switch (criteriaRs.getString("priority")) {
                                        case "High":
                                            priorityClass = "text-danger";
                                            priorityIcon = "fas fa-exclamation-circle";
                                            break;
                                        case "Medium":
                                            priorityClass = "text-warning";
                                            priorityIcon = "fas fa-star";
                                            break;
                                        case "Low":
                                            priorityClass = "text-info";
                                            priorityIcon = "fas fa-info-circle";
                                            break;
                                    }
                        %>
                                <div class="card mb-2">
                                    <div class="card-body py-2">
                                        <div class="row align-items-center">
                                            <div class="col-md-2">
                                                <span class="badge bg-secondary"><%= criteriaRs.getString("criteria_type") %></span>
                                            </div>
                                            <div class="col-md-5">
                                                <%= criteriaRs.getString("criteria_description") %>
                                            </div>
                                            <div class="col-md-2">
                                                <span class="<%= priorityClass %>">
                                                    <i class="<%= priorityIcon %>"></i> <%= criteriaRs.getString("priority") %>
                                                </span>
                                            </div>
                                            <div class="col-md-2">
                                                <span class="badge bg-primary"><%= criteriaRs.getInt("weightage") %>%</span>
                                            </div>
                                            <div class="col-md-1">
                                                <button class="btn btn-sm btn-outline-danger" 
                                                        onclick="deleteCriteria(<%= criteriaRs.getInt("criteria_id") %>)">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        <%
                                }
                                if (!currentVacancy.isEmpty()) {
                                    out.println("</div></div>");
                                }
                                criteriaRs.close();
                                criteriaStmt.close();
                            } catch (Exception e) {
                                out.println("<div class='alert alert-danger'>Error loading criteria: " + e.getMessage() + "</div>");
                            } finally {
                                if (connection != null) connection.close();
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function deleteCriteria(criteriaId) {
            if (confirm('Are you sure you want to delete this selection criteria?')) {
                window.location.href = 'backend/deleteSelectionCriteria.jsp?criteriaId=' + criteriaId;
            }
        }
    </script>
</body>
</html>