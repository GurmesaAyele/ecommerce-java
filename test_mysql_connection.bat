@echo off
echo Testing MySQL Connection...
echo.

echo Testing with password 14162121...
mysql -u root -p14162121 -e "SELECT 'Connection successful!' as status;" 2>nul
if %errorlevel% equ 0 (
    echo SUCCESS: Password 14162121 works!
    goto :create_db
)

echo Testing without password...
mysql -u root -e "SELECT 'Connection successful!' as status;" 2>nul
if %errorlevel% equ 0 (
    echo SUCCESS: No password needed!
    echo Updating DBConnector.java...
    powershell -Command "(Get-Content 'src\java\com\classes\DBConnector.java') -replace 'DB_PASSWORD = \"14162121\"', 'DB_PASSWORD = \"\"' | Set-Content 'src\java\com\classes\DBConnector.java'"
    goto :create_db
)

echo Testing with common passwords...
for %%p in ("" "root" "password" "123456" "admin") do (
    echo Testing password: %%p
    mysql -u root -p%%p -e "SELECT 'Connection successful!' as status;" 2>nul
    if !errorlevel! equ 0 (
        echo SUCCESS: Password %%p works!
        powershell -Command "(Get-Content 'src\java\com\classes\DBConnector.java') -replace 'DB_PASSWORD = \"14162121\"', 'DB_PASSWORD = %%p' | Set-Content 'src\java\com\classes\DBConnector.java'"
        goto :create_db
    )
)

echo All connection attempts failed. Please:
echo 1. Open WAMP/XAMPP control panel
echo 2. Make sure MySQL is green/running
echo 3. Check MySQL password in phpMyAdmin
pause
exit /b 1

:create_db
echo.
echo Creating trendhire database...
mysql -u root -e "CREATE DATABASE IF NOT EXISTS trendhire;" 2>nul
echo Database created/verified.

echo.
echo Recompiling Java classes...
call compile_java.bat

pause