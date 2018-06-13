module AdwordsSimpleApi
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
      has_many(:labels) # to initialize association
      @associations[:labels].push(label)
      true
    end

    def remove_label(label)
      self.class.change_label(:remove, id, label.id) or return false
      has_many(:labels) # to initialize association
      @associations[:labels].delete_if{ |l| l == label }
      true
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        attributes(:labels)
        has_many(labels: AdwordsSimpleApi::Label)
      end
    end

  end
end
