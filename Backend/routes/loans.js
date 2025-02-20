const express = require('express');
const db = require('../db'); // Import database connection
const router = express.Router();

// Get all loan requests
router.get('/', (req, res) => {
    db.query('SELECT * FROM LoanRequests', (err, results) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json(results);
    });
});

// Get a single loan request by ID
router.get('/:id', (req, res) => {
    const loanId = req.params.id;
    db.query('SELECT * FROM LoanRequests WHERE loan_id = ?', [loanId], (err, results) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        if (results.length === 0) {
            return res.status(404).json({ message: "Loan request not found" });
        }
        res.json(results[0]);
    });
});

// Create a new loan request
router.post('/', (req, res) => {
    const { borrower_id, amount, interest_rate, loan_term, status } = req.body;
    const query = `INSERT INTO LoanRequests (borrower_id, amount, interest_rate, loan_term, status) VALUES (?, ?, ?, ?, ?)`;
    db.query(query, [borrower_id, amount, interest_rate, loan_term, status || 'pending'], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json({ message: "Loan request created successfully", loan_id: result.insertId });
    });
});

// Update loan request status
router.put('/:id', (req, res) => {
    const loanId = req.params.id;
    const { status } = req.body;
    const query = `UPDATE LoanRequests SET status = ? WHERE loan_id = ?`;
    db.query(query, [status, loanId], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json({ message: "Loan request updated successfully" });
    });
});

// Delete a loan request
router.delete('/:id', (req, res) => {
    const loanId = req.params.id;
    db.query('DELETE FROM LoanRequests WHERE loan_id = ?', [loanId], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json({ message: "Loan request deleted successfully" });
    });
});

// Export the router
module.exports = router;