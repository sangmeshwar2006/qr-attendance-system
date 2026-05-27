# 🎓 QR Code Attendance Management System

A **production-ready**, **enterprise-grade**, smart attendance management system for colleges using QR codes. Built with modern tech stack and scalable architecture.

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Node](https://img.shields.io/badge/node-16.0.0-green)
![React](https://img.shields.io/badge/react-18.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## 📋 Table of Contents

- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Database Schema](#-database-schema)
- [Setup & Installation](#-setup--installation)
- [API Documentation](#-api-documentation)
- [Configuration](#-configuration)
- [Security Features](#-security-features)
- [Usage Guide](#-usage-guide)
- [Deployment](#-deployment)
- [Contributing](#-contributing)

## ✨ Features

### 🔐 Authentication & Authorization
- ✅ JWT-based authentication with refresh tokens
- ✅ Role-based access control (Admin, Faculty, Student)
- ✅ Secure password hashing with bcryptjs
- ✅ Session management
- ✅ Multi-device login handling

### 📊 Admin Dashboard
- ✅ User management (Students, Faculty, Admins)
- ✅ Department & Subject management
- ✅ Semester & Section configuration
- ✅ Attendance analytics with charts
- ✅ Export reports (Excel/PDF)
- ✅ Search & filter functionality
- ✅ Audit logging

### 👨‍🏫 Faculty Features
- ✅ Dashboard with today's classes
- ✅ Dynamic QR code generation
- ✅ QR expiry in 30 seconds
- ✅ Real-time attendance monitoring
- ✅ Attendance session management (Start/Stop)
- ✅ View present/absent students
- ✅ Download attendance reports
- ✅ Subject-wise analytics

### 👨‍🎓 Student Features
- ✅ Scan QR code using camera
- ✅ Mark attendance automatically
- ✅ View attendance percentage
- ✅ Subject-wise attendance tracking
- ✅ Attendance history
- ✅ Profile management
- ✅ Notifications

### 🔒 Security & Anti-Proxy Features
- ✅ 30-second QR code expiry
- ✅ One attendance per student per session
- ✅ Device/Session validation
- ✅ Optional geolocation verification
- ✅ Timestamp logging
- ✅ Token encryption (AES-256-GCM)
- ✅ SQL injection prevention
- ✅ CORS protection
- ✅ Rate limiting

### 📈 Advanced Features
- ✅ Real-time attendance updates (Socket.IO ready)
- ✅ Attendance heatmaps
- ✅ Smart analytics dashboard
- ✅ Email notifications
- ✅ Export functionality
- ✅ Responsive mobile-friendly UI
- ✅ Dark/Light mode

## 🛠 Tech Stack

### Frontend
```
React.js 18.0        - UI framework
Tailwind CSS         - Utility-first CSS
shadcn/ui           - Component library
React Router         - Client-side routing
Axios                - HTTP client
Zustand              - State management
Recharts             - Analytics charts
Framer Motion        - Animations
html5-qrcode         - QR code scanning
```

### Backend
```
Node.js              - Runtime
Express.js           - Web framework
MySQL2/Sequelize     - Database ORM
JWT                  - Authentication
bcryptjs             - Password hashing
Joi                  - Schema validation
QRCode               - QR generation
Helmet               - Security headers
CORS                 - Cross-origin support
```

### Database
```
MySQL 8.0            - Relational database
14 Optimized Tables  - Normalized schema
Indexing             - Performance optimization
```

## 📁 Project Structure

```
qr-attendance-system/
├── client/                          # React Frontend
│   ├── public/
│   ├── src/
│   │   ├── components/
│   │   │   ├── Auth/
│   │   │   │   ├── Login.jsx
│   │   │   │   └── Register.jsx
│   │   │   ├── Admin/
│   │   │   │   ├── Dashboard.jsx
│   │   │   │   ├── UserManagement.jsx
│   │   │   │   └── Reports.jsx
│   │   │   ├── Faculty/
│   │   │   │   ├── Dashboard.jsx
│   │   │   │   ├── QRGenerator.jsx
│   │   │   │   └── AttendanceMonitor.jsx
│   │   │   ├── Student/
│   │   │   │   ├── Dashboard.jsx
│   │   │   │   ├── QRScanner.jsx
│   │   │   │   └── AttendanceHistory.jsx
│   │   │   ├── Common/
│   │   │   │   ├── Sidebar.jsx
│   │   │   │   ├── Header.jsx
│   │   │   │   └── ProtectedRoute.jsx
│   │   │   └── Charts/
│   │   │       └── Analytics.jsx
│   │   ├── pages/
│   │   ├── api/
│   │   │   ├── auth.js
│   │   │   ├── faculty.js
│   │   │   ├── admin.js
│   │   │   └── student.js
│   │   ├── store/
│   │   │   └── useAuthStore.js
│   │   ├── utils/
│   │   │   ├── constants.js
│   │   │   └── validators.js
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── .env.example
│   └── package.json
│
├── server/                          # Express Backend
│   ├── src/
│   │   ├── config/
│   │   │   └── environment.ts
│   │   ├── database/
│   │   │   ├── connection.ts
│   │   │   └── models/
│   │   │       ├── User.ts
│   │   │       ├── Student.ts
│   │   │       ├── Faculty.ts
│   │   │       ├── Subject.ts
│   │   │       ├── Attendance.ts
│   │   │       └── QRSession.ts
│   │   ├── utils/
│   │   │   ├── jwt.ts
│   │   │   ├── encryption.ts
│   │   │   ├── qrGenerator.ts
│   │   │   ├── response.ts
│   │   │   ├── validation.ts
│   │   │   └── logger.ts
│   │   ├── middleware/
│   │   │   ├── auth.ts
│   │   │   ├── errorHandler.ts
│   │   │   ├── validate.ts
│   │   │   └── rateLimiter.ts
│   │   ├── controllers/
│   │   │   ├── authController.ts
│   │   │   ├── facultyController.ts
│   │   │   ├── studentController.ts
│   │   │   ├── adminController.ts
│   │   │   └── attendanceController.ts
│   │   ├── routes/
│   │   │   ├── auth.ts
│   │   │   ├── faculty.ts
│   │   │   ├── student.ts
│   │   │   ├── admin.ts
│   │   │   └── attendance.ts
│   │   └── app.ts
│   ├── .env.example
│   └── package.json
│
├── database/
│   ├── schema.sql                   # Complete database schema
│   ├── seedData.sql                 # Sample test data
│   └── migrations/
│
├── docs/
│   ├── API.md                       # API Documentation
│   ├── SETUP.md                     # Setup Instructions
│   ├── DEPLOYMENT.md                # Deployment Guide
│   └── ARCHITECTURE.md              # System Architecture
│
└── .gitignore
```

## 🗄️ Database Schema

### Tables (14 Total)

1. **users** - Base user accounts
2. **departments** - College departments
3. **faculty** - Faculty information
4. **students** - Student records
5. **subjects** - Courses/subjects
6. **subject_faculty** - Faculty assignments
7. **class_schedules** - Class timings
8. **qr_sessions** - QR attendance sessions
9. **attendance** - Attendance records
10. **attendance_summary** - Performance metrics
11. **reports** - Generated reports
12. **audit_logs** - Action logging
13. **notifications** - User notifications
14. **admin_settings** - System configuration

**All tables feature:**
- ✅ Proper foreign keys
- ✅ Indexes for performance
- ✅ Timestamps (created_at, updated_at)
- ✅ Soft deletes capability
- ✅ Audit trail support

## 🚀 Setup & Installation

### Prerequisites

```bash
Node.js >= 16.0.0
npm >= 8.0.0
MySQL >= 8.0
```

### Step 1: Clone Repository

```bash
git clone https://github.com/sangmeshwar2006/qr-attendance-system.git
cd qr-attendance-system
```

### Step 2: Database Setup

```bash
# Create database and import schema
mysql -u root -p < database/schema.sql

# Import seed data (optional)
mysql -u root -p < database/seedData.sql
```

### Step 3: Backend Setup

```bash
cd server

# Install dependencies
npm install

# Create environment file
cp .env.example .env

# Configure .env with your database credentials
# Edit .env file and add:
# DB_HOST=localhost
# DB_USER=root
# DB_PASSWORD=your_password
# DB_NAME=qr_attendance
# JWT_SECRET=your_secret_key

# Run migrations
npm run migrate

# Start development server
npm run dev
```

### Step 4: Frontend Setup

```bash
cd ../client

# Install dependencies
npm install

# Create environment file
cp .env.example .env

# Configure .env
# VITE_API_URL=http://localhost:5000

# Start development server
npm run dev
```

## 📡 API Documentation

### Authentication Endpoints

```
POST   /api/auth/login          - User login
POST   /api/auth/register       - Student registration
POST   /api/auth/refresh        - Refresh token
GET    /api/auth/me             - Current user
POST   /api/auth/logout         - Logout
```

### Faculty Endpoints

```
GET    /api/faculty/dashboard   - Faculty dashboard data
POST   /api/faculty/qr/generate - Generate QR code
GET    /api/faculty/sessions    - Get active sessions
POST   /api/faculty/session/stop - Stop session
GET    /api/faculty/attendance  - Get attendance records
GET    /api/faculty/reports     - Download reports
```

### Student Endpoints

```
GET    /api/student/dashboard   - Student dashboard
POST   /api/student/attendance  - Mark attendance
GET    /api/student/attendance  - Get attendance history
GET    /api/student/profile     - Get student profile
PUT    /api/student/profile     - Update profile
```

### Admin Endpoints

```
GET    /api/admin/dashboard     - Admin dashboard
GET    /api/admin/users         - List users
POST   /api/admin/users         - Create user
PUT    /api/admin/users/:id     - Update user
DELETE /api/admin/users/:id     - Delete user
GET    /api/admin/reports       - Export reports
```

## 🔒 Security Features

### Authentication
- ✅ JWT tokens with configurable expiry
- ✅ Refresh token rotation
- ✅ Secure token storage
- ✅ HTTPS ready

### Data Protection
- ✅ AES-256-GCM encryption for QR tokens
- ✅ HMAC-SHA256 signatures
- ✅ Bcryptjs password hashing (10 rounds)
- ✅ Input validation with Joi

### Infrastructure
- ✅ CORS configuration
- ✅ Rate limiting
- ✅ SQL injection prevention
- ✅ XSS protection ready
- ✅ Helmet.js headers
- ✅ Audit logging

### Anti-Proxy Measures
- ✅ 30-second QR code expiry
- ✅ One-time attendance per session
- ✅ Device fingerprinting
- ✅ Geolocation verification (optional)
- ✅ Timestamp validation

## 📖 Usage Guide

### For Admin

1. Login with admin credentials
2. Access Admin Dashboard
3. Manage users, departments, subjects
4. View attendance analytics
5. Generate reports

### For Faculty

1. Login with faculty credentials
2. View today's classes
3. Click "Generate QR"
4. Select subject, semester, section
5. Start attendance session
6. Monitor real-time attendance
7. Stop session and view report

### For Student

1. Register/Login with student credentials
2. Go to Dashboard
3. Click "Scan QR Code"
4. Allow camera permission
5. Point camera to QR code
6. Attendance marked automatically
7. View attendance history

## 🌐 Deployment

### Frontend Deployment (Vercel)

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
cd client
vercel
```

### Backend Deployment (Render/Railway)

```bash
# Using Render
# 1. Push code to GitHub
# 2. Connect repository to Render
# 3. Set environment variables
# 4. Deploy automatically
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see LICENSE file for details.

## 📧 Support

For support, email sangmeshwar2006@example.com or open an issue on GitHub.

---

**Made with ❤️ for Smart Attendance Management**
