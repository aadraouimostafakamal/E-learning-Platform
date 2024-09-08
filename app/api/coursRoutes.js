const express = require('express'); // Import the express module
const router = express.Router(); // Create a new router object
const supabase = require('../utils/supabaseClient'); // Import the Supabase client (ensure the path is correct)

// Route pour récupérer tous les cours
router.get('/cours', async (req, res) => {
    try {
        const { data, error } = await supabase
            .from('cours')
            .select('*');
        
        if (error) throw error;
        
        res.status(200).json(data);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour récupérer un cours par ID
router.get('/cours/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await supabase
            .from('cours')
            .select('*')
            .eq('id', id)
            .single();
        
        if (error) throw error;
        
        if (!data) {
            return res.status(404).send('cours non trouvé');
        }
        
        res.status(200).json(data);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour ajouter un nouveau cours
router.post('/create', async (req, res) => {
    try {
        const { niveau, format, domaine, prix } = req.body;
        if (!niveau || !format || !domaine, !prix) {
            return res.status(400).json({ error: 'Tous les champs sont requis' });
        }
        const { data, error } = await supabase
            .from('cours')
            .insert([{ niveau, format, domaine, prix }])
            .single();
        
        if (error) throw error;
        
        res.status(201).json(data);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour mettre à jour un cours existant
router.put('/update/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { niveau, format, domaine, prix } = req.body;
        if (!niveau || !format || !domaine, prix) {
            return res.status(400).json({ error: 'Tous les champs sont requis' });
        }
        const { data, error } = await supabase
            .from('cours')
            .update({ niveau, format, domaine, prix })
            .eq('id', id)
            .single();
        
        if (error) throw error;
        
        if (!data) {
            return res.status(404).send('cours non trouvé');
        }
        
        res.status(200).json(data);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour supprimer un cours
router.delete('/delete/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await supabase
            .from('cours')
            .delete()
            .eq('id', id)
            .single();
        
        if (error) throw error;
        
        if (!data) {
            return res.status(404).send('cours non trouvé');
        }
        
        res.status(204).send();
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

module.exports = router; // Export the router object to be used in other parts of the application