module GoogleAdsSimpleApi
  class CampaignCriterion < Base
    attributes :is_negative, :bid_modifier

    # All this fields get brought in as criterion
    [:day_of_week, :start_hour, :start_minute, :end_hour, :end_minute,
     :location_name, :display_type, :targeting_status, :parent_locations,  # Location
     :language_code, :language_name,                                       # Lanuage
     :keyword_text, :keyword_match_type,                                   # Keyword
     :platform_name,                                                       # Platform
     :geo_point, :radius_distance_units, :radius_in_units, :address,       # Proximity
     :user_list_id, :user_list_name, :user_list_membership_status,         # CriterionUserList
     :user_list_eligible_for_search, :user_list_eligible_for_display       # CriterionUserList
   ].each{ |a| attribute(a, no_getter: true) }

    status_attribute :status, states: [:active, :removed, :paused], field: :campaign_criterion_status

    belongs_to(:campaign)


    def criterion
      attributes[:criterion]
    end

    def criterion_type
      criterion[:criterion_type]
    end


  end



end
