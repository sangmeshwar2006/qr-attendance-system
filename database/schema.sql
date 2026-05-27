-- ============================================
-- QR CODE ATTENDANCE MANAGEMENT SYSTEM
-- MySQL Database Schema
-- ============================================

-- Create Database
CREATE DATABASE IF NOT EXISTS qr_attendance;
USE qr_attendance;

-- ============================================
-- 1. USERS TABLE (Base User Accounts)
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role ENUM('admin', 'faculty', 'student') NOT NULL DEFAULT 'student',
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_is_active (is_active)
);

-- ============================================
-- 2. DEPARTMENTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) UNIQUE NOT NULL,
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    head_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (head_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_name (name),
    INDEX idx_code (code)
);

-- ============================================
-- 3. FACULTY TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS faculty (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,
    employee_id VARCHAR(50) UNIQUE NOT NULL,
    department_id INT NOT NULL,
    qualification VARCHAR(255),
    specialization VARCHAR(255),
    phone VARCHAR(20),
    office_room VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE RESTRICT,
    INDEX idx_employee_id (employee_id),
    INDEX idx_department_id (department_id),
    INDEX idx_is_active (is_active)
);

-- ============================================
-- 4. STUDENTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,
    roll_number VARCHAR(50) UNIQUE NOT NULL,
    enrollment_number VARCHAR(100) UNIQUE NOT NULL,
    department_id INT NOT NULL,
    semester INT NOT NULL DEFAULT 1,
    section VARCHAR(10),
    parent_phone VARCHAR(20),
    address TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE RESTRICT,
    INDEX idx_roll_number (roll_number),
    INDEX idx_enrollment_number (enrollment_number),
    INDEX idx_department_id (department_id),
    INDEX idx_semester (semester),
    INDEX idx_section (section),
    INDEX idx_is_active (is_active)
);

-- ============================================
-- 5. SUBJECTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS subjects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    department_id INT NOT NULL,
    semester INT NOT NULL,
    credits INT DEFAULT 3,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE RESTRICT,
    INDEX idx_code (code),
    INDEX idx_department_id (department_id),
    INDEX idx_semester (semester),
    UNIQUE KEY unique_subject (code, department_id, semester)
);

-- ============================================
-- 6. SUBJECT-FACULTY ASSIGNMENT TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS subject_faculty (
    id INT PRIMARY KEY AUTO_INCREMENT,
    subject_id INT NOT NULL,
    faculty_id INT NOT NULL,
    section VARCHAR(10),
    semester INT NOT NULL,
    academic_year VARCHAR(10),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
    FOREIGN KEY (faculty_id) REFERENCES faculty(id) ON DELETE CASCADE,
    INDEX idx_faculty_id (faculty_id),
    INDEX idx_subject_id (subject_id),
    INDEX idx_semester (semester),
    UNIQUE KEY unique_assignment (subject_id, faculty_id, section, semester)
);

-- ============================================
-- 7. CLASS SCHEDULES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS class_schedules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    subject_faculty_id INT NOT NULL,
    day_of_week INT NOT NULL COMMENT '0=Monday, 6=Sunday',
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    room_number VARCHAR(50),
    semester INT NOT NULL,
    section VARCHAR(10),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (subject_faculty_id) REFERENCES subject_faculty(id) ON DELETE CASCADE,
    INDEX idx_day_of_week (day_of_week),
    INDEX idx_subject_faculty_id (subject_faculty_id)
);

-- ============================================
-- 8. QR SESSIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS qr_sessions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    session_uuid VARCHAR(36) UNIQUE NOT NULL COMMENT 'Unique session identifier',
    faculty_id INT NOT NULL,
    subject_faculty_id INT NOT NULL,
    qr_token VARCHAR(255) UNIQUE NOT NULL COMMENT 'Encrypted token',
    qr_code_data LONGTEXT COMMENT 'Base64 encoded QR code image',
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL COMMENT '30 seconds from generation',
    started_at TIMESTAMP NULL,
    ended_at TIMESTAMP NULL,
    status ENUM('generated', 'active', 'expired', 'completed') DEFAULT 'generated',
    semester INT,
    section VARCHAR(10),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (faculty_id) REFERENCES faculty(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_faculty_id) REFERENCES subject_faculty(id) ON DELETE CASCADE,
    INDEX idx_faculty_id (faculty_id),
    INDEX idx_session_uuid (session_uuid),
    INDEX idx_expires_at (expires_at),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);

