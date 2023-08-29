class Api::V1::UsersController < Api::V1::ApiApplicationController

  def impersonate
    @user = User.find(params[:user_id])
    @access_token, @refresh_token = JsonWebToken.access_tokens({ user_id: @user.id, role: @user.role, orig_user_id: @current_user.id, exp: Time.now.to_i + BaseApp::Settings::Config['access_token_validity'].seconds })
  end

  def show
    @users = User.all
    render json: {users: @users}
  end

  def presigned_photo_url
    @urls = UploadPresigner.presign("uploads/users/#{current_user.id}/photo", params[:ext])
  end

  private

  def update_params
    params.require(:user).permit(:first_name, :last_name, :photo_path)
  end

end