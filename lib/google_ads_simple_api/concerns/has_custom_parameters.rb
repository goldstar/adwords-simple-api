require 'google_ads_simple_api/custom_parameters'

module GoogleAdsSimpleApi
  module HasCustomParameters

    module ClassMethods

      def custom_parameters_attribute(name, options = {})
        attribute(name, options.merge(no_getter: true))
        define_method(name) do
          custom_parameters(name)
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
