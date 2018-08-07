module AdwordsSimpleApi
  class Feed < Base
    service :feed_service
    attributes :id, :name, :status, :origin, :system_feed_generation_data, :feed_attributes
    attribute_field_names status: :feed_status, feed_attributes: :attributes

    has_status :enabled, :removed
    has_many(items: AdwordsSimpleApi::FeedItem)

    def schema
      attributes[:attributes]
    end

    def schema=(value)
      attributes[:attributes] = value
    end

    # def save
    #   id.present? ? update : create
    # end
    #
    # def create
    #   service.mutate([create_operation])
    # end

#     # Create site links feed first.
# site_links_feed = {
#   :name => 'Feed For Site Links',
#   :attributes => [
#     {:type => 'STRING', :name => 'Link Text'},
#     {:type => 'URL_LIST', :name => 'Final URLs'},
#     {:type => 'STRING', :name => 'Line 2 Description'},
#     {:type => 'STRING', :name => 'Line 3 Description'}
#   ]
# }
#
# response = feed_srv.mutate([
#     {:operator => 'ADD', :operand => site_links_feed}
# ])

  end
end
