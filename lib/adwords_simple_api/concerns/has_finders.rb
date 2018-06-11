module AdwordsSimpleApi
  module HasFinders

    module ClassMethods      
      def get(predicates = nil)
        selector = { fields: field_names }
        unless predicates.nil?
          selector[:predicates] = AdwordsSimpleApi.wrap(predicates)
        end
        response = service.get(selector)
        if response && response[:entries]
          Array(response[:entries]).map{ |a| self.new(a) }
        else
          []
        end
      end

      def all
        get()
      end

      def find(id)
        find_by(id: id)
      end

      def find_by(hash)
        predicates = hash.map{ |k,v|
          {
            field: field_name(k),
            operator: 'EQUALS',
            values: AdwordsSimpleApi.wrap(v) }
        }
        get(predicates).first
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
