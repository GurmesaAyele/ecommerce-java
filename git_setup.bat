@echo off
echo ========================================
echo Git Setup for TrendHire Project
echo ========================================
echo.

echo Step 1: Initializing Git repository...
git init

echo Step 2: Adding remote repository...
git remote add origin https://github.com/GurmesaAyele/Online-Recruitment-Management-System.git

echo Step 3: Creating .gitignore file...
echo # TrendHire Project .gitignore > .gitignore
echo. >> .gitignore
echo # Build directories >> .gitignore
echo build/ >> .gitignore
echo dist/ >> .gitignore
echo nbproject/private/ >> .gitignore
echo. >> .gitignore
echo # Compiled class files >> .gitignore
echo *.class >> .gitignore
echo. >> .gitignore
echo # Log files >> .gitignore
echo *.log >> .gitignore
echo. >> .gitignore
echo # Temporary files >> .gitignore
echo *.tmp >> .gitignore
echo *.temp >> .gitignore
echo. >> .gitignore
echo # IDE files >> .gitignore
echo .vscode/ >> .gitignore
echo .idea/ >> .gitignore
echo *.iml >> .gitignore
echo. >> .gitignore
echo # OS files >> .gitignore
echo Thumbs.db >> .gitignore
echo .DS_Store >> .gitignore

echo Step 4: Adding all files to Git...
git add .

echo Step 5: Creating initial commit...
git commit -m "Initial commit: TrendHire Online Recruitment Management System

Features:
- Enhanced job posting system with skills management
- Application management dashboard for companies
- Interview scheduling system
- Status tracking (Applied, Under Review, Shortlisted, etc.)
- Recruiter notes and rejection reasons
- Complete database with enhanced features
- Responsive UI with Bootstrap
- MySQL integration with JDBC"

echo Step 6: Setting up main branch...
git branch -M main

echo Step 7: Pushing to GitHub...
git push -u origin main

echo.
echo ========================================
echo Git Setup Complete!
echo ========================================
echo.
echo Your TrendHire project has been pushed to:
echo https://github.com/GurmesaAyele/Online-Recruitment-Management-System
echo.
echo To make future updates:
echo 1. git add .
echo 2. git commit -m "Your commit message"
echo 3. git push
echo.
pause