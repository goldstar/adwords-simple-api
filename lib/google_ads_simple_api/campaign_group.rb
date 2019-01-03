module GoogleAdsSimpleApi
  class CampaignGroup < Base
    attributes :name
    status_attribute :status, states: [:enabled, :removed]
    has_many(campaigns: 'Campaign')
  end
end
