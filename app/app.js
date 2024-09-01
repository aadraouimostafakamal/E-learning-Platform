// app.js

const express = require('express');
const helmet = require('helmet');
require('dotenv').config();
const path = require('path');
const app = express();

// Serve static files from the 'app' directory
app.use('/app', express.static(path.join(__dirname, 'app')));
// Serve the reset_password.html file from the root directory
app.get('/reset_password.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'reset_password.html'));
});
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
app.use('', utilisateurRoutes);
// Import and use contact routes
const contactRoutes = require('./api/contactRoutes');
app.use('', contactRoutes);

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