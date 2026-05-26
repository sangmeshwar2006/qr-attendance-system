// src/controllers/facultyController.ts
import { Request, Response } from 'express';
import { generateSessionUUID, generateAttendanceQR } from '../utils/qrGenerator';
import { executeQuery, executeUpdate } from '../database/connection';
import { successResponse, errorResponse, paginatedResponse } from '../utils/response';
import { asyncHandler } from '../middleware/errorHandler';

/**
 * Get faculty dashboard
 */
export const getDashboard = asyncHandler(async (req: Request, res: Response) => {
  const facultyResult = await executeQuery<any>(
    'SELECT id FROM faculty WHERE user_id = ?',
    [req.user!.id]
  );
  
  if (facultyResult.length === 0) {
    res.status(404).json(errorResponse('Faculty not found', '', 404));
    return;
  }
  
  const facultyId = facultyResult[0].id;
  
  // Get today's classes
  const todayClasses = await executeQuery<any>(
    `SELECT sf.id, s.name as subject_name, s.code, 
            sf.semester, sf.section, cs.start_time, cs.end_time
     FROM subject_faculty sf
     JOIN subjects s ON sf.subject_id = s.id
     JOIN class_schedules cs ON sf.id = cs.subject_faculty_id
     WHERE sf.faculty_id = ? AND cs.day_of_week = ? AND sf.is_active = 1`,
    [facultyId, new Date().getDay()]
  );
  
  // Get attendance stats
  const attendanceStats = await executeQuery<any>(
    `SELECT COUNT(*) as total_sessions FROM qr_sessions WHERE faculty_id = ? AND DATE(session_start_time) = CURDATE()`,
    [facultyId]
  );
  
  res.json(
    successResponse('Dashboard data retrieved', {
      todayClasses,
      attendanceStats: attendanceStats[0],
    })
  );
});

/**
 * Generate QR code for attendance
 */
export const generateQRCode = asyncHandler(async (req: Request, res: Response) => {
  const { subject_id, semester, section } = req.body;
  
  // Get faculty ID
  const facultyResult = await executeQuery<any>(
    'SELECT id FROM faculty WHERE user_id = ?',
    [req.user!.id]
  );
  
  if (facultyResult.length === 0) {
    res.status(404).json(errorResponse('Faculty not found', '', 404));
    return;
  }
  
  const facultyId = facultyResult[0].id;
  
  // Get subject details
  const subjects = await executeQuery<any>(
    'SELECT code FROM subjects WHERE id = ?',
    [subject_id]
  );
  
  if (subjects.length === 0) {
    res.status(404).json(errorResponse('Subject not found', '', 404));
    return;
  }
  
  const subjectCode = subjects[0].code;
  
  // Create session record
  const sessionId = generateSessionUUID();
  
  const subjectFacultyResult = await executeQuery<any>(
    'SELECT id FROM subject_faculty WHERE subject_id = ? AND faculty_id = ? AND semester = ? AND section = ?',
    [subject_id, facultyId, semester, section]
  );
  
  if (subjectFacultyResult.length === 0) {
    res.status(400).json(errorResponse('Subject not assigned to faculty for this section', '', 400));
    return;
  }
  
  const subjectFacultyId = subjectFacultyResult[0].id;
  
  // Generate QR
  const qr = await generateAttendanceQR(sessionId, subjectCode, facultyId);
  
  // Get enrolled students count
  const studentCount = await executeQuery<any>(
    'SELECT COUNT(*) as count FROM students WHERE semester = ? AND section = ? AND department_id = (SELECT department_id FROM subjects WHERE id = ?)',
    [semester, section, subject_id]
  );
  
  // Save session to database
  const sessionResult = await executeUpdate(
    `INSERT INTO qr_sessions (
      session_uuid, subject_faculty_id, faculty_id, semester, section,
      qr_token, session_start_time, expires_at, total_enrolled_students
    ) VALUES (?, ?, ?, ?, ?, ?, NOW(), FROM_UNIXTIME(?/1000), ?)`,
    [sessionId, subjectFacultyId, facultyId, semester, section, qr.token, qr.expiresAt, studentCount[0].count]
  );
  
  res.status(201).json(
    successResponse('QR code generated', {
      sessionId,
      qrImage: qr.qrImage,
      token: qr.token,
      expiresAt: qr.expiresAt,
      expiresIn: `${(qr.expiresAt - Date.now()) / 1000} seconds`,
    }, 201)
  );
});

