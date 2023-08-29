class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :require_admin, only: [:admin_action]
  before_action :set_paper_trail_whodunnit
  before_action :update_user_activity
  before_action :check_session_timeout


  impersonates :user

  def admin_action
  end

  private

  def require_admin
    unless current_user.has_role?(:admin)
      flash[:alert] = "You do not have permission to access this page."
      redirect_to root_path
    end
  end
  before_action :update_user_activity
  before_action :check_session_timeout


  def update_user_activity
    begin
      current_user.update(last_activity_at: Time.current) if user_signed_in?
    rescue => e
      puts "errror !!!!!!!!!!!!!!!!!!!!!!#{e}"
    end

  end

  def check_session_timeout
    if user_signed_in? && current_user.last_activity_at < 1.hour.ago
      sign_out current_user
      flash[:notice] = "Your session has expired. Please sign in again."
      redirect_to new_user_session_path
    end
  end

end
