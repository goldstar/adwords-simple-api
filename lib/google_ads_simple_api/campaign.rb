module GoogleAdsSimpleApi
  class Campaign < Base
    include HasLabels
    has_many(ad_groups: 'AdGroup')
    has_many(feed_item_targets: 'FeedItemTarget')
    has_many(campaign_criteria: 'CampaignCriterion')
    belongs_to(:campaign_group)
    belongs_to(:budget)

    attributes :name, :serving_status, :start_date,
     :end_date, :ad_serving_optimization_status, :settings, :advertising_channel_type,
     :campaign_trial_type, :base_campaign_id, :budget_id

    attribute :budget_id, no_getter: true

    status_attribute :status, states: [:paused, :enabled, :removed]

    custom_parameters_attribute :url_custom_parameters

    def budget_id
      @attributes[:budget][:budget_id]
    end

    def final_urls
      expanded_text_ads.flat_map{|ad| ad.final_urls }.uniq
    end

    def expanded_text_ads
      @expanded_text_ads ||= ExpandedTextAd.for_campaign(id)
    end

  end
end
