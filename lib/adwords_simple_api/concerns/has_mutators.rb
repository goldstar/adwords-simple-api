module AdwordsSimpleApi
  module HasMutators

    module ClassMethods

      def create!(hash)
        new_values = add(hash)
        if new_values.first
          self.new(new_values.first)
        else
          raise 'No objects were created'
        end
      end

      def add(hash)
        operation = {:operator => 'ADD', :operand => hash}
        response = service.mutate([operation])
        if response && response[:value]
          response[:value]
        else
          []
        end
      end

      def set(id, hash)
        operation = { :operator => 'SET', :operand => hash.merge(id: id) }
        response = service.mutate([operation])
        if response && response[:value]
          response[:value]
        else
          []
        end
      end
    end

    # def save
    #   id.present? ? update : create
    # end

    # def update
    #   set(changed_attributes)
    # end

    # def create
    #   new_values = self.class.add(attributes)
    #   if new_value.first
    #     @attributes = new_values.first
    #   else
    #     raise "No objects were created"
    #   end
    # end

    def set(hash)
      new_values = self.class.set(id, hash)
      if new_values.first
        @attributes = new_values.first
      else
        raise 'No objects were updated.'
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
