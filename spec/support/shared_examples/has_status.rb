module AdwordsSimpleApi
  RSpec.shared_examples "it has status" do |statuses|
    statuses.each do |status|
      has_status = "#{status}?"
      change_status = status.to_s.gsub(/d$/,"!")
      status = status.to_s.upcase

      let(:subject) { described_class.new(described_class_attributes.merge(status: 'UNKNOWN')) }

      describe "##{change_status} & ##{has_status}" do
        before do
          allow(subject.class.service).to receive(:mutate).with(
            [{:operator=>"SET", :operand=>{:status=>status, :id=>subject.id}}]
          ).and_return(
            {value: [described_class_attributes.merge(status: status)]}
          )
        end
        let(:instance_with_status) { described_class.new(described_class_attributes.merge(status: 'UNKNOWN')) }
        it "should change the status" do
          expect{ subject.send(change_status) }.to change{ subject.send(has_status) }.from(false).to(true)
        end
      end
    end
  end
end
