module AdwordsSimpleApi
  RSpec.shared_examples "it has many" do |klass, plural, singular|
    describe "#campaigns" do
      let(:attributes){ attributes_for(singular) }
      let(:owned_instance){ klass.new(attributes) }
      let(:described_class_instance) { described_class.new(described_class_attributes) }
      before do
        allow(klass.service).to receive(:get).with(
          hash_including(
            predicates:
              [{ field: described_class.id_field_str, operator: 'EQUALS',  values: [described_class_instance.id] }]
          )
        ).and_return(entries: [attributes])
      end

      it "should get #{plural}" do
        expect(described_class_instance.send(plural)).to eq([owned_instance])
      end
    end
  end

end
