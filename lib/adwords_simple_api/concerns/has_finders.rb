module AdwordsSimpleApi
  module HasFinders

    module ClassMethods
      def get(predicates = [])
        selector = { fields: field_names }
        unless predicates.nil? || predicates.empty?
          selector[:predicates] = AdwordsSimpleApi.wrap(predicates)
        end
        response = service.get(selector)
        if response && response[:entries]
          Array(response[:entries]).map{ |a| self.new(a) }
        else
          []
        end
      end

      def all(hash = {})
        predicates = hash.map{ |k,v|
          {
            field: field_name(k),
            operator: 'EQUALS',
            values: AdwordsSimpleApi.wrap(v)
          }
        }
        get(predicates)
      end

      def find(id)
        find_by(id: id)
      end

      def find_by(hash)
        all(hash).first
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
