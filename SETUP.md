# 🚀 QR Attendance System - Complete Setup Guide

## Prerequisites

Before you begin, ensure you have the following installed:

```bash
✅ Node.js >= 16.0.0
✅ npm >= 8.0.0
✅ MySQL >= 8.0
✅ Git
```

### Installation Verification

```bash
node --version    # Should show v16 or higher
npm --version     # Should show 8 or higher
mysql --version   # Should show 8 or higher
```

## Step 1: Clone Repository

```bash
git clone https://github.com/sangmeshwar2006/qr-attendance-system.git
cd qr-attendance-system
```

## Step 2: Database Setup

### 2.1 Create MySQL Database

```bash
# Login to MySQL
mysql -u root -p

# Create database
CREATE DATABASE qr_attendance;
USE qr_attendance;
```

### 2.2 Import Schema

```bash
# Option 1: Using MySQL command line
mysql -u root -p qr_attendance < database/schema.sql

# Option 2: Using MySQL Workbench
# File > Run SQL Script > Select database/schema.sql
```

### 2.3 Import Seed Data (Optional)

```bash
mysql -u root -p qr_attendance < database/seedData.sql
```

### 2.4 Verify Database

```bash
mysql -u root -p qr_attendance
SHOW TABLES;  # Should display 14 tables
```

## Step 3: Backend Setup

### 3.1 Navigate to Server Directory

```bash
cd server
```

### 3.2 Install Dependencies

```bash
npm install
```

Expected output:
```
added X packages, and audited Y packages in Zs
```

### 3.3 Create Environment File

```bash
cp .env.example .env
```

### 3.4 Configure Environment Variables

Edit `.env` file with your configuration:

```env
# Server
NODE_ENV=development
PORT=5000
HOST=localhost

# Database
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=qr_attendance

# JWT
JWT_SECRET=your_secret_key_here_min_32_chars
JWT_EXPIRY=7d
JWT_REFRESH_SECRET=your_refresh_secret_key_here
JWT_REFRESH_EXPIRY=30d

# Encryption
ENCRYPTION_KEY=12345678901234567890123456789012

# CORS
CORS_ORIGIN=http://localhost:5173
```

### 3.5 Start Backend Server

```bash
npm run dev
```

Expected output:
```
✅ Server running on http://localhost:5000
✅ Database connected
```

## Step 4: Frontend Setup

### 4.1 Navigate to Client Directory (New Terminal)

```bash
cd client
```

### 4.2 Install Dependencies

```bash
npm install
```

### 4.3 Create Environment File

```bash
cp .env.example .env
```

### 4.4 Configure Environment Variables

Edit `.env` file:

```env
VITE_API_URL=http://localhost:5000
VITE_APP_NAME=QR Attendance System
VITE_ENVIRONMENT=development
```

### 4.5 Start Frontend Server

```bash
npm run dev
```

Expected output:
```
✅ Local: http://localhost:5173/
```

## Step 5: Access Application

Open your browser and navigate to:

```
http://localhost:5173
```

## Test Credentials

### Admin Login
```
Email: admin@college.edu
Password: password123
```

### Faculty Login
```
Email: prof_ramesh@college.edu
Password: password123
```

### Student Login
```
Email: student1@college.edu
Password: password123
```

## 🔍 Troubleshooting

### Issue 1: MySQL Connection Error

```
Error: connect ECONNREFUSED 127.0.0.1:3306
```

**Solution:**
```bash
# Start MySQL service
# Windows
net start MySQL80

# macOS
brew services start mysql

# Linux
sudo systemctl start mysql
```

### Issue 2: Port Already in Use

```
Error: listen EADDRINUSE: address already in use :::5000
```

**Solution:**
```bash
# Find and kill process using port 5000
lsof -i :5000
kill -9 <PID>
```

### Issue 3: Dependencies Installation Fails

```bash
# Clear npm cache
npm cache clean --force

# Remove node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

### Issue 4: Database Import Fails

```bash
# Verify database exists
mysql -u root -p -e "SHOW DATABASES;"

# Check schema file syntax
mysql -u root -p --verbose qr_attendance < database/schema.sql
```

## 📊 System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   CLIENT (React + Vite)                 │
│              http://localhost:5173                      │
└────────────────────┬────────────────────────────────────┘
                     │ (Axios HTTP Calls)
                     ↓
┌─────────────────────────────────────────────────────────┐
│              BACKEND (Express + Node.js)                │
│              http://localhost:5000                      │
│  ┌────────────────────────────────────────────────────┐ │
│  │ Routes → Controllers → Services → Database         │ │
│  └────────────────────────────────────────────────────┘ │
└────────────────────┬────────────────────────────────────┘
                     │ (MySQL Connection)
                     ↓
┌─────────────────────────────────────────────────────────┐
│         DATABASE (MySQL - qr_attendance)                │
│  ┌────────────────────────────────────────────────────┐ │
│  │ 14 Tables: users, attendance, qr_sessions, etc    │ │
│  └────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

## 📁 Project Structure Verification

```bash
# Verify all required files exist
ls -la database/schema.sql
ls -la database/seedData.sql
ls -la server/.env
ls -la server/src/app.ts
ls -la client/.env
ls -la client/src/main.jsx
```

## ✅ Verification Checklist

- [ ] MySQL database created and seeded
- [ ] Backend server running on port 5000
- [ ] Frontend server running on port 5173
- [ ] Can login with provided credentials
- [ ] Dashboard loads without errors
- [ ] Network tab shows successful API calls
- [ ] No console errors in browser
- [ ] No console errors in terminal

## 🚀 Next Steps

1. **Explore Admin Panel**
   - Add departments and subjects
   - Create faculty accounts
   - View attendance analytics

2. **Test Faculty Features**
   - Generate QR codes
   - Start attendance sessions
   - Monitor student attendance

3. **Test Student Features**
   - Scan QR codes
   - View attendance history
   - Check notifications

## 📚 Additional Resources

- [API Documentation](./docs/API.md)
- [Deployment Guide](./docs/DEPLOYMENT.md)
- [Architecture Details](./docs/ARCHITECTURE.md)

## 🆘 Getting Help

If you encounter issues:

1. Check the logs:
   ```bash
   # Backend logs
   tail -f logs/app.log
   ```

2. Review database:
   ```bash
   mysql -u root -p qr_attendance
   SELECT * FROM users LIMIT 5;
   ```

3. Check network requests (Browser DevTools):
   - Open DevTools (F12)
   - Go to Network tab
   - Review API responses

## 💡 Pro Tips

- Use MySQL Workbench for easier database management
- Use Postman/Insomnia for API testing
- Enable debug logging for troubleshooting
- Use VS Code extensions for better development experience

---

**Setup Complete! Happy Coding! 🎉**
