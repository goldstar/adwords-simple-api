RSpec.describe GoogleAdsSimpleApi::Reports::CampaignPerformanceReport do
  describe "report" do
    let(:report_utils){ instance_double("report_utils") }
    let(:adwords){
      instance_double("adwords",
          'skip_report_header=': true,
          'skip_column_header=': true,
          'skip_report_summary=': true,
          'include_zero_impressions=': true,
          'report_utils': report_utils
        )
    }
    before :each do
      allow(GoogleAdsSimpleApi).to receive(:adwords).and_return(adwords)
      allow(report_utils).to receive(:download_report).with(report.report_definition, nil).and_return(csv_string)
    end

    let(:report){
      described_class.new
    }
    let(:csv_string){
      [
        "Campaign ID,Campaign,Campaign state,Campaign Group ID,Tracking template,Custom parameter,Start date,Impressions,Clicks,Conversions,Cost,Labels",
        "1837091,z_s_geo_socal_5,paused,0, --,\"{\"\"campaign\"\":\"\"socal_5\"\",\"\"type\"\":\"\"entertainment\"\"}\",2003-04-04,1,2,3.00,400000,\"[\"\"Search\"\",\"\"Non-Brand\"\",\"\"Entertainment\"\"]\"",
        "2059431,z_s_geo_norcal_2,paused,0, --,\"{\"\"campaign\"\":\"\"norcal_2\"\",\"\"type\"\":\"\"entertainment\"\"}\",2003-06-17,0,0,0.00,0,\"[\"\"Search\"\",\"\"Non-Brand\"\",\"\"Entertainment\"\"]\""
      ].join("\n")
    }
    let(:result){ report.to_a.first }

    describe "perform" do
      it "should return an array" do
        expect(report.to_a).to be_an(Array)
      end
    end

    describe "a result" do
      it "should transfrom the values from strings" do
        expect(result[:campaign_id]).to eq(1837091)
        expect(result[:campaign]).to eq('z_s_geo_socal_5')
        expect(result[:campaign_group_id]).to eq(0)
        expect(result[:tracking_template]).to eq(' --')
        expect(result[:custom_parameter]).to be_a(Hash)
        expect(result[:start_date]).to eq(Date.new(2003,4,4))
        expect(result[:impressions]).to eq(1)
        expect(result[:clicks]).to eq(2)
        expect(result[:conversions]).to eq(3)
        expect(result[:cost]).to eq(0.4)
        expect(result[:labels]).to be_a(Array)
      end
    end
  end
end
