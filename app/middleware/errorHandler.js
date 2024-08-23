// middleware/errorHandler.js

function handleError(err, res, message = 'Erreur du serveur') {
    console.error(err);
    res.status(500).json({ error: message });
}

module.exports = handleError;
