FactoryBot.define do
  factory :feed, class: AdwordsSimpleApi::Feed do
    sequence :id
    sequence :name do |n|
      "Feed n"
    end
    status 'ENABLED'
    schema [
              {:id=>1, :name=>"our_price", :type=>"STRING", :is_part_of_key=>false},
              {:id=>2, :name=>"full_price", :type=>"STRING", :is_part_of_key=>false},
              {:id=>3, :name=>"percent_off", :type=>"INT64", :is_part_of_key=>false}
            ]
    origin 'USER'
  end
end
