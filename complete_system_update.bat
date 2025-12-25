@echo off
echo ========================================
echo TrendHire Complete System Update
echo ========================================
echo.
echo This will copy ALL your changes (images, texts, JSP files) to the system
echo.

echo Step 1: Stopping Tomcat...
taskkill /f /im java.exe >nul 2>&1

echo Step 2: Clearing Tomcat cache and old deployment...
rmdir /s /q "C:\apache-tomcat-9.0.113\work\Catalina\localhost\TrendHire" >nul 2>&1
rmdir /s /q "C:\apache-tomcat-9.0.113\webapps\TrendHire" >nul 2>&1

echo Step 3: Copying ALL updated content from web to build...
echo   - Copying all images (including new/updated ones)...
powershell -Command "Copy-Item 'web\images\*' 'build\web\images\' -Recurse -Force"

echo   - Copying all JSP files (with your text changes)...
powershell -Command "Copy-Item 'web\*.jsp' 'build\web\' -Force"

echo   - Copying all backend files...
powershell -Command "Copy-Item 'web\backend\*' 'build\web\backend\' -Recurse -Force"

echo   - Copying all CSS files...
powershell -Command "Copy-Item 'web\css\*' 'build\web\css\' -Recurse -Force"

echo   - Copying WEB-INF configuration...
powershell -Command "Copy-Item 'web\WEB-INF\*' 'build\web\WEB-INF\' -Recurse -Force"

echo Step 4: Deploying fresh build to Tomcat...
robocopy "build\web" "C:\apache-tomcat-9.0.113\webapps\TrendHire" /E >nul

echo Step 5: Starting Tomcat with fresh deployment...
call start_tomcat.bat

echo.
echo ========================================
echo Complete System Update Finished!
echo ========================================
echo.
echo ALL your changes have been deployed:
echo ✓ Updated images
echo ✓ Modified text content
echo ✓ JSP file changes
echo ✓ CSS updates
echo ✓ Backend modifications
echo.
echo IMPORTANT: In your browser:
echo 1. Press Ctrl+Shift+R (hard refresh)
echo 2. Or open in incognito/private mode
echo 3. Or clear browser cache manually
echo.
echo Your system is now running with ALL your latest changes!
echo.
pause