module AdwordsSimpleApi
  module HasMany

    module ClassMethods

      def has_many(has_many_associations)
        @associations ||= {}
        @associations.merge!(has_many_associations)
        has_many_associations.keys.each do |name|
          define_method(name) do
            has_many(name)
          end
        end
      end

    end

    def has_many(name)
      name = name.to_sym
      @associations[name] ||= begin
        self.class.associations[name].get(
          { field: id_field_str, operator: 'EQUALS',  values: [id] }
        )
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
