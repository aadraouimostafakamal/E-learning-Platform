// utils/getusersubscription.js
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
const supabase = require('../utils/supabaseClient');

async function getUserSubscription(email) {
    try {
        console.log('Fetching subscription for email:', email);

        // Retrieve user from Supabase by email
        const { data: user, error } = await supabase
            .from('utilisateur')
            .select('stripecustomerid')
            .eq('email', email)
            .single();

        if (error || !user || !user.stripecustomerid) {
            throw new Error('Utilisateur non trouvé');
        }

        const stripeCustomerId = user.stripecustomerid;

        // List subscriptions for the customer in Stripe
        const subscriptions = await stripe.subscriptions.list({
            customer: stripeCustomerId,
            status: 'active',
        });

        if (subscriptions.data.length > 0) {
            const subscription = subscriptions.data[0];
            const plan = subscription.items.data[0].price.nickname;

            return {
                subscriptionStatus: subscription.status,
                planName: plan,
                subscriptionId: subscription.id
            };
        } else {
            return { subscriptionStatus: 'inactive' };
        }
    } catch (error) {
        console.error('Error retrieving subscription:', error.message);
        throw new Error('Failed to retrieve subscription');
    }
}

module.exports = { getUserSubscription };
