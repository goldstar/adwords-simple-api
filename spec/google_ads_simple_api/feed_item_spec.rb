module GoogleAdsSimpleApi
  RSpec.describe FeedItem do
    let(:described_class_attributes){ attributes_for(:feed_item) }

    it_behaves_like "it has base finders", find_by: :feed_id
    it_behaves_like "it has base mutators"
    it_behaves_like "it has status", [:enabled, :removed]
    it_behaves_like "it belongs to", Feed, :feed

    let(:schema) {
      [{:id=>1, :name=>"event_id", :type=>"INT64", :is_part_of_key=>true},
       {:id=>2, :name=>"our_price", :type=>"PRICE", :is_part_of_key=>false},
       {:id=>3, :name=>"percent_off", :type=>"INT64", :is_part_of_key=>false}]
    }
    let(:feed){ Feed.new(attributes: schema ) }
    let(:item) { described_class.new(feed_id: 1, attribute_values: [
      {:feed_attribute_id=>1, :integer_value=>1},
      {:feed_attribute_id=>2, :money_with_currency_value=>{:comparable_value_type=>"MoneyWithCurrency", :money=>{:comparable_value_type=>"Money", :micro_amount=>11000000000}, :currency_code=>"USD"}},
      {:feed_attribute_id=>3, :integer_value=>5}])
    }

    before do
      allow(item).to receive(:feed).and_return(feed)
    end

    describe ".to_hash" do
      it "should transform the item attribute values into a simple hash" do
        expect(item.to_hash).to eq({"event_id"=>1, "our_price"=>11.0, "percent_off"=>5})
      end
    end

    describe "#attribute_values_for" do
      let(:new_values){
        {"event_id"=>2, "our_price"=>13.0, "percent_off"=>70}
      }
      it "should return an array of attribute values" do
        expect(described_class.attribute_values_for(feed,new_values)).to eq(
          [
            {:feed_attribute_id=>1, :integer_value=>2},
            {:feed_attribute_id=>2, :money_with_currency_value=>{:comparable_value_type=>"MoneyWithCurrency", :money=>{:comparable_value_type=>"Money", :micro_amount=>13000000000}, :currency_code=>"USD"}},
            {:feed_attribute_id=>3, :integer_value=>70}]
        )
      end
    end

  end
end
