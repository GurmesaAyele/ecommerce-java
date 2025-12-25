@echo off
echo ========================================
echo TrendHire Cache Clear and Update
echo ========================================
echo.

echo Step 1: Stopping Tomcat...
taskkill /f /im java.exe >nul 2>&1

echo Step 2: Clearing Tomcat cache...
rmdir /s /q "C:\apache-tomcat-9.0.113\work\Catalina\localhost\TrendHire" >nul 2>&1
rmdir /s /q "C:\apache-tomcat-9.0.113\webapps\TrendHire" >nul 2>&1

echo Step 3: Copying ALL updated files from web to build...
echo Copying images...
powershell -Command "Copy-Item 'web\images\*' 'build\web\images\' -Recurse -Force"
echo Copying JSP files...
powershell -Command "Copy-Item 'web\*.jsp' 'build\web\' -Force"
echo Copying backend files...
powershell -Command "Copy-Item 'web\backend\*' 'build\web\backend\' -Recurse -Force"
echo Copying CSS files...
powershell -Command "Copy-Item 'web\css\*' 'build\web\css\' -Recurse -Force"
echo Copying WEB-INF files...
powershell -Command "Copy-Item 'web\WEB-INF\*' 'build\web\WEB-INF\' -Recurse -Force"
echo Step 4: Copying fresh files to Tomcat...
robocopy "build\web" "C:\apache-tomcat-9.0.113\webapps\TrendHire" /E >nul

echo Step 5: Starting Tomcat...
call start_tomcat.bat

echo.
echo ========================================
echo Cache Cleared and System Updated!
echo ========================================
echo.
echo IMPORTANT: In your browser:
echo 1. Press Ctrl+Shift+R (hard refresh)
echo 2. Or open in incognito/private mode
echo 3. Or clear browser cache manually
echo.
echo Your updated content should now be visible!
echo.
pause