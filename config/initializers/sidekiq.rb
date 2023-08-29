require 'platform/settings'

Sidekiq.configure_server do |config|
  config.redis = { url: "#{BaseApp::Settings::Config.redis_url}/2" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "#{BaseApp::Settings::Config.redis_url}/2" }
end