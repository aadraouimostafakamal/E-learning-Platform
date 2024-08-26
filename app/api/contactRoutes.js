const express = require('express');
const supabase = require('../utils/supabaseClient');
//import the handleError middleware
const handleError = require('../middleware/errorHandler');
const nodemailer = require('nodemailer');
require('dotenv').config();

const router = express.Router();

// POST /contact
router.post('/contact', async (req, res) => {
    const { name, email, subject, message } = req.body;

    try {
        // Validate input fields
        if (!name || !email || !subject || !message) {
            return res.status(400).json({ error: 'All fields are required' });
        }

        // Store message in the database
        const { data, error } = await supabase
            .from('contacts')
            .insert([{ name, email, subject, message}])
            .single();

        if (error) throw error;

        // Send notification email to the enterprise
        const transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user: process.env.ENTERPRISE_EMAIL,
                pass: process.env.ENTERPRISE_EMAIL_PASSWORD,
            },
        });

        const mailOptions = {
            from: email,
            to: process.env.ENTERPRISE_EMAIL,
            subject: `New Contact Form Submission: ${subject}`,
            text: `Name: ${name}\nEmail: ${email}\nMessage: ${message}`,
        };

        transporter.sendMail(mailOptions, (err, info) => {
            if (err) {
                console.error('Error sending email:', err);
                return res.status(500).json({ error: 'Error sending email' });
            } else {
                console.log('Email sent:', info.response);
                return res.status(200).json({ message: 'Message sent successfully' });
            }
        });
    } catch (err) {
        console.error('Error processing contact form:', err);
        res.status(500).json({ error: 'Error processing contact form' });
    }
});

module.exports = router;
