module GoogleAdsSimpleApi
  module Macros
    class CampaignCreator
      def self.defaults(attributes = nil)
        @defaults = attributes if attributes
        @defaults || {}
      end

      attr_reader :attributes

      def initialize(attributes)
        @attributes = self.class.default.merget(attributes)
        # name
        # language_ids = []
        # campaign_group_id = int
        # location_ids = []
        # proximities = {}
        # budget = int
        # delivery_method = 'STANDARD'
        # bidding_strategy = 'MANUAL_CPC'
        # url_custom_parameters = {}
      end

      def create!
        create_budget
        create_campaign
        create_campaign_criteria
        @campaign
      end

      def create_budget
        @budget ||= GoogleAdsSimpleApi::Budget.create!(
          is_explicitly_shared: false,
          amount: {micro_amount: (attributes[:budget].to_f * 1_000_000).to_i},
          delivery_method: attributes[:delivery_method]
        )
      end

      def create_campaign
        # TODO: Turn off display network
        @campaign ||= begin
          campaign_attributes = {
            name: attributes[:name],
            status: 'PAUSED',
            bidding_strategy_configuration: { bidding_strategy_type: 'MANUAL_CPC' },
            advertising_channel_type: 'SEARCH',
            budget: { budget_id: @budget.id },
            # :start_date => DateTime.parse((Date.today + 1).to_s).strftime('%Y%m%d'),
            # :end_date => DateTime.parse((Date.today + 1).to_s).strftime('%Y%m%d'),
            :network_setting => {
              :target_google_search => !!attributes[:target_google_search],
              :target_search_network => !!attributes[:target_search_network],
              :target_content_network => !!attributes[:target_content_network],
            },
            settings: [
              {
                :xsi_type => 'GeoTargetTypeSetting',
                :positive_geo_target_type => 'DONT_CARE',
                :negative_geo_target_type => 'DONT_CARE'
              }
            ],
            # :frequency_cap => {
            #   :impressions => '5',
            #   :time_unit => 'DAY',
            #   :level => 'ADGROUP'
            # }
          }

          if attributes[:campaign_group_id]
            campaign_attributes[:campaign_group_id] = attributes[:campaign_group_id]
          end

          if attributes[:url_custom_parameters]
            campaign_attributes[:url_custom_parameters] = url_custom_parameters
          end
          GoogleAdsSimpleApi::Campaign.create!(campaign_attributes)
        )
      end

      def url_custom_parameters
        parameters = attributes[:url_custom_parameters].to_a.map{ |p|
          [[:key, p[0]], [:value, p[1]], [:is_remove, false]].to_h
        }
        { parameters: parameters }
      end

      def create_campaign_criteria
        criteria = [
          language_criteria,
          location_criteria,
          proximity_criteria,
        ].flatten.compact
        operations = criteria.map{ |criterion|
          GoogleAdsSimpleApi::CampaignCriterion.add_operation(
            campaign_id: @campaign.id,
            is_negative: false,
            criterion: criterion
          )
        }
        GoogleAdsSimpleApi::CampaignCriterion.service.mutate(operations)
      end

      def language_criteria
        attributes[:language_ids].map { |id|
          {id: id, xsi_type: 'Language'}
        }
      end

      def location_criteria
        attributes[:location_ids].map { |id|
          {id: id, xsi_type: 'Location'}
        }
      end

      def proximity_criteria
        attributes[:proximities].map{ |p|
          {
            xsi_type: 'Proximity',
            radius_distance_units: 'MILES',
            radius_in_units: p[:radius],
            geo_point: {
              latitude_in_micro_degrees: (p[:latitude]*1_000_000).to_i,
              longitude_in_micro_degrees: (p[:longitude]*1_000_000).to_i
            }
          }
        }
      end

    end
  end
end
