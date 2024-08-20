// db.js
const { Pool } = require('pg');

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'elearning',
    password: '1234Kamal',  
    port: 5432,
});

pool.on('connect', () => {
    console.log('Connected to the database');
});

module.exports = pool;
