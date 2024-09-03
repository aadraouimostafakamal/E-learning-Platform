const express = require('express'); // Import the express module
const router = express.Router(); // Create a new router object
const supabase = require('../utils/supabaseClient'); // Import the Supabase client

// Fetch all formations
router.get('/', async (req, res) => {
    try {
        // Query the 'formation' table to select all rows
        const { data, error } = await supabase
            .from('formation')
            .select('*');
        // If there is an error, throw it to be caught by the catch block
        if (error) throw error;
        // If no data is returned, send a 404 status with a message
        if (!data) {
            return res.status(404).send('Formation non trouvée');
        }

        // If data is found, send it with a 200 status
        res.status(200).json(data);
    } catch (err) {
        // Log the error message to the console
        console.error(err.message);

        // Send a 500 status with a server error message
        res.status(500).send('Erreur du serveur');
    }
});

// Fetch a specific formation by ID
router.get('/:idformation', async (req, res) => {
    try {
        const { idformation } = req.params; // Extract the ID from the request parameters
        // Query the 'formation' table to select the row with the specified ID
        const { data, error } = await supabase
            .from('formation')
            .select('*')
            .eq('idformation', idformation)
            .single(); // Ensure only one row is returned
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
router.post('/create', async (req, res) => {
    try {
        const { idapprenant, idformateur, idcours, datedebut, datefin, montantpaye } = req.body;
        // Insert a new row into the 'formation' table
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
router.put('/update/:idformation', async (req, res) => {
    try {
        const { idformation } = req.params; // Extract the ID from the request parameters to verify the ID
        const { idapprenant, idformateur, idcours, datedebut, datefin, montantpaye } = req.body;
        // Update the specified row in the 'formation' table
        const { data, error } = await supabase
            .from('formation')
            .update({ idapprenant, idformateur, idcours, datedebut, datefin, montantpaye })
            .eq('idformation', idformation)
            //explicitly tell Supabase to return the updated row
            .select('*');
        
        // Log the Supabase response
        console.log('Supabase response:', { data, error });

        // If there is an error, log it and send a 500 status with a server error message
        if (error) {
            console.error('Supabase error:', error); 
            return res.status(500).json({ message: 'Erreur du serveur', error: error.message });
        }

        // If no data is returned, send a 404 status with a message
        if (!data || data.length === 0) {
            return res.status(404).send('Formation non trouvée');
        }

        // If the update is successful, send the updated data with a 200 status
        res.status(200).json({ message: 'Formation mise à jour avec succès', data });
    } catch (err) {
        // Log the error message to the console
        console.error('Error:', err.message);

        // Send a 500 status with a server error message
        res.status(500).json({ message: 'Erreur du serveur', error: err.message });
    }
});

// Delete a formation by ID
router.delete('/delete/:idformation', async (req, res) => {
    try {
        const { idformation } = req.params; // Extract the ID from the request parameters
        console.log(`Deleting formation with ID: ${idformation}`); // Log the ID for debugging purposes
        // We need to verify that the formation exists before attempting to delete it.
        // This is important because if we attempt to delete a row that doesn't exist,
        // the deletion will be "successful" but nothing will actually be deleted.
        const { data: existingData, error: existError } = await supabase
            .from('formation')
            .select('idformation')
            .eq('idformation', idformation)
        
        if (existError) {
            // If there's an error checking for existence, respond with a server error
            return res.status(500).json({ message: 'Erreur du serveur', error: existError.message });
        }

        if (!existingData || existingData.length === 0) {
            // If the formation doesn't exist, respond with a 404 error
            return res.status(404).json({ message: 'Formation non trouvée' });
        }

        // Proceed with deleting the formation if it exists
        const { data, error } = await supabase
            .from('formation')
            .delete()
            .eq('idformation', idformation);

        if (error) {
            // If there's an error during deletion, respond with a server error
            return res.status(500).json({ message: 'Erreur du serveur', error: error.message });
        }

        if (data === null || data.length === 0) {
             // If no data is returned, the deletion was successful but we don't have anything to return
            return res.status(200).json({ message: 'Formation supprimée avec succès' });
        }

    } catch (err) {
        console.error('Error:', err.message);
        res.status(500).json({ message: 'Erreur du serveur', error: err.message });
    }
});

module.exports = router;