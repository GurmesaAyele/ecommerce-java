@echo off
echo ================================================================================
echo                            DATABASE SETUP COMMAND
echo ================================================================================
echo.

echo [1] Checking MySQL connection...
netstat -an | find "3306" >nul
if errorlevel 1 (
    echo ❌ MySQL is not running!
    echo Please start WAMP/XAMPP first
    pause
    exit /b 1
)
echo ✅ MySQL is running

echo.
echo [2] Opening database reset page...
start http://localhost/trendhire/reset_database.php

echo.
echo [3] Alternative: Direct PHP execution...
echo If browser doesn't work, you can also run:
echo php -f reset_database.php

echo.
echo [4] Manual SQL execution (if needed):
echo mysql -u root -p
echo CREATE DATABASE trendhire;
echo USE trendhire;
echo SOURCE database/trendhire_database.sql;

echo.
echo ✅ Database setup initiated
echo Complete the setup in the browser window that opened
pause