# AdwordsSimpleApi

Adwords' SOAP API is a complicated and powerful beast with a steep learning curve that allows you access to everything in Adwords. The official ruby client library is a thin layer on top of that API that isn't very rubyish. This gem isn't powerful nor complete, far from both, but is instead a handful of the most common tasks with a very simple ruby like interface.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'adwords-simple-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install adwords-simple-api

## Usage

### Congifiguration

```ruby
require 'adwords_simple_api'

AdwordsSimpleApi.adwords = AdwordsApi::Api.new(options)
```

See the AdwordsApi documentation on the configuring a client and getting adwords api access.

### Campaigns

```ruby
campaign = AdwordsSimpleApi::Campaign.find(campaign_id)

campaign.enabled? # true
campaign.pause! 
campaign.enabled? # false
campaign.paused? # true
campaign.enable!
campaign.enabled? # true

campaign.attributes # {} of values
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/goldstar/adwords-simple-api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
