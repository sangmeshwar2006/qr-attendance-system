-- ============================================
-- QR ATTENDANCE SYSTEM - SEED DATA
-- Sample test data for development
-- ============================================

USE qr_attendance;

-- ============================================
-- INSERT ADMIN USER
-- ============================================
INSERT INTO users (email, password, name, phone, role, is_active) VALUES
('admin@college.edu', '$2a$10$n9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36P4/1Pq', 'Admin User', '+91-9999999999', 'admin', TRUE);

-- ============================================
-- INSERT DEPARTMENTS
-- ============================================
INSERT INTO departments (name, code, description, head_id) VALUES
('Computer Science', 'CS', 'Department of Computer Science and Engineering', 1),
('Electronics', 'EC', 'Department of Electronics and Communication', 1),
('Mechanical', 'ME', 'Department of Mechanical Engineering', 1),
('Electrical', 'EE', 'Department of Electrical Engineering', 1);

-- ============================================
-- INSERT FACULTY USERS
-- ============================================
INSERT INTO users (email, password, name, phone, role, is_active) VALUES
('prof_ramesh@college.edu', '$2a$10$n9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36P4/1Pq', 'Prof. Ramesh Kumar', '+91-9876543210', 'faculty', TRUE),
('prof_priya@college.edu', '$2a$10$n9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36P4/1Pq', 'Prof. Priya Singh', '+91-9876543211', 'faculty', TRUE),
('prof_amit@college.edu', '$2a$10$n9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36P4/1Pq', 'Prof. Amit Patel', '+91-9876543212', 'faculty', TRUE),
('prof_neha@college.edu', '$2a$10$n9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36P4/1Pq', 'Prof. Neha Sharma', '+91-9876543213', 'faculty', TRUE);

-- ============================================
-- INSERT FACULTY DETAILS
-- ============================================
INSERT INTO faculty (user_id, employee_id, department_id, qualification, specialization, phone, office_room, is_active) VALUES
(2, 'FAC001', 1, 'M.Tech', 'Data Structures', '+91-9876543210', '101', TRUE),
(3, 'FAC002', 1, 'M.Tech', 'Web Development', '+91-9876543211', '102', TRUE),
(4, 'FAC003', 2, 'B.E., M.Tech', 'Digital Electronics', '+91-9876543212', '201', TRUE),
(5, 'FAC004', 2, 'B.E., M.Tech', 'Microprocessors', '+91-9876543213', '202', TRUE);

-- ============================================
-- INSERT STUDENT USERS
-- ============================================
INSERT INTO users (email, password, name, phone, role, is_active) VALUES
('student1@college.edu', '$2a$10$n9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36P4/1Pq', 'Raj Kumar', '+91-8765432101', 'student', TRUE),
('student2@college.edu', '$2a$10$n9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36P4/1Pq', 'Priya Sharma', '+91-8765432102', 'student', TRUE),
('student3@college.edu', '$2a$10$n9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36P4/1Pq', 'Rohit Singh', '+91-8765432103', 'student', TRUE),
('student4@college.edu', '$2a$10$n9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36P4/1Pq', 'Neha Gupta', '+91-8765432104', 'student', TRUE),
('student5@college.edu', '$2a$10$n9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36P4/1Pq', 'Arun Patel', '+91-8765432105', 'student', TRUE),
('student6@college.edu', '$2a$10$n9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36P4/1Pq', 'Sakshi Kumar', '+91-8765432106', 'student', TRUE),
('student7@college.edu', '$2a$10$n9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36P4/1Pq', 'Vikram Singh', '+91-8765432107', 'student', TRUE),
('student8@college.edu', '$2a$10$n9qo8uLOickgx2ZMRZoMyeIjZAgcg7b3XeKeUxWdeS86E36P4/1Pq', 'Ananya Verma', '+91-8765432108', 'student', TRUE);

