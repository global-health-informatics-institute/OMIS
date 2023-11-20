class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def password_reset
    if request.method.to_s == "POST"
      if params[:user][:password] == params[:user][:password_confirmation]
        user = User.find(params[:id]).update(password: params[:user][:password], reset_needed: false)
        redirect_to "/"
      else
        flash[:error] = "Passwords mismatch"
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
