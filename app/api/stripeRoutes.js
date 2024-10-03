const express = require('express');
const supabase = require('../utils/supabaseClient');
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
const authenticateToken = require('../middleware/authToken'); // Import middleware for JWT auth
const router = express.Router();

// Create a Stripe Checkout session
router.post('/create-checkout-session', authenticateToken, async (req, res) => {
    const { priceId } = req.body;
    const domainURL = process.env.DOMAIN;

    try {
        // Fetch the user from the database
        const { data: user, error } = await supabase
            .from('utilisateur')
            .select('stripecustomerid')
            .eq('email', req.user.email)
            .single();

        if (error) throw error;

        let customerId = user.stripecustomerid;

        // If the user doesn't have a Stripe customer ID, create a new customer in Stripe
        if (!customerId) {
            const customer = await stripe.customers.create({
                email: req.user.email, // Assuming you have the user's email
            });

            // Save the new customer ID in the database
            await supabase
                .from('utilisateur')
                .update({ stripecustomerid: customer.id })
                .eq('email', req.user.email);

            customerId = customer.id;
        }

        // Create a Stripe Checkout session
        const session = await stripe.checkout.sessions.create({
            customer: customerId,
            payment_method_types: ['card'],
            mode: 'subscription',
            line_items: [
                {
                    price: priceId,
                    quantity: 1,
                },
            ],
            success_url: `${domainURL}/content.html?session_id={CHECKOUT_SESSION_ID}`,
            cancel_url: `${domainURL}/cancel.html`,
        });

        res.json({ id: session.id });
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
});

// Webhook route for Stripe
router.post('/webhook', express.raw({ type: 'application/json' }), async (req, res) => {
    const sig = req.headers['stripe-signature'];

    try {
        const event = stripe.webhooks.constructEvent(req.body, sig, process.env.STRIPE_WEBHOOK_SECRET);

        if (event.type === 'checkout.session.completed') {
            const session = event.data.object;

            // Retrieve the subscription and customer details from Stripe
            const subscription = await stripe.subscriptions.retrieve(session.subscription);

            const customerEmail = session.customer_email; // Get customer's email from the session
            const planName = subscription.items.data[0].price.nickname;
            const startDate = new Date(subscription.start_date * 1000); // Stripe uses Unix timestamp
            const endDate = new Date(subscription.current_period_end * 1000);

            // Store the subscription information in Supabase
            const { error: subscriptionError } = await supabase
                .from('subscriptions')
                .insert({
                    stripesubscriptionid: subscription.id,
                    plan: planName,
                    status: subscription.status,
                    startdate: startDate,
                    enddate: endDate,
                    created_at: new Date(),
                    updated_at: new Date(),
                });

            if (subscriptionError) {
                console.error('Error saving subscription to database:', subscriptionError);
                throw subscriptionError;
            }

            // Update the user record in Supabase to set subscription status to active
            const { error: userUpdateError } = await supabase
                .from('utilisateur')
                .update({ subscription_status: 'active' }) // Set the status as active
                .eq('email', customerEmail);

            if (userUpdateError) {
                console.error('Error updating user subscription status:', userUpdateError);
                throw userUpdateError;
            }

            console.log('Subscription saved and user updated successfully for customer:', customerEmail);
        }

        res.json({ received: true });
    } catch (err) {
        console.log(`⚠️  Webhook signature verification failed.`, err.message);
        res.status(400).send(`Webhook Error: ${err.message}`);
    }
});


module.exports = router;
