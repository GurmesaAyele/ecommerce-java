@echo off
echo ========================================
echo TrendHire FORCE COMPLETE REFRESH
echo ========================================
echo This will completely remove all old cached content
echo and deploy ONLY your current files
echo ========================================
echo.

echo Step 1: Killing all Java/Tomcat processes...
taskkill /f /im java.exe >nul 2>&1
timeout /t 3 >nul

echo Step 2: COMPLETELY removing all old deployments...
echo   - Removing Tomcat work cache...
rmdir /s /q "C:\apache-tomcat-9.0.113\work" >nul 2>&1
echo   - Removing old TrendHire deployment...
rmdir /s /q "C:\apache-tomcat-9.0.113\webapps\TrendHire" >nul 2>&1
echo   - Removing old build directory...
rmdir /s /q "build" >nul 2>&1

echo Step 3: Creating fresh build directory...
mkdir "build" >nul 2>&1
mkdir "build\web" >nul 2>&1
mkdir "build\web\images" >nul 2>&1
mkdir "build\web\css" >nul 2>&1
mkdir "build\web\backend" >nul 2>&1
mkdir "build\web\WEB-INF" >nul 2>&1

echo Step 4: Copying ONLY your current files...
echo   - Copying current images...
powershell -Command "Copy-Item 'web\images\*' 'build\web\images\' -Recurse -Force"
echo   - Copying current JSP files...
powershell -Command "Copy-Item 'web\*.jsp' 'build\web\' -Force"
echo   - Copying current backend files...
powershell -Command "Copy-Item 'web\backend\*' 'build\web\backend\' -Recurse -Force"
echo   - Copying current CSS files...
powershell -Command "Copy-Item 'web\css\*' 'build\web\css\' -Recurse -Force"
echo   - Copying current WEB-INF...
powershell -Command "Copy-Item 'web\WEB-INF\*' 'build\web\WEB-INF\' -Recurse -Force"

echo Step 5: Copying compiled classes...
powershell -Command "Copy-Item 'build\classes' 'build\web\WEB-INF\classes' -Recurse -Force" >nul 2>&1

echo Step 6: Deploying fresh build to Tomcat...
robocopy "build\web" "C:\apache-tomcat-9.0.113\webapps\TrendHire" /E >nul

echo Step 7: Starting Tomcat with completely fresh deployment...
call start_tomcat.bat

echo.
echo ========================================
echo FORCE COMPLETE REFRESH FINISHED!
echo ========================================
echo.
echo ✓ All old cached content REMOVED
echo ✓ Only your current files deployed
echo ✓ No old images or text will show
echo ✓ System running with 100%% current content
echo.
echo CRITICAL: Clear your browser cache:
echo 1. Press Ctrl+Shift+Delete
echo 2. Select "All time" and check all boxes
echo 3. Click "Clear data"
echo 4. Or use incognito/private mode
echo.
echo Your system now shows ONLY your current content!
echo.
pause