class UsersController < ApplicationController
  def index
    @users = User.all
  end


  def show
    @user = current_user
    @person = @user.person
  end

  def edit

  end

  def update

  end

  def new

  end

  def create

  end

  def destroy

  end

  def password_reset

    @user = User.find(params[:id])
    if @user && @user.authenticate(params[:user][:old_password])
      if params[:user][:password] == params[:user][:password_confirmation]
        user = User.find(params[:id]).update(password: params[:user][:password], reset_needed: false)
        flash[:notice] = "Password successfully updated"
        redirect_to "/"
      else
        flash[:error] = "Passwords mismatch"
        redirect_to current_user
      end
    else
      flash[:error] = "Original Password did not match "
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
