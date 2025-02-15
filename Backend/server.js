require('dotenv').config();
const express = require('express');
const cors = require('cors');
const db = require('./db'); // Import database connection

const app = express();
app.use(express.json());
app.use(cors());

// API Test Route
app.get('/', (req, res) => {
    res.send('SmartLend API is running!');
});

// Import Routes
const userRoutes = require('./routes/users');
// const borrowerRoutes = require('./routes/borrowers');
const lenderRoutes = require('./routes/lenders');
const borrowerRoutes = require('./routes/borrowers');
app.use('/api/borrowers', borrowerRoutes);
app.use('/api/users', userRoutes);
// app.use('api/borrowers', borrowerRoutes);
app.use('/api/lenders', lenderRoutes);

// Start Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});