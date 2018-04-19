module AdwordsSimpleApi
  class CampaignGroup < Base
    attr_reader :attributes, :id
    fields 'Id', 'Name', 'Status'
    service :CampaignGroupService

    def enabled?
      attributes[:status] == 'ENABLED'
    end

    def campaigns
      @campaigns ||= Campaign.get({ field: 'CampaignGroupId', operator: 'EQUALS',  values: [id] })
    end

  end
end
