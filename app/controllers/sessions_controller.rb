class SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]
  respond_to :json, :html

  def create
    self.resource = warden.authenticate(auth_options)
    if resource
      sign_in(resource_name, resource)
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { render json: { user: resource }, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path }
        format.json { render json: { error: 'Invalid email or password' }, status: :unauthorized }
      end
    end
  end

  def after_sign_in_path_for(resource)
    if resource.has_role?(:admin)
      redirect_to admin_post_path
    else resource.has_role?(:user)
      redirect_to posts_path
    end
  end
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json do
        if signed_out
          render json: { success: 'User signed out successfully' }, status: :ok
        else
          render json: { error: 'Failed to sign out' }, status: :unprocessable_entity
        end
      end
    end
  end
end