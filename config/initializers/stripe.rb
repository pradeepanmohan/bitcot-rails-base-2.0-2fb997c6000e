Rails.configuration.stripe = {
    publishable_key: Rails.application.credentials[Rails.env.to_sym][:stripe_publishable_key],
    secret_key: Rails.application.credentials[Rails.env.to_sym][:stripe_secret_key]
}

# Set our app-stored secret key with Stripe
Stripe.api_key = Rails.configuration.stripe[:secret_key]