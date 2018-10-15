module GoogleAdsSimpleApi
  RSpec.shared_examples "it belongs to" do |klass, singular, field, value|
    describe "##{singular}" do
      let(:attributes){ attributes_for(singular) }
      let(:described_class_instance) {
        described_class.new(described_class_attributes.merge(foreign_key => value || attributes[:id]))
      }
      let(:foreign_key){ "#{singular}_id".to_sym }
      let(:owner_instance) { klass.new(attributes) }
      before do
        allow(klass.service).to receive(:get).with(
          hash_including(
            predicates:
              [{ field: (field || 'Id'), operator: 'IN',  values: [described_class_instance.send(foreign_key)] }]
          )
        ).and_return(entries: [attributes])
      end

      it "should get #{singular}" do
        expect(described_class_instance.send(singular)).to eq(owner_instance)
      end
    end
  end

end
