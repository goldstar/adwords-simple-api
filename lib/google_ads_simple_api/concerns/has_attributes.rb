module GoogleAdsSimpleApi
  module HasAttributes

    module ClassMethods
      class AttributeUndefined < StandardError
      end

      def attributes(*attributes_names)
        attributes_names.flatten.each do |name|
          attribute(name)
        end
      end

      def attribute(name, options = {})
        define_method(name) do
          get_attribute(name)
        end unless options[:no_getter]

        attribute_definitions[name] = {
          field_name: GoogleAdsSimpleApi.camelcase(options[:field] || name),
          field_key: options[:key] || name
        }
      end

      def attribute_definitions
        @attribute_definitions ||= begin
          # id_name = "#{self.name.split(/::/).last}Id"
          # id_key = GoogleAdsSimpleApi.underscore(name).to_sym
          {
            id: {
              field_name: "Id",
              field_key: :id
            }
          }
        end
      end

      def field_names
        attribute_definitions.values.map{ |v| v[:field_name] }
      end

      def attribute_definition(attribute)
        attribute_definitions[attribute] or raise AttributeUndefined.new("#{attribute} is not defined")
      end

      def field_name(attribute)
        attribute_definition(attribute)[:field_name]
      end

      def field_key(attribute)
        attribute_definition(attribute)[:field_key]
      end

    end

    def id
      get_attribute(:id)
    end

    def attributes
      @attributes ||= {}
    end

    def get_attribute(attribute_name)
      key = field_key(attribute_name)
      attributes[key]
    end

    def field_name(attribute)
      self.class.field_name(attribute)
    end

    def field_key(attribute_name)
      self.class.field_key(attribute_name)
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
