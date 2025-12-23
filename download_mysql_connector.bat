@echo off
echo Downloading MySQL Connector/J...
echo.

echo Creating lib directory...
if not exist "lib" mkdir lib

echo.
echo Downloading MySQL Connector/J 8.1.0...
powershell -Command "Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.33/mysql-connector-java-8.0.33.jar' -OutFile 'lib\mysql-connector-java-8.0.33.jar'"

if exist "lib\mysql-connector-java-8.0.33.jar" (
    echo ✅ MySQL Connector downloaded successfully!
    echo File: lib\mysql-connector-java-8.0.33.jar
) else (
    echo ❌ Download failed. Please download manually from:
    echo https://dev.mysql.com/downloads/connector/j/
    echo Save as: lib\mysql-connector-java-8.0.33.jar
)

echo.
pause