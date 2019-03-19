module GoogleAdsSimpleApi
  class CampaignExtensionSetting < Base
    attributes :campaign_id, :extension_type
    # attribute :extensions, no_getter: true # :extension_setting
    attribute :extension_setting, field: :extensions
    no_id

    def extensions
      extension_setting[:extensions]
    end

  end
end
