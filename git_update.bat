@echo off
echo ========================================
echo Git Update - Push Changes to GitHub
echo ========================================
echo.

set /p message="Enter commit message: "

echo Step 1: Adding all changes...
git add .

echo Step 2: Committing changes...
git commit -m "%message%"

echo Step 3: Pushing to GitHub...
git push

echo.
echo ========================================
echo Update Complete!
echo ========================================
echo.
echo Changes pushed to:
echo https://github.com/GurmesaAyele/Online-Recruitment-Management-System
echo.
pause