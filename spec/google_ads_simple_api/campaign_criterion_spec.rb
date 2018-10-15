module GoogleAdsSimpleApi
  RSpec.describe CampaignCriterion do
    let(:described_class_attributes){ attributes_for(:campaign_criterion) }

    it_behaves_like "it has base finders", find_by: :campaign_id
    it_behaves_like "it has base mutators"
    it_behaves_like "it belongs to", Campaign, :campaign
    it_behaves_like "it has status", [:active, :removed, :paused]
  end
end
