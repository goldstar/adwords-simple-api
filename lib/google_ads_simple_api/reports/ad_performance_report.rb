module GoogleAdsSimpleApi
  module Reports
    class AdPerformanceReport < Base

      report_definition(
        :selector => {
          :fields => [
            'CampaignId','CampaignName','CampaignStatus',
            'AdGroupId', 'AdGroupName', 'AdGroupStatus',
            'Id', 'HeadlinePart1', 'HeadlinePart2', 'Path1', 'Path2',
            'Description', 'CreativeFinalUrls', 'Status',
            'Impressions', 'Clicks', 'Conversions', 'Cost'],
          :predicates => [
            {
              :field => 'AdType',
              :operator => 'EQUALS',
              :values => ['EXPANDED_TEXT_AD']
            },
            {
              :field => 'AdGroupStatus',
              :operator => 'IN',
              :values => ['ENABLED','PAUSED']
            },
            {
              :field => 'CampaignStatus',
              :operator => 'IN',
              :values => ['ENABLED','PAUSED']
            },
            {
              :field => 'Status',
              :operator => 'IN',
              :values => ['ENABLED','PAUSED']
            }
          ]
        },
        :report_name => 'Last 7 days AD_PERFORMANCE_REPORT',
        :report_type => 'AD_PERFORMANCE_REPORT',
        :download_format => 'CSV',
        :date_range_type => 'LAST_7_DAYS'
    )

    json_columns(:final_url)
    end
  end
end
