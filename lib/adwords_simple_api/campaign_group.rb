module AdwordsSimpleApi
  class CampaignGroup < Base
    attributes :id, :name, :status
    has_status :enabled, :removed
    has_many(campaigns: AdwordsSimpleApi::Campaign)
  end
end
