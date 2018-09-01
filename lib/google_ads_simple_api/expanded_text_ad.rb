module GoogleAdsSimpleApi
  class ExpandedTextAd < Base
    service :ad_group_ad_service
    attributes :id, :headline_part1, :headline_part2,
      :description, :path1, :path2, :creative_final_urls

    belongs_to(:ad_group)
    has_custom_parameters :url_custom_parameters
    attribute_field_names url_custom_parameters: :creative_url_custom_parameters

    def initialize(hash)
      if hash[:ad]
        ad_group_id = hash[:ad_group_id]
        hash = hash.delete(:ad)
        hash[:ad_group_id] = ad_group_id
      end
      super(hash)
    end

    def self.for_campaign(campaign_id)
      response = service.get(
        fields: field_names,
        predicates: [
          { field: 'AdType',        operator: 'IN',   values: ['EXPANDED_TEXT_AD'] },
          { field: 'CampaignId',    operator: 'IN',   values: [campaign_id] },
          { field: 'AdGroupStatus', operator: 'IN',   values: ['ENABLED','PAUSED'] },
          { field: 'Status',        operator: 'IN',   values: ['ENABLED','PAUSED'] }
        ]
      )
      if response && response[:entries]
        return GoogleAdsSimpleApi.wrap(response[:entries]).map{|hash| self.new(hash) }
      else
        return []
      end
    end

    def final_urls
      GoogleAdsSimpleApi.wrap(attributes[:final_urls])
    end

    # def remove(ad)
    #   operation = {
    #     operator: 'REMOVE',
    #     operand: {
    #       ad_group_id: attributes[:ad_group_id],
    #       ad: {
    #         xsi_type: 'Ad',
    #         id: id
    #       }
    #     }
    #   }
    # end

    # def copy_expanded_ad(ad, changes)
    #   ad_group_ad = {
    #     ad_group_id: ad[:ad_group_id],
    #     ad: {
    #       xsi_type: 'ExpandedTextAd',
    #       headline_part1: ad[:ad][:headline_part1],
    #       headline_part2: ad[:ad][:headline_part2],
    #       description: ad[:ad][:description],
    #       final_urls: ad[:ad][:final_urls],
    #     }
    #   }
    #
    #   ad_group_ad[:ad][:path1] = ad[:ad][:path1] if ad[:ad][:path1].present?
    #   ad_group_ad[:ad][:path2] = ad[:ad][:path2] if ad[:ad][:path2].present?
    #
    #   operation = {
    #     :operator => 'ADD',
    #     :operand => ad_group_ad.merge(changes)
    #   }
    # end


  end
end
