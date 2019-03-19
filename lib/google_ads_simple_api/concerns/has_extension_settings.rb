module GoogleAdsSimpleApi
  module HasExtensionSettings

    module ClassMethods
    end

    EXTENSION_TYPES = {
      sitelinks: "SITELINK",
      apps: "APP",
      callouts: "CALLOUT",
      snippets: "STRUCTURED_SNIPPET",
      promotions: "PROMOTION"
    }

    EXTENSION_TYPES.each_pair do |name, type|
      define_method(name) do
        extensions_by_type(type)
      end

      define_method("update_#{name}".to_sym) do |options = {}|
        update_extension_settings(type, options)
      end
    end

    def extensions_by_type(type)
      extension_settings.select{|e| e.extension_type == type}.first
    end

    def update_extension_setting_operations(type, add: [], remove: [])
      current_extensions = extensions_by_type(type)
      remove_ids = remove.map{|h| h[:feed_item_id] }.compact
      add_ids = remove.map{|h| h[:feed_item_id] }.compact

      # Remove the BOTH the remove_ids and the add_ids. The re-add the adds
      set_extensions = current_extensions.reject{ |h|
        remove_ids.include?(h[:feed_item_id]) || add_ids.include?(h[:feed_item_id])
      }.concat(add)

      # https://developers.google.com/adwords/api/docs/guides/extension-settings
      #
      #
      # sitelink_feed_item = {
      #   :xsi_type => 'SitelinkFeedItem',
      #   :feed_item_id => stored_feed_item_id
      # }
      # campaign_extension_setting = {
      #   :campaign_id => campaign_id,
      #
      #   :extension_setting => {
      #     :extensions => [sitelink_feed_item]
      #   }
      # }

      new_extension_setting = {
        self.class.id_key => self.id,
        extension_type: type,
        extension_setting: {
          extensions: set_extensions
        }
      }
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        has_many(extension_settings: (base.name+'ExtensionSetting'))
      end
    end

  end
end