-- ============================================
-- 9. ATTENDANCE TABLE (Main Records)
-- ============================================
CREATE TABLE IF NOT EXISTS attendance (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    qr_session_id INT NOT NULL,
    subject_id INT NOT NULL,
    faculty_id INT NOT NULL,
    semester INT NOT NULL,
    section VARCHAR(10),
    marked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    device_info VARCHAR(255) COMMENT 'Device fingerprint',
    ip_address VARCHAR(45) COMMENT 'IPv4 or IPv6',
    latitude DECIMAL(10, 8) NULL,
    longitude DECIMAL(11, 8) NULL,
    accuracy FLOAT NULL COMMENT 'Geolocation accuracy in meters',
    status ENUM('present', 'absent', 'late', 'excused') DEFAULT 'present',
    notes TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (qr_session_id) REFERENCES qr_sessions(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE RESTRICT,
    FOREIGN KEY (faculty_id) REFERENCES faculty(id) ON DELETE RESTRICT,
    INDEX idx_student_id (student_id),
    INDEX idx_qr_session_id (qr_session_id),
    INDEX idx_subject_id (subject_id),
    INDEX idx_faculty_id (faculty_id),
    INDEX idx_marked_at (marked_at),
    INDEX idx_semester_section (semester, section),
    UNIQUE KEY unique_attendance (student_id, qr_session_id)
);

-- ============================================
-- 10. ATTENDANCE SUMMARY TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS attendance_summary (
    id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    semester INT NOT NULL,
    total_classes INT DEFAULT 0,
    present_count INT DEFAULT 0,
    absent_count INT DEFAULT 0,
    late_count INT DEFAULT 0,
    excused_count INT DEFAULT 0,
    attendance_percentage DECIMAL(5, 2) DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
    INDEX idx_student_id (student_id),
    INDEX idx_subject_id (subject_id),
    INDEX idx_semester (semester),
    INDEX idx_attendance_percentage (attendance_percentage),
    UNIQUE KEY unique_summary (student_id, subject_id, semester)
);

-- ============================================
-- 11. REPORTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS reports (
    id INT PRIMARY KEY AUTO_INCREMENT,
    report_type ENUM('attendance', 'student', 'faculty', 'department') NOT NULL,
    generated_by INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    filters JSON COMMENT 'Filter criteria used',
    file_path VARCHAR(255),
    file_format ENUM('pdf', 'excel', 'csv') DEFAULT 'pdf',
    total_records INT,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NULL,
    download_count INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (generated_by) REFERENCES users(id) ON DELETE RESTRICT,
    INDEX idx_report_type (report_type),
    INDEX idx_generated_by (generated_by),
    INDEX idx_generated_at (generated_at)
);

-- ============================================
-- 12. AUDIT LOGS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS audit_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(100),
    entity_id INT,
    old_values JSON,
    new_values JSON,
    ip_address VARCHAR(45),
    user_agent TEXT,
    status ENUM('success', 'failed') DEFAULT 'success',
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_action (action),
    INDEX idx_created_at (created_at),
    INDEX idx_entity (entity_type, entity_id)
);

-- ============================================
-- 13. NOTIFICATIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    notification_type ENUM('attendance', 'assignment', 'alert', 'system', 'info') DEFAULT 'info',
    related_entity_type VARCHAR(100),
    related_entity_id INT,
    is_read BOOLEAN DEFAULT FALSE,
    read_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_is_read (is_read),
    INDEX idx_created_at (created_at)
);

-- ============================================
-- 14. ADMIN SETTINGS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS admin_settings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    setting_key VARCHAR(255) UNIQUE NOT NULL,
    setting_value LONGTEXT,
    description TEXT,
    data_type ENUM('string', 'integer', 'boolean', 'json') DEFAULT 'string',
    updated_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_setting_key (setting_key)
);

-- ============================================
-- DEFAULT SETTINGS
-- ============================================
INSERT IGNORE INTO admin_settings (setting_key, setting_value, description, data_type) VALUES
('qr_expiry_seconds', '30', 'QR code expiry time in seconds', 'integer'),
('attendance_threshold', '75', 'Minimum attendance percentage required', 'integer'),
('enable_geolocation', 'false', 'Enable geolocation verification for attendance', 'boolean'),
('max_geolocation_radius', '500', 'Maximum geolocation radius in meters', 'integer'),
('enable_email_notifications', 'true', 'Send email notifications', 'boolean'),
('organization_name', 'College Name', 'Organization name', 'string'),
('organization_email', 'admin@college.edu', 'Organization contact email', 'string');

-- ============================================
-- CREATE INDEXES FOR PERFORMANCE
-- ============================================
CREATE INDEX idx_attendance_date ON attendance(marked_at);
CREATE INDEX idx_attendance_student_subject ON attendance(student_id, subject_id);
CREATE INDEX idx_qr_session_status_expires ON qr_sessions(status, expires_at);
CREATE INDEX idx_faculty_department ON faculty(department_id, is_active);
CREATE INDEX idx_student_department_semester ON students(department_id, semester, is_active);

-- ============================================
-- TRIGGER: Update attendance_summary on insert
-- ============================================
DELIMITER $$

CREATE TRIGGER update_attendance_summary_after_insert
AFTER INSERT ON attendance
FOR EACH ROW
BEGIN
    DECLARE total_classes INT;
    DECLARE present_count INT;
    DECLARE absent_count INT;
    DECLARE attendance_pct DECIMAL(5, 2);
    
    -- Get total classes for the student-subject combination
    SELECT COUNT(*) INTO total_classes
    FROM attendance
    WHERE student_id = NEW.student_id
    AND subject_id = NEW.subject_id
    AND semester = NEW.semester;
    
    -- Count present
    SELECT COUNT(*) INTO present_count
    FROM attendance
    WHERE student_id = NEW.student_id
    AND subject_id = NEW.subject_id
    AND semester = NEW.semester
    AND status = 'present';
    
    -- Calculate percentage
    IF total_classes > 0 THEN
        SET attendance_pct = (present_count / total_classes) * 100;
    ELSE
        SET attendance_pct = 0;
    END IF;
    
    -- Insert or update summary
    INSERT INTO attendance_summary (student_id, subject_id, semester, total_classes, present_count, attendance_percentage)
    VALUES (NEW.student_id, NEW.subject_id, NEW.semester, total_classes, present_count, attendance_pct)
    ON DUPLICATE KEY UPDATE
    total_classes = total_classes,
    present_count = present_count,
    attendance_percentage = attendance_pct,
    last_updated = CURRENT_TIMESTAMP;
END$$

DELIMITER ;

-- ============================================
-- TRIGGER: Create audit log on user action
-- ============================================
DELIMITER $$

CREATE TRIGGER audit_log_attendance
AFTER INSERT ON attendance
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs (action, entity_type, entity_id, new_values, status)
    VALUES ('INSERT', 'attendance', NEW.id, JSON_OBJECT('student_id', NEW.student_id, 'qr_session_id', NEW.qr_session_id), 'success');
END$$

DELIMITER ;
