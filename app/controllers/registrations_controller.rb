class RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token
  respond_to :json, :html

  def create
    build_resource(sign_up_params)

    resource.save
    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        respond_to do |format|
          format.html { redirect_to root_path }
          format.json { render json: { user: resource}, status: :created }
        end
      else
        expire_data_after_sign_in!
        respond_to do |format|
          format.html { redirect_to root_path }
          format.json { render json: { user: resource }, status: :created }
        end
      end
    else
      clean_up_passwords resource
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
