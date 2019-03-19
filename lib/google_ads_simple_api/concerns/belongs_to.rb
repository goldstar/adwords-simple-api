module GoogleAdsSimpleApi
  module BelongsTo

    module ClassMethods

      def belongs_to(*belongs_to_names)
        @associations ||= {}

        attribute_names = belongs_to_names.map{|name| "#{name}_id".to_sym }
        attributes(attribute_names)

        belongs_to_associations = belongs_to_names.map{|n|
          klass_name = 'GoogleAdsSimpleApi::'+GoogleAdsSimpleApi.camelcase(n)
          [n,klass_name]
        }.to_h

        @associations.merge!(belongs_to_associations)
        belongs_to_associations.keys.each do |name|

          define_method(name) do
            belongs_to(name)
          end
        end
      end
    end

    # When a has_many relationship is eager loaded, the inverse relationship
    # is made by here.  This implementation isn't ideal because it assumes the
    # the name of the association matches the class.
    def eager_load_belongs_to(obj)
      association = self.class.associations.select{|k,v| v == obj.class.name}.first or return
      name = association.first
      return unless name
      @associations[name] = obj
    end

    def belongs_to(name)
      name = name.to_sym
      foreign_key = "#{name}_id".to_sym
      foreign_id = @attributes[foreign_key] || self.send(foreign_key)
      return nil unless foreign_id
      klass = Kernel.const_get(self.class.associations[name])
      @associations[name] ||= klass.find_by(id: foreign_id)
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
