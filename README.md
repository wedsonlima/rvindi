# Vindi Little Help

ActiveRecord-like way to interact with Vindi API

## Vindi

[Vindi](https://vindi.com.br) is a brazilian fintech, that was recently acquired by [Locaweb](https://blog.vindi.com.br/agora-a-vindi-faz-parte-do-grupo-locaweb), that helps other companies to work with **recurring payments**.

### API docs

  * [Swagger sandbox](https://vindi.github.io/api-docs/dist/?url=https://sandbox-app.vindi.com.br/api/v1/docs#/)
  * [Swagger prod](https://vindi.github.io/api-docs/dist)
  *
    [Vindi - Official Gem](https://github.com/vindi/vindi-ruby)

    > You may ask: Why create another if there is already one that's official?
    > *And I'll tell you, **little grasshopper**: Because I think this one could be more beautiful.*
    >
    > And you also may ask: Why the hell is the doc in english when all those interested are from the big banana republic?
    > *And my answer to you would be: You ask a lot of questions, huh?*

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vindi-hermes'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install vindi-hermes

## Usage

### Config

```ruby
# config/initializers/vindi.rb
Vindi.config do |c|
  c.sandbox = true # default is false
  c.api_key = 'YOUR API KEY'
  c.webhook_secret = 'YOUR WEBHOOK SECRET'
end
```

### Examples

#### Saruman creates a subscription business to rent his Palantir

```ruby
# Let's say that Gandalf wants to borrow Saruman's Palantir
# promising he'll give it back before the end of the 3rd era.
#
# But Saruman is wise and he thinks he could make a good money
# charging a rent for the use of the magic ball.
#
# So, Saruman went on to Vindi and there created a product...
#
palantir = Vindi::Product.new.tap do |p|
  p.code = "palantir"
  p.name = "Palantir"
  p.description = "The Twitch of Istari folk"
  p.pricing_schema = { price: 42.42 }
  p.save
end

# ...then created a recurring plan.
one_plan = Vindi::Plan.new.tap do |p|
  p.code = "the-one-plan"
  p.name = "Monthly Plan"
  p.description = "The One Plan To Rule Them All"
  p.period = "monthly"
  p.recurring = true
  p.plan_items = [
    {
      cycles: nil, # untill the end of time
      product_id: palantir.id
    }
  ]
  p.save
end

# Gandalf uses his fellow Bilbo's address to receive the invoices...
gandalf = Vindi::Customer.new.tap do |c|
  c.code = 1
  c.name = "Gandalf the Grey"
  c.email = "mithrandir@middlearth.io"
  c.address = {
    street: "Bagshot Row",
    number: "Bag End",
    neighborhood: "Hobbiton",
    city: "Shire"
  }
  c.save
end

# ...uses Elrond's credit card to create a payment profile...
pp = Vindi::PaymentProfile.new.tap do |pp|
  pp.holder_name = "Elrond Half-elven"
  pp.card_expiration = "12/3021"
  pp.card_number = "5167454851671773"
  pp.card_cvv = "123"
  pp.customer_id = gandalf.id
  pp.save
end

# ...subscribes and then get the palantir.
subscription = Vindi::Subscription.new.tap do |s|
  s.plan_id = one_plan.id
  s.customer_id = gandalf.id
  s.payment_method_code = "credit_card"
  s.save
end
```

#### After some time he wants to know how the business is going

```ruby
# Active customers
customers = Vindi::Customer.active

# Active subscriptions
subscriptions = Vindi::Subscriptions.active

# Subscriptions for the-one-plan
subscriptions = Vindi::Plan.find_by(code: "the-one-plan").subscriptions

# Filter Gandalf
gandalf = Vindi::Customer.find_by(email: "mithrandir@middlearth.io")

# All Gandalf's subscriptions
subscriptions = gandalf.subscriptions.active

# Cancel Gandalf's subscription
gandalf.subscriptions.active.last.cancel!

# Refund the last Gandalf's payment
gandalf.charges.last.refund!
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wedsonlima/vindi-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/wedsonlima/vindi-ruby/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Vindi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/wedsonlima/vindi-ruby/blob/main/CODE_OF_CONDUCT.md).
