require 'forwardable'

module GoogleAdsSimpleApi
  class CustomParameters
    extend Forwardable

    def_delegators :to_hash, :[], :fetch, :empty?, :each_value, :each_pair,
      :each_key, :has_key?, :has_value?, :include?, :keys, :key, :key?, :value?,
      :values, :values_at

    attr_reader :changed, :owner, :attribute_name
    alias_method :changed?, :changed

    # https://developers.google.com/adwords/api/docs/reference/v201710/CampaignService.CustomParameters

    def initialize(owner, attribute_name)
      @owner = owner
      @attribute_name = attribute_name
      @changed = false
    end

    def attribute_data
      owner.attributes[attribute_name] ||= {:parameters => [], :do_replace => false}
    end

    def clear
      self.each_key{ |k| delete(k) }
      to_hash
    end

    def eql?(other)
      self.to_hash.eql?(other.to_hash)
    end

    def delete(key)
      value = self[key.to_sym]
      store(key, nil)
      value
    end

    def store(key, value)
      key = key.to_sym
      index = key_index(key)

      return nil if index.nil? && value.nil? # delete something not there
      return nil if !index.nil? && attribute_data[:parameters][index][:value] == value.to_s # no change

      parameter = value.nil? ?
        {:key => key.to_s, :is_remove => true} :
        {:key => key.to_s, :value => value.to_s, :is_remove => false}

      if index.nil? # add a parameter
        attribute_data[:parameters].push(parameter)
      else # set a value
        attribute_data[:parameters][index] = parameter
      end

      @changed = true
      self[key] # new value read from hash
    end
    alias_method :[]=, :store

    def key_index(key)
      key = key.to_s
      attribute_data[:parameters].index{|p| p[:key] == key }
    end

    def save
      return true unless changed? # noop
      owner.set( {attribute_name => attribute_data} )
    end

    def to_hash(refresh = false)
      attribute_data[:parameters].reject{|p| p[:is_remove] }.map{|p| [p[:key].to_sym,p[:value]] }.to_h
    end

    def inspect
      "#<#{self.class.to_s}:#{"%X" % self.object_id} @attribute_data=#{attribute_data}>"
    end

  end
end
