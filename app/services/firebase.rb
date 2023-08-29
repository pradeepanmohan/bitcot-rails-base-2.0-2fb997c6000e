class Firebase

  attr_accessor :desktop_fallback_url, :link, :params, :talent

  def initialize(link, params = {}, talent = nil)
    self.link = link
    self.params = params
    self.talent = talent
    firebase_request_url = "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=#{Rails.application.credentials[Rails.env.to_sym][:FIREBASE_KEY]}"
    @uri = URI.parse(firebase_request_url)
  end

  def create
    callback_response = {}

    check_create_params(callback_response)

    return callback_response if callback_response.present?

    unless self.link.include?("http://") or self.link.include?("https://")
      self.link = "https://#{self.link}"
    end

    long_dynamic_link = "https://#{BaseApp::Settings::Firebase.app_code}/?link=#{link}/?#{CGI::escape(params.to_query)}&ibi=#{BaseApp::Settings::Firebase.ios_bundle_id}&dfl=#{self.desktop_fallback_url}&apn=#{BaseApp::Settings::Firebase.android_package_name}&isi=#{BaseApp::Settings::Firebase.app_store_id}"
    unless self.talent.blank?
      long_dynamic_link += "&st=#{talent.first_name}#{talent.last_name[0].capitalize}"
      long_dynamic_link += "&sd=#{(talent.about_my_work || '')[0..100]}..."
      long_dynamic_link += "&si=#{talent.profile_photo}" unless talent.profile_photo.blank?
    end

    @dynamic_long_url = {
        "longDynamicLink": long_dynamic_link,
        "suffix": {
            "option": "SHORT"
        }
    }

    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(@uri.request_uri)
    request.body = @dynamic_long_url.to_json
    request.content_type = 'application/json'
    response = http.request(request)
    json_response = JSON.parse(response.body)

    if json_response['shortLink'].present?
      callback_response['success'] = 'true'
      callback_response['short_link'] = json_response['shortLink']
      callback_response['debug_link'] = json_response['previewLink']
    else
      callback_response['success'] = 'false'
      callback_response['message'] = json_response['error'].present? ? json_response['error']['status'] : 'Something went wrong!'
      Rails.logger.debug json_response
    end
    callback_response
  end

  class Analytics
    def initialize
      # base64 encoded header in UTF-8
      encoded_header = Base64.urlsafe_encode64({"alg": "RS256", "typ": "JWT"}.to_json.encode('utf-8'))
      current_time = Time.now.utc
      # claim_set
      claim_set = {iss: BaseApp::Settings::Firebase.service_account,
                   scope: 'https://www.googleapis.com/auth/firebase',
                   aud: 'https://www.googleapis.com/oauth2/v4/token',
                   iat: current_time.to_i,
                   exp: (current_time + 1.hour).to_i
      }

      # base64 encoded claim_set in UTF-8
      encoded_claim_set = Base64.urlsafe_encode64(claim_set.to_json.encode('utf-8'))
      # prepare SHA256 Encryption
      digest = OpenSSL::Digest.new('sha256')

      # Load Google Private Key
      private_key = Rails.application.credentials[Rails.env.to_sym][:GOOGLE_PRIVATE_KEY].to_s
      rsa_private = OpenSSL::PKey::RSA.new(private_key)

      # Sign encoded_header and encoded claim_set with your private key
      signature = rsa_private.sign(digest, "#{encoded_header}.#{encoded_claim_set}")

      # base64 encoded signature in UTF-8
      encoded_signature = Base64.urlsafe_encode64(signature)

      # required JWT Token for requesting access_token
      jwt = "#{encoded_header}.#{encoded_claim_set}.#{encoded_signature}"

      # Request for access_token begins here
      request_access_token_url = "https://www.googleapis.com/oauth2/v4/token"
      uri = URI.parse(request_access_token_url)
      query = URI.encode_www_form([['grant_type', 'urn:ietf:params:oauth:grant-type:jwt-bearer'], ['assertion', jwt]])
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(uri.request_uri)
      request.content_type = "application/x-www-form-urlencoded"
      response = http.request(request, query)
      json_response = JSON.parse(response.body)
      if json_response['access_token'].present?
        @access_token = json_response['access_token'] # valid access_token
      else
        @access_token = nil
      end
    end

    def get_analytics(short_link, duration = 7)
      if @access_token.nil?
        return {success: false, message: 'Invalid Access Code'}
      end
      firebase_analytics_url = "https://firebasedynamiclinks.googleapis.com/v1/#{CGI::escape(short_link)}/linkStats?durationDays=#{duration}"
      uri = URI.parse(firebase_analytics_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      request.add_field('Authorization', "Bearer #{@access_token}")
      response = http.request(request)
      JSON.parse(response.body)
    end
  end

  private
  def check_create_params(callback_response)
    #check if link is string
    unless link.is_a?(String)
      callback_response['success'] = false
      callback_response['message'] = 'link should be a string'
      return callback_response
    end

    #check if params is hash
    unless params.is_a?(Hash)
      callback_response['success'] = false
      callback_response['message'] = 'params should be a hash'
      callback_response
    end
  end
end