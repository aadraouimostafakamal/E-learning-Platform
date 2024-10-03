// api/contentRoutes.js
const express = require('express');
const supabase = require('../utils/supabaseClient');
const authenticateToken = require('../middleware/authenToken');
const router = express.Router();

// Route to get user subscription details
router.get('/user/subscription', authenticateToken, async (req, res) => {
    try {
        // Fetch the user's subscription from Supabase
        const { data: subscription, error } = await supabase
            .from('subscriptions')
            .select('plan, status, startdate, enddate')
            .eq('stripecustomerid', req.user.stripecustomerid)
            .single();

        if (error || !subscription) {
            return res.status(404).json({ message: 'Subscription not found' });
        }

        res.status(200).json({
            subscriptionStatus: subscription.status,
            planName: subscription.plan,
            startDate: subscription.startdate,
            endDate: subscription.enddate,
        });
    } catch (error) {
        res.status(500).json({ message: 'An error occurred while retrieving the subscription' });
    }
});

module.exports = router;
