module AdwordsSimpleApi
  class CampaignGroup < Base
    attributes :id, :name, :status
    has_status :enabled, :removed

    def campaigns
      @campaigns ||= Campaign.all(id_field_sym => id)
    end

  end
end
