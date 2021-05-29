# Vindi Little Help

ActiveRecord-like way to interact with Vindi API

## Vindi

    https://vindi.github.io/api-docs/dist/?url=https://sandbox-app.vindi.com.br/api/v1/docs#/

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
Vindi::Config.new do |c|
  c.sandbox = true # default is false
  c.api_key = 'YOUT API KEY'
end
```

### Customers

```ruby
customer = Vindi::Customer.find(1)

customers = Vindi::Customer.active

customers = Vindi::Customer.where(created_at: Time.zone.today)

customers = Vindi::Customer.where(gt: { created_at: Time.zone.yesterday })
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake -test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/vindi. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/vindi/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Vindi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/vindi/blob/master/CODE_OF_CONDUCT.md).
