class ApplicationController < ActionController::Base
    before_action :logged_in?
    helper_method :current_user
    def current_user
        # If session[:user_id] is nil, set it to nil, otherwise find the user by id.
        @current_user ||= session[:user_id] && User.find_by(user_id: session[:user_id])
    end

    def possible_actions(current_state, is_owner, is_supervisor)
        actions = []
        allowed_transitions = WorkflowStateActor.where(employee_designation_id:
                                                         current_user.employee.current_designations.collect{|x| x.id})
                                                .collect{|x| x.workflow_state_id}

        #need to know possible actions, know things you are owner of, supervisor on, need your role

        (WorkflowStateTransition.where(workflow_state_id: current_state) || []).each do |transition|
            if (is_owner && transition.by_owner) or (!is_owner && allowed_transitions.include?(transition.id))
                actions.append(transition.action)
            elsif (is_supervisor && transition.by_supervisor) and !is_owner
                actions.append(transition.action)
            end
        end
        # raise allowed_transitions.inspect
        return  actions
    end
    def current_timesheet
        unless @current_user.blank?
            return Timesheet.where(employee_id: @current_user.employee.id,
                                   timesheet_week: Date.today.beginning_of_week).first_or_create
        end
    end

    def logged_in?
      return true if request.get? && request.path == '/dashboards/dashboards'

        if current_user.blank?
            redirect_to new_user_session_path
        end
    end

    def can_access?
        #function to check if user has access rights to the resource
    end
end
