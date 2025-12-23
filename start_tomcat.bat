@echo off
echo ========================================
echo Starting Tomcat Server for TrendHire
echo ========================================
echo.

set CATALINA_HOME=C:\apache-tomcat-9.0.113
set JAVA_HOME=C:\Program Files\Java\jdk1.8.0_202

echo Setting environment variables...
echo CATALINA_HOME: %CATALINA_HOME%
echo JAVA_HOME: %JAVA_HOME%
echo.

echo Checking if Tomcat is already running...
netstat -an | findstr :8080 >nul
if %ERRORLEVEL% EQU 0 (
    echo Tomcat is already running on port 8080
    echo Stopping existing Tomcat...
    call "%CATALINA_HOME%\bin\shutdown.bat"
    timeout /t 5 /nobreak >nul
)

echo Starting Tomcat...
call "%CATALINA_HOME%\bin\startup.bat"

echo.
echo Waiting for Tomcat to start...
timeout /t 10 /nobreak >nul

echo.
echo Checking if Tomcat started successfully...
netstat -an | findstr :8080 >nul
if %ERRORLEVEL% EQU 0 (
    echo ✅ Tomcat started successfully!
    echo.
    echo TrendHire Application URLs:
    echo ========================================
    echo Main Page: http://localhost:8080/TrendHire/
    echo Admin Login: http://localhost:8080/TrendHire/adminLogin.jsp
    echo Company Login: http://localhost:8080/TrendHire/companyLogin.jsp
    echo Seeker Login: http://localhost:8080/TrendHire/seekerLogin.jsp
    echo.
    echo Login Credentials:
    echo Admin: admin / admin
    echo Company: techcorp / hello
    echo Seeker: johndoe / hello
    echo.
    echo Opening application in browser...
    start http://localhost:8080/TrendHire/
) else (
    echo ❌ Tomcat failed to start
    echo Check the logs in: %CATALINA_HOME%\logs\
)

echo.
pause