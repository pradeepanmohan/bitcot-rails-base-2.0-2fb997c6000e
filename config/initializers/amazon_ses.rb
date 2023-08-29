Aws::Rails.add_action_mailer_delivery_method(:aws_sdk, {
  access_key_id: Rails.application.credentials[Rails.env.to_sym][:SES_ACCESS_KEY_ID],
  secret_access_key: Rails.application.credentials[Rails.env.to_sym][:SES_SECRET_ACCESS_KEY],
  region: Rails.application.credentials[Rails.env.to_sym][:AWS_REGION]})