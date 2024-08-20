// Importer les modules nécessaires
const express = require('express');
const { Pool } = require('pg');
const bcrypt = require('bcrypt');
const helmet = require('helmet'); // Pour sécuriser Express avec des en-têtes HTTP appropriés
const jwt = require('jsonwebtoken');
require('dotenv').config();

// Créer une application Express
const app = express();

// Configurer le middleware pour analyser les corps de requêtes en JSON
app.use(express.json());
app.use(helmet()); // Appliquer les protections de base d'Helmet

// Import the database connection
const pool = require('./db');

// Définir le port sur lequel le serveur va écouter
const port = 3000;

// Route de base pour tester la configuration
app.get('/', (req, res) => {
    res.send('Bienvenue sur la plateforme E-learning!');
});

// Fonction pour hacher les mots de passe
async function hashPassword(password) {
    const saltRounds = 10;
    return await bcrypt.hash(password, saltRounds);
}

// Routes pour la gestion des utilisateurs
// Route pour ajouter un utilisateur
app.post('/utilisateurs', async (req, res) => {
    try {
        const { login, passwd, adresse, pays, age, sexe, photo } = req.body;
        if (!login || !passwd || !adresse || !pays || !age || !sexe || !photo) {
            return res.status(400).json({ error: 'Tous les champs sont requis' });
        }
        const hashedPassword = await hashPassword(passwd);
        const result = await pool.query(
            'INSERT INTO Utilisateur (login, passwd, adresse, pays, age, sexe, photo) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *',
            [login, hashedPassword, adresse, pays, age, sexe, photo]
        );
        res.status(201).json(result.rows[0]);
    } catch (err) {
        if (err.code === '23505') { // Code d'erreur pour violation de contrainte unique
            res.status(400).json({ error: 'Cet utilisateur existe déjà.' });
        } else {
            console.error(err.message);
            res.status(500).send('Erreur du serveur');
        }
    }
});

// Route pour récupérer tous les utilisateurs
app.get('/utilisateurs', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM Utilisateur');
        res.status(200).json(result.rows);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour récupérer un utilisateur par ID
app.get('/utilisateurs/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query('SELECT * FROM Utilisateur WHERE id = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(404).send('Utilisateur non trouvé');
        }
        res.status(200).json(result.rows[0]);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Middleware pour vérifier le token JWT et extraire l'utilisateur authentifié
const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if (token == null) {
        console.log('No token provided');
        return res.sendStatus(401);
    }

    jwt.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, user) => {
        if (err) {
            console.error('Token verification failed:', err);
            return res.sendStatus(403);
        }
        console.log('Authenticated user:', user);
        req.user = user;
        next();
    });
};


