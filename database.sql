-- ==========================================
-- UPWORK CLONE - DATABASE STRUCTURE
-- Created for MVP with 8 key use cases
-- ==========================================

-- Drop database if exists
DROP DATABASE IF EXISTS upwork_clone;

-- Create database
CREATE DATABASE upwork_clone CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE upwork_clone;

-- ==========================================
-- 1. TABLE: USERS
-- ==========================================
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('freelancer', 'client') NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    profile_picture VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_role (role)
);

-- ==========================================
-- 2. TABLE: FREELANCER_PROFILES
-- ==========================================
CREATE TABLE freelancer_profiles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE,
    title VARCHAR(255),
    bio TEXT,
    hourly_rate DECIMAL(10, 2),
    experience_level ENUM('beginner', 'intermediate', 'expert'),
    portfolio_url VARCHAR(255),
    location VARCHAR(100),
    rating DECIMAL(3, 2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_experience (experience_level)
);

-- ==========================================
-- 3. TABLE: SKILLS
-- ==========================================
CREATE TABLE skills (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) UNIQUE NOT NULL,
    category VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 4. TABLE: FREELANCER_SKILLS
-- ==========================================
CREATE TABLE freelancer_skills (
    id INT PRIMARY KEY AUTO_INCREMENT,
    freelancer_id INT NOT NULL,
    skill_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (freelancer_id) REFERENCES freelancer_profiles(id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE,
    UNIQUE (freelancer_id, skill_id),
    INDEX idx_freelancer_id (freelancer_id),
    INDEX idx_skill_id (skill_id)
);

-- ==========================================
-- 5. TABLE: CLIENT_PROFILES
-- ==========================================
CREATE TABLE client_profiles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL UNIQUE,
    company_name VARCHAR(255),
    company_description TEXT,
    location VARCHAR(100),
    rating DECIMAL(3, 2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
);

-- ==========================================
-- 6. TABLE: JOBS
-- ==========================================
CREATE TABLE jobs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(100),
    budget DECIMAL(10, 2),
    budget_type ENUM('fixed', 'hourly') DEFAULT 'fixed',
    experience_level ENUM('beginner', 'intermediate', 'expert'),
    status ENUM('open', 'closed') DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES client_profiles(id) ON DELETE CASCADE,
    INDEX idx_client_id (client_id),
    INDEX idx_status (status),
    INDEX idx_category (category)
);

-- ==========================================
-- 7. TABLE: JOB_SKILLS
-- ==========================================
CREATE TABLE job_skills (
    id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT NOT NULL,
    skill_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(id) ON DELETE CASCADE,
    UNIQUE (job_id, skill_id),
    INDEX idx_job_id (job_id),
    INDEX idx_skill_id (skill_id)
);

-- ==========================================
-- 8. TABLE: JOB_APPLICATIONS
-- ==========================================
CREATE TABLE job_applications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT NOT NULL,
    freelancer_id INT NOT NULL,
    bid_amount DECIMAL(10, 2),
    cover_letter TEXT,
    status ENUM('pending', 'accepted', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
    FOREIGN KEY (freelancer_id) REFERENCES freelancer_profiles(id) ON DELETE CASCADE,
    UNIQUE (job_id, freelancer_id),
    INDEX idx_job_id (job_id),
    INDEX idx_freelancer_id (freelancer_id),
    INDEX idx_status (status)
);

-- ==========================================
-- INSERT SAMPLE DATA - SKILLS
-- ==========================================
INSERT INTO skills (name, category) VALUES
('PHP', 'Backend'),
('JavaScript', 'Frontend'),
('React', 'Frontend'),
('Node.js', 'Backend'),
('MySQL', 'Database'),
('HTML/CSS', 'Frontend'),
('Python', 'Backend'),
('UI/UX Design', 'Design'),
('Web Development', 'Full Stack'),
('Mobile Development', 'Development'),
('WordPress', 'CMS'),
('Vue.js', 'Frontend');

-- ==========================================
-- INSERT SAMPLE DATA - USERS & PROFILES
-- ==========================================

-- Sample Freelancer User
INSERT INTO users (email, password, role, first_name, last_name) VALUES
('john@example.com', '$2y$10$YQvbJk1v5nzJ5cN7kL2K0uJ5cN7kL2K0uJ5cN7kL2K0uJ5cN7kL2K', 'freelancer', 'John', 'Developer');

INSERT INTO freelancer_profiles (user_id, title, bio, hourly_rate, experience_level, location, portfolio_url) VALUES
(1, 'Full Stack Developer', 'Experienced web developer with 5 years in PHP and JavaScript', 50.00, 'expert', 'USA', 'https://johndev.com');

INSERT INTO freelancer_skills (freelancer_id, skill_id) VALUES
(1, 1), (1, 2), (1, 4), (1, 5);

-- Sample Client User
INSERT INTO users (email, password, role, first_name, last_name) VALUES
('client@example.com', '$2y$10$YQvbJk1v5nzJ5cN7kL2K0uJ5cN7kL2K0uJ5cN7kL2K0uJ5cN7kL2K', 'client', 'Jane', 'Business');

INSERT INTO client_profiles (user_id, company_name, company_description, location) VALUES
(2, 'Tech Startup Inc', 'We build innovative web solutions', 'Canada');

-- Sample Jobs
INSERT INTO jobs (client_id, title, description, category, budget, budget_type, experience_level, status) VALUES
(1, 'Build a responsive website', 'We need a modern, responsive website built with React and Node.js backend', 'Web Development', 2500.00, 'fixed', 'expert', 'open'),
(1, 'WordPress Theme Customization', 'Customize an existing WordPress theme for our business needs', 'WordPress', 500.00, 'fixed', 'intermediate', 'open'),
(1, 'Mobile App Development', 'Create a mobile app using React Native', 'Mobile Development', 5000.00, 'fixed', 'expert', 'open');

-- Link skills to jobs
INSERT INTO job_skills (job_id, skill_id) VALUES
(1, 2), (1, 3), (1, 4), (1, 5),
(2, 11), (2, 6),
(3, 10), (3, 3);

-- Sample Applications
INSERT INTO job_applications (job_id, freelancer_id, bid_amount, cover_letter, status) VALUES
(1, 1, 2400.00, 'I have extensive experience with React and Node.js. I can deliver this project on time with high quality.', 'pending'),
(3, 1, 4800.00, 'I have built several mobile apps using React Native. Perfect match for your requirements.', 'pending');

-- ==========================================
-- CREATE USER FOR APPLICATION
-- ==========================================
CREATE USER IF NOT EXISTS 'upwork_user'@'localhost' IDENTIFIED BY 'upwork_password123';
GRANT ALL PRIVILEGES ON upwork_clone.* TO 'upwork_user'@'localhost';
FLUSH PRIVILEGES;

-- ==========================================
-- VERIFICATION
-- ==========================================
SELECT 'Database created successfully!' as status;
SHOW TABLES;
