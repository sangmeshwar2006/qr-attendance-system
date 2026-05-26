// src/controllers/authController.ts
import { Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import { executeQuery, executeUpdate } from '../database/connection';
import { generateToken, generateRefreshToken } from '../utils/jwt';
import { successResponse, errorResponse } from '../utils/response';
import { asyncHandler } from '../middleware/errorHandler';

/**
 * Login user
 */
export const login = asyncHandler(async (req: Request, res: Response) => {
  const { email, password } = req.body;
  
  // Fetch user
  const users = await executeQuery<any>(
    'SELECT id, email, password_hash, role FROM users WHERE email = ?',
    [email]
  );
  
  if (users.length === 0) {
    res.status(401).json(errorResponse('Invalid email or password', '', 401));
    return;
  }
  
  const user = users[0];
  
  // Verify password
  const passwordMatch = await bcrypt.compare(password, user.password_hash);
  
  if (!passwordMatch) {
    res.status(401).json(errorResponse('Invalid email or password', '', 401));
    return;
  }
  
  // Generate tokens
  const token = generateToken({
    id: user.id,
    email: user.email,
    role: user.role,
  });
  
  const refreshToken = generateRefreshToken({
    id: user.id,
    email: user.email,
    role: user.role,
  });
  
  // Update last login
  await executeUpdate(
    'UPDATE users SET last_login = NOW() WHERE id = ?',
    [user.id]
  );
  
  res.json(
    successResponse('Login successful', {
      token,
      refreshToken,
      user: {
        id: user.id,
        email: user.email,
        role: user.role,
      },
    })
  );
});

/**
 * Register student
 */
export const register = asyncHandler(async (req: Request, res: Response) => {
  const { email, password, first_name, last_name, roll_number, department_id, semester, section } = req.body;
  
  // Check if email exists
  const existingUsers = await executeQuery<any>(
    'SELECT id FROM users WHERE email = ?',
    [email]
  );
  
  if (existingUsers.length > 0) {
    res.status(400).json(errorResponse('Email already exists', '', 400));
    return;
  }
  
  // Hash password
  const passwordHash = await bcrypt.hash(password, 10);
  
  // Create user
  const userResult = await executeUpdate(
    'INSERT INTO users (email, password_hash, first_name, last_name, role) VALUES (?, ?, ?, ?, ?)',
    [email, passwordHash, first_name, last_name, 'student']
  );
  
  // Create student record
  await executeUpdate(
    `INSERT INTO students (user_id, department_id, roll_number, enrollment_number, semester, section, batch_year, date_of_admission)
     VALUES (?, ?, ?, ?, ?, ?, ?, NOW())`,
    [userResult.insertId, department_id, roll_number, roll_number, semester, section, new Date().getFullYear()]
  );
  
  res.status(201).json(successResponse('Registration successful', { userId: userResult.insertId }, 201));
});

/**
 * Refresh token
 */
export const refreshToken = asyncHandler(async (req: Request, res: Response) => {
  const { refreshToken } = req.body;
  
  if (!refreshToken) {
    res.status(400).json(errorResponse('Refresh token required', '', 400));
    return;
  }
  
  // Verify refresh token (implement similar to verifyToken)
  const token = generateToken({
    id: req.user!.id,
    email: req.user!.email,
    role: req.user!.role,
  });
  
  res.json(successResponse('Token refreshed', { token }));
});

/**
 * Logout
 */
export const logout = asyncHandler(async (req: Request, res: Response) => {
  res.json(successResponse('Logout successful'));
});

/**
 * Get current user
 */
export const getCurrentUser = asyncHandler(async (req: Request, res: Response) => {
  const user = await executeQuery<any>(
    'SELECT id, email, first_name, last_name, phone, avatar_url, role FROM users WHERE id = ?',
    [req.user!.id]
  );
  
  if (user.length === 0) {
    res.status(404).json(errorResponse('User not found', '', 404));
    return;
  }
  
  res.json(successResponse('User fetched', user[0]));
});
