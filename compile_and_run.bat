@echo off
echo ========================================
echo TrendHire - Quick Deploy
echo ========================================
echo.

echo Step 1: Creating build structure...
if not exist "build\web" mkdir "build\web"
if not exist "build\web\WEB-INF" mkdir "build\web\WEB-INF"
if not exist "build\web\WEB-INF\classes" mkdir "build\web\WEB-INF\classes"
if not exist "build\web\WEB-INF\lib" mkdir "build\web\WEB-INF\lib"

echo Step 2: Copying web files...
xcopy /E /Y "web\*" "build\web\"

echo Step 3: Copying libraries...
if exist "lib\*.jar" copy "lib\*.jar" "build\web\WEB-INF\lib\"

echo Step 4: Compiling Java classes...
if exist "src\java" (
    javac -cp "lib\*" -d "build\web\WEB-INF\classes" src\java\com\classes\*.java 2>nul
    if errorlevel 1 (
        echo Java compilation failed, continuing anyway...
    ) else (
        echo Java compilation successful
    )
)

echo Step 5: Creating web.xml...
echo ^<?xml version="1.0" encoding="UTF-8"?^> > "build\web\WEB-INF\web.xml"
echo ^<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee" >> "build\web\WEB-INF\web.xml"
echo          version="4.0"^> >> "build\web\WEB-INF\web.xml"
echo     ^<display-name^>TrendHire^</display-name^> >> "build\web\WEB-INF\web.xml"
echo ^</web-app^> >> "build\web\WEB-INF\web.xml"

echo Step 6: Starting Tomcat and deploying...
call start_tomcat.bat

echo Step 7: Waiting for server...
timeout /t 10 >nul

echo ========================================
echo Quick Deploy Complete!
echo ========================================
echo.
echo Try these URLs:
echo - http://localhost:8080/trendhire/index.jsp
echo - http://localhost:8080/trendhire/postvacancy.jsp
echo.
echo If 404 error persists, the files are at:
echo - build\web\postvacancy.jsp
echo.
echo Opening application...
start http://localhost:8080/trendhire/index.jsp

pause