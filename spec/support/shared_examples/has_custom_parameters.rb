module AdwordsSimpleApi
  RSpec.shared_examples "it has custom parameters" do |attribute|
    describe "##{attribute}" do
      let(:described_class_instance) { described_class.new(described_class_attributes) }

      subject{ described_class_instance.send(attribute) }

      it "should return a CustomParameters object" do
        expect(subject).to be_a(CustomParameters)
      end

      it "should have the owner and name set" do
        expect(subject.owner).to eq(described_class_instance)
        expect(subject.attribute_name).to eq(attribute)
      end

    end
  end

end
