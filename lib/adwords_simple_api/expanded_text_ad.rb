module AdwordsSimpleApi
  class ExpandedTextAd < Base
    attr_reader :attributes, :id

    FIELDS = ['AdGroupId','Id', 'Status', 'HeadlinePart1', 'HeadlinePart2',
    'Description','Path1','Path2', 'CreativeFinalUrls']

    def initialize(hash)
      @attributes = hash
      if hash[:ad]
        @attributes = hash.delete(:ad)
        @attributes[:ad_group_id] = hash[:ad_group_id]
      end
      @id = @attributes[:id] or raise "Must initialize with at least an id"
    end

    def self.for_campaign(campaign_id)
      response = ad_service.get(
        fields: FIELDS,
        predicates: [
          { field: 'AdType',        operator: 'IN',   values: ['EXPANDED_TEXT_AD'] },
          { field: 'CampaignId',    operator: 'IN',   values: [campaign_id] },
          { field: 'AdGroupStatus', operator: 'IN',   values: ['ENABLED','PAUSED'] },
          { field: 'Status',        operator: 'IN',   values: ['ENABLED','PAUSED'] }
        ]
      )
      if response && response[:entries]
        return Array(response[:entries]).map{|hash| self.new(hash) }
      else
        return []
      end
    end

    def final_urls
      Array(attributes[:final_urls])
    end

    def remove(ad)
      operation = {
        operator: 'REMOVE',
        operand: {
          ad_group_id: attributes[:ad_group_id],
          ad: {
            xsi_type: 'Ad',
            id: id
          }
        }
      }
    end

    def copy_expanded_ad(ad, changes)
      ad_group_ad = {
        ad_group_id: ad[:ad_group_id],
        ad: {
          xsi_type: 'ExpandedTextAd',
          headline_part1: ad[:ad][:headline_part1],
          headline_part2: ad[:ad][:headline_part2],
          description: ad[:ad][:description],
          final_urls: ad[:ad][:final_urls],
        }
      }

      ad_group_ad[:ad][:path1] = ad[:ad][:path1] if ad[:ad][:path1].present?
      ad_group_ad[:ad][:path2] = ad[:ad][:path2] if ad[:ad][:path2].present?

      operation = {
        :operator => 'ADD',
        :operand => ad_group_ad.merge(changes)
      }
    end


  end
end
