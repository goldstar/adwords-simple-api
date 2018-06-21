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
      @associations[name] ||= self.class.associations[name].all(id_field_sym => id)
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
