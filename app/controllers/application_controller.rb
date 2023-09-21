class ApplicationController < ActionController::Base
    before_action :logged_in?
    helper_method :current_user
    def current_user
        # If session[:user_id] is nil, set it to nil, otherwise find the user by id.
        @current_user ||= session[:user_id] && User.find_by(user_id: session[:user_id])
    end

    def logged_in?
        #function to check if user is logged in before accessing recourses
        if current_user.blank?
            redirect_to new_user_session_path
        end
    end

    def can_access?
        #function to check if user has access rights to the resource
    end
end
