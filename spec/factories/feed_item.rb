FactoryBot.define do
  factory :feed_item, class: GoogleAdsSimpleApi::FeedItem do
    sequence :id
    sequence :feed_id
  end
end
