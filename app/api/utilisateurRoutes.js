// utilisateurRoutes.js
const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const supabase = require('../utils/supabaseClient');
// Import the authenticateToken middleware 
const { authenticateToken } = require('../middleware/authenticateToken');
// Import the handleError middleware
const handleError = require('../middleware/errorHandler');
const { signUp, signIn, signOut } = require('../utils/auth');

const router = express.Router();

// Route pour inscrire un utilisateur
router.post('/signup', async (req, res) => {
    const { login, email, passwd, adresse, pays, age, sexe, photo } = req.body;
    try {
        const user = await signUp({
            login,
            email,
            passwd,
            adresse,
            pays,
            age,
            sexe,
            photo
        });
        res.status(201).send("Verify your Email!");
    } catch (error) {
        if (error.message.includes('Email rate limit exceeded')) {
            res.status(429).json({ message: 'Rate limit exceeded. Please try again later.' });
        } else {
            handleError(error, req, res);
        }
    }
});


//Route pour connecter un utilisateur
router.post('/signin', async (req, res) => {
    const { email, password } = req.body;
    try {
        const result = await signIn(email, password);
        res.status(200).json(result);
    } catch (error) {
        handleError(error, req, res);  // Ensure errors are passed to handleError
    }
});


// Route pour demander la récupération de mot de passe
router.post('/recover', async (req, res) => {
    const { email } = req.body;
    try {
        const { error } = await supabase.auth.resetPasswordForEmail(email, {
            redirectTo: 'http://localhost:3000/api/auth/confirm' // This will handle the token verification
        });
        if (error) {
            throw error;
        }
        res.status(200).json({ message: 'Password recovery email sent' });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// Route to reset the user's password
router.post('/reset_password', async (req, res) => {
    const { email, access_token, new_password } = req.body;
    try {
        // Verify OTP
        const { error: verifyError } = await supabase.auth.verifyOtp({
            email: email,
            token: access_token,
            type: 'recovery',
        });

        if (verifyError) {
            throw new Error('Invalid or expired token');
        }

        // Update user's password
        const { error: updateError } = await supabase.auth.updateUser({ password: new_password });
        if (updateError) {
            throw new Error('Failed to update the password');
        }

        // Update password in local DB
        const hashedPassword = await bcrypt.hash(new_password, 10);
        const { error: dbError } = await supabase.from('utilisateur').update({ passwd: hashedPassword }).eq('email', email);

        if (dbError) {
            throw new Error('Failed to update the password in the local database');
        }

        res.status(200).json({ message: 'Password has been reset successfully' });
    } catch (error) {
        handleError(error, req, res);  // Catch errors and pass them to handleError
    }
});


// Route pour déconnecter un utilisateur
router.post('/logout', authenticateToken, async (req, res) => {
    try {
        await signOut();
        res.status(200).json({ message: 'User signed out' });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// Route to get all users
router.get('/users_list', async (req, res) => {
    try {
        const { data, error } = await supabase
            .from('utilisateur')
            .select('*');

        if (error) throw error;

        res.status(200).json(data);
    } catch (err) {
        handleError(err, res);
    }
});

// Route to get a user by ID
router.get('/user/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await supabase.from('utilisateur').select('*').eq('id', id).single();

        if (error) {
            throw new Error('Utilisateur non trouvé');
        }

        res.status(200).json(data);
    } catch (error) {
        handleError(error, req, res);  // Ensure errors are passed to handleError
    }
});


// Route to update a user
router.put('/update_user/:id', authenticateToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { login, passwd, adresse, pays, age, sexe, photo } = req.body;

        if (!login || !passwd || !adresse || !pays || !age || !sexe || !photo) {
            return res.status(400).json({ error: 'Tous les champs sont requis' });
        }

        // Check if the user is either the owner or an admin
        if (req.user.id !== parseInt(id) && !req.user.is_admin) {
            return res.status(403).json({ error: "Vous n'êtes pas autorisé à mettre à jour cet utilisateur" });
        }

        const hashedPassword = await hashPassword(passwd);

        const { data, error } = await supabase
            .from('utilisateur')
            .update({ login, passwd: hashedPassword, adresse, pays, age, sexe, photo })
            .eq('id', id)
            .single();

        if (error) throw error;

        res.status(200).send("mise a jour terminé!");
    } catch (err) {
        handleError(err, res);
    }
});


// Route to delete a user
router.delete('/delete_user/:id', authenticateToken, async (req, res) => {
    const userId = req.params.id;

    try {
        if (req.user.id === parseInt(userId) || req.user.is_admin) {
            const { data: user, error: fetchError } = await supabase.from('utilisateur').select('id, login, adresse, pays, age, sexe').eq('id', userId).single();

            if (fetchError || !user) throw new Error('Utilisateur non trouvé');

            const { error: deleteError } = await supabase.from('utilisateur').delete().eq('id', userId);
            if (deleteError) throw new Error('Failed to delete user');

            res.status(200).json({
                message: `L'utilisateur avec l'ID ${user.id} (${user.login}) a été supprimé avec succès.`,
                details: {
                    adresse: user.adresse,
                    pays: user.pays,
                    age: user.age,
                    sexe: user.sexe,
                },
            });
        } else {
            res.status(403).json({ message: 'Accès refusé' });
        }
    } catch (error) {
        handleError(error, req, res);  // Ensure errors are passed to handleError
    }
});



// Route pour vérifier les informations d'identification de l'utilisateur (login et mot de passe)
router.post('/verify_user', async (req, res) => {
    try {
        const { login, passwd } = req.body;
        if (!login || !passwd) {
            return res.status(400).json({ error: 'Login et mot de passe sont requis' });
        }

        const { data: user, error } = await supabase
            .from('utilisateur')
            .select('*')
            .eq('login', login)
            .single();

        if (error || !user) return res.status(401).json({ error: 'Authentification échouée' });

        const isMatch = await bcrypt.compare(passwd, user.passwd);
        if (!isMatch) return res.status(401).json({ error: 'Authentification échouée' });

        const { passwd: _, ...userWithoutPassword } = user;
        res.status(200).json(userWithoutPassword);
    } catch (err) {
        handleError(err, res);
    }
});
module.exports = router;
