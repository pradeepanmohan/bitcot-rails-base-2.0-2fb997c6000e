class UsersController < ApplicationController
    before_action :set_user, only: [:show, :destroy]

    def index
        @users = User.all
        respond_to do |format|
            format.html
            format.json {
                render json: [['City', 'Population'], ['New York', 8175000], ['Los Angeles', 3792000],
                ['UK', 37000]
                ]
            }
        end
    end

    def show
        @user = User.find(params[:id])
    end

    def destroy
        @user.destroy
        respond_to do |format|
            format.html { redirect_to admin_users_url, notice: 'User was successfully removed.' }
            format.json { head :no_content }
        end
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
        @user = User.find(params[:id])
    end

end
