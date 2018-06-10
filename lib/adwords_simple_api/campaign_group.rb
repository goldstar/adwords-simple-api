module AdwordsSimpleApi
  class CampaignGroup < Base
    attributes :id, :name, :status
    service :campaign_group_service

    def enabled?
      attributes[:status] == 'ENABLED'
    end

    def campaigns
      @campaigns ||= Campaign.get({ field: id_field_str, operator: 'EQUALS',  values: [id] })
    end

  end
end
