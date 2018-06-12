module AdwordsSimpleApi
  RSpec.describe Campaign do
    let(:described_class_attributes){ attributes_for(:campaign) }

    it_behaves_like "it has base finders"
    # it_behaves_like "it belongs to", :campaign_group
    it_behaves_like "it has status", [:enabled, :paused, :removed]
    it_behaves_like "it has many", AdGroup, :ad_groups, :ad_group
    # it_behaves_like "it has many", :expanded_text_ads
    # it_behaves_like "it has labels"

    describe "#final_urls" do
      it "gets the unique final urls from the expanded text ads"
    end
  end
end