-- ============================================
-- INSERT STUDENT DETAILS
-- ============================================
INSERT INTO students (user_id, roll_number, enrollment_number, department_id, semester, section, parent_phone, address, is_active) VALUES
(6, 'CS001', 'EN2021CS001', 1, 1, 'A', '+91-9111111111', '123 Main Street, City', TRUE),
(7, 'CS002', 'EN2021CS002', 1, 1, 'A', '+91-9111111112', '456 Elm Street, City', TRUE),
(8, 'CS003', 'EN2021CS003', 1, 1, 'B', '+91-9111111113', '789 Oak Street, City', TRUE),
(9, 'CS004', 'EN2021CS004', 1, 1, 'B', '+91-9111111114', '321 Pine Street, City', TRUE),
(10, 'EC001', 'EN2021EC001', 2, 2, 'A', '+91-9111111115', '654 Maple Street, City', TRUE),
(11, 'EC002', 'EN2021EC002', 2, 2, 'A', '+91-9111111116', '987 Birch Street, City', TRUE),
(12, 'EC003', 'EN2021EC003', 2, 2, 'B', '+91-9111111117', '111 Cedar Street, City', TRUE),
(13, 'EC004', 'EN2021EC004', 2, 2, 'B', '+91-9111111118', '222 Spruce Street, City', TRUE);

-- ============================================
-- INSERT SUBJECTS
-- ============================================
INSERT INTO subjects (code, name, description, department_id, semester, credits, is_active) VALUES
('CS101', 'Data Structures', 'Fundamentals of data structures and algorithms', 1, 1, 4, TRUE),
('CS102', 'Web Development', 'HTML, CSS, JavaScript, and frameworks', 1, 1, 3, TRUE),
('CS103', 'Database Systems', 'SQL and database design', 1, 2, 4, TRUE),
('EC101', 'Digital Electronics', 'Logic gates and digital circuits', 2, 1, 4, TRUE),
('EC102', 'Microprocessors', 'x86 architecture and assembly', 2, 1, 3, TRUE),
('EC103', 'Signals and Systems', 'Signal processing fundamentals', 2, 2, 4, TRUE);

-- ============================================
-- INSERT SUBJECT-FACULTY ASSIGNMENTS
-- ============================================
INSERT INTO subject_faculty (subject_id, faculty_id, section, semester, academic_year, is_active) VALUES
(1, 1, 'A', 1, '2024-2025', TRUE),
(1, 1, 'B', 1, '2024-2025', TRUE),
(2, 2, 'A', 1, '2024-2025', TRUE),
(2, 2, 'B', 1, '2024-2025', TRUE),
(4, 3, 'A', 1, '2024-2025', TRUE),
(4, 3, 'B', 1, '2024-2025', TRUE),
(5, 4, 'A', 1, '2024-2025', TRUE),
(5, 4, 'B', 1, '2024-2025', TRUE);

-- ============================================
-- INSERT CLASS SCHEDULES
-- ============================================
INSERT INTO class_schedules (subject_faculty_id, day_of_week, start_time, end_time, room_number, semester, section, is_active) VALUES
(1, 0, '09:00:00', '10:00:00', 'A101', 1, 'A', TRUE),
(1, 2, '09:00:00', '10:00:00', 'A101', 1, 'A', TRUE),
(1, 4, '09:00:00', '10:00:00', 'A101', 1, 'A', TRUE),
(2, 0, '10:15:00', '11:15:00', 'A102', 1, 'B', TRUE),
(2, 2, '10:15:00', '11:15:00', 'A102', 1, 'B', TRUE),
(2, 4, '10:15:00', '11:15:00', 'A102', 1, 'B', TRUE),
(3, 1, '11:30:00', '12:30:00', 'A103', 1, 'A', TRUE),
(3, 3, '11:30:00', '12:30:00', 'A103', 1, 'A', TRUE),
(3, 5, '11:30:00', '12:30:00', 'A103', 1, 'A', TRUE),
(4, 1, '14:00:00', '15:00:00', 'B101', 1, 'B', TRUE),
(4, 3, '14:00:00', '15:00:00', 'B101', 1, 'B', TRUE),
(4, 5, '14:00:00', '15:00:00', 'B101', 1, 'B', TRUE);

