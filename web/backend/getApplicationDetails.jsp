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
            String query = "SELECT a.*, v.title as job_title, v.location, v.type as job_type, v.salary, " +
                         "v.description, v.requirements, v.application_deadline, v.required_skills, " +
                         "c.companyName, c.companyEmail, c.companyAddress, c.companyWeb, c.companyAbout " +
                         "FROM application a " +
                         "JOIN vacancy v ON a.vacancyID = v.vacancyID " +
                         "JOIN company c ON a.companyID = c.companyID " +
                         "WHERE a.applicationID = ? AND a.seekerID = ?";
            
            PreparedStatement stmt = connection.prepareStatement(query);
            stmt.setString(1, applicationId);
            stmt.setString(2, seeker.useSeekerID());
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String status = rs.getString("application_status");
                if (status == null) status = "Applied";
%>

<div class="row">
    <div class="col-md-6">
        <h5><i class="fas fa-briefcase"></i> Job Information</h5>
        <div class="card mb-3">
            <div class="card-body">
                <h6 class="card-title"><%= rs.getString("job_title") %></h6>
                <p class="card-text">
                    <strong>Company:</strong> <%= rs.getString("companyName") %><br>
                    <strong>Location:</strong> <%= rs.getString("location") %><br>
                    <strong>Type:</strong> <%= rs.getString("job_type") %><br>
                    <strong>Salary:</strong> <%= rs.getString("salary") %>
                </p>
                <% if (rs.getDate("application_deadline") != null) { %>
                <p><strong>Application Deadline:</strong> <%= rs.getDate("application_deadline") %></p>
                <% } %>
            </div>
        </div>
        
        <h6><i class="fas fa-building"></i> Company Information</h6>
        <div class="card mb-3">
            <div class="card-body">
                <p class="card-text">
                    <strong>Email:</strong> <%= rs.getString("companyEmail") %><br>
                    <strong>Address:</strong> <%= rs.getString("companyAddress") %><br>
                    <% if (rs.getString("companyWeb") != null && !rs.getString("companyWeb").trim().isEmpty()) { %>
                    <strong>Website:</strong> <a href="<%= rs.getString("companyWeb") %>" target="_blank"><%= rs.getString("companyWeb") %></a><br>
                    <% } %>
                </p>
                <% if (rs.getString("companyAbout") != null && !rs.getString("companyAbout").trim().isEmpty()) { %>
                <p><strong>About:</strong> <%= rs.getString("companyAbout") %></p>
                <% } %>
            </div>
        </div>
    </div>
    
    <div class="col-md-6">
        <h5><i class="fas fa-info-circle"></i> Application Status</h5>
        <div class="card mb-3">
            <div class="card-body">
                <p>
                    <strong>Current Status:</strong> 
                    <span class="badge bg-primary"><%= status %></span>
                </p>
                <p><strong>Applied Date:</strong> <%= rs.getTimestamp("applied_date") %></p>
                <% if (rs.getTimestamp("status_updated_at") != null) { %>
                <p><strong>Last Updated:</strong> <%= rs.getTimestamp("status_updated_at") %></p>
                <% } %>
                <% if (rs.getString("recruiter_notes") != null && !rs.getString("recruiter_notes").trim().isEmpty()) { %>
                <div class="alert alert-info">
                    <strong>Recruiter Notes:</strong><br>
                    <%= rs.getString("recruiter_notes") %>
                </div>
                <% } %>
            </div>
        </div>
        
        <!-- Required Skills (if available) -->
        <% if (rs.getString("required_skills") != null && !rs.getString("required_skills").trim().isEmpty()) { %>
        <h6><i class="fas fa-cogs"></i> Required Skills</h6>
        <div class="card mb-3">
            <div class="card-body">
                <div id="skillsContainer">
                    <!-- Skills will be parsed and displayed here -->
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>

<div class="row">
    <div class="col-12">
        <h5><i class="fas fa-file-alt"></i> Job Description</h5>
        <div class="card">
            <div class="card-body">
                <p><%= rs.getString("description") %></p>
                <% if (rs.getString("requirements") != null && !rs.getString("requirements").trim().isEmpty()) { %>
                <h6>Requirements:</h6>
                <p><%= rs.getString("requirements") %></p>
                <% } %>
            </div>
        </div>
    </div>
</div>

<% if (rs.getString("required_skills") != null && !rs.getString("required_skills").trim().isEmpty()) { %>
<script>
    // Parse and display skills
    try {
        const skills = JSON.parse('<%= rs.getString("required_skills").replace("'", "\\'") %>');
        const container = document.getElementById('skillsContainer');
        if (skills && skills.length > 0) {
            skills.forEach(skill => {
                const skillBadge = document.createElement('span');
                skillBadge.className = 'badge bg-secondary me-2 mb-2';
                skillBadge.textContent = skill.name + ' (' + skill.level + ')';
                container.appendChild(skillBadge);
            });
        } else {
            container.innerHTML = '<p class="text-muted">No specific skills listed</p>';
        }
    } catch (e) {
        document.getElementById('skillsContainer').innerHTML = '<p class="text-muted">Skills information not available</p>';
    }
</script>
<% } %>

<%
            } else {
                out.println("<div class='alert alert-danger'>Application not found or access denied</div>");
            }
            
            rs.close();
            stmt.close();
            connection.close();
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error loading application details: " + e.getMessage() + "</div>");
        e.printStackTrace();
    }
%>