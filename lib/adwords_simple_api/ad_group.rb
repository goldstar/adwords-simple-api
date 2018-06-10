module AdwordsSimpleApi
  class AdGroup < Base
    service :ad_group_service
    attributes :id, :campaign_id, :campaign_name, :name, :status,
     :settings, :base_campaign_id, :base_ad_group_id, :ad_group_type
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

    def expanded_text_ads
      @expanded_text_ads ||= ExpandedTextAd.for_ad_group(id)
    end

    def campaign
      @campaign ||= Campaign.find(attributes[:campaign_id])
    end

    def self.for_campaign(campaign_id)
      response = service.get(
        fields: fields,
        predicates: [
          { field: 'CampaignId',     operator: 'IN',   values: [campaign_id] },
          { field: 'AdGroupStatus', operator: 'IN',   values: ['ENABLED','PAUSED'] },
          { field: 'Status',        operator: 'IN',   values: ['ENABLED','PAUSED'] }
        ]
      )
      if response && response[:entries]
        return Array(response[:entries]).map{|hash| self.new(hash) }
      else
        return []
      end
    end

  end
end
