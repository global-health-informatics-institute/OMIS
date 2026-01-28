class ApplicationController < ActionController::Base
  before_action :logged_in?
  helper_method :current_user
  def current_user
    # If session[:user_id] is nil, set it to nil, otherwise find the user by id.
    @current_user ||= session[:user_id] && User.find_by(user_id: session[:user_id])
  end

  def possible_actions(current_state, is_owner, is_supervisor, requisition=nil)
    actions = []
    designation_ids = current_user.employee.current_designations.collect { |x| x.designation_id }
    process = WorkflowState
             .joins(:workflow_process)
             .where(workflow_state_id: current_state)
             .select('workflow_processes.workflow')
             .first
             &.workflow
    allowed_transitions = WorkflowStateActor.where(employee_designation_id:
                                                     current_user.employee.current_designations.collect { |x| x.employee_designation_id })
                                            .collect { |x| x.workflow_state_id }

    # need to know possible actions, know things you are owner of, supervisor on, need your role

    (WorkflowStateTransition.where(workflow_state_id: current_state) || []).each do |transition|
      if ['Recall Request', 'Collect Funds','Recall Timesheet','Rescind Request'].include?(transition.action) && !is_owner
        next
      end
      if (is_owner && transition.by_owner) or (!is_owner && allowed_transitions.include?(current_state))
        actions.append(transition.action)
      elsif is_supervisor && transition.by_supervisor and !is_owner
        actions.append(transition.action)
      # Special case: allow only designation_id = 12 for workflow_state_id = 28
     elsif is_owner && designation_ids.include?(12)
       if process == 'Petty Cash Request'
         initial_state_id = InitialState.find_by(
           workflow_process_id: WorkflowProcess.find_by(workflow: 'Petty Cash Request')&.id
         )&.workflow_state_id

         actions.append(transition.action) unless current_state == initial_state_id
       end
      elsif !is_owner && WorkflowStateActor.where(
        workflow_state_id: current_state,
        employee_designation_id: designation_ids
      ).exists?
        actions.append(transition.action)
      end
    end
    # raise allowed_transitions.inspect
    #Add this condition when one has recalled the requisition can rescind that also
    if  current_state== 35
      actions.append('Rescind Request')
    end

    if is_supervisor && !is_owner && process == 'Purchase Request'
      actions = actions - ['Accept Item', 'Reject Item']
    end

    # Filter actions based on IPC status for Purchase Requests
    if process == 'Purchase Request' && requisition.present?
      if requisition.went_through_ipc?
        # IPC flow: remove "Confirm Delivery", but keep "Approve/Reject Funds" for Item Accepted state
        actions = actions - ['Confirm Delivery']
        if current_state == 47  # Item Accepted
          # Keep "Approve Funds" and "Reject Funds" for Item Accepted state in IPC flow
          # No removal needed for these actions
        else
          # For other IPC states, remove "Approve Funds" and "Reject Funds"
          actions = actions - ['Approve Funds', 'Reject Funds']
        end
      else
        # Non-IPC flow:
        # - Always remove "Confirm Delivery"
        # - In Payment Requested state: keep "Approve Funds" and "Reject Funds", remove "Confirm Item Delivery"
        # - In LPO Issued state: keep "Confirm Item Delivery", remove "Approve Funds" and "Reject Funds"
        # - In Item Accepted state: keep "Approve Funds" and "Reject Funds"
        actions = actions - ['Confirm Delivery']
        if current_state == 42  # Payment Requested
          actions = actions - ['Confirm Item Delivery']
        elsif current_state == 57  # LPO Issued
          actions = actions - ['Approve Funds', 'Reject Funds']
        elsif current_state == 47  # Item Accepted
          # Keep "Approve Funds" and "Reject Funds" for Item Accepted state
          # No removal needed for these actions
        end
      end
    end

    actions
  end

  def current_timesheet
    return if @current_user.blank?

    Timesheet.where(employee_id: @current_user.employee.id,
                    timesheet_week: Date.today.beginning_of_week).first_or_create
  end

  def logged_in?
    return true if request.get? && (request.path.start_with?('/tc_dashboard') || request.path.start_with?('/dashboards')) # rubocop:disable Layout/LineLength

    return unless current_user.blank?

    redirect_to new_user_session_path
  end

  def clear_flash
    flash.discard[:warning] # Or whatever flash key you are using
    render plain: "Flash cleared"
  end

  def can_access?
    # function to check if user has access rights to the resource
  end
end
