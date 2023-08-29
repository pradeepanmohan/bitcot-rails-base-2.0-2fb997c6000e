class Api::V1::AuthenticatedController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  protect_from_forgery with: :null_session

  # before_action :authenticate

  # attr_reader :current_user

  def handle_bad_authentication
    render json: { message: "Bad credentials" }, status: :unauthorized
  end

  def handle_not_found
    render json: { message: "Record not found" }, status: :not_found
  end

  private

  # def current_user
  #   @current_user = User.active.first
  # end
end