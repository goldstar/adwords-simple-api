FactoryBot.define do
  factory :campaign, class: GoogleAdsSimpleApi::Campaign do
    sequence :id
    sequence :name do |n|
      "Camapign n"
    end
    status 'ENABLED'
    budget({budget_id: 1})
  end
end
