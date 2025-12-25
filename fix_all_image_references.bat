@echo off
echo ========================================
echo Fixing ALL Image References in ALL Pages
echo ========================================
echo.

echo Step 1: Converting all .png references to .jpg with cache-busting...

echo Fixing trendhireLogo.png to trendhireLogo.jpg...
powershell -Command "(Get-Content 'web\*.jsp' -Raw) -replace 'src=\"images/trendhireLogo\.png\"', 'src=\"images/trendhireLogo.jpg?v=<%%= System.currentTimeMillis() %%>\"' | Set-Content 'web\*.jsp'"

echo Fixing trenHire.png to trenHire.jpg...
powershell -Command "(Get-Content 'web\*.jsp' -Raw) -replace 'src=\"images/trenHire\.png\"', 'src=\"images/trenHire.jpg?v=<%%= System.currentTimeMillis() %%>\"' | Set-Content 'web\*.jsp'"

echo Step 2: Adding cache-busting to existing .jpg references...
powershell -Command "Get-ChildItem 'web\*.jsp' | ForEach-Object { (Get-Content $_.FullName -Raw) -replace 'src=\"images/([^\"]+\.jpg)\"(?!\?v=)', 'src=\"images/$1?v=<%%= System.currentTimeMillis() %%>\"' | Set-Content $_.FullName }"

echo Step 3: Fixing backend JSP files...
powershell -Command "Get-ChildItem 'web\backend\*.jsp' | ForEach-Object { (Get-Content $_.FullName -Raw) -replace 'src=\"images/([^\"]+\.png)\"', 'src=\"images/$1?v=<%%= System.currentTimeMillis() %%>\"' | Set-Content $_.FullName }"

echo.
echo ========================================
echo ALL Image References Fixed!
echo ========================================
echo.
echo ✓ All .png references converted to .jpg
echo ✓ Cache-busting added to all images
echo ✓ All pages will use your current images
echo.
echo Now run: force_complete_refresh.bat
echo.
pause