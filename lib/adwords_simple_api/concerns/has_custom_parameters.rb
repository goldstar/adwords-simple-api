require 'adwords_simple_api/custom_parameters'

module AdwordsSimpleApi
  module HasCustomParameters

    module ClassMethods

      def has_custom_parameters(*attribute_names)
        attribute_names.flatten.each do |name|
          add_field(name)
          define_method(name) do
            custom_parameters(name)
          end
        end
      end

    end

    def custom_parameters(name)
      @custom_parameters ||= {}
      @custom_parameters[name] ||= CustomParameters.new(self, name)
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
