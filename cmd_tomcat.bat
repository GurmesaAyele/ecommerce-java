@echo off
echo ================================================================================
echo                            TOMCAT SERVER COMMAND
echo ================================================================================
echo.

echo [1] Stopping existing Tomcat processes...
taskkill /f /im java.exe 2>nul
timeout /t 2 >nul

echo [2] Starting Tomcat server...
if exist "start_tomcat.bat" (
    echo Using start_tomcat.bat...
    start "Tomcat Server" start_tomcat.bat
) else (
    echo start_tomcat.bat not found, trying alternative methods...
    
    if exist "%CATALINA_HOME%\bin\startup.bat" (
        echo Using CATALINA_HOME startup script...
        start "Tomcat" "%CATALINA_HOME%\bin\startup.bat"
    ) else (
        echo Manual Tomcat start required
        echo Please navigate to your Tomcat bin directory and run:
        echo startup.bat
    )
)

echo.
echo [3] Waiting for Tomcat to start...
timeout /t 15 >nul

echo [4] Checking Tomcat status...
netstat -an | find "8080" >nul
if errorlevel 1 (
    echo ⚠️  Tomcat might still be starting...
    echo Check the Tomcat console window for any errors
    echo If startup fails, check:
    echo - JAVA_HOME is set correctly
    echo - Port 8080 is not in use by another application
    echo - Tomcat configuration is correct
) else (
    echo ✅ Tomcat is running on port 8080
    echo Application should be available at:
    echo http://localhost:8080/trendhire
)

echo.
echo [5] Opening application...
timeout /t 3 >nul
start http://localhost:8080/trendhire/web/index.jsp

pause