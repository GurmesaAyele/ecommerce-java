-- TrendHire Complete Database Setup Script
-- This is the ONLY database file you need - includes all basic and enhanced features
-- Run this script in phpMyAdmin or MySQL command line

-- Create database
CREATE DATABASE IF NOT EXISTS trendhire;
USE trendhire;

-- Create Admin table
CREATE TABLE IF NOT EXISTS admin (
    adminID INT AUTO_INCREMENT PRIMARY KEY,
    adFirstname VARCHAR(50) NOT NULL,
    adLastname VARCHAR(50) NOT NULL,
    adPhone VARCHAR(15) NOT NULL,
    adAddress TEXT NOT NULL,
    adUsername VARCHAR(50) UNIQUE NOT NULL,
    adEmail VARCHAR(100) UNIQUE NOT NULL,
    adPassword VARCHAR(255) NOT NULL,
    adPicture VARCHAR(255) DEFAULT './images/uploads/adminPictures/default.jpg',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Company table
CREATE TABLE IF NOT EXISTS company (
    companyID INT AUTO_INCREMENT PRIMARY KEY,
    companyName VARCHAR(100) NOT NULL,
    companyAddress TEXT NOT NULL,
    companyCategory VARCHAR(50) NOT NULL,
    companyWeb VARCHAR(100),
    companyEmail VARCHAR(100) UNIQUE NOT NULL,
    companyEmployee VARCHAR(20) NOT NULL,
    companyUsername VARCHAR(50) UNIQUE NOT NULL,
    companyPassword VARCHAR(255) NOT NULL,
    companyPic VARCHAR(255) DEFAULT './images/uploads/companyPictures/default.jpg',
    companyAbout TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active', 'inactive', 'pending') DEFAULT 'active'
);

-- Create Seeker table
CREATE TABLE IF NOT EXISTS seeker (
    seekerID INT AUTO_INCREMENT PRIMARY KEY,
    seekerFName VARCHAR(50) NOT NULL,
    seekerLName VARCHAR(50) NOT NULL,
    seekerEmail VARCHAR(100) UNIQUE NOT NULL,
    seekerPhone VARCHAR(15) NOT NULL,
    seekerUName VARCHAR(50) UNIQUE NOT NULL,
    seekerAddress TEXT NOT NULL,
    seekerPassword VARCHAR(255) NOT NULL,
    seekerImg VARCHAR(255) DEFAULT './images/uploads/profilePictures/default.jpg',
    seekerCV VARCHAR(255) DEFAULT './images/uploads/cvs/default.pdf',
    seekerAbout TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active', 'inactive') DEFAULT 'active'
);

-- Create Enhanced Vacancy table (includes all basic and enhanced features)
CREATE TABLE IF NOT EXISTS vacancy (
    vacancyID INT AUTO_INCREMENT PRIMARY KEY,
    companyID INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    location VARCHAR(100) NOT NULL,
    type ENUM('Full-time', 'Part-time', 'Contract', 'Internship', 'Remote') NOT NULL,
    salary VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    requirements TEXT,
    posted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deadline DATE,
    status ENUM('active', 'inactive', 'closed') DEFAULT 'active',
    -- Enhanced columns for advanced job posting
    required_skills TEXT,
    experience_level ENUM('Entry Level', 'Mid Level', 'Senior Level', 'Executive') DEFAULT 'Entry Level',
    salary_min DECIMAL(10,2),
    salary_max DECIMAL(10,2),
    application_deadline DATE,
    job_status ENUM('Draft', 'Published', 'Closed', 'On Hold') DEFAULT 'Published',
    created_by INT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (companyID) REFERENCES company(companyID) ON DELETE CASCADE
);

-- Create Enhanced Application table (includes all basic and enhanced features)
CREATE TABLE IF NOT EXISTS application (
    applicationID INT AUTO_INCREMENT PRIMARY KEY,
    vacancyID INT NOT NULL,
    seekerID INT NOT NULL,
    companyID INT NOT NULL,
    status ENUM('Waiting', 'Accepted', 'Rejected', 'Under Review') DEFAULT 'Waiting',
    applied_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_date TIMESTAMP NULL,
    notes TEXT,
    -- Enhanced columns for detailed application tracking
    application_status ENUM('Applied', 'Under Review', 'Shortlisted', 'Interview Scheduled', 'Interview Completed', 'Selected', 'Rejected', 'Withdrawn') DEFAULT 'Applied',
    recruiter_notes TEXT,
    interview_score DECIMAL(3,1),
    updated_by INT,
    status_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (vacancyID) REFERENCES vacancy(vacancyID) ON DELETE CASCADE,
    FOREIGN KEY (seekerID) REFERENCES seeker(seekerID) ON DELETE CASCADE,
    FOREIGN KEY (companyID) REFERENCES company(companyID) ON DELETE CASCADE,
    UNIQUE KEY unique_application (vacancyID, seekerID)
);

-- Create Interview table for scheduling and tracking interviews
CREATE TABLE IF NOT EXISTS interview (
    interviewID INT AUTO_INCREMENT PRIMARY KEY,
    applicationID INT NOT NULL,
    vacancyID INT NOT NULL,
    seekerID INT NOT NULL,
    companyID INT NOT NULL,
    interviewer_name VARCHAR(100) NOT NULL,
    interviewer_email VARCHAR(100),
    interview_date DATE NOT NULL,
    interview_time TIME NOT NULL,
    interview_mode ENUM('Online', 'Onsite', 'Phone') DEFAULT 'Online',
    interview_location VARCHAR(255),
    meeting_link VARCHAR(500),
    interview_status ENUM('Scheduled', 'Completed', 'Cancelled', 'Rescheduled') DEFAULT 'Scheduled',
    feedback TEXT,
    score DECIMAL(3,1),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (applicationID) REFERENCES application(applicationID) ON DELETE CASCADE,
    FOREIGN KEY (vacancyID) REFERENCES vacancy(vacancyID) ON DELETE CASCADE,
    FOREIGN KEY (seekerID) REFERENCES seeker(seekerID) ON DELETE CASCADE,
    FOREIGN KEY (companyID) REFERENCES company(companyID) ON DELETE CASCADE
);

-- Create Recruiter table for company recruiters
CREATE TABLE IF NOT EXISTS recruiter (
    recruiterID INT AUTO_INCREMENT PRIMARY KEY,
    companyID INT NOT NULL,
    recruiter_name VARCHAR(100) NOT NULL,
    recruiter_email VARCHAR(100) UNIQUE NOT NULL,
    recruiter_phone VARCHAR(15),
    department VARCHAR(50),
    role ENUM('HR Manager', 'Recruiter', 'Hiring Manager', 'Admin') DEFAULT 'Recruiter',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (companyID) REFERENCES company(companyID) ON DELETE CASCADE
);

-- Create Application Status History table
CREATE TABLE IF NOT EXISTS application_status_history (
    historyID INT AUTO_INCREMENT PRIMARY KEY,
    applicationID INT NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50) NOT NULL,
    changed_by INT,
    change_reason TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (applicationID) REFERENCES application(applicationID) ON DELETE CASCADE
);

