module AdwordsSimpleApi
  module HasService

    module ClassMethods
      def service(srvc = nil)
        if srvc
          @service_name = AdwordsSimpleApi.camelcase(srvc).to_sym
        else
          @service_name ||= "#{self.name}Service".to_sym
          @service ||= adwords.service(@service_name, AdwordsSimpleApi::API_VERSION)
        end
      end

      def adwords
        AdwordsSimpleApi.adwords
      end
    end

    def adwords
      self.adwords
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
