@echo off
echo Opening TrendHire Page Launcher...
echo.

REM Check if WAMP/XAMPP is running
echo Checking if Apache is running...
netstat -an | find ":80 " >nul
if errorlevel 1 (
    echo.
    echo ⚠️  Apache is not running on port 80!
    echo Please start WAMP/XAMPP first, then run this again.
    echo.
    pause
    exit /b 1
)

echo ✅ Apache is running
echo.
echo Opening launcher page in your default browser...
echo.

REM Open the launcher page
start http://localhost/trendhire/launcher.html

echo.
echo 🚀 Launcher opened! Use it to navigate to all TrendHire pages.
echo.
echo Quick links:
echo - Database Setup: http://localhost/trendhire/reset_database.php
echo - Main App: http://localhost:8080/trendhire/web/index.jsp
echo - Job Posting: http://localhost:8080/trendhire/web/postvacancy.jsp
echo.
pause