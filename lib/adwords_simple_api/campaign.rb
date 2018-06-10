module AdwordsSimpleApi
  class Campaign < Base
    service :campaign_service
    attributes :id, :campaign_group_id, :name, :status, :serving_status, :start_date,
     :end_date, :ad_serving_optimization_status, :settings, :advertising_channel_type,
     :campaign_trial_type, :base_campaign_id, :url_custom_parameters
    has_many(labels: AdwordsSimpleApi::Label)

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

    def final_urls
      expanded_text_ads.flat_map{|ad| ad.final_urls }.uniq
    end

    def ad_groups
      @ad_groups ||= AdGroup.for_campaign(id)
    end

    def expanded_text_ads
      @expanded_text_ads ||= ExpandedTextAd.for_campaign(id)
    end

    def campaign_group
      @campaign_group ||= CampaignGroup.find(attributes[:campaign_group_id])
    end

  end
end
