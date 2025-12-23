# TrendHire - Online Recruitment Management System

A comprehensive web-based recruitment management system built with JSP, Servlets, and MySQL. This system provides a complete solution for job posting, application management, and recruitment workflow automation.

## 🚀 Features

### For Companies
- **Enhanced Job Posting System**
  - Advanced job posting form with skills management
  - Experience level requirements
  - Salary range specification
  - Application deadline setting
  - Job status management (Draft/Published)

- **Application Management Dashboard**
  - View all job applications in one place
  - Filter applications by status
  - Update application status with one click
  - Add recruiter notes for each candidate
  - Download candidate CVs

- **Interview Scheduling System**
  - Schedule interviews with date and time
  - Support for Online, Onsite, and Phone interviews
  - Meeting link management for online interviews
  - Automatic status updates

- **Status Tracking**
  - Applied → Under Review → Shortlisted → Interview Scheduled → Selected/Rejected
  - Complete status history tracking
  - Rejection reasons management

### For Job Seekers
- **User Registration & Profile Management**
  - Create detailed seeker profiles
  - Upload CV and profile pictures
  - Manage personal information

- **Job Search & Application**
  - Browse and search job vacancies
  - Apply for jobs with CV upload
  - View detailed job descriptions and requirements

- **Comprehensive Application Tracking**
  - Real-time application status monitoring
  - Application statistics dashboard
  - Filter applications by status (Applied, Under Review, Shortlisted, Interview Scheduled, Selected, Rejected)
  - Detailed application history with timeline view
  - Interview scheduling information with meeting links
  - Recruiter notes and feedback visibility
  - Application withdrawal functionality

- **Interview Management**
  - View scheduled interview details
  - Access meeting links for online interviews
  - Track interview completion and feedback

### For Administrators
- System administration dashboard
- Manage companies and job seekers
- Monitor system activity
- Generate reports

## 🛠️ Technology Stack

- **Frontend**: JSP, HTML5, CSS3, Bootstrap 5, JavaScript
- **Backend**: Java Servlets, JSP
- **Database**: MySQL 8.0
- **Server**: Apache Tomcat 9.0
- **Build Tool**: Apache Ant
- **Version Control**: Git

## 📋 Prerequisites

- Java JDK 8 or higher
- Apache Tomcat 9.0
- MySQL 8.0
- WAMP/XAMPP (for local development)

## 🚀 Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/GurmesaAyele/Online-Recruitment-Management-System.git
cd Online-Recruitment-Management-System
```

### 2. Database Setup
1. Start WAMP/XAMPP and ensure MySQL is running
2. Open phpMyAdmin or MySQL command line
3. Run the database script:
```sql
SOURCE database/trendhire_database.sql;
```

### 3. Configure Database Connection
Update the database connection settings in `src/java/com/classes/DBConnector.java` if needed:
```java
private static final String URL = "jdbc:mysql://localhost:3306/trendhire";
private static final String USERNAME = "root";
private static final String PASSWORD = "";
```

### 4. Compile and Deploy
```batch
# Compile Java classes
compile_java.bat

# Deploy to Tomcat
compile_and_run.bat
```

### 5. Start the Application
1. Start Tomcat server: `start_tomcat.bat`
2. Open browser: `http://localhost:8080/TrendHire`

## 🔑 Default Login Credentials

### Company Accounts
- **Username**: `techcorp` | **Password**: `hello`
- **Username**: `greenenergy` | **Password**: `hello`
- **Username**: `creative` | **Password**: `hello`

### Job Seeker Accounts
- **Username**: `johndoe` | **Password**: `hello`
- **Username**: `janesmith` | **Password**: `hello`

### Admin Account
- **Username**: `admin` | **Password**: `admin`

## 📁 Project Structure

```
TrendHire/
├── web/                          # Web application files
│   ├── index.jsp                 # Homepage
│   ├── postvacancy.jsp          # Enhanced job posting form
│   ├── manageApplications.jsp   # Application management dashboard
│   ├── companyProfile.jsp       # Company dashboard
│   ├── backend/                 # Backend processing files
│   │   ├── enhanced_post_job_process.jsp
│   │   ├── updateApplicationStatus.jsp
│   │   └── scheduleInterview.jsp
│   └── css/                     # Stylesheets
├── src/java/                    # Java source files
│   └── com/classes/            # Java classes
├── database/                    # Database scripts
│   └── trendhire_database.sql  # Complete database setup
├── lib/                        # JAR dependencies
└── nbproject/                  # NetBeans project files
```

## 🎯 Key Features Walkthrough

### 1. Enhanced Job Posting
- Navigate to Company Profile → Post New Job
- Choose between Quick Post and Advanced Post modes
- Add skills with proficiency levels
- Set salary ranges and application deadlines
- Publish immediately or save as draft

### 2. Application Management (Company Side)
- Access via Company Profile → Manage Applications
- Filter applications by status tabs
- Review candidate information and CVs
- Update status with action buttons
- Schedule interviews with detailed information

### 3. Interview Scheduling
- Select candidates from Shortlisted status
- Choose interview mode (Online/Onsite/Phone)
- Set date, time, and meeting details
- Automatic email notifications (if configured)

### 4. Application Tracking (Job Seeker Side)
- Access via User Profile → My Applications
- View comprehensive application statistics
- Filter applications by current status
- Track complete application history with timeline
- View interview details and meeting links
- Withdraw applications when allowed
- Access recruiter notes and feedback

## 🔧 Configuration

### Database Configuration
The system uses MySQL with the following default settings:
- **Host**: localhost
- **Port**: 3306
- **Database**: trendhire
- **Username**: root
- **Password**: (empty)

### Tomcat Configuration
- **Port**: 8080
- **Context Path**: /TrendHire
- **Deployment**: webapps/TrendHire/

## 📊 Database Schema

The system includes the following main tables:
- `company` - Company profiles and authentication
- `seeker` - Job seeker profiles and authentication
- `vacancy` - Job postings with enhanced features
- `application` - Job applications with status tracking
- `interview` - Interview scheduling and management
- `application_status_history` - Complete audit trail

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Gurmesa Ayele**
- GitHub: [@GurmesaAyele](https://github.com/GurmesaAyele)
- Project: [Online Recruitment Management System](https://github.com/GurmesaAyele/Online-Recruitment-Management-System)

## 🙏 Acknowledgments

- Bootstrap team for the responsive UI framework
- Apache Software Foundation for Tomcat and other tools
- MySQL team for the robust database system
- FontAwesome for the beautiful icons

## 📞 Support

If you encounter any issues or have questions, please:
1. Check the existing issues on GitHub
2. Create a new issue with detailed information
3. Include error logs and system information

---

**⭐ If you find this project helpful, please give it a star on GitHub!**