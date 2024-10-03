const supabase = require('./supabaseClient');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Fonction pour inscrire un utilisateur
async function signUp(userData) {
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(userData.passwd, saltRounds);

    // Sign up the user in Supabase's auth system
    const { user, error } = await supabase.auth.signUp({
        email: userData.email,
        password: userData.passwd,
    });

    if (error) {
        throw error;
    }

    // Insert user data into the 'utilisateur' table
    const { data, error: insertError } = await supabase
        .from('utilisateur')
        .insert({
            login: userData.login,
            email: userData.email,
            adresse: userData.adresse,
            pays: userData.pays,
            age: userData.age,
            sexe: userData.sexe,
            photo: userData.photo,
            passwd: hashedPassword,
        });

    if (insertError) {
        throw insertError;
    }

    return user;
}

// Fonction pour connecter un utilisateur
const JWT_SECRET = process.env.JWT_SECRET;

async function signIn(email, password) {
    console.log(`Attempting to sign in with email: ${email}`);

    // Authenticate the user with Supabase
    const { data, error } = await supabase.auth.signInWithPassword({
        email: email,
        password: password,
    });

    if (error) {
        console.error('Error during sign in:', error.message);
        throw new Error('Invalid login credentials');
    }

    const user = data.user;

    // Generate JWT token
    const token = jwt.sign({ id: user.id, email: user.email }, JWT_SECRET, {
        expiresIn: '1h', // Set token expiration
    });

    console.log('Sign in successful:', data);

    // Return the token and user data
    return { token, user };
}


// Fonction pour déconnecter un utilisateur
async function signOut() {
    const { error } = await supabase.auth.signOut();
    if (error) {
        throw error;
    }
}

// Fonction pour vérifier un token JWT
async function verifyToken(token) {
    const { data, error } = await supabase.auth.api.getUser(token);
    if (error) {
        throw error;
    }
    return data;
}

// Exporter les fonctions pour les utiliser ailleurs
module.exports = {
    signUp,
    signIn,
    signOut,
    verifyToken,
};