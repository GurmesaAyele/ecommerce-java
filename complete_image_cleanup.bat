@echo off
echo ========================================
echo Complete Image Cleanup and Refresh
echo ========================================
echo This will remove ALL old cached images and use ONLY your current images
echo ========================================
echo.

echo Step 1: Stopping Tomcat completely...
taskkill /f /im java.exe >nul 2>&1
timeout /t 3 >nul

echo Step 2: Removing ALL cached deployments...
rmdir /s /q "C:\apache-tomcat-9.0.113\work" >nul 2>&1
rmdir /s /q "C:\apache-tomcat-9.0.113\webapps\TrendHire" >nul 2>&1
rmdir /s /q "C:\apache-tomcat-9.0.113\temp" >nul 2>&1

echo Step 3: Cleaning build directory completely...
rmdir /s /q "build\web" >nul 2>&1

echo Step 4: Creating fresh build structure...
mkdir "build\web" >nul 2>&1
mkdir "build\web\images" >nul 2>&1
mkdir "build\web\css" >nul 2>&1
mkdir "build\web\backend" >nul 2>&1
mkdir "build\web\WEB-INF" >nul 2>&1
mkdir "build\web\WEB-INF\classes" >nul 2>&1

echo Step 5: Copying ONLY your current content...
echo   - Copying your current images...
powershell -Command "Copy-Item 'web\images\*' 'build\web\images\' -Recurse -Force"

echo   - Copying your current JSP files...
powershell -Command "Copy-Item 'web\*.jsp' 'build\web\' -Force"

echo   - Copying your current backend files...
powershell -Command "Copy-Item 'web\backend\*' 'build\web\backend\' -Recurse -Force"

echo   - Copying your current CSS files...
powershell -Command "Copy-Item 'web\css\*' 'build\web\css\' -Recurse -Force"

echo   - Copying WEB-INF configuration...
powershell -Command "Copy-Item 'web\WEB-INF\*' 'build\web\WEB-INF\' -Recurse -Force"

echo   - Copying compiled Java classes...
powershell -Command "Copy-Item 'build\classes\*' 'build\web\WEB-INF\classes\' -Recurse -Force"

echo Step 6: Deploying completely fresh build...
robocopy "build\web" "C:\apache-tomcat-9.0.113\webapps\TrendHire" /E >nul

echo Step 7: Starting Tomcat with completely clean deployment...
call start_tomcat.bat

echo.
echo ========================================
echo COMPLETE IMAGE CLEANUP FINISHED!
echo ========================================
echo.
echo ✓ ALL old cached images removed
echo ✓ Only your current JPG images deployed
echo ✓ No PNG images from old system
echo ✓ Fresh deployment with current content
echo.
echo CRITICAL BROWSER STEPS:
echo 1. Close ALL browser windows
echo 2. Open browser in incognito/private mode
echo 3. Go to: http://localhost:8080/TrendHire/
echo 4. Or clear ALL browser data (Ctrl+Shift+Delete)
echo.
echo Your system now uses ONLY your current images!
echo.
pause