// Route pour login
app.post('/login', async (req, res) => {
    const { login, passwd } = req.body;

    try {
        const result = await pool.query('SELECT * FROM Utilisateur WHERE login = $1', [login]);
        if (result.rows.length === 0) return res.status(400).send('Login ou mot de passe incorrect.');

        const user = result.rows[0];
        const validPassword = await bcrypt.compare(passwd, user.passwd);
        if (!validPassword) return res.status(400).send('Login ou mot de passe incorrect.');

        // Generate a JWT token with expiration
        const token = jwt.sign({ id: user.id, login: user.login }, 'your_secret_key', { expiresIn: '1h' });

        res.json({
            token,
            status: 'success',
            expiresIn: '1 hour'
        });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour mettre à jour un utilisateur, avec vérification d'identité
app.put('/utilisateurs/:id', authenticateToken, async (req, res) => {
    try {
        const { id } = req.params;
        const { login, passwd, adresse, pays, age, sexe, photo } = req.body;

        // Vérification de la présence de tous les champs
        if (!login || !passwd || !adresse || !pays || !age || !sexe || !photo) {
            return res.status(400).json({ error: 'Tous les champs sont requis' });
        }

        // Vérification que l'utilisateur authentifié correspond à l'utilisateur ciblé
        if (req.user.id !== parseInt(id)) {
            console.log(`User ID mismatch: token ID ${req.user.id} does not match param ID ${id}`);
            return res.status(403).json({ error: "Vous n'êtes pas autorisé à mettre à jour cet utilisateur" });
        }

        // Hachage du mot de passe
        const hashedPassword = await hashPassword(passwd);

        const result = await pool.query(
            'UPDATE Utilisateur SET login = $1, passwd = $2, adresse = $3, pays = $4, age = $5, sexe = $6, photo = $7 WHERE id = $8 RETURNING *',
            [login, hashedPassword, adresse, pays, age, sexe, photo, id]
        );

        if (result.rows.length === 0) {
            return res.status(404).send('Utilisateur non trouvé');
        }

        res.status(200).json(result.rows[0]);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour supprimer un utilisateur, avec vérification d'identité
app.delete('/utilisateurs/:id', authenticateToken, async (req, res) => {
    try {
        const { id } = req.params;

        // Vérification que l'utilisateur authentifié correspond à l'utilisateur ciblé
        if (req.user.id !== parseInt(id)) {
            return res.status(403).json({ error: "Vous n'êtes pas autorisé à supprimer cet utilisateur" });
        }

        const result = await pool.query('DELETE FROM Utilisateur WHERE id = $1 RETURNING *', [id]);
        if (result.rows.length === 0) {
            return res.status(404).send('Utilisateur non trouvé');
        }

        const deletedUser = result.rows[0];
        const { id: userId, login, adresse, pays, age, sexe } = deletedUser;

        res.status(200).json({
            message: `L'utilisateur avec l'ID ${userId} (${login}) a été supprimé avec succès.`,
            details: {
                adresse,
                pays,
                age,
                sexe
            }
        });
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});


// Route pour vérifier les informations d'identification de l'utilisateur (login et mot de passe)
app.post('/utilisateurs/auth', async (req, res) => {
    try {
        const { login, passwd } = req.body;
        if (!login || !passwd) {
            return res.status(400).json({ error: 'Login et mot de passe sont requis' });
        }

        // Récupérer l'utilisateur par login
        const result = await pool.query('SELECT * FROM Utilisateur WHERE login = $1', [login]);
        if (result.rows.length === 0) {
            return res.status(401).json({ error: 'Authentification échouée' });
        }

        const user = result.rows[0];

        // Comparer les mots de passe hachés
        const isMatch = await bcrypt.compare(passwd, user.passwd);
        if (!isMatch) {
            return res.status(401).json({ error: 'Authentification échouée' });
        }

        // Si tout est bon, retourner les informations utilisateur (sans le mot de passe)
        const { passwd: _, ...userWithoutPassword } = user;
        res.status(200).json(userWithoutPassword);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour récupérer toutes les formations
app.get('/formations', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM Formation');
        res.status(200).json(result.rows);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour récupérer une formation par ID
app.get('/formations/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query('SELECT * FROM Formation WHERE id = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(404).send('Formation non trouvée');
        }
        res.status(200).json(result.rows[0]);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour ajouter une nouvelle formation
app.post('/formations', async (req, res) => {
    try {
        const { nom, description, date_debut, date_fin } = req.body;
        if (!nom || !description || !date_debut || !date_fin) {
            return res.status(400).json({ error: 'Tous les champs sont requis' });
        }
        const result = await pool.query(
            'INSERT INTO Formation (nom, description, date_debut, date_fin) VALUES ($1, $2, $3, $4) RETURNING *',
            [nom, description, date_debut, date_fin]
        );
        res.status(201).json(result.rows[0]);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour mettre à jour une formation existante
app.put('/formations/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { nom, description, date_debut, date_fin } = req.body;
        if (!nom || !description || !date_debut || !date_fin) {
            return res.status(400).json({ error: 'Tous les champs sont requis' });
        }
        const result = await pool.query(
            'UPDATE Formation SET nom = $1, description = $2, date_debut = $3, date_fin = $4 WHERE id = $5 RETURNING *',
            [nom, description, date_debut, date_fin, id]
        );
        if (result.rows.length === 0) {
            return res.status(404).send('Formation non trouvée');
        }
        res.status(200).json(result.rows[0]);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour supprimer une formation
app.delete('/formations/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query('DELETE FROM Formation WHERE id = $1 RETURNING *', [id]);
        if (result.rows.length === 0) {
            return res.status(404).send('Formation non trouvée');
        }
        res.status(204).send();
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour récupérer tous les cours
app.get('/cours', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM Cours');
        res.status(200).json(result.rows);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour récupérer un cours par ID
app.get('/cours/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query('SELECT * FROM Cours WHERE id = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(404).send('Cours non trouvé');
        }
        res.status(200).json(result.rows[0]);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour ajouter un nouveau cours
app.post('/cours', async (req, res) => {
    try {
        const { nom, description, formation_id } = req.body;
        if (!nom || !description || !formation_id) {
            return res.status(400).json({ error: 'Tous les champs sont requis' });
        }
        const result = await pool.query(
            'INSERT INTO Cours (nom, description, formation_id) VALUES ($1, $2, $3) RETURNING *',
            [nom, description, formation_id]
        );
        res.status(201).json(result.rows[0]);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour mettre à jour un cours existant
app.put('/cours/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { nom, description, formation_id } = req.body;
        if (!nom || !description || !formation_id) {
            return res.status(400).json({ error: 'Tous les champs sont requis' });
        }
        const result = await pool.query(
            'UPDATE Cours SET nom = $1, description = $2, formation_id = $3 WHERE id = $4 RETURNING *',
            [nom, description, formation_id, id]
        );
        if (result.rows.length === 0) {
            return res.status(404).send('Cours non trouvé');
        }
        res.status(200).json(result.rows[0]);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour supprimer un cours
app.delete('/cours/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query('DELETE FROM Cours WHERE id = $1 RETURNING *', [id]);
        if (result.rows.length === 0) {
            return res.status(404).send('Cours non trouvé');
        }
        res.status(204).send();
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour récupérer tous les modules
app.get('/modules', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM Module');
        res.status(200).json(result.rows);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour récupérer un module par ID
app.get('/modules/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query('SELECT * FROM Module WHERE id = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(404).send('Module non trouvé');
        }
        res.status(200).json(result.rows[0]);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour ajouter un nouveau module
app.post('/modules', async (req, res) => {
    try {
        const { nom, contenu, cours_id } = req.body;
        if (!nom || !contenu || !cours_id) {
            return res.status(400).json({ error: 'Tous les champs sont requis' });
        }
        const result = await pool.query(
            'INSERT INTO Module (nom, contenu, cours_id) VALUES ($1, $2, $3) RETURNING *',
            [nom, contenu, cours_id]
        );
        res.status(201).json(result.rows[0]);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour mettre à jour un module existant
app.put('/modules/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { nom, contenu, cours_id } = req.body;
        if (!nom || !contenu || !cours_id) {
            return res.status(400).json({ error: 'Tous les champs sont requis' });
        }
        const result = await pool.query(
            'UPDATE Module SET nom = $1, contenu = $2, cours_id = $3 WHERE id = $4 RETURNING *',
            [nom, contenu, cours_id, id]
        );
        if (result.rows.length === 0) {
            return res.status(404).send('Module non trouvé');
        }
        res.status(200).json(result.rows[0]);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour supprimer un module
app.delete('/modules/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query('DELETE FROM Module WHERE id = $1 RETURNING *', [id]);
        if (result.rows.length === 0) {
            return res.status(404).send('Module non trouvé');
        }
        res.status(204).send();
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Démarrer le serveur pour écouter les requêtes sur le port 3000
app.listen(port, () => {
    console.log(`L'application est lancée sur http://localhost:${port}`);
});