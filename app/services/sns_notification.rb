class SnsNotification

  # Public: Initialize sns provider with aws sns keys
  #         in asset_store.yml
  #
  # Example
  #
  #  SnsNotification.new
  #  # => '#<Aws::SNS::Client:0x00007f4570d41a40>'
  # Returns aws sns client
  def initialize
    @sns_provider = Aws::SNS::Client.new(access_key_id: BaseApp::Settings::SNS.access_key,
                                         secret_access_key: BaseApp::Settings::SNS.secret_key,
                                         region: BaseApp::Settings::AssetStore.s3_media_region)
  end

  # Internal: Create SNS Endpoint for the User's Device
  #
  # identifier - The String device identifier
  # token - The String device push token
  # customer_user_data - The String user id
  #
  # Example
  #
  #   create_endpoint('ios', '740f4707 bebcf74e...', '2')
  #   # => "arn:aws:sns:us-west-2:202255567303:endpoint/APNS_SANDBOX/reverb_staging_dev/4fb1cb06-e4a9-39c5-b692-f983025b236f"
  #
  # Returns endpoint arn for the device
  def create_endpoint(identifier, token, custom_user_data = nil)
    begin
      if identifier.to_i == Device.identifiers[:ios]
        arn = BaseApp::Settings::SNS.apns_arn
      else
        arn = BaseApp::Settings::SNS.gcm_arn
      end

      resp = @sns_provider.create_platform_endpoint({
                                                        platform_application_arn: arn,
                                                        token: token,
                                                        custom_user_data: custom_user_data,
                                                    })

      # TODO: uncomment below for updating the token
      # update_token resp.endpoint_arn, token, custom_user_data
      return true, resp.endpoint_arn
    rescue Exception => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      return false
    end
  end

  def update_token(arn, token, custom_user_data = nil)
    begin
      resp = @sns_provider.set_endpoint_attributes({
                                                       endpoint_arn: arn,
                                                       attributes: {
                                                           CustomUserData: custom_user_data,
                                                           Enabled: :true,
                                                           Token: token
                                                       },
                                                   })
      true
    rescue Exception => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
      return false
    end
  end

  # Public: Send push notification to user's device
  #
  # device_identifier - The String device identifier
  # arn - The String device endpoint arn generated while creating endpoint
  # push_token - The String device push token
  # message - String message that will set as push notification message
  # opts - The Hash options for push notification
  #        config (eg - silent: true for silent notification)
  # additional_data - The Hash options containing additional
  #                   information for push notification
  #
  # Example
  #
  #   sns_service = SnsNotification.new
  #   sns_service.send_notification('ios', '740f4707 bebcf74e...',
  #                                  "arn:aws:sns:us-west-2:202255567303:endpoint
  #                                   /APNS_SANDBOX/reverb_staging_dev/4fb1cb06-e4a9-39c5-b692-f983025b236f",
  #                                   {silent: true}, {user_id: 2})
  #   => [true, #<struct Aws::SNS::Types::PublishResponse message_id="923a9e32-fecc-5d5d-9d73-caa204d2591b">]
  #
  # Returns boolean value(True) and AWS SNS publish response or
  # destroy all user's device from DB and returns boolean value(False) .
  def send_notification(device_identifier, arn, push_token, message, opts = {}, additional_data = {})
    begin
      case Device.identifiers[device_identifier]
        when Device.identifiers[:ios]
          if opts[:silent]
            push_message = {'content-available' => 1}
          else
            push_message = {alert: message, sound: 'default'}
          end

          data = {
              default: 'text',
              :APNS_SANDBOX => {aps: additional_data.merge(push_message)}.to_json,
              :APNS => {aps: additional_data.merge(push_message)}.to_json,
              expiration_date: (Time.now + 100.seconds).to_i
          }

        when Device.identifiers[:android]
          push_message = {message: message}

          data = {
              default: 'text',
              :GCM => {
                  data: additional_data.merge(push_message),
                  delay_while_idle: false,
                  time_to_live: BaseApp::Settings::SNS.ttl_seconds,
                  priority: :high
              }.to_json
          }

        else
          Rails.logger.debug "Unsupported platform device identifier #{device_identifier}"
          return
      end

      resp = @sns_provider.publish({
                                       target_arn: arn,
                                       message_structure: 'json',
                                       message: data.to_json
                                   })
      Rails.logger.info "Data #{data.to_json}"
      return true, resp
    rescue Exception => e
      Rails.logger.error e.message
      if e.class == Aws::SNS::Errors::InvalidParameter or e.class == Aws::SNS::Errors::EndpointDisabled
        delete_endpoint(arn)
        Device.where(:push_token => push_token).destroy_all
      end
      return false
    end
  end

  # Internal: Delete SNS Endpoint for the User's Device
  #
  # arn - The String Device arn
  #
  # Example
  #
  #   delete_endpoint("arn:aws:sns:us-west-2:202255567303:endpoint/APNS_SANDBOX/reverb_staging_dev/4fb1cb06-e4a9-39c5-b692-f983025b236f")
  #
  # Returns nothing.
  def delete_endpoint(arn)
    begin
      @sns_provider.delete_endpoint({
                                        endpoint_arn: arn
                                    })
    rescue Exception => e
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end