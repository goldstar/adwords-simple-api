module AdwordsSimpleApi
  module Reports
    class DailyAdPerformanceReport < Base

      report_definition(
        selector: {
          fields: [                             # RETURNS AS:
            'Id', 'Date',                                  #   :ad_id, # :day,
            'AdGroupId', 'AdGroupName', 'AdGroupStatus',   #   :ad_group_id, :ad_group_name
            'CampaignId','CampaignName','CampaignStatus',  #   :campaign_id, :campaign_name
            'Impressions', 'Clicks',                       #   :impressions, :clicks,
            'Conversions', 'Cost',                         #   :conversions, :cost
            'CreativeFinalUrls',                           #   :final_url
            'HeadlinePart1','HeadlinePart2',
            'Path1','Path2','Description'
          ],

        },
        report_name: 'Daily Ad Performance Report',
        report_type: 'AD_PERFORMANCE_REPORT',
        download_format: 'CSV',
        date_range_type: 'YESTERDAY'
      )

      include_zero_impressions(false)
      integer_columns(:ad_id, :ad_group_id, :campaign_id, :impressions, :clicks)
      float_columns(:conversions)
      currency_columns(:cost)
      json_columns(:final_url)
      date_columns(:day)
      string_columns(:path_1, :path_2) # cleans up " --" strings

      def initialize(date_or_range = nil)
        return if date_or_range.nil?
        date_range = date_or_range.is_a?(Range) ? date_or_range : date_or_range..date_or_range
        self.report_definition = report_definition.merge({
          date_range_type: 'CUSTOM_DATE',
          selector: report_definition[:selector].merge({
            date_range: {
              min: date_range.min.to_s(:number),
              max: date_range.max.to_s(:number)
            }
          })
         })
      end

    end
  end
end
