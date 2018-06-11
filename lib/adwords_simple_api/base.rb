require 'adwords_simple_api/concerns/has_many'
require 'adwords_simple_api/concerns/has_status'
require 'adwords_simple_api/concerns/has_finders'

module AdwordsSimpleApi
  class Base
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

    def self.service(srvc = nil)
      if srvc
        @service = AdwordsSimpleApi.camelcase(srvc).to_sym
      else
        @adwords_service ||= adwords.service(@service, AdwordsSimpleApi::API_VERSION)
      end
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

    def self.adwords
      AdwordsSimpleApi.adwords
    end

    def adwords
      self.class.adwords
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

    def self.id_field_str
      "#{self.name.split(/::/).last}Id"
    end
    def id_field_str
      self.class.id_field_str
    end

    def add_label(label)
      self.class.change_label(:add, id, label.id) or return false
      has_many(:labels) # to initialize association
      @associations[:labels].push(label)
      true
    end

    def remove_label(label)
      self.class.change_label(:remove, id, label.id) or return false
      has_many(:labels) # to initialize association
      @associations[:labels].delete_if{ |l| l == label }
      true
    end

    def self.change_label(operator, id, label_id)
      begin
        service.mutate_label([{
          :operator => operator.to_s.upcase,
          :operand => {:label_id=> label_id, id_field_sym => id}
        }])
        true
      rescue AdwordsApi::Errors::ApiException => e
        false
      end
    end
  end
end
