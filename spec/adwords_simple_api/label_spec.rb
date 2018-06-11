module AdwordsSimpleApi
  RSpec.describe Label do
    let(:described_class_attributes){ attributes_for(:label) }

    it_behaves_like "it has base finders"
    # it_behaves_like "it has many", Campaign, :campaigns, :campaign
    it_behaves_like "it has status", [:enabled, :removed]

  end
end
