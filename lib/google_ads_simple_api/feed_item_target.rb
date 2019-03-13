module GoogleAdsSimpleApi
  class FeedItemTarget < Base
    service :feed_item_target_service
    attributes :feed_id, :feed_item_id, :target_type,
      :campaign_id, :campaign_name, # target_type is "CAMPAIGN"
      :ad_group_id, :parent_campaign_name#, # target_type is "AD_GROUP"
      # :criterion, :is_negative # target_type is "CRITERION"

    status_attribute :status, states: [:active, :removed]

    belongs_to(:feed)
    belongs_to(:feed_item)
    
    def self.create_target_for(ad_group_or_campaign, feed_item)
      id_key = ad_group_or_campaign.class.id_key
      operation = add_operation(
        :xsi_type       => "FeedItem#{ad_group_or_campaign.class.api_object_name}Target",
        :feed_id        => feed_item.feed_id,
        :feed_item_id   => feed_item.id,
        id_key          => ad_group_or_campaign.id
      )
      service.mutate([operation])
    end

  end
end
