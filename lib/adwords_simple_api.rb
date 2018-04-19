module AdwordsSimpleApi
  API_VERSION = :v201802

  def self.adwords=(adwords)
    @adwords = adwords
  end

  def self.adwords(adwords = nil)
    @adwords or raise "Adwords not configured"
  end

end

require 'adwords_api'
require 'adwords_simple_api/base'
require 'adwords_simple_api/campaign'
require 'adwords_simple_api/campaign_group'
require 'adwords_simple_api/expanded_text_ad'
require 'adwords_simple_api/version'
require 'adwords_simple_api/reports'
