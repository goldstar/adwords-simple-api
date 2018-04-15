require 'adwords_api'
Dir[__dir__ + '/**/*.rb'].each &method(:require)

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
