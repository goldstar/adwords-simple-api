FactoryBot.define do
  factory :feed_item, class: AdwordsSimpleApi::FeedItem do
    sequence :feed_item_id
    sequence :feed_id
  end
end
