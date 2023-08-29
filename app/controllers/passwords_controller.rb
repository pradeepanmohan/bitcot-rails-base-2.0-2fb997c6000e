class PasswordsController < Devise::PasswordsController
  respond_to :json, :html

  def create
    user = User.find_by_email(params[:email])
    if user
      user.send_reset_password_instructions
      render json: { message: "Reset password instructions sent successfully." }
    else
      render json: { error: "User with provided email not found." }, status: :unprocessable_entity
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      if Devise.sign_in_after_reset_password
        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message!(:notice, flash_message)
        sign_in(resource_name, resource)
      else
        set_flash_message!(:notice, :updated_not_active)
      end
      respond_to do |format|
        format.html { respond_with resource, location: after_resetting_password_path_for(resource) }
        format.json { render json: { message: "Password updated successfully." } }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: { error: resource.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end
end