module AdwordsSimpleApi
  module HasStatus

    module ClassMethods

      def has_status(*status_labels)
        status_labels.each do |status|
          attributes(:status)
          has_status = "#{status}?"
          change_status = status.to_s.gsub(/d$/,"!")
          status = status.to_s.upcase

          define_method(has_status) do
            attributes[:status] == status
          end

          define_method(change_status) do
            set(status: status)
          end
        end
      end

    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
