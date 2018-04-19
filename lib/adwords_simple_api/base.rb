module AdwordsSimpleApi
  class Base

    def initialize(hash)
      @attributes = hash
      @id = hash[:id] or raise "Must initialize with at least an id"
    end

    def set(hash)
      operation = { :operator => 'SET', :operand => hash.merge(id: id) }
      response = service.mutate([operation])
      if response && response[:value]
        @attributes = response[:value].first
      else
        raise 'No objects were updated.'
      end
    end

    def self.fields(*field_names)
      if field_names.any?
        @fields = field_names.map(&:to_s)
      else
        @fields
      end
    end

    def self.service(srvc = nil)
      if srvc
        @service = srvc.to_sym
      else
        @adwords_service ||= adwords.service(@service, AdwordsSimpleApi::API_VERSION)
      end
    end

    def self.get(predicates = nil)
      selector = { fields: fields }
      unless predicates.nil?
        selector[:predicates] = wrap(predicates)
      end
      response = service.get(selector)
      if response && response[:entries]
        Array(response[:entries]).map{ |a| self.new(a) }
      else
        []
      end
    end

    def self.all
      get()
    end

    def self.find(id)
      get({ field: 'Id', operator: 'EQUALS',  values: [id] }).first or raise "No object found"
    end

    def self.adwords
      AdwordsSimpleApi.adwords
    end

    def adwords
      self.class.adwords
    end

    def self.ad_service
      @ad_service ||= adwords.service(:AdGroupAdService, AdwordsSimpleApi::API_VERSION)
    end

    def ad_service
      self.class.ad_service
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

  end
end
