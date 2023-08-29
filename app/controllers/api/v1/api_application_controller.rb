class Api::V1::ApiApplicationController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  attr_reader :current_user

  rescue_from Exception do |e|
    Rails.logger.error e.to_s
    Rails.logger.error e.backtrace.join("\n")
    render 'global/error', locals: {code: 500, message: 'Something Went Wrong!'}
  end
end
