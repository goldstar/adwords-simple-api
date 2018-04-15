module AdwordsSimpleApi
  module Reports
    class CampaignPerformanceReport < Base

      report_defination(
        :selector => {
          :fields => [
            'CampaignId','CampaignName','CampaignStatus',
            'TrackingUrlTemplate', 'UrlCustomParameters','StartDate',
            'Impressions', 'Clicks', 'Conversions', 'Cost', 'Labels'],
          :predicates => [
            {
              :field => 'CampaignStatus',
              :operator => 'IN',
              :values => ['ENABLED','PAUSED']
            }
          ]
        },
        :report_name => 'Last 7 days CAMPAIGN_PERFORMANCE_REPORT',
        :report_type => 'CAMPAIGN_PERFORMANCE_REPORT',
        :download_format => 'CSV',
        :date_range_type => 'LAST_7_DAYS'
    )

    json_columns(:labels, :custom_parameter)

    end
  end
end
