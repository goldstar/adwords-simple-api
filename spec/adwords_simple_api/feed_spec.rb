module AdwordsSimpleApi
  RSpec.describe Feed do
    let(:described_class_attributes){ attributes_for(:feed) }

    it_behaves_like "it has base finders"
    it_behaves_like "it has base mutators"
    it_behaves_like "it has status", [:enabled, :removed]
    # it_behaves_like "it has many", FeedItem, :feed_items, :feed_item

  end
end
