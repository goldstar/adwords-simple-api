module GoogleAdsSimpleApi
  module HasMany

    module ClassMethods

      def has_many(has_many_associations)
        @associations ||= {}
        @associations.merge!(has_many_associations)
        has_many_associations.keys.each do |name|
          define_method(name) do |options = {}|
            has_many(name, options)
          end
        end
      end

    end

    def has_many(name, reload: false, eager_load: false)
      name = name.to_sym
      load_has_many(name) if reload || !@associations[name]
      @associations[name]
    end

    def load_has_many(name, associates = false)
      associates ||= self.class.associations[name].all(id_field_sym => id)
      associates.each do |assoc|
        assoc.eager_load_belongs_to(self) if assoc.respond_to?(:eager_load_belongs_to)
      end
      @associations[name] = associates
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
