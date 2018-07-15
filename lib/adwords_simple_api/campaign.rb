require 'adwords_simple_api/concerns/has_labels'

module AdwordsSimpleApi
  class Campaign < Base
    include HasLabels
    has_many(ad_groups: AdwordsSimpleApi::AdGroup)
    belongs_to(:campaign_group)

    attributes :id, :name, :status, :serving_status, :start_date,
     :end_date, :ad_serving_optimization_status, :settings, :advertising_channel_type,
     :campaign_trial_type, :base_campaign_id
    has_status :paused, :enabled, :removed
    has_custom_parameters :url_custom_parameters

    def final_urls
      expanded_text_ads.flat_map{|ad| ad.final_urls }.uniq
    end

    def expanded_text_ads
      @expanded_text_ads ||= ExpandedTextAd.for_campaign(id)
    end

  end
end
