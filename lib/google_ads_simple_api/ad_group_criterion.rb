module GoogleAdsSimpleApi
  class AdGroupCriterion < Base
    include HasLabels

    attributes :criterion_use, :disapproval_reasons, :first_page_cpc,
      :top_of_page_cpc, :first_position_cpc,# :bidding_strategy_configuration,
      :final_urls, :final_mobile_urls, :final_app_urls, :tracking_url_template,
      :final_url_suffix

    # All this fields get brought in as criterion
    [:keyword_text, :keyword_match_type,                                   # Keyword
     :user_list_id, :user_list_name, :user_list_membership_status,         # CriterionUserList
     :user_list_eligible_for_search, :user_list_eligible_for_display       # CriterionUserList
   ].each{ |a| attribute(a, no_getter: true) }

   # aake sure no states are duplicated
    status_attribute :status,
      states: [:enabled, :removed, :paused]
    status_attribute :system_serving_status,
      states: [:eligible, :rarely_served]
    status_attribute :approval_status,
      states: [:approved, :pending_review, :under_review, :disapproved]

    belongs_to(:ad_group)
    custom_parameters_attribute :url_custom_parameters

    def criterion
      attributes[:criterion]
    end

    def criterion_type
      criterion[:criterion_type]
    end

  end

end
