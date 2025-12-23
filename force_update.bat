@echo off
echo ========================================
echo Force Update TrendHIRE Form
echo ========================================
echo.

echo Step 1: Stopping Tomcat to clear cache...
taskkill /f /im java.exe 2>nul
timeout /t 3 >nul

echo Step 2: Finding TrendHIRE deployment...
set TRENDHIRE_PATH=""

REM Check common Tomcat locations
if exist "C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\TrendHIRE\postvacancy.jsp" (
    set TRENDHIRE_PATH=C:\Program Files\Apache Software Foundation\Tomcat 9.0\webapps\TrendHIRE
)
if exist "C:\apache-tomcat-9.0.113\webapps\TrendHIRE\postvacancy.jsp" (
    set TRENDHIRE_PATH=C:\apache-tomcat-9.0.113\webapps\TrendHIRE
)
if exist "C:\xampp\tomcat\webapps\TrendHIRE\postvacancy.jsp" (
    set TRENDHIRE_PATH=C:\xampp\tomcat\webapps\TrendHIRE
)

REM Check in current directory build
if exist "build\web\postvacancy.jsp" (
    set TRENDHIRE_PATH=build\web
)

if %TRENDHIRE_PATH%=="" (
    echo Cannot find TrendHIRE deployment!
    echo Please manually replace the postvacancy.jsp file in your Tomcat webapps\TrendHIRE folder
    pause
    exit /b 1
)

echo Found TrendHIRE at: %TRENDHIRE_PATH%

echo Step 3: Deleting old cached file...
del "%TRENDHIRE_PATH%\postvacancy.jsp" 2>nul

echo Step 4: Copying new enhanced form...
copy "web\postvacancy.jsp" "%TRENDHIRE_PATH%\postvacancy.jsp"

echo Step 5: Updating timestamp to force reload...
echo. >> "%TRENDHIRE_PATH%\postvacancy.jsp"

echo Step 6: Restarting Tomcat...
call start_tomcat.bat

echo Step 7: Waiting for server restart...
timeout /t 15 >nul

echo ========================================
echo Force Update Complete!
echo ========================================
echo.
echo The enhanced form should now be visible at:
echo http://localhost:8080/TrendHIRE/postvacancy.jsp
echo.
echo IMPORTANT: Clear your browser cache!
echo - Press Ctrl+Shift+R (hard refresh)
echo - Or open in incognito/private mode
echo.
echo Opening page in 5 seconds...
timeout /t 5 >nul
start http://localhost:8080/TrendHIRE/postvacancy.jsp

pause