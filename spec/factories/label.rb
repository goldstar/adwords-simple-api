FactoryBot.define do
  factory :label, class: GoogleAdsSimpleApi::Label do
    sequence :id
    sequence :name do |n|
      "Label n"
    end
    status 'ENABLED'
  end
end
