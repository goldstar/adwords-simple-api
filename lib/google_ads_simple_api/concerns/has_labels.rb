module GoogleAdsSimpleApi
  module HasLabels

    module ClassMethods
      def change_label(operator, id, label_id)
        begin
          service.mutate_label([{
            :operator => operator.to_s.upcase,
            :operand => {:label_id=> label_id, id_field_sym => id}
          }])
          true
        rescue AdwordsApi::Errors::ApiException => e
          false
        end
      end
    end

    def add_label(label)
      self.class.change_label(:add, id, label.id) or return false
      @labels = labels.push( label )
      true
    end

    def remove_label(label)
      self.class.change_label(:remove, id, label.id) or return false
      @labels = labels.delete_if{ |l| l == label }
      true
    end

    def labels
      @labels ||= GoogleAdsSimpleApi.wrap(attributes[:labels]).map{ |h| Label.new(h) }
    end


    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        add_field(:labels)
      end
    end

  end
end
