FactoryBot.define do
  factory :budget, class: GoogleAdsSimpleApi::Budget do
    sequence :id
    sequence :name do |n|
      "Budget n"
    end
    status 'ENABLED'
    delivery_method 'STANDARD'
    amount({ micro_amount: 5_000_000 })
  end
end
