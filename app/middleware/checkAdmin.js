// Middleware to check if the user is an admin
const checkAdmin = (req, res, next) => {
    if (req.user.is_admin) {
        next(); // User is an admin, proceed to the next middleware or route handler
    } else {
        res.status(403).json({ message: 'Accès refusé: réservée aux administrateurs uniquement.' });
    }
};

module.exports = checkAdmin;
