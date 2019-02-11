module GoogleAdsSimpleApi
  class Budget < Base
    attribute :id, field: :budget_id, key: :budget_id, no_getter: true
    attribute :name, field: :budget_name
    attribute :is_explicitly_shared, field: :is_budget_explicitly_shared
    attributes :amount, :delivery_method
    status_attribute :status, states: [:enabled, :removed], field: :budget_status

    # has_many(campaigns: 'Campaign')

    def id
      attributes[:budget_id]
    end
  end
end
