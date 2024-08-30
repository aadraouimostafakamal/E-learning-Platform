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
        console.log(`Deleting formation with ID: ${idformation}`); // Log the ID

        // Check if the formation exists
        const { data: existingData, error: existError } = await supabase
            .from('formation')
            .select('idformation')
            .eq('idformation', idformation)
        
        if (existError) {
            return res.status(500).json({ message: 'Erreur du serveur', error: existError.message });
        }

        if (!existingData || existingData.length === 0) {
            return res.status(404).json({ message: 'Formation non trouvée' });
        }

        const { data, error } = await supabase
            .from('formation')
            .delete()
            .eq('idformation', idformation);

        if (error) {
            return res.status(500).json({ message: 'Erreur du serveur', error: error.message });
        }

        if (data === null || data.length === 0) {
            return res.status(200).json({ message: 'Formation supprimée avec succès' });
        }

        res.status(200).json({ message: 'Formation supprimée avec succès', data });
    } catch (err) {
        console.error('Error:', err.message);
        res.status(500).json({ message: 'Erreur du serveur', error: err.message });
    }
});

module.exports = router;