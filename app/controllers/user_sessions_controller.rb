class UserSessionsController < ApplicationController
  skip_before_action :logged_in?, only: [:new, :create]
  def new
    @user = User.new
  end

  def create
    @user = User.find_by_username(params[:user][:username])

    if @user && @user.authenticate(params[:user][:password])
      if @user.activated
        session[:user_id] = @user.id
        if @user.reset_needed
          redirect_to "/users/#{@user.user_id}"
          flash[:info] = "Please reset password."
        else
          session[:success] ||= []
          session[:success] << ['Welcome to OMIS', 'Successfully logged in']
          redirect_to root_path
        end
      else
        flash[:error] = "Your user account was deactivated. Please contact your supervisor"
        redirect_to new_user_session_path  
      end
      
    else
      flash[:error] = "Login failed. Wrong password/username"
      redirect_to new_user_session_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
