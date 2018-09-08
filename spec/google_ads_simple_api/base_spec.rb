module GoogleAdsSimpleApi
  RSpec.describe Base do

    class CampaignBalloon < Base
    end

    let(:example_class) { CampaignBalloon }
    let(:example_instance) { CampaignBalloon.new({}) }

    describe ".id_key" do
      it { expect(example_class.id_key).to eq(:campaign_balloon_id) }
    end

    describe ".id_field" do
      it { expect(example_class.id_field).to eq('CampaignBalloonId') }
    end
  end
end
