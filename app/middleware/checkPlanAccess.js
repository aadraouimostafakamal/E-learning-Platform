// middleware/checkPlanAccess.js
const checkPlanAccess = (allowedPlanId) => {
    return (req, res, next) => {
        const userPlanId = req.subscription.items.data[0].price.id;

        if (userPlanId !== allowedPlanId) {
            return res.status(403).json({ error: 'You do not have access to this content.' });
        }

        next();
    };
};

module.exports = checkPlanAccess;
