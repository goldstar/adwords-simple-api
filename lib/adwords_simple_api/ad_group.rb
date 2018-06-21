require 'adwords_simple_api/concerns/has_labels'

module AdwordsSimpleApi
  class AdGroup < Base
    include HasLabels
    has_many(expanded_text_ads: AdwordsSimpleApi::ExpandedTextAd)
    belongs_to(:campaign)

    attributes :id, :name, :status, :settings, :base_ad_group_id, :ad_group_type

    # default_predicates [{field; 'Status', operator: 'IN', values: ['ENABLED','PAUSED']}]
    has_status :enabled, :paused, :removed

  end
end
