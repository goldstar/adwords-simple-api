module AdwordsSimpleApi
  class Campaign < Base
    attr_reader :attributes, :id

    # {
    #   :id=>929051657,
    #   :name=>"s_venues_atlanta",
    #   :status=>"ENABLED",
    #   :serving_status=>"SERVING",
    #   :start_date=>"20170913",
    #   :end_date=>"20371230",
    #   :budget=>{
    #     :budget_id=>1208907545,
    #     :name=>"s_venues_atlanta",
    #     :amount=>{
    #       :comparable_value_type=>"Money", :micro_amount=>300000000
    #     },
    #     :delivery_method=>"STANDARD",
    #     :is_explicitly_shared=>false, :status=>"ENABLED"
    #   },
    #   :conversion_optimizer_eligibility=>{
    #     :eligible=>true
    #   },
    #   :ad_serving_optimization_status=>"OPTIMIZE",
    #   :settings=>[
    #     {:setting_type=>"GeoTargetTypeSetting", :positive_geo_target_type=>"DONT_CARE", :negative_geo_target_type=>"DONT_CARE", :xsi_type=>"GeoTargetTypeSetting"},
    #     {:setting_type=>"TargetingSetting", :details=>[{:criterion_type_group=>"USER_INTEREST_AND_LIST", :target_all=>true}], :xsi_type=>"TargetingSetting"}
    #   ],
    #   :advertising_channel_type=>"SEARCH",
    #   :network_setting=>{
    #     :target_google_search=>true,
    #     :target_search_network=>true,
    #     :target_content_network=>false,
    #     :target_partner_search_network=>false
    #   },
    #   :labels=>[
    #     {:id=>2110792870, :name=>"Non-Brand", :status=>"ENABLED", :attribute=>{:label_attribute_type=>"DisplayAttribute", :background_color=>"#8000ff", :description=>"", :xsi_type=>"DisplayAttribute"}, :label_type=>"TextLabel", :xsi_type=>"TextLabel"},
    #     {:id=>1869572067, :name=>"Venue", :status=>"ENABLED", :attribute=>{:label_attribute_type=>"DisplayAttribute", :background_color=>"#FFFF00", :description=>"", :xsi_type=>"DisplayAttribute"}, :label_type=>"TextLabel", :xsi_type=>"TextLabel"}
    #   ],
    #   :bidding_strategy_configuration=>{
    #     :bidding_strategy_type=>"TARGET_CPA",
    #     :bidding_scheme=>{
    #       :bidding_scheme_type=>"TargetCpaBiddingScheme",
    #       :target_cpa=>{
    #         :comparable_value_type=>"Money", :micro_amount=>3750000
    #       },
    #       :xsi_type=>"TargetCpaBiddingScheme"
    #     }
    #   },
    #   :campaign_trial_type=>"BASE",
    #   :base_campaign_id=>929051657,
    #   :url_custom_parameters=>{
    #     :parameters=>[
    #       {:key=>"campaign", :value=>"atlanta", :is_remove=>false},
    #       {:key=>"type", :value=>"venue", :is_remove=>false}
    #     ],
    #     :do_replace=>false
    #   }
    # }



    FIELDS = ['CampaignId', 'Status', 'CampaignName', 'Labels', 'TrackingUrlTemplate']

    def initialize(hash)
      @attributes = hash
      @id = hash[:id] or raise "Must initialize with at least an id"
    end

    def paused?
      attributes[:status] == 'PAUSED'
    end

    def enabled?
      attributes[:status] == 'ENABLED'
    end

    def pause!
      set(status: 'PAUSED')
    end

    def enable!
      set(status: 'ENABLED')
    end

    def set(hash)
      operation = { :operator => 'SET', :operand => hash.merge(id: id) }
      response = campaign_service.mutate([operation])
      if response && response[:value]
        @attributes = response[:value].first
      else
        raise 'No campaigns were updated.'
      end
    end

    def self.get(campaign_ids)
      response = campaign_service.get(
        fields: FIELDS,
        predicates: [
          { field: 'CampaignId', operator: 'EQUALS',  values: Array(campaign_ids) },
        ]
      )
      if response && response[:entries]
        Array(response[:entries])
      else
        []
      end
    end

    def self.find(campaign_id)
      attributes = get(campaign_id).first
      if attributes
        return self.new(attributes)
      else
        raise "No campaign found"
      end
    end

    def final_urls
      expanded_text_ads.flat_map{|ad| ad.final_urls }.uniq
    end

    def expanded_text_ads
      expanded_text_ads ||= ExpandedTextAd.for_campaign(id)
    end

  end
end
