require('dotenv').config();  // Load .env variables

const { createClient } = require('@supabase/supabase-js');

// Use environment variables for Supabase credentials
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_KEY;
console.log(supabaseUrl, supabaseKey);

if (!supabaseUrl || !supabaseKey) {
    throw new Error("Missing Supabase URL or Key from environment variables");
}

const supabase = createClient(supabaseUrl, supabaseKey);

module.exports = supabase;