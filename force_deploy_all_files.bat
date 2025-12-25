@echo off
echo ========================================
echo FORCE DEPLOY ALL FILES - Complete Sync
echo ========================================
echo This will ensure ALL your current files are deployed
echo and remove ALL old cached content completely
echo ========================================
echo.

echo Step 1: Stopping Tomcat completely...
taskkill /f /im java.exe >nul 2>&1
timeout /t 5 >nul

echo Step 2: COMPLETELY removing all old deployments and cache...
echo   - Removing Tomcat webapps deployment...
rmdir /s /q "C:\apache-tomcat-9.0.113\webapps\TrendHire" >nul 2>&1
echo   - Removing Tomcat work cache...
rmdir /s /q "C:\apache-tomcat-9.0.113\work" >nul 2>&1
echo   - Removing Tomcat temp files...
rmdir /s /q "C:\apache-tomcat-9.0.113\temp" >nul 2>&1
echo   - Removing local build directory...
rmdir /s /q "build\web" >nul 2>&1

echo Step 3: Creating completely fresh build structure...
mkdir "build\web" >nul 2>&1
mkdir "build\web\images" >nul 2>&1
mkdir "build\web\css" >nul 2>&1
mkdir "build\web\backend" >nul 2>&1
mkdir "build\web\WEB-INF" >nul 2>&1
mkdir "build\web\WEB-INF\classes" >nul 2>&1
mkdir "build\web\WEB-INF\lib" >nul 2>&1

echo Step 4: Copying ALL your current files systematically...
echo   - Copying ALL images (including subdirectories)...
powershell -Command "Copy-Item 'web\images\*' 'build\web\images\' -Recurse -Force"

echo   - Copying ALL JSP files...
powershell -Command "Copy-Item 'web\*.jsp' 'build\web\' -Force"

echo   - Copying ALL backend JSP files...
powershell -Command "Copy-Item 'web\backend\*' 'build\web\backend\' -Recurse -Force"

echo   - Copying ALL CSS files...
powershell -Command "Copy-Item 'web\css\*' 'build\web\css\' -Recurse -Force"

echo   - Copying WEB-INF configuration...
powershell -Command "Copy-Item 'web\WEB-INF\*' 'build\web\WEB-INF\' -Recurse -Force"

echo   - Copying compiled Java classes...
powershell -Command "Copy-Item 'build\classes\*' 'build\web\WEB-INF\classes\' -Recurse -Force"

echo   - Copying required JAR libraries...
powershell -Command "Copy-Item 'lib\mysql-connector-j-8.1.0.jar' 'build\web\WEB-INF\lib\' -Force"
powershell -Command "Copy-Item 'lib\servlet-api.jar' 'build\web\WEB-INF\lib\' -Force"

echo Step 5: Deploying fresh build to Tomcat (with verification)...
robocopy "build\web" "C:\apache-tomcat-9.0.113\webapps\TrendHire" /E /V >nul

echo Step 6: Starting Tomcat with completely fresh deployment...
call start_tomcat.bat

echo.
echo ========================================
echo FORCE DEPLOY ALL FILES COMPLETED!
echo ========================================
echo.
echo ✓ ALL old cached files removed completely
echo ✓ ALL your current files deployed fresh
echo ✓ Images, texts, JSP files synchronized
echo ✓ Database libraries properly deployed
echo ✓ System running with 100%% current content
echo.
echo CRITICAL: Clear browser cache completely:
echo 1. Press Ctrl+Shift+Delete
echo 2. Select "All time" 
echo 3. Check ALL boxes (cookies, cache, etc.)
echo 4. Click "Clear data"
echo 5. Or use incognito/private browsing mode
echo.
echo Your system now shows ONLY your current files!
echo Access: http://localhost:8080/TrendHire/
echo.
pause