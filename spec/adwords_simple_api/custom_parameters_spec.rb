module AdwordsSimpleApi
  RSpec.describe CustomParameters do
    let(:parameters){
      [{key: 'gold',  value: 'star', is_remove: false}]
    }
    let(:attribute_data){ { parameters: parameters, do_replace: false} }
    let(:owner_attributes){ { name => attribute_data } }
    let(:name){ 'some_custom_parameters'}
    let(:owner){ double(:owner, attributes: owner_attributes) }
    let(:subject){ described_class.new(owner, name) }

    describe "#attribute_data" do
      context "with existign customer parameters" do
        it "should get the data from the owner" do
          expect(subject.attribute_data).to eq(attribute_data)
        end
      end
      context "with nil data" do
        let(:attribute_data){ nil }
        it "shoud return a default structure" do
          expect(subject.attribute_data).to eq({parameters: [], do_replace: false })
        end
      end
    end

    describe "#store" do
      context "nil value" do
        it "should update the flag the parameter as removed" do
          expect{ subject.store(:gold, nil) }.to change{ subject.attribute_data[:parameters] }.
            from( [{key: 'gold', value: 'star', is_remove: false}]).
            to(   [{key: 'gold', is_remove: true}]  )
        end
        it "should update the changed flag" do
          expect{ subject.store(:gold, nil) }.to change{ subject.changed? }.from(false).to(true)
        end
      end
      context "adding key" do
        it "should add a new parameter" do
          expect{ subject.store(:foo, 'bar') }.to change{ subject.attribute_data[:parameters] }.
            from( [{key: 'gold', value: 'star', is_remove: false}]).
            to(   [{key: 'gold', value: 'star', is_remove: false},{key: 'foo',   value: 'bar',  is_remove: false}]  )
        end
        it "should update the changed flag" do
          expect{  subject.store(:foo, 'bar') }.to change{ subject.changed? }.from(false).to(true)
        end
      end

      context "updating key" do
        it "should update the paramter" do
          expect{ subject.store(:gold, 'mine') }.to change{ subject.attribute_data[:parameters] }.
            from( [{key: 'gold', value: 'star', is_remove: false}]).
            to(   [{key: 'gold', value: 'mine', is_remove: false}]  )
        end
        it "should update the changed flag" do
          expect{  subject.store(:gold, 'mine') }.to change{ subject.changed? }.from(false).to(true)
        end
      end
    end

    describe "#fetch" do
      it "should return the current value" do
        expect(subject[:gold]).to eq('star')
      end
      it "should return nil if flagged for deletion" do
        expect(subject[:foo]).to eq(nil) # is_remove is true
      end
    end
    describe "#delete" do
      it "should return the original value" do
        expect(subject.delete(:gold)).to eq('star')
      end
      it "should all store nil" do
        expect(subject).to receive(:store).with(:gold, nil)
        subject.delete(:gold)
      end
    end
    describe "#save" do
      context "with no changes" do
        it "should not call set on the owner" do
          expect(owner).to_not receive(:set)
          subject.save
        end
        it "should return true" do
          expect(subject.save).to eq(true)
        end
      end
      context "with changes" do
        before do
          subject[:new] = 'true'
        end
        it "should call set on the owner" do
          expect(owner).to receive(:set).with({ name => subject.attribute_data})
          subject.save
        end
      end
    end
    describe "#to_hash" do
      it "should return just a with non-removed key values" do
        expect(subject.to_hash).to eq({gold: 'star'})
      end
    end
  end
end
