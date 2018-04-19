module AdwordsSimpleApi
  module Reports
    class YesterdayAdPerformanceReport < Base

      report_definition(
        selector: {
          fields: [                               # RETURNS AS:
            'Id', 'Date',                         #   :ad_id, # :day,
            'AdGroupId', 'AdGroupName',           #   :ad_group_id, :ad_group_name,
            'CampaignId','CampaignName',          #   :campaign_id, :campaign_name,
            'Impressions', 'Clicks',              #   :impressions, :clicks,
            'Conversions', 'Cost',
            'CreativeFinalUrls'],               #   :conversions, :cost
        },
        report_name: 'Yesterday AD_PERFORMANCE_REPORT',
        report_type: 'AD_PERFORMANCE_REPORT',
        download_format: 'CSV',
        date_range_type: 'YESTERDAY'
      )

      include_zero_impressions(false)
      integer_columns(:ad_id, :ad_group_id, :campaign_id, :impressions, :clicks, :conversions)
      currency_columns(:cost)
      json_columns(:final_url)

      def self.historical(date_range)
        historical_report = @report_definition.merge({
          report_name: 'Historical AD_PERFORMANCE_REPORT',
          date_range_type: 'CUSTOM_DATE',
          selector: @report_definition[:selector].merge({
            date_range: {
              min: date_range.min.to_s(:number),
              max: date_range.max.to_s(:number)
            }
          })
         })
        report = self.new
        report.report_definition = historical_report
        report
      end

    end
  end
end
