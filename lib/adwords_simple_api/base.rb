module AdwordsSimpleApi
  class Base
    
    def self.adwords
      AdwordsSimpleApi.adwords
    end
    
    def adwords
      self.class.adwords
    end
    
    def self.campaign_service
      @campaign_service ||= adwords.service(:CampaignService, AdwordsSimpleApi::API_VERSION)
    end
    
    def campaign_service
      self.class.campaign_service
    end

    def self.ad_service
      @ad_service ||= adwords.service(:AdGroupAdService, AdwordsSimpleApi::API_VERSION)
    end
    
    def ad_service
      self.class.ad_service
    end
    
  end
end