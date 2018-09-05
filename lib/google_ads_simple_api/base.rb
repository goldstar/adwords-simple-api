require 'google_ads_simple_api/concerns/has_service'
require 'google_ads_simple_api/concerns/has_many'
require 'google_ads_simple_api/concerns/belongs_to'
require 'google_ads_simple_api/concerns/has_status'
require 'google_ads_simple_api/concerns/has_finders'
require 'google_ads_simple_api/concerns/has_mutators'
require 'google_ads_simple_api/concerns/has_custom_parameters'

module GoogleAdsSimpleApi
  class Base
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

    def self.attributes(*attributes_names)
      attr_reader :attributes
      attributes_names.flatten.each do |name|
        add_field(name)
        define_method(name) do
          get_attribute(name)
        end
      end
    end

    def get_attribute(name)
      attributes[name]
    end

    def self.attribute_field_names(hash = nil)
      if hash
        @attribute_field_names = hash
      else
        @attribute_field_names ||= {}
      end
    end

    def self.field_names
      @fields.map{|f| field_name(f) }
    end

    def self.field_name(f)
      @attribute_field_names ||= {}
      f = @attribute_field_names[f.to_sym] || f
      GoogleAdsSimpleApi.camelcase(f)
    end

    # "Id"
    def field_name(f)
      self.class.field_name(f)
    end

    def self.field_key(attribute_name)
      attribute_name
    end

    def field_key(attribute_name)
      self.class.field_key(attribute_name)
    end

    def self.add_field(field)
      @fields ||= []
      @fields << field
      @fields.uniq!
    end

    def self.fields
      @fields ||= []
    end

    def self.associations
      @associations
    end

    def ==(obj)
      obj.class == self.class && self.id && self.id == obj.id
    end

    def self.id_field_sym
      GoogleAdsSimpleApi.underscore(id_field_str).to_sym
    end

    def id_field_sym
      self.class.id_field_sym
    end

    def self.class_str
      self.name.split(/::/).last
    end

    def self.id_field_str
      "#{self.class_str}Id"
    end

    def id_field_str
      self.class.id_field_str
    end

    def inspect
      "#<#{self.class.to_s}:#{"%X" % self.object_id} @attributes=#{@attributes}>"
    end

  end
end
