require 'json'
require 'devise/version'

class DeviseMailer < Devise::Mailer

  def reset_password_instructions(record, token, opts={})
    data = {
        reset_password_token: token,
        email: record.email,
        type: :rp
    }
    @url = Branch.new.params(data).get_link
    devise_mail(record, :reset_password_instructions, opts)
  end

end