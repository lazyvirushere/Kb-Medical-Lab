-- KB Labs Medical Laboratory Database Setup
-- Run this in your MySQL/phpMyAdmin

-- Create database
CREATE DATABASE IF NOT EXISTS kb_labs CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE kb_labs;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    password VARCHAR(255) NOT NULL,
    verification_token VARCHAR(64),
    reset_token VARCHAR(64),
    reset_token_expiry DATETIME,
    remember_token VARCHAR(64),
    is_active BOOLEAN DEFAULT TRUE,
    is_verified BOOLEAN DEFAULT TRUE,
    last_login DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email)
);

-- Admin users table
CREATE TABLE IF NOT EXISTS admin_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('super_admin', 'admin', 'staff') DEFAULT 'staff',
    remember_token VARCHAR(64),
    is_active BOOLEAN DEFAULT TRUE,
    last_login DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username)
);

-- Contact submissions table
CREATE TABLE IF NOT EXISTS contact_submissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    status ENUM('new', 'in_progress', 'resolved') DEFAULT 'new',
    admin_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tests table
CREATE TABLE IF NOT EXISTS tests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    sample_type VARCHAR(50),
    result_time VARCHAR(50),
    category VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Packages table
CREATE TABLE IF NOT EXISTS packages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    features JSON,
    is_featured BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Test bookings table
CREATE TABLE IF NOT EXISTS test_bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_reference VARCHAR(20) UNIQUE NOT NULL,
    user_id INT,
    test_name VARCHAR(200) NOT NULL,
    patient_name VARCHAR(100) NOT NULL,
    patient_phone VARCHAR(20) NOT NULL,
    patient_email VARCHAR(100) NOT NULL,
    preferred_date DATE NOT NULL,
    preferred_time TIME NOT NULL,
    status ENUM('pending', 'confirmed', 'completed', 'cancelled') DEFAULT 'pending',
    admin_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Package bookings table
CREATE TABLE IF NOT EXISTS package_bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_reference VARCHAR(20) UNIQUE NOT NULL,
    user_id INT,
    package_name VARCHAR(200) NOT NULL,
    patient_name VARCHAR(100) NOT NULL,
    patient_phone VARCHAR(20) NOT NULL,
    patient_email VARCHAR(100) NOT NULL,
    preferred_date DATE NOT NULL,
    preferred_time TIME NOT NULL,
    status ENUM('pending', 'confirmed', 'completed', 'cancelled') DEFAULT 'pending',
    admin_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Locations table
CREATE TABLE IF NOT EXISTS locations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    opening_hours VARCHAR(100),
    is_main_center BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Activity logs table
CREATE TABLE IF NOT EXISTS activity_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    details TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Admin activity logs table
CREATE TABLE IF NOT EXISTS admin_activity_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT,
    action VARCHAR(100) NOT NULL,
    details TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admin_users(id) ON DELETE SET NULL
);

-- Settings table
CREATE TABLE IF NOT EXISTS settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample data (only if not exists)

-- Insert sample tests
INSERT IGNORE INTO tests (name, description, price, sample_type, result_time, category) VALUES
('Complete Blood Count (CBC)', 'Comprehensive blood analysis including red blood cells, white blood cells, and platelets', 800.00, 'Blood', 'Same Day', 'Hematology'),
('Lipid Profile', 'Cholesterol and triglyceride levels to assess cardiovascular risk', 1200.00, 'Blood', 'Same Day', 'Biochemistry'),
('Thyroid Function Test', 'TSH, T3, T4 levels to evaluate thyroid gland function', 2500.00, 'Blood', 'Next Day', 'Endocrinology'),
('Liver Function Test', 'ALT, AST, bilirubin, and other markers to assess liver health', 1800.00, 'Blood', 'Same Day', 'Biochemistry'),
('Kidney Function Test', 'Creatinine, BUN, and other markers to evaluate kidney function', 1500.00, 'Blood', 'Same Day', 'Biochemistry'),
('Diabetes Panel', 'Fasting glucose, HbA1c, and other diabetes-related markers', 2000.00, 'Blood', 'Same Day', 'Endocrinology'),
('Vitamin D Test', 'Vitamin D levels assessment', 1800.00, 'Blood', 'Next Day', 'Biochemistry'),
('Cardiac Enzymes', 'Heart attack and cardiac damage markers', 3000.00, 'Blood', 'Same Day', 'Cardiology');

-- Insert sample packages
INSERT IGNORE INTO packages (name, description, price, features, is_featured) VALUES
('Basic Health Check', 'Essential health screening package', 5000.00, '["Complete Blood Count (CBC)", "Lipid Profile", "Liver Function Test", "Kidney Function Test", "Diabetes Panel"]', FALSE),
('Executive Health Check', 'Comprehensive health assessment for executives', 12000.00, '["All Basic Health Check tests", "Thyroid Function Test", "Cardiac Enzymes", "Vitamin D Test", "ECG", "Chest X-Ray", "Consultation with Doctor"]', TRUE),
('Premium Health Check', 'Most comprehensive health screening', 25000.00, '["All Executive Health Check tests", "Cancer Screening Markers", "Hormone Panel", "Ultrasound Abdomen", "Stress Test", "Bone Density Test", "Detailed Medical Report"]', FALSE);

-- Insert sample locations
INSERT IGNORE INTO locations (name, address, phone, email, opening_hours, is_main_center) VALUES
('Clifton Branch', 'Block 7, Clifton, Karachi, Pakistan', '+92 21 123 4567', 'clifton@kblabs.com', '24/7 Available', TRUE),
('Gulshan Branch', 'Block 3, Gulshan-e-Iqbal, Karachi, Pakistan', '+92 21 123 4568', 'gulshan@kblabs.com', '8 AM - 10 PM', FALSE),
('Defence Branch', 'Phase 2, DHA, Karachi, Pakistan', '+92 21 123 4569', 'defence@kblabs.com', '7 AM - 11 PM', FALSE);

-- Insert default admin users (Password: admin123)
INSERT IGNORE INTO admin_users (username, email, password, full_name, role) VALUES
('admin', 'admin@kblabs.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'System Administrator', 'super_admin'),
('manager', 'manager@kblabs.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Lab Manager', 'admin'),
('staff', 'staff@kblabs.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Lab Staff', 'staff');

-- Insert sample users (Password: user123)
INSERT IGNORE INTO users (first_name, last_name, email, phone, password, is_verified) VALUES
('Ahmad', 'Ali', 'ahmad.ali@example.com', '+92 300 1234567', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
('Fatima', 'Khan', 'fatima.khan@example.com', '+92 301 2345678', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE),
('Hassan', 'Ahmed', 'hassan.ahmed@example.com', '+92 302 3456789', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', TRUE);

-- Insert default settings
INSERT IGNORE INTO settings (setting_key, setting_value, description) VALUES
('site_name', 'KB Labs Medical Laboratory', 'Website name'),
('site_email', 'info@kblabs.com', 'Contact email'),
('site_phone', '+92 21 123 4567', 'Contact phone'),
('site_address', 'Block 7, Clifton, Karachi, Pakistan', 'Main address');

-- Show success message
SELECT 'KB Labs Medical Laboratory database created successfully!' as message;
SELECT 'Default Admin Login: admin / admin123' as admin_credentials;
SELECT 'Default User Login: ahmad.ali@example.com / user123' as user_credentials;

