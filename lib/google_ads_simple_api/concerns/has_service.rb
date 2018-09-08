module GoogleAdsSimpleApi
  module HasService

    module ClassMethods
      def service(srvc = nil)
        if srvc
          @service_name = GoogleAdsSimpleApi.camelcase(srvc).to_sym
        else
          @service_name ||= "#{self.api_object_name}Service".to_sym
          @service ||= adwords.service(@service_name, GoogleAdsSimpleApi::API_VERSION)
        end
      end

      def adwords
        GoogleAdsSimpleApi.adwords
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
