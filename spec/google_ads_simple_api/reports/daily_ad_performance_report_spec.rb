RSpec.describe GoogleAdsSimpleApi::Reports::DailyAdPerformanceReport do
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
      <<END_OF_STRING
      Ad ID,Day,Ad group ID,Ad group,Ad group state,Campaign ID,Campaign,Campaign state,Impressions,Clicks,Conversions,Cost,Final URL,Headline 1,Headline 2,Path 1,Path 2,Description
265003130151,2018-05-16,48622916109,Gardens Discount,enabled,993020526,s_events_gilroy_gardens,enabled,4,2,1.00,570000,"[""https://www.goldstar.com/events/gilroy-ca/gilroy-gardens-family-theme-park""]",Gilroy Gardens Theme Park Deal,Save up to 48% on Admission, --, --,Buy & save on tickets to Gilroy Gardens Family Theme Park at Goldstar.
256666482414,2018-05-16,46009106306,Statue of Liberty Tour - end 1.13.2018,enabled,929119574,s_events_tours_annie_moore_tours,enabled,135,1,0.00,100000,"[""https://www.goldstar.com/events/new-york-ny/statue-of-liberty-and-ellis-island-tour-tickets""]",{KeyWord:Statue of Liberty Tour},Tickets On Sale Now, --, --,"Find the Best Deals on Sightseeing Tours, Activities & Must-See Attractions."
256906545796,2018-05-16,52087738451,The Media Theatre - end 10.22.17,enabled,929051714,s_venues_philadelphia,enabled,2,0,0.00,0,"[""https://www.goldstar.com/venues/media-pa/the-media-theatre-tickets""]",{KeyWord:The Media Theatre},Tickets & Event Schedules, --, --,See All Upcoming Events {KeyWord:at this Venue on Goldstar}. Book Your Ticket Today!
END_OF_STRING
    }
    let(:result){ report.to_a.first }

    describe "perform" do
      it "should return an array" do
        expect(report.to_a).to be_an(Array)
      end
    end

    describe "a result" do
      it "should transfrom the values from strings" do
        expect(result).to eq(
          {ad_id: 265003130151,
          day: Date.new(2018,5,16),
          ad_group_id: 48622916109,
          ad_group: "Gardens Discount",
          ad_group_state: "enabled",
          campaign_id: 993020526,
          campaign: "s_events_gilroy_gardens",
          campaign_state: "enabled",
          impressions: 4,
          clicks: 2,
          conversions: 1.0,
          cost: 0.57,
          final_url: ["https://www.goldstar.com/events/gilroy-ca/gilroy-gardens-family-theme-park"],
          headline_1: "Gilroy Gardens Theme Park Deal",
          headline_2: "Save up to 48% on Admission",
          path_1: nil,
          path_2: nil,
          description: "Buy & save on tickets to Gilroy Gardens Family Theme Park at Goldstar."
        })
      end
    end
  end
end
