module AdwordsSimpleApi
  class AdGroup < Base
    service :ad_group_service
    attributes :id, :campaign_id, :campaign_name, :name, :status,
     :settings, :base_campaign_id, :base_ad_group_id, :ad_group_type
    has_many(labels: AdwordsSimpleApi::Label)

    # default_predicates [{field; 'Status', operator: 'EQUALS', values: ['ENABLED','PAUSED']}]
    has_status :enabled, :paused, :removed

    def expanded_text_ads
      @expanded_text_ads ||= ExpandedTextAd.for_ad_group(id)
    end

    def campaign
      @campaign ||= Campaign.find(attributes[:campaign_id])
    end

  end
end
