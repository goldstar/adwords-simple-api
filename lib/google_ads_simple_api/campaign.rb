require 'google_ads_simple_api/concerns/has_labels'

module GoogleAdsSimpleApi
  class Campaign < Base
    include HasLabels
    has_many(ad_groups: GoogleAdsSimpleApi::AdGroup)
    belongs_to(:campaign_group)

    attributes :name, :serving_status, :start_date,
     :end_date, :ad_serving_optimization_status, :settings, :advertising_channel_type,
     :campaign_trial_type, :base_campaign_id
    status_attribute :status, states: [:paused, :enabled, :removed]

    custom_parameters_attribute :url_custom_parameters

    def final_urls
      expanded_text_ads.flat_map{|ad| ad.final_urls }.uniq
    end

    def expanded_text_ads
      @expanded_text_ads ||= ExpandedTextAd.for_campaign(id)
    end

  end
end
