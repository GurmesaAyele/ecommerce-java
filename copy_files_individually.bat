@echo off
echo ========================================
echo Copying Each File Individually
echo ========================================
echo This will copy each JSP file one by one to ensure proper deployment
echo ========================================
echo.

echo Step 1: Stopping Tomcat...
taskkill /f /im java.exe >nul 2>&1
timeout /t 3 >nul

echo Step 2: Copying each JSP file individually...
echo   - Copying aboutUs.jsp...
copy "web\aboutUs.jsp" "build\web\aboutUs.jsp" /Y >nul
copy "build\web\aboutUs.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\aboutUs.jsp" /Y >nul

echo   - Copying index.jsp...
copy "web\index.jsp" "build\web\index.jsp" /Y >nul
copy "build\web\index.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\index.jsp" /Y >nul

echo   - Copying vacancies.jsp...
copy "web\vacancies.jsp" "build\web\vacancies.jsp" /Y >nul
copy "build\web\vacancies.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\vacancies.jsp" /Y >nul

echo   - Copying contact.jsp...
copy "web\contact.jsp" "build\web\contact.jsp" /Y >nul
copy "build\web\contact.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\contact.jsp" /Y >nul

echo   - Copying adminLogin.jsp...
copy "web\adminLogin.jsp" "build\web\adminLogin.jsp" /Y >nul
copy "build\web\adminLogin.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\adminLogin.jsp" /Y >nul

echo   - Copying adminCompany.jsp...
copy "web\adminCompany.jsp" "build\web\adminCompany.jsp" /Y >nul
copy "build\web\adminCompany.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\adminCompany.jsp" /Y >nul

echo   - Copying adminPost.jsp...
copy "web\adminPost.jsp" "build\web\adminPost.jsp" /Y >nul
copy "build\web\adminPost.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\adminPost.jsp" /Y >nul

echo   - Copying adminProfile.jsp...
copy "web\adminProfile.jsp" "build\web\adminProfile.jsp" /Y >nul
copy "build\web\adminProfile.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\adminProfile.jsp" /Y >nul

echo   - Copying adminUser.jsp...
copy "web\adminUser.jsp" "build\web\adminUser.jsp" /Y >nul
copy "build\web\adminUser.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\adminUser.jsp" /Y >nul

echo   - Copying seekerLogin.jsp...
copy "web\seekerLogin.jsp" "build\web\seekerLogin.jsp" /Y >nul
copy "build\web\seekerLogin.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\seekerLogin.jsp" /Y >nul

echo   - Copying companyLogin.jsp...
copy "web\companyLogin.jsp" "build\web\companyLogin.jsp" /Y >nul
copy "build\web\companyLogin.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\companyLogin.jsp" /Y >nul

echo   - Copying CompanyRegister.jsp...
copy "web\CompanyRegister.jsp" "build\web\CompanyRegister.jsp" /Y >nul
copy "build\web\CompanyRegister.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\CompanyRegister.jsp" /Y >nul

echo   - Copying companyProfile.jsp...
copy "web\companyProfile.jsp" "build\web\companyProfile.jsp" /Y >nul
copy "build\web\companyProfile.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\companyProfile.jsp" /Y >nul

echo   - Copying companyVacancies.jsp...
copy "web\companyVacancies.jsp" "build\web\companyVacancies.jsp" /Y >nul
copy "build\web\companyVacancies.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\companyVacancies.jsp" /Y >nul

echo   - Copying companyApplication.jsp...
copy "web\companyApplication.jsp" "build\web\companyApplication.jsp" /Y >nul
copy "build\web\companyApplication.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\companyApplication.jsp" /Y >nul

echo   - Copying userprofile.jsp...
copy "web\userprofile.jsp" "build\web\userprofile.jsp" /Y >nul
copy "build\web\userprofile.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\userprofile.jsp" /Y >nul

echo   - Copying userApplication.jsp...
copy "web\userApplication.jsp" "build\web\userApplication.jsp" /Y >nul
copy "build\web\userApplication.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\userApplication.jsp" /Y >nul

echo   - Copying userRegisterForm.jsp...
copy "web\userRegisterForm.jsp" "build\web\userRegisterForm.jsp" /Y >nul
copy "build\web\userRegisterForm.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\userRegisterForm.jsp" /Y >nul

