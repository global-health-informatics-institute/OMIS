class ApplicationController < ActionController::Base
    before_action :logged_in?
    helper_method :current_user
    def current_user
        # If session[:user_id] is nil, set it to nil, otherwise find the user by id.
        @current_user ||= session[:user_id] && User.find_by(user_id: session[:user_id])
    end

    def current_timesheet
        unless @current_user.blank?
            return Timesheet.where(employee_id: @current_user.employee.id,
                                   timesheet_week: Date.today.beginning_of_week).first_or_create
        end
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
