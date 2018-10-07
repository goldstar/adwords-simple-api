module GoogleAdsSimpleApi
  RSpec.describe Budget do
    let(:described_class_attributes){ attributes_for(:budget) }

    it_behaves_like "it has base finders"
    it_behaves_like "it has base mutators"
    # it_behaves_like "it has many", Campaign, :campaigns, :campaign
    it_behaves_like "it has status", [:enabled, :removed]

  end
end
