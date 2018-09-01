FactoryBot.define do
  factory :expanded_text_ad, class: GoogleAdsSimpleApi::ExpandedTextAd do
    sequence :id
    headline_part1 "Come one, come all"
    headline_part2 "The greatest show on earth"
    description "witness all the circus has to offer"
    path1 "greatest-show"
    path2 "tickets"
    creative_final_urls ["https://www.example.com"]
  end
end
