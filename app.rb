herorequire 'sinatra'
require 'stripe'

set :publishable_key, ENV['PUBLISHABLE_KEY']
set :secret_key, ENV['SECRET_KEY']

Stripe.api_key = settings.secret_key

get '/' do
  erb :index
end

post '/ephemeral_keys' do
    authenticate!
    begin
        key = Stripe::EphemeralKey.create(
            {customer: @customer.id},
            {stripe_version: params["api_version"]}
        )
        rescue Stripe::StripeError => e
            status 402
        return "Error creating ephemeral key: #{e.message}"
    end
    
    status 200
    key.to_json
end

post '/charge' do
  @amount = 500

  customer = Stripe::Customer.create(
    :email => 'customer@example.com',
    :card  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => 'Sinatra Charge',
    :currency    => 'usd',
    :customer    => customer
  )

  erb :charge
end

__END__

@@ layout
  <!DOCTYPE html>
  <html>
  <head></head>
  <body>
    <%= yield %>
  </body>
  </html>

@@index
  <form action="/charge" method="post">
    <article>
      <label class="amount">
        <span>Amount: $5.00</span>
      </label>
    </article>

    <script src="https://checkout.stripe.com/v3/checkout.js" class="stripe-button" data-key="<%= settings.publishable_key %>"></script>
  </form>

@@charge
  <h2>Thanks, you paid <strong>$5.00</strong>!</h2>
