module AdwordsSimpleApi
  RSpec.describe AdGroup do
    let(:described_class_attributes){ attributes_for(:ad_group) }

    it_behaves_like "it has base finders"
    it_behaves_like "it belongs to", Campaign, :campaign
    it_behaves_like "it has status", [:enabled, :paused, :removed]
    it_behaves_like "it has many", ExpandedTextAd, :expanded_text_ads, :expanded_text_ad
    # it_behaves_like "it has labels"

  end
end
