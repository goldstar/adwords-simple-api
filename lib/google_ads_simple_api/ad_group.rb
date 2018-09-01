require 'google_ads_simple_api/concerns/has_labels'

module GoogleAdsSimpleApi
  class AdGroup < Base
    include HasLabels
    has_many(expanded_text_ads: GoogleAdsSimpleApi::ExpandedTextAd)
    belongs_to(:campaign)

    attributes :id, :name, :status, :settings, :base_ad_group_id, :ad_group_type

    # TO-DO: CampaignStatus IN ['ENABLED', PAUSED]
    # It already uses default predicates for status
    # default_predicates [{field; 'Status', operator: 'IN', values: ['ENABLED','PAUSED']}]
    has_status :enabled, :paused, :removed
    has_custom_parameters :url_custom_parameters

  end
end
