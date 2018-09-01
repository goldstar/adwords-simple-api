module AdwordsSimpleApi
  class FeedItemTarget < Base
    service :feed_item_target_service
    attributes :id, :feed_id, :feed_item_id, :status, :target_type,
      :campaign_id, :campaign_name, # target_type is "CAMPAIGN"
      :ad_group_id, :parent_campaign_name#, # target_type is "AD_GROUP"
      # :criterion, :is_negative # target_type is "CRITERION"

    has_status :active, :removed

    # def add
    #   operation = {
    #     :operator => 'ADD',
    #     :operand => ad_group_ad.merge(changes)
    #   }
    # end

    # Optional: Restrict the first feed item to only serve with ads for the
    # specified ad group ID.
    # if !ad_group_id.nil? && ad_group_id != 0
    #   feed_item_target = {
    #     :xsi_type => 'FeedItemAdGroupTarget',
    #     :feed_id => sitelinks_data[:feed_id],
    #     :feed_item_id => sitelinks_data[:feed_item_ids].first,
    #     :ad_group_id => ad_group_id
    #   }
    #
    #   operation = {
    #     :operator => 'ADD',
    #     :operand => feed_item_target
    #   }
    #
    #   response = feed_item_target_srv.mutate([operation])
  end
end
