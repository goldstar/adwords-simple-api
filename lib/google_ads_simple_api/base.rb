require 'google_ads_simple_api/concerns/has_attributes'
require 'google_ads_simple_api/concerns/has_service'
require 'google_ads_simple_api/concerns/has_many'
require 'google_ads_simple_api/concerns/belongs_to'
require 'google_ads_simple_api/concerns/has_status'
require 'google_ads_simple_api/concerns/has_finders'
require 'google_ads_simple_api/concerns/has_mutators'
require 'google_ads_simple_api/concerns/has_custom_parameters'

module GoogleAdsSimpleApi
  class Base
    include HasAttributes
    include HasService
    include HasMany
    include BelongsTo
    include HasStatus
    include HasFinders
    include HasMutators
    include HasCustomParameters

    def initialize(hash = {})
      @attributes = hash
      @associations = {}
    end

    def self.associations
      @associations ||= {}
    end

    def self.api_object_name
      self.name.split(/::/).last
    end

    def self.id_field
      "#{self.api_object_name}Id"
    end

    def self.id_key
      GoogleAdsSimpleApi.underscore(id_field).to_sym
    end

    def ==(obj)
      obj.class == self.class && self.id && self.id == obj.id
    end

    def inspect
      "#<#{self.class.to_s}:#{"%X" % self.object_id} @attributes=#{@attributes}>"
    end

  end
end
