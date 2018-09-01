module GoogleAdsSimpleApi
  class CampaignGroup < Base
    attributes :id, :name, :status
    has_status :enabled, :removed
    has_many(campaigns: GoogleAdsSimpleApi::Campaign)
  end
end
