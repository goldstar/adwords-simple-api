module GoogleAdsSimpleApi
  class Feed < Base
    service :feed_service

    attributes :name, :origin, :system_feed_generation_data
    attribute :feed_attributes, field: :attributes  # TODO. should just be attributes
    status_attribute :status, field: :feed_status, states: [:enabled, :removed]

    has_many(items: 'FeedItem')
    has_many(feed_item_targets: 'FeedItemTarget')

    def schema
      attributes[:attributes] || []
    end

    def schema=(value)
      attributes[:attributes] = value
    end

    def schema_lookup_by_id
      @schema_lookup_by_id ||= schema.map{|attribute|
          [attribute[:id], attribute]
        }.to_h
    end

    def sync_item_values(new_values, options = {})
      FeedSynchronizer.new(self, new_values, options).run
      enabled_items(reload: true)
    end

    def key_attributes
      schema.select{ |a| a[:is_part_of_key] }
    end

    def enabled_items(reload: false)
      self.items(reload: reload).select{|item| item.enabled? }
    end

  end
end
