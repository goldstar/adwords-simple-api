module GoogleAdsSimpleApi
  class Feed < Base
    service :feed_service

    attributes :id, :name, :origin, :system_feed_generation_datas
    attribute :status, field: :feed_status
    attribute :feed_attributes, field: :attributes  # TODO. should just be attributes

    has_status :enabled, :removed
    has_many(items: GoogleAdsSimpleApi::FeedItem)

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
      Synchronizer.new(self, new_values, options).run
      items
    end

    def key_attributes
      schema.select{ |a| a[:is_part_of_key] }
    end

    def enabled_items(reload: false)
      @enabled_items = nil if reload
      @enabled_items ||= GoogleAdsSimpleApi::FeedItem.all(id_field_sym => id, status: 'ENABLED')
    end

  end
end
