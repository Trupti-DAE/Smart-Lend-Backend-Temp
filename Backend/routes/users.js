const express = require('express');
const db = require('../db'); // Import database connection
const router = express.Router();

// Get all users
router.get('/', (req, res) => {
    db.query('SELECT * FROM Users', (err, results) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json(results);
    });
});

// Export the router
module.exports = router;