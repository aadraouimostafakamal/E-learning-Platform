const express = require('express');
const router = express.Router();
const supabase = require('../utils/supabaseClient'); // Ensure this path is correct

// Fetch all formations
router.get('/', async (req, res) => {
    try {
        const { data, error } = await supabase
            .from('formation')
            .select('*');
        if (error) throw error;
        if (!data) {
            return res.status(404).send('Formation non trouvée');
        }
        res.status(200).json(data);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Fetch a specific formation by ID
router.get('/:idformation', async (req, res) => {
    try {
        const { idformation } = req.params;
        const { data, error } = await supabase
            .from('formation')
            .select('*')
            .eq('idformation', idformation)
            .single();
        if (error) throw error;
        if (!data) {
            return res.status(404).send('Formation non trouvée');
        }
        res.status(200).json(data);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Create a new formation
router.post('/', async (req, res) => {
    try {
        const { idapprenant, idformateur, idcours, datedebut, datefin, montantpaye } = req.body;
        const { data, error } = await supabase
            .from('formation')
            .insert([{ idapprenant, idformateur, idcours, datedebut, datefin, montantpaye }])
            .single();
        if (error) throw error;
        res.status(201).json(data);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Update an existing formation by ID
router.put('/:idformation', async (req, res) => {
    try {
        const { idformation } = req.params;
        const { idapprenant, idformateur, idcours, datedebut, datefin, montantpaye } = req.body;
        const { data, error } = await supabase
            .from('formation')
            .update({ idapprenant, idformateur, idcours, datedebut, datefin, montantpaye })
            .eq('idformation', idformation)
            .single();
        if (error) throw error;
        if (!data) {
            return res.status(404).send('Formation non trouvée');
        }
        res.status(200).json(data);
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Delete a formation by ID
router.delete('/:idformation', async (req, res) => {
    try {
        const { idformation } = req.params;
        const { data, error } = await supabase
            .from('formation')
            .delete()
            .eq('idformation', idformation)
            .single();
        if (error) throw error;
        if (!data) {
            return res.status(404).send('Formation non trouvée');
        }
        res.status(204).send();
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

module.exports = router;