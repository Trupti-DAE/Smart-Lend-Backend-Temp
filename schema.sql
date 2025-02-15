CREATE DATABASE smartlend;
USE smartlend;

-- Users Table (Common for both borrowers and lenders)
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    firebase_uid VARCHAR(255) UNIQUE NOT NULL, -- Firebase Authentication UID
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    user_type ENUM('borrower', 'lender') NOT NULL, -- Identify role
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Borrower Profile
CREATE TABLE BorrowerProfile (
    borrower_id INT PRIMARY KEY,
    age INT,
    income INT,
    credit_score INT,
    months_employed INT,
    num_credit_lines INT,
    dti_ratio FLOAT, -- Debt-to-Income Ratio
    education ENUM('PhD', 'Master', 'Bachelor', 'High School'),
    employment_type ENUM('Full-time', 'Part-time', 'Self-employed', 'Unemployed'),
    marital_status ENUM('Single', 'Married', 'Divorced'),
    has_mortgage BOOLEAN,
    has_dependents BOOLEAN,
    loan_purpose ENUM('Home', 'Auto', 'Education', 'Business', 'Other'),
    has_cosigner BOOLEAN,
    FOREIGN KEY (borrower_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Lender Profile
CREATE TABLE LenderProfile (
    lender_id INT PRIMARY KEY,
    max_investment INT, -- Maximum amount willing to invest
    min_investment INT, -- Minimum investment per loan
    risk_appetite ENUM('Low', 'Medium', 'High'),
    preferred_interest_rate FLOAT,
    preferred_loan_term INT, -- Preferred loan term in months
    FOREIGN KEY (lender_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Loan Requests
CREATE TABLE LoanRequests (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    borrower_id INT,
    amount INT NOT NULL,
    interest_rate FLOAT,
    loan_term INT, -- Months
    status ENUM('pending', 'approved', 'rejected', 'funded', 'completed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (borrower_id) REFERENCES BorrowerProfile(borrower_id) ON DELETE CASCADE
);

-- Loan Evaluations (ML Model Results)
CREATE TABLE LoanEvaluations (
    evaluation_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT,
    approval_status BOOLEAN, -- 1 = Approved, 0 = Rejected
    risk_score FLOAT, -- ML Model Generated Score
    reason TEXT, -- Reason for approval/rejection
    FOREIGN KEY (loan_id) REFERENCES LoanRequests(loan_id) ON DELETE CASCADE
);

-- Loan Funding (Tracks which lender funds which loan)
CREATE TABLE LoanFunding (
    funding_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT,
    lender_id INT,
    amount INT,
    funding_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (loan_id) REFERENCES LoanRequests(loan_id) ON DELETE CASCADE,
    FOREIGN KEY (lender_id) REFERENCES LenderProfile(lender_id) ON DELETE CASCADE
);

-- Loan Repayments
CREATE TABLE LoanRepayments (
    repayment_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT,
    amount INT NOT NULL,
    due_date DATE NOT NULL,
    status ENUM('pending', 'paid', 'late') DEFAULT 'pending',
    payment_date DATE,
    FOREIGN KEY (loan_id) REFERENCES LoanRequests(loan_id) ON DELETE CASCADE
);

-- Loan Agreements (AI Generated & Digitally Signed)
CREATE TABLE LoanAgreements (
    agreement_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT,
    borrower_signature VARCHAR(255),
    lender_signature VARCHAR(255),
    agreement_text TEXT,
    signed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (loan_id) REFERENCES LoanRequests(loan_id) ON DELETE CASCADE
);

-- Populate Users Table
INSERT INTO Users (firebase_uid, email, full_name, phone, user_type) VALUES
('uid_001', 'ramesh.kumar@gmail.com', 'Ramesh Kumar', '9876543210', 'borrower'),
('uid_002', 'priya.sharma@gmail.com', 'Priya Sharma', '9876543211', 'borrower'),
('uid_003', 'amit.verma@gmail.com', 'Amit Verma', '9876543212', 'borrower'),
('uid_004', 'neha.patel@gmail.com', 'Neha Patel', '9876543213', 'borrower'),
('uid_005', 'rahul.mehra@gmail.com', 'Rahul Mehra', '9876543214', 'lender'),
('uid_006', 'sneha.das@gmail.com', 'Sneha Das', '9876543215', 'lender'),
('uid_007', 'arjun.nair@gmail.com', 'Arjun Nair', '9876543216', 'lender'),
('uid_008', 'deepak.singh@gmail.com', 'Deepak Singh', '9876543217', 'lender'),
('uid_009', 'rekha.iyer@gmail.com', 'Rekha Iyer', '9876543218', 'borrower'),
('uid_010', 'vikas.malhotra@gmail.com', 'Vikas Malhotra', '9876543219', 'lender');

-- Populate BorrowerProfile Table
INSERT INTO BorrowerProfile (borrower_id, age, income, credit_score, months_employed, num_credit_lines, dti_ratio, education, employment_type, marital_status, has_mortgage, has_dependents, loan_purpose, has_cosigner) VALUES
(1, 28, 600000, 750, 36, 3, 0.25, 'Master', 'Full-time', 'Single', TRUE, FALSE, 'Home', FALSE),
(2, 35, 850000, 800, 72, 5, 0.20, 'PhD', 'Self-employed', 'Married', TRUE, TRUE, 'Business', TRUE),
(3, 40, 400000, 650, 48, 2, 0.30, 'Bachelor', 'Unemployed', 'Divorced', FALSE, TRUE, 'Auto', FALSE),
(4, 22, 250000, 700, 12, 1, 0.40, 'High School', 'Part-time', 'Single', FALSE, FALSE, 'Education', FALSE),
(9, 50, 1000000, 820, 120, 10, 0.10, 'Master', 'Full-time', 'Married', TRUE, TRUE, 'Home', TRUE);

-- Populate LenderProfile Table
INSERT INTO LenderProfile (lender_id, max_investment, min_investment, risk_appetite, preferred_interest_rate, preferred_loan_term) VALUES
(5, 500000, 10000, 'Medium', 7.5, 24),
(6, 1000000, 50000, 'High', 9.0, 36),
(7, 200000, 5000, 'Low', 5.0, 12),
(8, 750000, 25000, 'Medium', 8.5, 18),
(10, 300000, 10000, 'High', 10.0, 48);