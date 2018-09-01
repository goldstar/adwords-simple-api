FactoryBot.define do
  factory :campaign_group, class: GoogleAdsSimpleApi::CampaignGroup do
    sequence :id
    sequence :name do |n|
      "Camapign Group n"
    end
    status 'ENABLED'
  end
end
