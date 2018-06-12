require 'adwords_simple_api/concerns/has_service'
require 'adwords_simple_api/concerns/has_many'
require 'adwords_simple_api/concerns/has_status'
require 'adwords_simple_api/concerns/has_finders'

module AdwordsSimpleApi
  class Base
    include HasService
    include HasMany
    include HasStatus
    include HasFinders

    def initialize(hash = {})
      @attributes = hash
      @associations = {}
    end

    def self.attributes(*attributes_names)
      @fields ||= []
      attr_reader :attributes
      attributes_names.each do |name|
        @fields << name
        define_method(name) do
          attributes[name]
        end
      end
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

    def self.fields
      @fields
    end

    def self.associations
      @associations
    end


    def self.set(id, hash)
      operation = { :operator => 'SET', :operand => hash.merge(id: id) }
      response = service.mutate([operation])
      if response && response[:value]
        response[:value]
      else
        []
      end
    end

    def set(hash)
      new_values = self.class.set(id, hash)
      if new_values.first
        @attributes = new_values.first
      else
        raise 'No objects were updated.'
      end
    end

    def ==(obj)
      obj.class == self.class && attributes[:id] && attributes[:id] == obj.id
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

  end
end
