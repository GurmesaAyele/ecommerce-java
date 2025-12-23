@echo off
echo ========================================
echo Update TrendHIRE Deployment
echo ========================================
echo.

REM Find Tomcat webapps directory
set TOMCAT_WEBAPPS=""
if exist "C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\TrendHIRE" (
    set TOMCAT_WEBAPPS=C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps
)
if exist "C:\apache-tomcat-9.0.113\webapps\TrendHIRE" (
    set TOMCAT_WEBAPPS=C:\apache-tomcat-9.0.113\webapps
)
if exist "C:\xampp\tomcat\webapps\TrendHIRE" (
    set TOMCAT_WEBAPPS=C:\xampp\tomcat\webapps
)

if %TOMCAT_WEBAPPS%=="" (
    echo Cannot find TrendHIRE deployment in Tomcat webapps
    echo Please manually copy web\postvacancy.jsp to your Tomcat webapps\TrendHIRE\ folder
    pause
    exit /b 1
)

echo Found TrendHIRE at: %TOMCAT_WEBAPPS%\TrendHIRE

echo Step 1: Backing up current postvacancy.jsp...
if exist "%TOMCAT_WEBAPPS%\TrendHIRE\postvacancy.jsp" (
    copy "%TOMCAT_WEBAPPS%\TrendHIRE\postvacancy.jsp" "%TOMCAT_WEBAPPS%\TrendHIRE\postvacancy.jsp.backup"
)

echo Step 2: Updating postvacancy.jsp with enhanced version...
copy "web\postvacancy.jsp" "%TOMCAT_WEBAPPS%\TrendHIRE\postvacancy.jsp"

echo Step 3: Updating backend processor...
if not exist "%TOMCAT_WEBAPPS%\TrendHIRE\backend" mkdir "%TOMCAT_WEBAPPS%\TrendHIRE\backend"
copy "web\backend\enhanced_post_job_process.jsp" "%TOMCAT_WEBAPPS%\TrendHIRE\backend\"

echo Step 4: Compiling Java classes...
if exist "src\java" (
    if not exist "%TOMCAT_WEBAPPS%\TrendHIRE\WEB-INF\classes" mkdir "%TOMCAT_WEBAPPS%\TrendHIRE\WEB-INF\classes"
    javac -cp "lib\*" -d "%TOMCAT_WEBAPPS%\TrendHIRE\WEB-INF\classes" src\java\com\classes\*.java 2>nul
)

echo ========================================
echo Update Complete!
echo ========================================
echo.
echo Updated files:
echo - postvacancy.jsp (enhanced job posting form)
echo - backend\enhanced_post_job_process.jsp
echo.
echo Clear your browser cache (Ctrl+F5) and try:
echo http://localhost:8080/TrendHIRE/postvacancy.jsp
echo.
echo Opening updated page...
start http://localhost:8080/TrendHIRE/postvacancy.jsp

pause