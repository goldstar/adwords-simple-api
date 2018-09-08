module GoogleAdsSimpleApi
  class Label < Base
    service :label_service

    attribute :name, field: :label_name
    attribute :status, field: :label_status

    has_status :enabled, :removed

    def campaigns
      @campaigns ||= Campaign.get({ field: 'Labels', operator: 'CONTAINS_ANY',  values: [id] })
    end

    def ad_groups
      @ad_groups ||= AdGroup.get({ field: 'Labels', operator: 'CONTAINS_ANY',  values: [id] })
    end

  end
end
