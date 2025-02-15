const express = require('express');
const db = require('../db'); // Import database connection
const router = express.Router();

// Get all lenders
router.get('/', (req, res) => {
    db.query(
        `SELECT u.user_id, u.full_name, u.email, l.* 
         FROM Users u 
         JOIN LenderProfile l ON u.user_id = l.lender_id`,
        (err, results) => {
            if (err) {
                return res.status(500).json({ error: err.message });
            }
            res.json(results);
        }
    );
});

// Get lender by ID
router.get('/:id', (req, res) => {
    const lenderId = req.params.id;
    db.query(
        `SELECT u.user_id, u.full_name, u.email, l.* 
         FROM Users u 
         JOIN LenderProfile l ON u.user_id = l.lender_id
         WHERE l.lender_id = ?`, 
         [lenderId], 
         (err, results) => {
            if (err) {
                return res.status(500).json({ error: err.message });
            }
            if (results.length === 0) {
                return res.status(404).json({ message: "Lender not found" });
            }
            res.json(results[0]);
        }
    );
});

// Export the router
module.exports = router;