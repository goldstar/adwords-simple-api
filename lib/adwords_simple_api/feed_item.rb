module AdwordsSimpleApi
  class FeedItem < Base
    service :feed_item_service
    attributes :id, :feed_id, :status, :start_time, :end_time, :attribute_values,
      :url_custom_parameters
    attribute_field_names id: :feed_item_id

    has_status :enabled, :removed
  end
end
