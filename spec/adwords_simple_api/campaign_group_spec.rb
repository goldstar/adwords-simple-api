module AdwordsSimpleApi
  RSpec.describe CampaignGroup do
    let(:campaign_group_service){ AdwordsSimpleApi.adwords.service(:campaign_group_service) }

    let(:campaign_group_attributes){
      {
        id: 1,
        name: 'great group',
        status: 'ENABLED'
      }
    }
    let(:campaign_attributes){
      {
        id: 12,
        name: 'great campaign',
        status: 'ENABLED'
      }
    }

    it "should have fields" do
      expect(described_class.fields).to_not be_empty
    end

    describe ".all" do
      before do
        allow(campaign_group_service).to receive(:get).with({ fields: described_class.field_names }).and_return(
          entries: [ campaign_group_attributes ]
        )
      end

      let(:results){ described_class.all }

      it "should return an array of CampaignGroups" do
        expect(results).to be_an(Array)
        expect(results.first).to be_a(described_class)
      end
    end

    describe ".find_by" do
      before do
        allow(campaign_group_service).to receive(:get).with(
          hash_including(
            predicates: [{field: 'Name', operator: 'EQUALS', values: [campaign_group_attributes[:name]]}]
          )
        ).and_return(entries: [campaign_group_attributes])
      end

      let(:campaign_group) { described_class.find_by(name: campaign_group_attributes[:name]) }
      it "should return a CampaignGroup object" do
        expect(campaign_group).to be_a(described_class)
      end

      it "should have attributes" do
        expect(campaign_group).to have_attributes(campaign_group_attributes)
      end
    end

    describe ".find" do
      it "should find by id" do
        expect(described_class).to receive(:find_by).with(id: 1).and_return(nil)
        described_class.find(1)
      end
    end

    describe "#campaigns" do
      let(:campaign){ Campaign.new(campaign_attributes) }
      let(:campaign_group) { CampaignGroup.new(campaign_group_attributes) }
      before do
        allow(Campaign.service).to receive(:get).with(
          hash_including(
            predicates:
              [{ field: 'CampaignGroupId', operator: 'EQUALS',  values: [campaign_group.id] }]
          )
        ).and_return(entries: [campaign_attributes])
      end

      it "should get campaigns" do
        expect(campaign_group.campaigns).to eq([campaign])
      end
    end

  end
end
