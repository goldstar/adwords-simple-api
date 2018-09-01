module GoogleAdsSimpleApi
  RSpec.shared_examples "it has base mutators" do
    describe ".create!" do
      before do
        allow(described_class.service).to receive(:mutate).
          with([operator: 'ADD', operand: described_class_attributes]).
          and_return(value: [described_class_attributes])
      end

      let(:subject) { described_class.create!(described_class_attributes) }

      it "should return an class instance" do
        expect(subject).to be_a(described_class)
      end

      it "should have attributes" do
        expect(subject.attributes).to eq(described_class_attributes)
      end
    end

    describe ".add" do
      before do
        expect(described_class.service).to receive(:mutate).
          with([operator: 'ADD', operand: described_class_attributes]).
          and_return(value: [described_class_attributes])
      end
      it "should call mutate" do
        described_class.add(described_class_attributes)
      end
      it "should return a value array" do
        expect(described_class.add(described_class_attributes)).to eq([described_class_attributes])
      end
    end

    describe ".set" do
      let(:id) { described_class_attributes[:id] }
      let(:mutated_attributes) { {name: 'new name'} }
      before do
        id_field = described_class.attribute_name(:id)
        expect(described_class.service).to receive(:mutate).
          with([operator: 'SET', operand: mutated_attributes.merge({id_field => id})]).
          and_return(value: [described_class_attributes])
      end
      it "should return the new attributes" do
        expect(described_class.set(id, mutated_attributes)).to eq([described_class_attributes])
      end

      it "should call mutate" do
        described_class.set(id, mutated_attributes)
      end
    end

    describe "#set" do
      let(:changes){ { name: 'new name'} }
      let(:subject){ described_class.new(described_class_attributes)}
      let(:changed_attributes){ described_class_attributes.merge(changes) }

      before do
        id_field = subject.attribute_name(:id)
        expect(described_class.service).to receive(:mutate).
          with([operator: 'SET', operand: changes.merge(id_field => subject.id)]).
          and_return(value: [changed_attributes])
      end
      it "should call mutate" do
        subject.set(changes)
      end

      it "should update the attributes" do
        subject.set(changes)
        expect(subject.attributes).to eq(changed_attributes)
      end
    end
  end
end
