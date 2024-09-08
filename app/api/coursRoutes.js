const express = require('express'); // Import the express module
const router = express.Router(); // Create a new router object
const supabase = require('../utils/supabaseClient'); // Import the Supabase client (ensure the path is correct)

// Route pour récupérer tous les cours
router.get('/', async (req, res) => {
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
router.get('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { data, error } = await supabase
            .from('cours')
            .select('*')
            .eq('idcours', id)
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
        if (!niveau || !format || !domaine || !prix) {
            return res.status(400).json({ error: 'Tous les champs sont requis' });
        }
        const { data, error } = await supabase
            .from('cours')
            .insert([{ niveau, format, domaine, prix }])
            .select('*')  // Explicitly select the updated row
            .single();
        
        if (error) throw error;
        
        res.status(201).json({ message: 'Cours créé avec succès', cours: data});
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
        if (!niveau || !format || !domaine || !prix) {
            return res.status(400).json({ error: 'Tous les champs sont requis' });
        }
        const { data, error } = await supabase
            .from('cours')
            .update({ niveau, format, domaine, prix })
            .eq('idcours', id)
            .select('*')  // Explicitly select the updated row
            .single();
        
        if (error) throw error;
        
        if (!data) {
            return res.status(404).send('cours non trouvé');
        }
        
        res.status(200).json({ message: 'Cours mise à jour avec succès', data});
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

// Route pour supprimer un cours
router.delete('/delete/:id', async (req, res) => {
    try {
        const { id } = req.params;

        // Step 1: Verify if the course exists before attempting deletion
        const { data: existingData, error: checkError } = await supabase
            .from('cours')
            .select('idcours')
            .eq('idcours', id)

        if (checkError) {
            // If there's an error while checking existence
            console.error(checkError);
            return res.status(500).send('Erreur du serveur lors de la vérification.');
        }

        if (!existingData || existingData.length === 0) {
            // If the course doesn't exist, return a 404 error
            return res.status(404).send('Cours non trouvé');
        }

        const { data, error } = await supabase
            .from('cours')
            .delete()
            .eq('idcours', id)
            .single();
        
        if (error){
            // If there's an error during deletion
            console.error(error);
            return res.status(500).send('Erreur du serveur lors de la suppression.');
        }
        
        if (data === null || data.length === 0) {
            // If no data is returned, the deletion was successful but we don't have anything to return
            return res.status(200).json({ message: 'cours supprimée avec succès' });
        }
        
    } catch (err) {
        console.error(err.message);
        res.status(500).send('Erreur du serveur');
    }
});

module.exports = router; // Export the router object to be used in other parts of the application