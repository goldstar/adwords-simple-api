module GoogleAdsSimpleApi
  class FeedItem < Base
    VALUE_ATTRIBUTE_BY_TYPE = {
      'INT64' => { :value_key => :integer_value, :to_value => lambda{|x| x.to_i} },
      'FLOAT' => { :value_key => :double_value, :to_value => lambda{|x| x.to_f} },
      'STRING' => { :value_key => :string_value, :to_value => lambda{|x| x.to_s} },
      'BOOLEAN' => { :value_key => :boolean_value, :to_value => lambda{|x| !!x} },
      'URL' => { :value_key => :string_value, :to_value => lambda{|x| x.to_s} },
      'DATE_TIME' => { :value_key => :string_value, :to_value => lambda{|x| x.to_s} }, # 'YYYYMMDD hhmmss' in Account's timezone. Need to improve this.
      'INT64_LIST' => { :value_key => :integer_values, :to_value => lambda{|a| GoogleAdsSimpleApi.wrap(a).map(:to_i) } },
      'FLOAT_LIST' => { :value_key => :double_values, :to_value => lambda{|a| GoogleAdsSimpleApi.wrap(a).map(&:to_f) } },
      'STRING_LIST' => { :value_key => :string_values, :to_value => lambda{|a| GoogleAdsSimpleApi.wrap(a).map(&:to_s) } },
      'BOOLEAN_LIST' => { :value_key => :boolean_values, :to_value => lambda{|a| GoogleAdsSimpleApi.wrap(a).map{|x| !!x } } },
      'URL_LIST' => { :value_key => :string_values, :to_value => lambda{|a| GoogleAdsSimpleApi.wrap(a).map(&:to_s) } },
      'DATE_TIME_LIST' => { :value_key => :string_values, :to_value => lambda{|a| GoogleAdsSimpleApi.wrap(a).map(&:to_s) } },
      'PRICE' => { :value_key => :money_with_currency_value,
        # Need to improve this so it can handle non-USD
        :to_value => lambda{|x| { comparable_value_type: "MoneyWithCurrency", money: {comparable_value_type: "Money", micro_amount: (x * 1_000_000_000).to_i}, currency_code: 'USD'} },
        :from_value => lambda{|x| x[:money][:micro_amount].to_f / 1_000_000_000.0 }
       }
    }

    service :feed_item_service

    attributes :feed_id, :start_time, :end_time, :attribute_values,
      :url_custom_parameters

    status_attribute :status, states: [:enabled, :removed]
    belongs_to(:feed)

    def to_hash
      attribute_values.map{ |attribute_value|
        feed_attribute_id = attribute_value[:feed_attribute_id]
        attribute_schema = feed.schema_lookup_by_id[feed_attribute_id]
        name = attribute_schema[:name]
        type = attribute_schema[:type]
        value_key = VALUE_ATTRIBUTE_BY_TYPE[type][:value_key]
        value = attribute_value[value_key]
        value = VALUE_ATTRIBUTE_BY_TYPE[type][:from_value].call(value) if VALUE_ATTRIBUTE_BY_TYPE[type][:from_value]
        [ name, value ]
      }.to_h
    end

    def self.attribute_values_for(feed,new_values)
      i = 0
      new_attribute_values = feed.schema.map{ |attribute|
        name = attribute[:name] # this is the name of the attribute
        type = attribute[:type] # this is the type of the attribute
        value_key = VALUE_ATTRIBUTE_BY_TYPE[type][:value_key] # this is the hash key that we need to use to set the value
        value = VALUE_ATTRIBUTE_BY_TYPE[type][:to_value].call(new_values[name] || new_values[name.to_sym]) # # pull the value out of new_values by name and transform it
        { :feed_attribute_id => i+=1,  value_key => value }
      }
      new_attribute_values
    end

    def attribute_values_for(new_values)
      self.class.attribute_values_for(feed,new_values)
    end

    def set_operation(hash)
      self.class.set_operation(self.id, hash.merge(feed_id: feed.id))
    end

    def remove_operation
      self.class.remove_operation(self.id, feed_id: feed.id)
    end

  end
end
