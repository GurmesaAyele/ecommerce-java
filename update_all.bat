@echo off
echo ========================================
echo Updating All TrendHire Files
echo ========================================
echo.

echo Copying updated files to Tomcat...
copy "web\manageApplications.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\manageApplications.jsp"
copy "web\backend\updateApplicationStatus.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\backend\updateApplicationStatus.jsp"
copy "web\backend\scheduleInterview.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\backend\scheduleInterview.jsp"
copy "web\companyProfile.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\companyProfile.jsp"
copy "web\postvacancy.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\postvacancy.jsp"
copy "web\backend\enhanced_post_job_process.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\backend\enhanced_post_job_process.jsp"

echo.
echo ========================================
echo Update Complete!
echo ========================================
echo.
echo New Features Added:
echo ✅ Application Management System
echo ✅ Status Updates (Applied, Under Review, Shortlisted, etc.)
echo ✅ Interview Scheduling
echo ✅ Rejection with Reasons
echo ✅ Recruiter Notes
echo ✅ Application Filtering
echo.
echo Access at: http://localhost:8080/TrendHire/manageApplications.jsp
echo.
pause