-- Create Job Skills table for better skill management
CREATE TABLE IF NOT EXISTS job_skills (
    skillID INT AUTO_INCREMENT PRIMARY KEY,
    vacancyID INT NOT NULL,
    skill_name VARCHAR(100) NOT NULL,
    skill_level ENUM('Basic', 'Intermediate', 'Advanced', 'Expert') DEFAULT 'Intermediate',
    is_required BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (vacancyID) REFERENCES vacancy(vacancyID) ON DELETE CASCADE
);

-- Create Seeker Skills table
CREATE TABLE IF NOT EXISTS seeker_skills (
    seekerSkillID INT AUTO_INCREMENT PRIMARY KEY,
    seekerID INT NOT NULL,
    skill_name VARCHAR(100) NOT NULL,
    skill_level ENUM('Basic', 'Intermediate', 'Advanced', 'Expert') DEFAULT 'Intermediate',
    years_experience DECIMAL(3,1) DEFAULT 0,
    FOREIGN KEY (seekerID) REFERENCES seeker(seekerID) ON DELETE CASCADE
);

-- Create Notification system
CREATE TABLE IF NOT EXISTS notifications (
    notificationID INT AUTO_INCREMENT PRIMARY KEY,
    recipient_type ENUM('seeker', 'company', 'admin') NOT NULL,
    recipient_id INT NOT NULL,
    notification_type ENUM('application_status', 'interview_scheduled', 'new_application', 'job_posted') NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    related_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default admin user
INSERT IGNORE INTO admin (adFirstname, adLastname, adPhone, adAddress, adUsername, adEmail, adPassword) 
VALUES ('Admin', 'User', '+94771234567', 'Badulla, Sri Lanka', 'admin', 'admin@trendhire.com', '21232f297a57a5a743894a0e4a801fc3');
-- Password is 'admin' (MD5 hashed)

-- Insert sample companies
INSERT IGNORE INTO company (companyName, companyAddress, companyCategory, companyWeb, companyEmail, companyEmployee, companyUsername, companyPassword, companyAbout) VALUES
('TechCorp Solutions', 'Colombo 03, Sri Lanka', 'Technology', 'www.techcorp.lk', 'hr@techcorp.lk', '100-500', 'techcorp', '5d41402abc4b2a76b9719d911017c592', 'Leading technology solutions provider in Sri Lanka'),
('Green Energy Ltd', 'Kandy, Sri Lanka', 'Energy', 'www.greenenergy.lk', 'careers@greenenergy.lk', '50-100', 'greenenergy', '5d41402abc4b2a76b9719d911017c592', 'Sustainable energy solutions for a better tomorrow'),
('Creative Designs', 'Galle, Sri Lanka', 'Design', 'www.creativedesigns.lk', 'jobs@creativedesigns.lk', '10-50', 'creative', '5d41402abc4b2a76b9719d911017c592', 'Award-winning design agency specializing in digital solutions');
-- Password is 'hello' (MD5 hashed)

-- Insert sample job seekers
INSERT IGNORE INTO seeker (seekerFName, seekerLName, seekerEmail, seekerPhone, seekerUName, seekerAddress, seekerPassword, seekerAbout) VALUES
('John', 'Doe', 'john.doe@email.com', '+94771234567', 'johndoe', 'Colombo, Sri Lanka', '5d41402abc4b2a76b9719d911017c592', 'Experienced software developer with 5+ years in web development'),
('Jane', 'Smith', 'jane.smith@email.com', '+94772345678', 'janesmith', 'Kandy, Sri Lanka', '5d41402abc4b2a76b9719d911017c592', 'Creative graphic designer passionate about user experience'),
('Mike', 'Johnson', 'mike.johnson@email.com', '+94773456789', 'mikejohnson', 'Galle, Sri Lanka', '5d41402abc4b2a76b9719d911017c592', 'Marketing professional with expertise in digital campaigns');
-- Password is 'hello' (MD5 hashed)

-- Insert sample vacancies with enhanced features
INSERT IGNORE INTO vacancy (companyID, title, category, location, type, salary, description, experience_level, salary_min, salary_max, job_status, required_skills) VALUES
(1, 'Senior Java Developer', 'Technology', 'Colombo', 'Full-time', 'Rs. 150,000 - 200,000', 'We are looking for an experienced Java developer to join our dynamic team. Must have experience with Spring Boot, MySQL, and web development.', 'Senior Level', 150000, 200000, 'Published', '[{"name":"Java","level":"Advanced","required":true},{"name":"Spring Boot","level":"Intermediate","required":true},{"name":"MySQL","level":"Intermediate","required":true}]'),
(1, 'Frontend Developer', 'Technology', 'Colombo', 'Full-time', 'Rs. 100,000 - 150,000', 'Join our frontend team to create amazing user experiences. Required skills: React, JavaScript, HTML5, CSS3.', 'Mid Level', 100000, 150000, 'Published', '[{"name":"React","level":"Advanced","required":true},{"name":"JavaScript","level":"Advanced","required":true},{"name":"HTML5","level":"Intermediate","required":true}]'),
(2, 'Project Manager', 'Management', 'Kandy', 'Full-time', 'Rs. 180,000 - 250,000', 'Lead renewable energy projects from conception to completion. PMP certification preferred.', 'Senior Level', 180000, 250000, 'Published', '[{"name":"Project Management","level":"Advanced","required":true},{"name":"PMP Certification","level":"Expert","required":false}]'),
(3, 'Graphic Designer', 'Design', 'Galle', 'Part-time', 'Rs. 50,000 - 80,000', 'Create stunning visual designs for our clients. Proficiency in Adobe Creative Suite required.', 'Mid Level', 50000, 80000, 'Published', '[{"name":"Adobe Photoshop","level":"Advanced","required":true},{"name":"Adobe Illustrator","level":"Intermediate","required":true}]'),
(1, 'DevOps Engineer', 'Technology', 'Remote', 'Remote', 'Rs. 200,000 - 300,000', 'Manage cloud infrastructure and deployment pipelines. Experience with AWS, Docker, and Kubernetes required.', 'Senior Level', 200000, 300000, 'Published', '[{"name":"Docker","level":"Advanced","required":true},{"name":"Kubernetes","level":"Intermediate","required":true},{"name":"AWS","level":"Intermediate","required":false}]');

-- Insert sample applications
INSERT IGNORE INTO application (vacancyID, seekerID, companyID, status, application_status) VALUES
(1, 1, 1, 'Under Review', 'Under Review'),
(2, 1, 1, 'Waiting', 'Applied'),
(3, 2, 2, 'Accepted', 'Selected'),
(4, 2, 3, 'Waiting', 'Applied'),
(5, 3, 1, 'Rejected', 'Rejected');

-- Insert sample recruiters
INSERT IGNORE INTO recruiter (companyID, recruiter_name, recruiter_email, recruiter_phone, department, role) VALUES
(1, 'Sarah Johnson', 'sarah.johnson@techcorp.lk', '+94771234567', 'Human Resources', 'HR Manager'),
(1, 'Mike Chen', 'mike.chen@techcorp.lk', '+94772345678', 'Engineering', 'Hiring Manager'),
(2, 'Emma Wilson', 'emma.wilson@greenenergy.lk', '+94773456789', 'HR', 'Recruiter'),
(3, 'David Brown', 'david.brown@creativedesigns.lk', '+94774567890', 'Creative', 'Hiring Manager');

-- Insert sample job skills for existing vacancies
INSERT IGNORE INTO job_skills (vacancyID, skill_name, skill_level, is_required) VALUES
(1, 'Java', 'Advanced', TRUE),
(1, 'Spring Boot', 'Intermediate', TRUE),
(1, 'MySQL', 'Intermediate', TRUE),
(1, 'REST APIs', 'Intermediate', FALSE),
(2, 'React', 'Advanced', TRUE),
(2, 'JavaScript', 'Advanced', TRUE),
(2, 'HTML5', 'Intermediate', TRUE),
(2, 'CSS3', 'Intermediate', TRUE),
(3, 'Project Management', 'Advanced', TRUE),
(3, 'PMP Certification', 'Expert', FALSE),
(4, 'Adobe Photoshop', 'Advanced', TRUE),
(4, 'Adobe Illustrator', 'Intermediate', TRUE),
(5, 'Docker', 'Advanced', TRUE),
(5, 'Kubernetes', 'Intermediate', TRUE),
(5, 'AWS', 'Intermediate', FALSE);

-- Insert sample seeker skills
INSERT IGNORE INTO seeker_skills (seekerID, skill_name, skill_level, years_experience) VALUES
(1, 'Java', 'Advanced', 5.0),
(1, 'Spring Boot', 'Advanced', 3.0),
(1, 'MySQL', 'Intermediate', 4.0),
(1, 'React', 'Intermediate', 2.0),
(2, 'Adobe Photoshop', 'Expert', 6.0),
(2, 'Adobe Illustrator', 'Advanced', 5.0),
(2, 'UI/UX Design', 'Advanced', 4.0),
(3, 'Digital Marketing', 'Advanced', 4.0),
(3, 'Google Analytics', 'Intermediate', 3.0),
(3, 'Social Media Marketing', 'Advanced', 5.0);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_vacancy_company ON vacancy(companyID);
CREATE INDEX IF NOT EXISTS idx_vacancy_category ON vacancy(category);
CREATE INDEX IF NOT EXISTS idx_vacancy_location ON vacancy(location);
CREATE INDEX IF NOT EXISTS idx_vacancy_status ON vacancy(job_status);
CREATE INDEX IF NOT EXISTS idx_vacancy_deadline ON vacancy(application_deadline);
CREATE INDEX IF NOT EXISTS idx_application_vacancy ON application(vacancyID);
CREATE INDEX IF NOT EXISTS idx_application_seeker ON application(seekerID);
CREATE INDEX IF NOT EXISTS idx_application_company ON application(companyID);
CREATE INDEX IF NOT EXISTS idx_application_status ON application(application_status);
CREATE INDEX IF NOT EXISTS idx_interview_date ON interview(interview_date);
CREATE INDEX IF NOT EXISTS idx_notifications_recipient ON notifications(recipient_type, recipient_id, is_read);

-- Create views for common queries
CREATE OR REPLACE VIEW active_vacancies AS
SELECT v.*, c.companyName, c.companyEmail,
       COUNT(a.applicationID) as total_applications,
       COUNT(CASE WHEN a.application_status = 'Applied' THEN 1 END) as new_applications,
       COUNT(CASE WHEN a.application_status = 'Shortlisted' THEN 1 END) as shortlisted
FROM vacancy v
LEFT JOIN company c ON v.companyID = c.companyID
LEFT JOIN application a ON v.vacancyID = a.vacancyID
WHERE v.job_status = 'Published'
GROUP BY v.vacancyID;

CREATE OR REPLACE VIEW application_summary AS
SELECT a.*, v.title as job_title, v.location, v.type as job_type,
       s.seekerFName, s.seekerLName, s.seekerEmail, s.seekerPhone,
       c.companyName,
       DATEDIFF(CURDATE(), a.applied_date) as days_since_applied
FROM application a
JOIN vacancy v ON a.vacancyID = v.vacancyID
JOIN seeker s ON a.seekerID = s.seekerID
JOIN company c ON a.companyID = c.companyID;

-- Show all tables created
SHOW TABLES;

-- Display success message
SELECT 'TrendHire database setup completed successfully!' as Status,
       'All basic and enhanced features are now available' as Message,
       'You can now use the enhanced job posting system' as Note;