module GoogleAdsSimpleApi
  module HasStatus

    module ClassMethods

      def status_attribute(name, options)
        attribute(name, options.merge(no_getter: true))

        define_method(name) do
          get_attribute(name).downcase.to_sym
        end

        options[:states].each do |state|
          has_state = "#{state}?"
          change_state = state.to_s.gsub(/d$/,"!")
          state_string = state.to_s.upcase

          define_method(has_state) do
            get_attribute(name).downcase.to_sym == state
          end

          define_method(change_state) do
            set(name => state_string)
          end

        end
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
