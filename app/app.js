// app.js

const express = require('express');
const helmet = require('helmet');
require('dotenv').config();
const path = require('path');
const app = express();
const handleError = require('./middleware/errorHandler'); // Import error handler

// Serve static files
app.use(express.static('.'));

// Apply middleware
app.use(express.json());
app.use(helmet());
app.use(express.urlencoded({ extended: true }));

// Define the port
const port = 3000;

// Import routes
const utilisateurRoutes = require('./api/utilisateurRoutes');
app.use('', utilisateurRoutes);

const contactRoutes = require('./api/contactRoutes');
app.use('', contactRoutes);

const stripeRoutes = require('./api/stripeRoutes');
app.use('/api/stripe', stripeRoutes);

const contentRoutes = require('./api/contentRoutes');
app.use('', contentRoutes);

// Base route
app.get('/', (req, res) => {
    res.send('Bienvenue sur la plateforme E-learning!');
});

// Add error handler middleware at the end of all routes
app.use(handleError);

// Start the server
app.listen(port, () => {
    console.log(`L'application est lancée sur http://localhost:${port}`);
});
