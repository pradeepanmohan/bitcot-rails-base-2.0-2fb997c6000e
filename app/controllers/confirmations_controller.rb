class ConfirmationsController < Devise::ConfirmationsController
  respond_to :json, :html

  def new
    super
  end

  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_to do |format|
        format.html { redirect_to  after_resending_confirmation_instructions_path_for(resource_name) }
        format.json { render json: { user: resource}, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      set_flash_message(:notice, :confirmed) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with_navigational(resource){
        respond_to do |format|
          format.html { redirect_to  users_path }
          format.json { render json: { user: resource}, status: :ok }
        end
      }
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

 private



 def after_confirmation_path_for(resource_name, resource)
   users_path
 end
end