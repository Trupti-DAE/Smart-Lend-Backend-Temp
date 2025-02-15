// const express = require('express');
// const db = require('../db'); // Import database connection
// const router = express.Router();

// // Get all borrowers
// router.get('/', (req, res) => {
//     db.query(
//         `SELECT u.user_id, u.full_name, u.email, b.* 
//          FROM Users u 
//          JOIN BorrowerProfile b ON u.user_id = b.borrower_id`,
//         (err, results) => {
//             if (err) {
//                 return res.status(500).json({ error: err.message });
//             }
//             res.json(results);
//         }
//     );
// });

// // Export the router
// module.exports = router;

const express = require('express');
const db = require('../db'); // Import database connection
const router = express.Router();

// Get all borrowers
router.get('/', (req, res) => {
    db.query(
        `SELECT u.user_id, u.full_name, u.email, b.* 
         FROM Users u 
         JOIN BorrowerProfile b ON u.user_id = b.borrower_id`,
        (err, results) => {
            if (err) {
                return res.status(500).json({ error: err.message });
            }
            res.json(results);
        }
    );
});

// Get borrower by ID
router.get('/:id', (req, res) => {
    const borrowerId = req.params.id;
    db.query(
        `SELECT u.user_id, u.full_name, u.email, b.* 
         FROM Users u 
         JOIN BorrowerProfile b ON u.user_id = b.borrower_id
         WHERE b.borrower_id = ?`, 
        [borrowerId], 
        (err, results) => {
            if (err) {
                return res.status(500).json({ error: err.message });
            }
            if (results.length === 0) {
                return res.status(404).json({ message: "Borrower not found" });
            }
            res.json(results[0]);
        }
    );
});

// Export the router
module.exports = router;