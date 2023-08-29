module BaseApp
class Settings < Settingslogic
    namespace Rails.env

    class Config < Settingslogic
      source File.join(File.dirname(__FILE__), '../..', 'config', 'settings', 'config.yml')
      namespace Rails.env
    end

    class AssetStore < Settingslogic
      source File.join(File.dirname(__FILE__), '../..', 'config', 'settings', 'asset_store.yml')
      namespace Rails.env
    end

    class Config < Settingslogic
      source File.join(File.dirname(__FILE__), '../..', 'config', 'settings', 'config.yml')
      namespace Rails.env
    end

    class SNS < Settingslogic
      source File.join(File.dirname(__FILE__), '../..', 'config', 'settings', 'sns.yml')
      namespace Rails.env
    end

    class Firebase < Settingslogic
      source File.join(File.dirname(__FILE__), '../..', 'config', 'settings', 'firebase.yml')
      namespace Rails.env
    end
  end
end