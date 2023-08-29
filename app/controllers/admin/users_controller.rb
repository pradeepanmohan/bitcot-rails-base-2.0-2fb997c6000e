class Admin::UsersController < ApplicationController
  before_action :require_admin, only: [:index]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
    if params[:query].present?
      @users = @users.where('first_name LIKE ? OR last_name LIKE ? OR email LIKE ?', "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%")
    end
    @users = @users.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  def show
    @user = User.find(params[:id])
  end

  def audit_changes
    @user = User.find(params[:id])
    @audits = @user.audits
  end

  def new
    @user = User.new
  end

  def impersonate
    user = User.find(params[:id])
    impersonate_user(user)
    redirect_to root_path
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to root_path
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to [:admin, @user], notice: "User created successfully."
    else
      puts "Error !!!!!!!"
      puts @user.errors.full_messages.join(',')
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path(@user), notice: 'User was successfully updated.'
    else
      render :edit
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

  def soft_delete
    @user = User.find(params[:id])
    @user.update(soft_deleted_at: Time.current)
    @user.update(active_status: "deleted")
    redirect_to admin_users_url, notice: 'User was successfully soft deleted.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :photo_path)
  end
end
