module AdwordsSimpleApi
  RSpec.describe ExpandedTextAd do
    let(:described_class_attributes){ attributes_for(:expanded_text_ad) }

    it_behaves_like "it belongs to", AdGroup, :ad_group
  end
end
