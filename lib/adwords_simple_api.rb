require 'adwords_api'
require 'adwords_simple_api/base'
require 'adwords_simple_api/campaign'
require 'adwords_simple_api/expanded_text_ad'
require 'adwords_simple_api/version'
require 'adwords_simple_api/reports'

module AdwordsSimpleApi
  API_VERSION = :v201710
    
  def self.adwords=(adwords)
    @adwords = adwords
  end
  
  def self.adwords(adwords = nil)
    if adwords
      self.adwords=adwords
    end
    @adwords || AdwordsApi::Api.new
  end
  
end
