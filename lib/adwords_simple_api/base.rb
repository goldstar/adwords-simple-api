require 'adwords_simple_api/concerns/has_service'
require 'adwords_simple_api/concerns/has_many'
require 'adwords_simple_api/concerns/belongs_to'
require 'adwords_simple_api/concerns/has_status'
require 'adwords_simple_api/concerns/has_finders'
require 'adwords_simple_api/concerns/has_mutators'
require 'adwords_simple_api/concerns/has_custom_parameters'

module AdwordsSimpleApi
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
      name = attribute_name(name)
      attributes[name]
    end

    def self.attribute_name(name)
      attribute_field_names[name] || name
    end

    def attribute_name(name)
      self.class.attribute_name(name)
    end

    def self.attribute_field_names(hash = nil)
      if hash
        @attribute_field_names = hash
      else
        @attribute_field_names
      end
    end

    def self.field_names
      @fields.map{|f| field_name(f) }
    end

    def self.field_name(f)
      @attribute_field_names ||= {}
      f = @attribute_field_names[f.to_sym] || f
      AdwordsSimpleApi.camelcase(f)
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
      AdwordsSimpleApi.underscore(id_field_str).to_sym
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
