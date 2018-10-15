FactoryBot.define do
  factory :campaign_criterion, class: GoogleAdsSimpleApi::CampaignCriterion do
    status 'ACTIVE'
    campaign_id 1
  end
end
