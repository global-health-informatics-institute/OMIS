class UsersController < ApplicationController
  skip_before_action :logged_in?, only: [:forgot_password, :password_reset_forget]

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

  def forgot_password
    
  end

  def password_reset_forget
    @user = Person.find_by(params[:email])
    #raise @user.inspect
    if @user
      flash[:notice] = "Password reset instructions have been sent to your email."
      redirect_to "/user_sessions/new"
    else
      flash[:error] = "User with this email address not found."
      redirect_to forgot_password_path
    end
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
    params.require(:user).permit(:username, :password, :password_confirmation, :email)
  end
end
