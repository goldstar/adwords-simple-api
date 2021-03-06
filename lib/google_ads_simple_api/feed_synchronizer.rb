module GoogleAdsSimpleApi
  class FeedSynchronizer
    attr_reader :feed, :new_values, :remove_items_flag, :key_attributes

    def initialize(feed, new_values, remove_items: false)
      @feed = feed
      @key_attributes = feed.key_attributes
      @new_values = new_values
      @remove_items_flag = !!remove_items
    end

    def run
      return [] if operations.empty?
      FeedItem.service.mutate(operations)
    end

    private

    def items
      @items ||= feed.enabled_items
    end

    def new_values_by_key
      @new_values_by_key ||= new_values.map{ |v| [string_key_for_values(v),v.except(:feed_item_id)] }.to_h
    end

    def items_by_key
      @items_by_key ||= items.map{|i| [string_key_for_item(i),i] }.to_h
    end

    def string_key_for_values(values)
      return values[:feed_item_id] || values.to_s if @key_attributes.empty?
      key_attributes.map{ |k|
        name = k[:name]
        values[name] || values[name.to_sym]
      }.join("::")
    end

    def string_key_for_item(item)
      string_key_for_values(item.to_hash.merge(feed_item_id: item.id))
    end

    def operations
      @operations ||= set_operations + add_operations + remove_operations
    end

    def set_operations
      (items_by_key.keys & new_values_by_key.keys).select{|key|
         items_by_key[key].to_hash != new_values_by_key[key]
      }.map{ |key|
        item = items_by_key[key]
        attribute_values = item.attribute_values_for(new_values_by_key[key])
        item.set_operation(attribute_values: attribute_values)
      }
    end

    def add_operations
      (new_values_by_key.keys - items_by_key.keys).map{ |key|
        new_values = new_values_by_key[key]
        attribute_values = FeedItem.attribute_values_for(feed, new_values)
        FeedItem.add_operation(attribute_values: attribute_values, feed_id: feed.id)
      }
    end

    def remove_operations
      return [] unless remove_items_flag
      (items_by_key.keys - new_values_by_key.keys).map { |key|
        item = items_by_key[key]
        item.remove_operation
      }
    end

  end
end
