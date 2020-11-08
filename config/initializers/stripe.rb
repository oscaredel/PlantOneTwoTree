Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLISHABLE_KEY_TEST'],
  secret_key:      ENV['STRIPE_SECRET_KEY_TEST']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
