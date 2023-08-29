require 'platform/settings'
require 'aws-sdk-core'

Aws.config = {
  access_key_id: BaseApp::Settings::AssetStore.s3_access_key_id,
  secret_access_key: BaseApp::Settings::AssetStore.s3_secret_access_key,
  region: BaseApp::Settings::AssetStore.s3_media_region,
}