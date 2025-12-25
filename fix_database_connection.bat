@echo off
echo ========================================
echo TrendHire Database Connection Fix
echo ========================================

echo Step 1: Checking MySQL service status...
sc query MySQL95
if %errorlevel% neq 0 (
    echo MySQL95 service not found, checking other MySQL services...
    sc query | findstr /i mysql
)

echo.
echo Step 2: Attempting to restart MySQL service...
net stop MySQL95 2>nul
timeout /t 2 /nobreak >nul
net start MySQL95
if %errorlevel% neq 0 (
    echo Failed to start MySQL95, trying alternative...
    net start wampmysqld64
)

echo.
echo Step 3: Testing MySQL connection...
mysql -u root -p14162121 -e "SHOW DATABASES;" 2>nul
if %errorlevel% neq 0 (
    echo Connection failed with password 14162121, trying without password...
    mysql -u root -e "SHOW DATABASES;" 2>nul
    if %errorlevel% neq 0 (
        echo MySQL connection failed. Please check:
        echo 1. MySQL service is running
        echo 2. Root password is correct
        echo 3. MySQL is installed properly
        pause
        exit /b 1
    ) else (
        echo SUCCESS: Connected without password
        echo Updating DBConnector.java to use empty password...
        powershell -Command "(Get-Content 'src\java\com\classes\DBConnector.java') -replace 'DB_PASSWORD = \"14162121\"', 'DB_PASSWORD = \"\"' | Set-Content 'src\java\com\classes\DBConnector.java'"
    )
) else (
    echo SUCCESS: Connected with password 14162121
)

echo.
echo Step 4: Creating trendhire database if it doesn't exist...
mysql -u root -p14162121 -e "CREATE DATABASE IF NOT EXISTS trendhire;" 2>nul
if %errorlevel% neq 0 (
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS trendhire;" 2>nul
)

echo.
echo Step 5: Importing database schema...
mysql -u root -p14162121 trendhire < database\trendhire_database.sql 2>nul
if %errorlevel% neq 0 (
    mysql -u root trendhire < database\trendhire_database.sql 2>nul
)

echo.
echo Step 6: Recompiling Java classes with updated connection...
call compile_java.bat

echo.
echo ========================================
echo Database Connection Fix Complete!
echo ========================================
echo.
echo If you still get connection errors:
echo 1. Check WAMP/XAMPP is running (green icon)
echo 2. Verify MySQL service is started
echo 3. Check if port 3306 is available
echo.
pause