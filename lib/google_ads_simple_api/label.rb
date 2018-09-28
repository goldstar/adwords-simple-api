module GoogleAdsSimpleApi
  class Label < Base
    service :label_service

    attribute :id, field: :label_id, key: :id
    attribute :name, field: :label_name
    status_attribute :status, states: [:enabled, :removed], field: :label_status

    def campaigns
      @campaigns ||= Campaign.get({ field: 'Labels', operator: 'CONTAINS_ANY',  values: [id] })
    end

    def ad_groups
      @ad_groups ||= AdGroup.get({ field: 'Labels', operator: 'CONTAINS_ANY',  values: [id] })
    end

  end
end
