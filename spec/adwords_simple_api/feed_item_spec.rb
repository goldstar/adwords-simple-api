module AdwordsSimpleApi
  RSpec.describe FeedItem do
    let(:described_class_attributes){ attributes_for(:feed_item) }

    it_behaves_like "it has base finders", find_by: :feed_id
    it_behaves_like "it has base mutators"
    it_behaves_like "it has status", [:enabled, :removed]
    it_behaves_like "it belongs to", Feed, :feed

  end
end
