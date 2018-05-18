# AdwordsSimpleApi

Adwords' SOAP API is a complicated and powerful beast with a steep learning curve that allows you access to everything in Adwords. The official ruby client library is a thin layer on top of that API that isn't very rubyish. This gem isn't powerful nor complete, far from both, but is instead a handful of the most common tasks with a very simple ruby like interface.

This gem is very alpha. You probably don't want to use it unless you're actively developing it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'adwords-simple-api', {
  git: 'https://github.com/goldstar/adwords-simple-api.git',
  ref: 'master'
}
```

Since this gem's interace can change at anytime, it's recommended that you point to a specific commit and not master.

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
campaigns = AdwordsSimpleApi::Campaign.all
campaign = AdwordsSimpleApi::Campaign.find(campaign_id)

campaign.enabled? # true
campaign.pause!
campaign.enabled? # false
campaign.paused? # true
campaign.enable!
campaign.enabled? # true

campaign.attributes # hash of values
campaign.expanded_text_ads # array of ExpandedTextAds
```

### Campaign Groups

```ruby
groups = AdwordsSimpleApi::CampaignGroup.all
group = AdwordsSimpleApi::CampaignGroup.find(campaign_id)

group.enabled? # true

group.attributes # hash of values
group.campaigns # array of Campaigns
```

### Expanded Text Ads

```ruby
ads = AdwordsSimpleApi::ExpandedTextAd.for_campaign(campaign_id)  # array of ExpandedTextAds
ads.first.attributes # hash of values
ads.first.final_urls # array of the final_urls

```

### Reports

```ruby
AdwordsSimpleApi::Reports::AdPerformanceReport.new.to_a # Array of Hashes
AdwordsSimpleApi::Reports::CampaignPerformanceReport.new.to_a
AdwordsSimpleApi::Reports::PlaceholderFeedItemReport.new.to_a
AdwordsSimpleApi::Reports::DailyAdPerformanceReport.new.to_a                              # Report for yesterday
AdwordsSimpleApi::Reports::DailyAdPerformanceReport.new(Date.today).to_a                  # Report for today
AdwordsSimpleApi::Reports::DailyAdPerformanceReport.new(Date.yesterday..Date.today).to_a  # Report segmented by day for range
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/goldstar/adwords-simple-api.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
