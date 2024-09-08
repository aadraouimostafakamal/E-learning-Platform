// app.js

const express = require('express');
const helmet = require('helmet');
require('dotenv').config();

const app = express();

// Apply middleware
app.use(express.json());
app.use(helmet());

// Define the port
const port = 3000;

// Base route
app.get('/', (req, res) => {
    res.send('Bienvenue sur la plateforme E-learning!');
});

// Import and use utilisateur routes
const utilisateurRoutes = require('./api/utilisateurRoutes');
app.use('/utilisateurs', utilisateurRoutes);

// Import and Use the formations routes
const formationsRoutes = require('./api/formationsRoutes');
app.use('/formations', formationsRoutes);

// Import and Use the cours routes
const coursRoutes = require('./api/coursRoutes');
app.use('/cours', coursRoutes);

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