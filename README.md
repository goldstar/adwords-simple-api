# GoogleAdsSimpleApi

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
require 'google_ads_simple_api'

GoogleAdsSimpleApi.adwords = AdwordsApi::Api.new(options)
```

See the AdwordsApi documentation on the configuring a client and getting adwords api access.

### AdGroups

```ruby
ad_groups = GoogleAdsSimpleApi::AdGroup.all # Array of AdGroups
ad_groups = GoogleAdsSimpleApi::AdGroup.all(campaign_id: campaign.id) # Array of AdGroups
ad_groups = GoogleAdsSimpleApi::AdGroup.find(ad_group_id) # Instance or nil
ad_groups = GoogleAdsSimpleApi::AdGroup.find_by(name: ad_group_name) # Instance or nil
ad_group = GoogleAdsSimpleApi::AdGroup.create!(name: ad_group_name)

ad_group.enabled? # true
ad_group.pause!
ad_group.paused? # true
ad_group.enable!
ad_group.enabled? # true
ad_group.status # 'ENABLED'
ad_group.name # 'some ad group'

GoogleAdsSimpleApi::AdGroup.fields # list of available attributes

ad_group.attributes # hash of values
ad_group.labels # array of Label
ad_group.add_label(label_object) # true or false
ad_group.remove_label(label_object) # true or false
ad_group.campaign # Campaign object
ad_group.expanded_text_ads # Array of ExpandedTextAd

ad_group.set(name: 'A New Name', ...) # Mutates the ad_group

```

### Budgets

```ruby
  budget = GoogleAdsSimpleApi::Budget.create!(
    is_explicitly_shared: false,
    amount: {micro_amount: 5_000_000},
    delivery_method: 'STANDARD'
  )
```

### Campaigns

```ruby
campaigns = GoogleAdsSimpleApi::Campaign.all # Array of Campaign
campaigns = GoogleAdsSimpleApi::Campaign.all(campaign_group_id: 2) # Array of Campaigns
campaign = GoogleAdsSimpleApi::Campaign.find_by(name: campaign_name) # Instance of Campaign or nil
campaign = GoogleAdsSimpleApi::Campaign.find(campaign_id) # same as all(id: campaign_id).first
campaign = GoogleAdsSimpleApi::Campaign.create!(name: campaign_name)

campaign.enabled? # true
campaign.pause!
campaign.enabled? # false
campaign.paused? # true
campaign.enable!
campaign.enabled? # true
campaign.status # 'ENABLED'
campaign.name # 'some campaign'
campaign.set(name: 'A New Name', ...) # Mutates the campaign

GoogleAdsSimpleApi::Campaign.fields # list of available attributes

campaign.attributes # hash of values
campaign.labels # array of Label
campaign.add_label(label_object) # true or false
campaign.remove_label(label_object) # true or false
campaign.ad_groups # array of AdGroup
campaign.expanded_text_ads # array of ExpandedTextAd
```

### Campaign Groups

```ruby
groups = GoogleAdsSimpleApi::CampaignGroup.all(finder_options) # Array of CampaignGroup
group = GoogleAdsSimpleApi::CampaignGroup.find(campaign_id) # same as all(id: campaign_id).first
group = GoogleAdsSimpleApi::CampaignGroup.create!(name: group_name)

group.id # 1
group.name # 'group name'
group.status # 'ENABLED'
group.enabled? # true

group.set(name: 'A New Name', ...) # Mutates the group

group.attributes # Hash of values
group.campaigns # Array of Campaign
```

### Expanded Text Ads

```ruby
ads = GoogleAdsSimpleApi::ExpandedTextAd.for_campaign(campaign_id)  # array of ExpandedTextAds
ads.first.attributes # hash of values
ads.first.final_urls # array of the final_urls
```

### Feeds

```ruby
feed = GoogleAdsSimpleApi::Feed.find(feed_id)
feed = GoogleAdsSimpleApi::Feed.find_by(name: 'feed name')
feed = GoogleAdsSimpleApi::Feed.create!(name: feed_name)

feed.id # 1
feed.name # 'label name'
feed.status # 'ENABLED'
feed.schema # Array of Hashes. Comes from schema.attributes[:attributes]
feed.system_feed_generation_data
```

### Feed Items

```ruby
feed_item = GoogleAdsSimpleApi::FeedItem.find(feed_item_id) # or
feeds_items = GoogleAdsSimpleApi::Feed.find(feed_id).items

feed_item.attribute_values # array of attribute values
feed_item.to_hash # attribute values converted into a hash

feed_item.attribute_values_for(hash) # convert a hash into an array of attribute_values
```

### Labels

```ruby
label = GoogleAdsSimpleApi::Label.find(label_id)
label = GoogleAdsSimpleApi::Label.find_by(name: 'label name')
label.id # 1
label.name # 'label name'
label.status # 'ENABLED'

label.campaigns # Array of Campaign
label.ad_groups # Array of AdGroup
```

### Reports

```ruby
GoogleAdsSimpleApi::Reports::AdPerformanceReport.new.to_a # Array of Hashes
GoogleAdsSimpleApi::Reports::CampaignPerformanceReport.new.to_a
GoogleAdsSimpleApi::Reports::PlaceholderFeedItemReport.new.to_a
GoogleAdsSimpleApi::Reports::DailyAdPerformanceReport.new.to_a                              # Report for yesterday
GoogleAdsSimpleApi::Reports::DailyAdPerformanceReport.new(Date.today).to_a                  # Report for today
GoogleAdsSimpleApi::Reports::DailyAdPerformanceReport.new(Date.yesterday..Date.today).to_a  # Report segmented by day for range
```

### URL Custom parameters

Campaigns, Ad Groups, and Ads can have URL custom parameters. This object's interface
is similar to a hash and most hash methods work as expected.

```ruby
url_custom_parameters = GoogleAdsSimpleApi::Campaign.find(campaign_id).url_custom_parameters
url_custom_parameters[:foo] = 'bar' # 'bar'
url_custom_parameters.to_hash # {:foo => 'bar'}
url_custom_parameters.keys # [:foo]  
url_custom_parameters.delete(:foo)
url_custom_parameters.save # calls set(url_custom_parameters: ...) on the owner e.g. Campaign
```

### Eager Loading

You can eager load has_many associations to reduce API calls similar to ActiveRecord:

```ruby
GoogleAdsSimpleApi::Campaign.all(includes: :ad_groups)
GoogleAdsSimpleApi::Campaign.all(includes: {ad_groups: :expanded_text_ads})
GoogleAdsSimpleApi::Campaign.all(id: [campaign_ids], includes: :ad_groups)
GoogleAdsSimpleApi::Campaign.find_by(name: 'shoes', includes: :ad_groups)
GoogleAdsSimpleApi::CampaignGroup.find(id, includes: {campaigns: {ad_groups: :expanded_text_ads}})
```

If the associated object has a corresponding belongs_to relation, that is also pre-set to reduce API calls.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/goldstar/adwords-simple-api.
