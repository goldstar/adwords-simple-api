FactoryBot.define do
  factory :ad_group, class: GoogleAdsSimpleApi::AdGroup do
    sequence :id
    sequence :name do |n|
      "Ad Group n"
    end
    status 'ENABLED'
  end
end
