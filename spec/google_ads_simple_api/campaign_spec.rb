module GoogleAdsSimpleApi
  RSpec.describe Campaign do
    let(:described_class_attributes){ attributes_for(:campaign) }

    it_behaves_like "it has base finders"
    it_behaves_like "it has base mutators"
    it_behaves_like "it belongs to", CampaignGroup, :campaign_group
    it_behaves_like "it belongs to", Budget, :budget, 'BudgetId', 1
    it_behaves_like "it has status", [:enabled, :paused, :removed]
    it_behaves_like "it has many", AdGroup, :ad_groups, :ad_group
    # it_behaves_like "it has many", :expanded_text_ads
    # it_behaves_like "it has labels"
    it_behaves_like "it has custom parameters", :url_custom_parameters

    describe "#final_urls" do
      it "gets the unique final urls from the expanded text ads"
    end

    describe "eager loading" do
      let(:campaign1) { attributes_for(:campaign) }
      let(:campaign2) { attributes_for(:campaign) }
      let(:ad_groups_1) { attributes_for_list(:ad_group, 3, campaign_id: campaign1[:id]) }
      let(:ad_groups_2) { attributes_for_list(:ad_group, 2, campaign_id: campaign2[:id]) }
      let(:campaign_ids) { [campaign1[:id], campaign2[:id]] }

      context "with 1 get load 2 campaigns and with a 2nd get load their ad_groups" do
        before do
          allow(described_class.service).to receive(:get).with(
            hash_including(
              predicates: [{field: 'Id', operator: 'IN', values: campaign_ids}]
            )
          ).and_return(
            entries: [ campaign1, campaign2 ]
          )

          allow(AdGroup.service).to receive(:get).with(
            hash_including(
              predicates: [{field: 'CampaignId', operator: 'IN', values: campaign_ids}]
            )
          ).and_return(
            entries: ad_groups_1 + ad_groups_2
          )
        end

        let(:results){
          described_class.all(id: campaign_ids, includes: :ad_groups)
        }

        it "should have loaded the ad groups for both campaigns" do
          expect(results[0].ad_groups.count).to eq(ad_groups_1.count)
          expect(results[1].ad_groups.count).to eq(ad_groups_2.count)
        end

        it "should have eager loaded the campaign onto the adgroups as well" do
          expect(results[0].ad_groups.first.campaign).to eq(results[0])
          expect(results[1].ad_groups.first.campaign).to eq(results[1])
        end
      end

    end
  end
end