echo   - Copying postvacancy.jsp...
copy "web\postvacancy.jsp" "build\web\postvacancy.jsp" /Y >nul
copy "build\web\postvacancy.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\postvacancy.jsp" /Y >nul

echo   - Copying manageApplications.jsp...
copy "web\manageApplications.jsp" "build\web\manageApplications.jsp" /Y >nul
copy "build\web\manageApplications.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\manageApplications.jsp" /Y >nul

echo   - Copying vacancyDetails.jsp...
copy "web\vacancyDetails.jsp" "build\web\vacancyDetails.jsp" /Y >nul
copy "build\web\vacancyDetails.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\vacancyDetails.jsp" /Y >nul

echo   - Copying edituser.jsp...
copy "web\edituser.jsp" "build\web\edituser.jsp" /Y >nul
copy "build\web\edituser.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\edituser.jsp" /Y >nul

echo   - Copying editCompany.jsp...
copy "web\editCompany.jsp" "build\web\editCompany.jsp" /Y >nul
copy "build\web\editCompany.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\editCompany.jsp" /Y >nul

echo   - Copying termsAndConditions.jsp...
copy "web\termsAndConditions.jsp" "build\web\termsAndConditions.jsp" /Y >nul
copy "build\web\termsAndConditions.jsp" "C:\apache-tomcat-9.0.113\webapps\TrendHire\termsAndConditions.jsp" /Y >nul

echo Step 3: Copying each image individually...
echo   - Copying trendhireLogo.jpg...
copy "web\images\trendhireLogo.jpg" "build\web\images\trendhireLogo.jpg" /Y >nul
copy "build\web\images\trendhireLogo.jpg" "C:\apache-tomcat-9.0.113\webapps\TrendHire\images\trendhireLogo.jpg" /Y >nul

echo   - Copying trenHire.jpg...
copy "web\images\trenHire.jpg" "build\web\images\trenHire.jpg" /Y >nul
copy "build\web\images\trenHire.jpg" "C:\apache-tomcat-9.0.113\webapps\TrendHire\images\trenHire.jpg" /Y >nul

echo   - Copying favicon.ico...
copy "web\images\favicon.ico" "build\web\images\favicon.ico" /Y >nul
copy "build\web\images\favicon.ico" "C:\apache-tomcat-9.0.113\webapps\TrendHire\images\favicon.ico" /Y >nul

echo Step 4: Copying CSS files individually...
echo   - Copying stylesheet.css...
copy "web\css\stylesheet.css" "build\web\css\stylesheet.css" /Y >nul
copy "build\web\css\stylesheet.css" "C:\apache-tomcat-9.0.113\webapps\TrendHire\css\stylesheet.css" /Y >nul

echo   - Copying bootstrap.min.css...
copy "web\css\bootstrap.min.css" "build\web\css\bootstrap.min.css" /Y >nul
copy "build\web\css\bootstrap.min.css" "C:\apache-tomcat-9.0.113\webapps\TrendHire\css\bootstrap.min.css" /Y >nul

echo   - Copying aboutUs.css...
copy "web\css\aboutUs.css" "build\web\css\aboutUs.css" /Y >nul
copy "build\web\css\aboutUs.css" "C:\apache-tomcat-9.0.113\webapps\TrendHire\css\aboutUs.css" /Y >nul

echo   - Copying admin.css...
copy "web\css\admin.css" "build\web\css\admin.css" /Y >nul
copy "build\web\css\admin.css" "C:\apache-tomcat-9.0.113\webapps\TrendHire\css\admin.css" /Y >nul

echo Step 5: Starting Tomcat...
call start_tomcat.bat

echo.
echo ========================================
echo Individual File Copy Complete!
echo ========================================
echo.
echo ✓ Each JSP file copied individually
echo ✓ Each image file copied individually  
echo ✓ Each CSS file copied individually
echo ✓ All files deployed directly to Tomcat
echo.
echo IMPORTANT: Clear browser cache:
echo 1. Press Ctrl+Shift+Delete
echo 2. Select "All time" and check all boxes
echo 3. Click "Clear data"
echo.
echo Your current files are now deployed!
echo.
pause