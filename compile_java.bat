@echo off
echo ========================================
echo Compiling TrendHire Java Classes
echo ========================================
echo.

set MYSQL_JAR=lib\mysql-connector-j-8.1.0.jar
set SERVLET_JAR=lib\servlet-api.jar

echo Checking MySQL Connector...
if exist "%MYSQL_JAR%" (
    echo ✅ MySQL Connector found: %MYSQL_JAR%
) else (
    echo ❌ MySQL Connector not found at: %MYSQL_JAR%
    echo Please update the path in this script
    pause
    exit /b 1
)

echo.
echo Creating build directories...
if not exist "build\classes" mkdir "build\classes"

echo.
echo Compiling Java classes...
javac -cp "%MYSQL_JAR%;%SERVLET_JAR%" -d build\classes src\java\com\classes\*.java src\java\servlet\*.java

if %ERRORLEVEL% EQU 0 (
    echo ✅ Java compilation successful!
    echo.
    echo Running database setup...
    java -cp "build\classes;%MYSQL_JAR%" com.classes.DatabaseSetup
) else (
    echo ❌ Java compilation failed!
    echo Make sure you have JDK installed and servlet-api.jar available
)

echo.
pause