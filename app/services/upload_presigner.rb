class UploadPresigner

  def self.presign(prefix, extname)
    filename = "#{SecureRandom.uuid}#{extname}"
    upload_key = Pathname.new(prefix).join(filename).to_s

    creds = Aws::Credentials.new(BaseApp::Settings::AssetStore.s3_access_key_id, BaseApp::Settings::AssetStore.s3_secret_access_key)
    s3 = Aws::S3::Resource.new(region: 'us-west-2', credentials: creds)
    obj = s3.bucket(BaseApp::Settings::AssetStore.s3_media_bucket).object(upload_key)

    params = { acl: 'public-read' }

    {
        presigned_url: obj.presigned_url(:put, params),
        path: upload_key
    }
  end

end