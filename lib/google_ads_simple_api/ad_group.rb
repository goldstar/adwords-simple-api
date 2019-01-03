module GoogleAdsSimpleApi
  class AdGroup < Base
    include HasLabels

    attributes :name, :settings, :base_ad_group_id, :ad_group_type
    custom_parameters_attribute :url_custom_parameters

    # TO-DO: CampaignStatus IN ['ENABLED', PAUSED]
    # It already uses default predicates for status
    # default_predicates [{field; 'Status', operator: 'IN', values: ['ENABLED','PAUSED']}]
    status_attribute :status, states: [:enabled, :paused, :removed]

    has_many(expanded_text_ads: 'ExpandedTextAd')
    has_many(feed_item_targets: 'FeedItemTarget')
    has_many(ad_group_criteria: 'AdGroupCriterion')

    belongs_to(:campaign)
  end
end
