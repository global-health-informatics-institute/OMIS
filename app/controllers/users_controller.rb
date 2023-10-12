class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def password_reset

  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