/**
 * Get active session attendance
 */
export const getSessionAttendance = asyncHandler(async (req: Request, res: Response) => {
  const { sessionId } = req.params;
  
  // Get session details
  const sessions = await executeQuery<any>(
    'SELECT id, faculty_id, present_count, absent_count FROM qr_sessions WHERE session_uuid = ?',
    [sessionId]
  );
  
  if (sessions.length === 0) {
    res.status(404).json(errorResponse('Session not found', '', 404));
    return;
  }
  
  const session = sessions[0];
  
  // Get attendance records
  const attendance = await executeQuery<any>(
    `SELECT a.id, s.roll_number, u.first_name, u.last_name, a.status, a.check_in_time
     FROM attendance a
     JOIN students s ON a.student_id = s.id
     JOIN users u ON s.user_id = u.id
     WHERE a.qr_session_id = ?
     ORDER BY a.check_in_time DESC`,
    [session.id]
  );
  
  res.json(
    successResponse('Attendance retrieved', {
      sessionId,
      presentCount: session.present_count,
      absentCount: session.absent_count,
      attendance,
    })
  );
});

/**
 * Stop attendance session
 */
export const stopSession = asyncHandler(async (req: Request, res: Response) => {
  const { sessionId } = req.body;
  
  await executeUpdate(
    'UPDATE qr_sessions SET is_active = 0, session_end_time = NOW() WHERE session_uuid = ?',
    [sessionId]
  );
  
  res.json(successResponse('Session stopped'));
});

/**
 * Get attendance reports
 */
export const getAttendanceReports = asyncHandler(async (req: Request, res: Response) => {
  const facultyResult = await executeQuery<any>(
    'SELECT id FROM faculty WHERE user_id = ?',
    [req.user!.id]
  );
  
  if (facultyResult.length === 0) {
    res.status(404).json(errorResponse('Faculty not found', '', 404));
    return;
  }
  
  const facultyId = facultyResult[0].id;
  const { page = 1, limit = 10, subject_id, start_date, end_date } = req.query;
  
  let query = 'SELECT COUNT(*) as total FROM qr_sessions WHERE faculty_id = ?';
  let params: any[] = [facultyId];
  
  if (subject_id) {
    query += ' AND subject_id = ?';
    params.push(subject_id);
  }
  
  if (start_date) {
    query += ' AND DATE(session_start_time) >= ?';
    params.push(start_date);
  }
  
  if (end_date) {
    query += ' AND DATE(session_start_time) <= ?';
    params.push(end_date);
  }
  
  const countResult = await executeQuery<any>(query, params);
  const total = countResult[0].total;
  
  const offset = (Number(page) - 1) * Number(limit);
  
  const reports = await executeQuery<any>(
    `SELECT qs.id, qs.session_uuid, s.name as subject_name, qs.semester, qs.section,
            qs.session_start_time, qs.present_count, qs.absent_count
     FROM qr_sessions qs
     JOIN subject_faculty sf ON qs.subject_faculty_id = sf.id
     JOIN subjects s ON sf.subject_id = s.id
     WHERE qs.faculty_id = ?
     ORDER BY qs.session_start_time DESC
     LIMIT ? OFFSET ?`,
    [facultyId, Number(limit), offset]
  );
  
  res.json(paginatedResponse(reports, total, Number(page), Number(limit), 'Reports retrieved'));
});
