const supabase = require('../utils/supabaseClient');

const checkSubscription = async (req, res, next) => {
    try {
        const stripecustomerid = req.user.stripecustomerid;

        // Check if the user has an active subscription in Supabase
        const { data: subscription, error } = await supabase
            .from('subscriptions')
            .select('*')
            .eq('stripecustomerid', stripecustomerid)
            .eq('status', 'active') // Only check for active subscriptions
            .single();

        if (error || !subscription) {
            // No active subscription found, redirect to subscription page
            return res.redirect('/subscribe.html');
        }

        // Attach subscription details to the request object
        req.subscription = subscription;
        next();
    } catch (error) {
        console.error('Error while checking subscription:', error.message);
        return res.redirect('/subscribe.html'); // Redirect if there's an error
    }
};

module.exports = checkSubscription;
