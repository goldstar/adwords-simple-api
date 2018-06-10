module AdwordsSimpleApi
  RSpec.describe Base do

    class CampaignBalloon < Base
    end

    let(:example_class) { CampaignBalloon }
    let(:example_instance) { CampaignBalloon.new({}) }

    describe ".id_field_sym" do
      it { expect(example_class.id_field_sym).to eq(:campaign_balloon_id) }
    end

    describe ".id_field_str" do
      it { expect(example_class.id_field_str).to eq('CampaignBalloonId') }
    end
  end
end
