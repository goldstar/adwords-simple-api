FactoryBot.define do
  factory :campaign_group, class: AdwordsSimpleApi::CampaignGroup do
    sequence :id
    sequence :name do |n|
      "Camapign Group n"
    end
    status 'ENABLED'
  end
end
