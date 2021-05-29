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
gem 'vindi-little-help'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install vindi-little-help

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

#### Plans

```ruby

  # List active plans

  plans = Vindi::Plan.active

  # Create a recurring plan

  plan = Vindi::Plan.new.tap do |p|
    p.name = "Monthly Plan"
    p.description = "This plan will be renewed every month in the same day"
    p.period = "monthly"
    p.recurring = true
    p.code = 1
    p.plan_items = [
      {
        cycles: nil,
        product_id: 1
      }
    ]
  end

  # Create an yearly plan with installments

  plan = Vindi::Plan.new.tap do |p|
    p.name = "Yearly Plan"
    p.description = "This plan will be paid in 12 installments"
    p.period = "yearly"
    p.billing_cycles = 1
    p.installments = 12
    p.code = 1
    p.plan_items = [
      {
        cycles: nil,
        product_id: 1
      }
    ]
  end
```

#### Customer

```ruby
# Finding a specific customer
customer = Vindi::Customer.find(1)
# #<Vindi::Customer(customers/1) name="Gandalf the Grey" email="gandalf@middleearth.com" registry_code="" code="1" notes=nil status="archived" created_at="0001-01-01T00:00:01.000-00:00" updated_at="0001-01-01T00:00:01.000-00:00" metadata={} phones=[] id=1 address=#<Vindi::Address(addresses) street=nil number=nil additional_details=nil zipcode=nil neighborhood=nil city=nil state=nil country=nil>>

# Listing all active customers
customers = Vindi::Customer.active
# [#<Vindi::Customer(customers/1) name="Gandalf the Grey" email="gandalf@middleearth.com" registry_code="" code="1" notes=nil status="archived" created_at="0001-01-01T00:00:01.000-00:00" updated_at="0001-01-01T00:00:01.000-00:00" metadata={} phones=[] id=1 address=#<Vindi::Address(addresses) street=nil number=nil additional_details=nil zipcode=nil neighborhood=nil city=nil state=nil country=nil>>]

# ...paginated
customers = Vindi::Customer.active.page(2)

# New customers from yesterday
customers = Vindi::Customer.where(created_at: Time.zone.today)

# New customers since yesterday
customers = Vindi::Customer.where(gt: { created_at: Time.zone.yesterday })
```

#### Subscription

```ruby
# Active subscriptions of a customer
subscriptions = Vindi::Customer.find(1).subscriptions.active
# [#<Vindi::Subscription(subscriptions/1) status="active" start_at="2020-07-14T00:00:00.000-03:00" ...>>,
# #<Vindi::Subscription(subscriptions/2) status="active" start_at="2020-07-14T00:00:00.000-03:00" ...>>]

# You can cancel an active subscription
subscription = Vindi::Customer.find(1).subscriptions.active.last
subscription.cancel!

# Or reactivate one
subscription = Vindi::Subscription.find(1)
subscription.active!
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wedsonlima/vindi-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/vindi/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Vindi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/wedsonlima/vindi-ruby/blob/main/CODE_OF_CONDUCT.md).
