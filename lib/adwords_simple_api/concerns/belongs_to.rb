module AdwordsSimpleApi
  module BelongsTo

    module ClassMethods

      def belongs_to(*belongs_to_names)
        @associations ||= {}

        attribute_names = belongs_to_names.map{|name| "#{name}_id".to_sym }
        attributes(attribute_names)

        belongs_to_associations = belongs_to_names.map{|n|
          klass_name = 'AdwordsSimpleApi::'+AdwordsSimpleApi.camelcase(n)
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

    def belongs_to(name)
      name = name.to_sym
      foreign_key = "#{name}_id".to_sym
      return nil unless @attributes[foreign_key]
      klass = Kernel.const_get(self.class.associations[name])
      @associations[name] ||= klass.find_by(id: @attributes[foreign_key])
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
