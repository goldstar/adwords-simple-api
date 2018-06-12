module AdwordsSimpleApi
  API_VERSION = :v201802

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
require 'adwords_simple_api/base'
require 'adwords_simple_api/label'
require 'adwords_simple_api/ad_group'
require 'adwords_simple_api/campaign'
require 'adwords_simple_api/campaign_group'
require 'adwords_simple_api/expanded_text_ad'
require 'adwords_simple_api/label'
require 'adwords_simple_api/version'
require 'adwords_simple_api/reports'
