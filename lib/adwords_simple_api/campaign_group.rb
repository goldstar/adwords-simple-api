module AdwordsSimpleApi
  class CampaignGroup < Base
    attributes :id, :name, :status
    service :campaign_group_service

    has_status :enabled, :removed

    def campaigns
      @campaigns ||= Campaign.get({ field: id_field_str, operator: 'EQUALS',  values: [id] })
    end

  end
end
