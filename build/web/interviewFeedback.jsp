<%@page import="com.classes.company"%>
<%@page import="java.sql.*"%>
<%@page import="com.classes.DBConnector"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Interview Feedback & Scoring</title>
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

        String interviewId = request.getParameter("interviewId");
        if (interviewId == null) {
            response.sendRedirect("manageApplications.jsp");
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
                        <li class="nav-item"><a class="nav-link" href="backend/logout.jsp">Logout</a></li>
                    </ul>
                </div>
            </div>
        </nav>
    </header>

    <div class="container-fluid mt-4">
        <%
            Connection connection = null;
            try {
                connection = DBConnector.getCon();
                
                // Get interview and candidate details
                PreparedStatement interviewStmt = connection.prepareStatement(
                    "SELECT i.*, s.firstName, s.lastName, s.email, v.title as vacancy_title " +
                    "FROM interview i " +
                    "JOIN seeker s ON i.seekerID = s.seekerID " +
                    "JOIN vacancy v ON i.vacancyID = v.vacancyID " +
                    "WHERE i.interview_id = ? AND i.companyID = ?");
                interviewStmt.setString(1, interviewId);
                interviewStmt.setString(2, String.valueOf(company.getCompanyID()));
                ResultSet interviewRs = interviewStmt.executeQuery();
                
                if (interviewRs.next()) {
        %>

        <div class="row">
            <div class="col-12">
                <h2><i class="fas fa-clipboard-check"></i> Interview Feedback & Scoring</h2>
                <p class="text-muted">Provide detailed feedback and scores for the interview</p>
            </div>
        </div>

        <!-- Candidate Information -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5><i class="fas fa-user"></i> Candidate Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Name:</strong> <%= interviewRs.getString("firstName") %> <%= interviewRs.getString("lastName") %></p>
                                <p><strong>Email:</strong> <%= interviewRs.getString("email") %></p>
                                <p><strong>Position:</strong> <%= interviewRs.getString("vacancy_title") %></p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Interview Date:</strong> <%= interviewRs.getDate("interview_date") %></p>
                                <p><strong>Interview Time:</strong> <%= interviewRs.getTime("interview_time") %></p>
                                <p><strong>Interviewer:</strong> <%= interviewRs.getString("interviewer_name") %></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Feedback Form -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-star"></i> Interview Evaluation</h5>
                    </div>
                    <div class="card-body">
                        <form action="backend/saveInterviewFeedback.jsp" method="POST">
                            <input type="hidden" name="interviewId" value="<%= interviewId %>">
                            
                            <!-- Scoring Criteria -->
                            <div class="row mb-4">
                                <div class="col-12">
                                    <h6 class="text-primary">Scoring Criteria (1-10 scale)</h6>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Technical Skills</label>
                                        <select class="form-select" name="technical_score" required>
                                            <option value="">Select score...</option>
                                            <% for (int i = 1; i <= 10; i++) { %>
                                            <option value="<%= i %>"><%= i %> - <%= i <= 3 ? "Poor" : i <= 6 ? "Average" : i <= 8 ? "Good" : "Excellent" %></option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Communication Skills</label>
                                        <select class="form-select" name="communication_score" required>
                                            <option value="">Select score...</option>
                                            <% for (int i = 1; i <= 10; i++) { %>
                                            <option value="<%= i %>"><%= i %> - <%= i <= 3 ? "Poor" : i <= 6 ? "Average" : i <= 8 ? "Good" : "Excellent" %></option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Problem Solving</label>
                                        <select class="form-select" name="problem_solving_score" required>
                                            <option value="">Select score...</option>
                                            <% for (int i = 1; i <= 10; i++) { %>
                                            <option value="<%= i %>"><%= i %> - <%= i <= 3 ? "Poor" : i <= 6 ? "Average" : i <= 8 ? "Good" : "Excellent" %></option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Cultural Fit</label>
                                        <select class="form-select" name="cultural_fit_score" required>
                                            <option value="">Select score...</option>
                                            <% for (int i = 1; i <= 10; i++) { %>
                                            <option value="<%= i %>"><%= i %> - <%= i <= 3 ? "Poor" : i <= 6 ? "Average" : i <= 8 ? "Good" : "Excellent" %></option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Experience Relevance</label>
                                        <select class="form-select" name="experience_score" required>
                                            <option value="">Select score...</option>
                                            <% for (int i = 1; i <= 10; i++) { %>
                                            <option value="<%= i %>"><%= i %> - <%= i <= 3 ? "Poor" : i <= 6 ? "Average" : i <= 8 ? "Good" : "Excellent" %></option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Overall Impression</label>
                                        <select class="form-select" name="overall_score" required>
                                            <option value="">Select score...</option>
                                            <% for (int i = 1; i <= 10; i++) { %>
                                            <option value="<%= i %>"><%= i %> - <%= i <= 3 ? "Poor" : i <= 6 ? "Average" : i <= 8 ? "Good" : "Excellent" %></option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <!-- Detailed Feedback -->
                            <div class="mb-4">
                                <h6 class="text-primary">Detailed Feedback</h6>
                                
                                <div class="mb-3">
                                    <label class="form-label">Strengths</label>
                                    <textarea class="form-control" name="strengths" rows="3" 
                                              placeholder="What were the candidate's key strengths during the interview?"></textarea>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Areas for Improvement</label>
                                    <textarea class="form-control" name="weaknesses" rows="3" 
                                              placeholder="What areas could the candidate improve on?"></textarea>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Additional Comments</label>
                                    <textarea class="form-control" name="additional_comments" rows="4" 
                                              placeholder="Any additional observations or comments about the interview..."></textarea>
                                </div>
                            </div>

                            <!-- Recommendation -->
                            <div class="mb-4">
                                <h6 class="text-primary">Recommendation</h6>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="recommendation" value="Strongly Recommend" id="recommend1">
                                    <label class="form-check-label text-success" for="recommend1">
                                        <i class="fas fa-thumbs-up"></i> Strongly Recommend
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="recommendation" value="Recommend" id="recommend2">
                                    <label class="form-check-label text-info" for="recommend2">
                                        <i class="fas fa-check"></i> Recommend
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="recommendation" value="Maybe" id="recommend3">
                                    <label class="form-check-label text-warning" for="recommend3">
                                        <i class="fas fa-question"></i> Maybe
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="recommendation" value="Do Not Recommend" id="recommend4">
                                    <label class="form-check-label text-danger" for="recommend4">
                                        <i class="fas fa-thumbs-down"></i> Do Not Recommend
                                    </label>
                                </div>
                            </div>

                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i> Save Feedback
                                </button>
                                <a href="manageApplications.jsp" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Back to Applications
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <%
                } else {
                    out.println("<div class='alert alert-danger'>Interview not found or access denied.</div>");
                }
                interviewRs.close();
                interviewStmt.close();
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error loading interview details: " + e.getMessage() + "</div>");
                e.printStackTrace();
            } finally {
                if (connection != null) connection.close();
            }
        %>
    </div>
</body>
</html>