-- ============================================
-- INSERT SAMPLE QR SESSIONS (for testing)
-- ============================================
INSERT INTO qr_sessions (session_uuid, faculty_id, subject_faculty_id, qr_token, generated_at, expires_at, started_at, ended_at, status, semester, section) VALUES
('550e8400-e29b-41d4-a716-446655440001', 1, 1, 'encrypted_token_001', NOW(), DATE_ADD(NOW(), INTERVAL 30 SECOND), NOW(), NULL, 'active', 1, 'A'),
('550e8400-e29b-41d4-a716-446655440002', 2, 3, 'encrypted_token_002', DATE_SUB(NOW(), INTERVAL 1 MINUTE), DATE_SUB(NOW(), INTERVAL 30 SECOND), DATE_SUB(NOW(), INTERVAL 1 MINUTE), DATE_SUB(NOW(), INTERVAL 30 SECOND), 'completed', 1, 'A'),
('550e8400-e29b-41d4-a716-446655440003', 3, 5, 'encrypted_token_003', DATE_SUB(NOW(), INTERVAL 2 HOUR), DATE_SUB(NOW(), INTERVAL 2 HOUR), DATE_SUB(NOW(), INTERVAL 2 HOUR), NULL, 'expired', 1, 'A');

-- ============================================
-- INSERT SAMPLE ATTENDANCE RECORDS
-- ============================================
INSERT INTO attendance (student_id, qr_session_id, subject_id, faculty_id, semester, section, marked_at, status) VALUES
(1, 1, 1, 1, 1, 'A', NOW(), 'present'),
(2, 1, 1, 1, 1, 'A', NOW(), 'present'),
(3, 1, 1, 1, 1, 'A', NOW(), 'absent'),
(4, 1, 1, 1, 1, 'A', NOW(), 'present'),
(1, 2, 1, 1, 1, 'A', DATE_SUB(NOW(), INTERVAL 1 DAY), 'present'),
(2, 2, 1, 1, 1, 'A', DATE_SUB(NOW(), INTERVAL 1 DAY), 'present'),
(3, 2, 1, 1, 1, 'A', DATE_SUB(NOW(), INTERVAL 1 DAY), 'present'),
(4, 2, 1, 1, 1, 'A', DATE_SUB(NOW(), INTERVAL 1 DAY), 'absent');

-- ============================================
-- INSERT ATTENDANCE SUMMARY
-- ============================================
INSERT INTO attendance_summary (student_id, subject_id, semester, total_classes, present_count, absent_count, attendance_percentage) VALUES
(1, 1, 1, 2, 2, 0, 100),
(2, 1, 1, 2, 2, 0, 100),
(3, 1, 1, 2, 1, 1, 50),
(4, 1, 1, 2, 1, 1, 50),
(5, 4, 2, 0, 0, 0, 0),
(6, 4, 2, 0, 0, 0, 0),
(7, 5, 2, 0, 0, 0, 0),
(8, 5, 2, 0, 0, 0, 0);

-- ============================================
-- INSERT NOTIFICATIONS (Sample)
-- ============================================
INSERT INTO notifications (user_id, title, message, notification_type, is_read) VALUES
(6, 'Attendance Marked', 'Your attendance has been marked for CS101 class', 'attendance', FALSE),
(7, 'Attendance Alert', 'Your attendance is below 75% threshold', 'alert', FALSE),
(1, 'New Attendance Session', 'Prof. Ramesh created attendance session for CS101', 'system', FALSE);

-- ============================================
-- END SEED DATA
-- ============================================
