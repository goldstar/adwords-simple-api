FactoryBot.define do
  factory :campaign, class: AdwordsSimpleApi::Campaign do
    sequence :id
    sequence :name do |n|
      "Camapign n"
    end
    status 'ENABLED'
  end
end
