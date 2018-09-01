module GoogleAdsSimpleApi
  module Reports
    class PlaceholderFeedItemReport < Base
      #  https://developers.google.com/adwords/api/docs/appendix/placeholders

      SITELINK_TYPE = "1"
      APP_TYPE = "3"
      CALLOUT_TYPE = "17"
      STRUCTURED_SNIPPET_TYPE = "24"
      PROMOTION_TYPE = "38"

      report_definition(
        :selector => {
          :fields => [
            'FeedId', 'FeedItemId', 'Status','AttributeValues',
            'PlaceholderType',
            'Impressions', 'Clicks', 'Conversions', 'Cost', 'IsSelfAction'],
          :predicates => [
            {
              :field => 'Status',
              :operator => 'IN',
              :values => ['ENABLED']
            }
          ]
        },
        :report_name => 'Last 7 days PLACEHOLDER_FEED_ITEM_REPORT',
        :report_type => 'PLACEHOLDER_FEED_ITEM_REPORT',
        :download_format => 'CSV',
        :date_range_type => 'LAST_7_DAYS'
      )

      json_columns(:attribute_values)
      include_zero_impressions(false)

      def sitelinks
        filter_type(SITELINK_TYPE, text: 1, line_1: 3, line_2: 4, final_url: 5, tracking_url: 7)
      end

      def apps
        filter_type(APP_TYPE, app_store: 1, app_id: 2, text: 3, final_url: 5, tracking_url: 7).map{|hash|
          hash[:app_store] = app_store_name(hash[:app_store])
          hash
        }
      end

      def callouts
        filter_type(CALLOUT_TYPE, text: 1)
      end

      def structured_snippets
        filter_type(STRUCTURED_SNIPPET_TYPE, header: 1, values: 2)
      end

      def promotions
        filter_type(PROMOTION_TYPE,
            promotion_target: 1, discount_modifier: 2, percent_off: 3,
            money_amount_off: 4, promotion_code: 5, orders_over_amount: 6,
            promotion_start: 7, promotion_end: 8, occasion: 9,
            final_url: 10, tracking_url: 11
        )
      end

      def filter_type(type, attribute_map)
        self.to_a.select{ |h| h[:feed_placeholder_type] == type && h[:this_extension_vs_other] == "This extension" }.map{ |hash|
          attribute_values = hash.delete(:attribute_values) || {}
          attribute_map.each_pair do |key, value|
            hash[key] = (value.class.to_s == "Array") ?
               attribute_values[value.to_s].map(&:to_s).join(', ') :
               attribute_values[value.to_s]
          end
          hash
        }
      end

      private

      def app_store_name(str)
        case str
        when "1"
          "Apple iTunes Store"
        when "2"
          "Google Play Store"
        else
          "unknown"
        end
      end
    end
  end
end
