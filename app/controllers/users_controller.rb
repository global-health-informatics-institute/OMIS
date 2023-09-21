class UsersController < ApplicationController
  def index
    @users = User.all
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
