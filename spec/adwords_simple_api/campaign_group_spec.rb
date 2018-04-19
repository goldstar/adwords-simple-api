RSpec.describe AdwordsSimpleApi::CampaignGroup do
  let(:campaign_group_service){ instance_double("campaign_group_service") }
  let(:adwords){
    instance_double("adwords",
        'skip_report_header=': true,
        'skip_column_header=': true,
        'skip_report_summary=': true,
        'include_zero_impressions=': true
      )
  }
  let(:service){
    instance_double("service")
  }
  before :each do
    allow(AdwordsSimpleApi).to receive(:adwords).and_return(adwords)
    allow(adwords).to receive(:service).with(:CampaignGroupService, AdwordsSimpleApi::API_VERSION).and_return(service)
  end

  it "should have fields" do
    expect(described_class.fields).to_not be_empty
  end

  describe "all" do
    before do
      expect(service).to receive(:get).with({ fields: described_class.fields }).and_return(
        entries: [
          {
            id: 1,
            name: 'great group',
            status: 'ENABLED'
          }
        ]
      )
    end

    let(:results){ described_class.all }

    it "should return an array of CampaignGroups" do
      expect(results).to be_an(Array)
      expect(results.first).to be_a(described_class)
    end

  end
end
