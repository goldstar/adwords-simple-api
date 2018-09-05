module GoogleAdsSimpleApi
  class Label < Base
    service :label_service
    attributes :id, :name, :status
    attribute_field_names id: :label_id, name: :label_name, status: :label_status

    has_status :enabled, :removed

    def campaigns
      @campaigns ||= Campaign.get({ field: 'Labels', operator: 'CONTAINS_ANY',  values: [id] })
    end

    def ad_groups
      @ad_groups ||= AdGroup.get({ field: 'Labels', operator: 'CONTAINS_ANY',  values: [id] })
    end

  end
end
