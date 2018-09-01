module GoogleAdsSimpleApi
  API_VERSION = :v201802
  PAGE_SIZE = 500
  SLICE_SIZE = 500

  def self.adwords=(adwords)
    @adwords = adwords
  end

  def self.adwords(adwords = nil)
    @adwords or raise "Adwords not configured"
  end

  # Need to put this somewhere. It's based on Rails Array.wrap
  def self.wrap(object)
    if object.nil?
      []
    elsif object.respond_to?(:to_ary)
      object.to_ary || [object]
    else
      [object]
    end
  end

  def self.camelcase(stringy)
    stringy.to_s.split(/[_ ]+/).map(&:capitalize).join
  end

  def self.underscore(stringy)
    stringy.to_s.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end

end

require 'adwords_api'
require 'google_ads_simple_api/base'
require 'google_ads_simple_api/feed_item'
require 'google_ads_simple_api/feed_item_target'
require 'google_ads_simple_api/feed'
require 'google_ads_simple_api/feed_synchronizer'
require 'google_ads_simple_api/label'
require 'google_ads_simple_api/expanded_text_ad'
require 'google_ads_simple_api/ad_group'
require 'google_ads_simple_api/campaign'
require 'google_ads_simple_api/campaign_group'
require 'google_ads_simple_api/version'
require 'google_ads_simple_api/reports'
