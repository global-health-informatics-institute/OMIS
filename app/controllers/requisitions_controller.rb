class RequisitionsController < ApplicationController
  # before_action :show
  def index
  end

  def show
    @requisition = Requisition.find(params[:id])
    is_owner = (@requisition.initiated_by == current_user.employee_id)
    is_supervisor = current_user.employee.current_supervisees.collect do |x|
      x.supervisee
    end.include?(@requisition.initiated_by)
    @possible_actions = possible_actions(@requisition.workflow_state_id, is_owner, is_supervisor)
    # raise @possible_actions.inspect
  end

  def new
    @requisition = Requisition.new
    @selected_request = params['request_type']

    @project_options = Project.all.collect { |x| [x.project_name, x.id] }
    @selected_project = Project.find_by_short_name(params[:prj])

    case @selected_request
    when 'Petty Cash'
      @petty_cash_limit = GlobalProperty.petty_cash_limit.to_f
    when 'Asset Request'
      @asset_types = AssetCategory.all.collect { |x| x.category }
    when 'Purchase Request'

    when 'Travel Request'
      @employees = Employee.where(still_employed: true).collect { |x| x.person.full_name }
    when 'Personnel Requests'

    when 'Token Request'
      @token = SecureRandom.alphanumeric
      TokenLog.create(token: @token)
      # send_data @token,  :filename => "requested_token.txt"

    when 'Leave Request'
      @annual_leave_bal = LeaveSummary.where(employee_id: current_user.employee.id,
                                             leave_type: 'Annual Leave', financial_year: Date.today.year).first_or_create(leave_days_balance: 0.0, leave_days_total: 0.0)

      @sick_leave_bal = LeaveSummary.where(employee_id: current_user.employee.id,
                                           leave_type: 'Sick Leave', financial_year: Date.today.year).first_or_create(leave_days_balance: 0.0, leave_days_total: 0.0)

      @compassionate_leave_bal = LeaveSummary.where(employee_id: current_user.employee.id,
                                                    leave_type: 'Compassionate Leave', financial_year: Date.today.year).first_or_create(leave_days_balance: 0.0, leave_days_total: 0.0)
      @employees = Employee.where(still_employed: true)
                           .collect do |x|
        [x.person.full_name,
         x.employee_id]
      end - [[current_user.employee.person.full_name, current_user.employee_id]]
    end
  end

  def create
    state_id = InitialState.find_by_workflow_process_id(WorkflowProcess.find_by_workflow('Petty Cash Request')).workflow_state_id
    ActiveRecord::Base.transaction do
      @requisition = Requisition.create(purpose: params[:requisition][:purpose],
                                        initiated_by: current_user.id,
                                        initiated_on: Date.today,
                                        requisition_type: params[:requisition][:requisition_type],
                                        workflow_state_id: state_id,
                                        project_id: params[:requisition][:project_id])
      RequisitionItem.create(requisition_id: @requisition.id, value: params[:requisition][:amount], quantity: 1.0,
                             item_description: 'Petty Cash')
    end

    if @requisition.errors.empty?
      supervisor = current_user.employee.supervisor
      
      begin
        # Debugging line - log that we're attempting to send
        Rails.logger.info "Attempting to send email to #{supervisor.email}"
        
        # Send email
        RequisitionMailer.notify_supervisor(@requisition, supervisor).deliver_now
        
        flash[:notice] = 'Request successful. An email has been sent to your supervisor.'
      rescue StandardError => e
        Rails.logger.error("EMAIL FAILED: #{e.message}\n#{e.backtrace.join("\n")}")
        flash[:alert] = "Request saved, but failed to send email notification. Please notify your supervisor manually."
      end
      redirect_to "/requisitions/#{@requisition.id}"
    else
      flash[:error] = 'Request failed'
    end
  end

  def edit
  end

  def approve_request
    # raise @transition_state.inspect
    new_state = WorkflowState.where(state: 'Approved',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Petty Cash Request').id)
    @requisition = Requisition.where(requisition_id: params[:id])
                              .update(reviewed_by: current_user.user_id, workflow_state_id: new_state.first.id)

    redirect_to "/requisitions/#{params[:id]}"
  end

  def approve_funds
    # raise @transition_state.inspect
    new_state = WorkflowState.where(state: 'Finances Approved',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Petty Cash Request').id)
    @requisition = Requisition.where(requisition_id: params[:id])
                              .update(approved_by: current_user.user_id, workflow_state_id: new_state.first.id)

    redirect_to "/requisitions/#{params[:id]}"
  end

  def deny_funds
    new_state = WorkflowState.where(state: 'Finances Rejected',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Petty Cash Request').id)
    @requisition = Requisition.where(requisition_id: params[:id])
                              .update(approved_by: current_user.user_id, workflow_state_id: new_state.first.id)

    redirect_to "/requisitions/#{params[:id]}"
  end

  def release_funds
    new_state = WorkflowState.where(state: 'Prepared',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Petty Cash Request').id)
    @requisition = Requisition.where(requisition_id: params[:id])
                              .update(approved_by: current_user.user_id, workflow_state_id: new_state.first.id)

    redirect_to "/requisitions/#{params[:id]}"
  end

  def rescind_request
    new_state = WorkflowState.where(state: 'Rescinded',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Petty Cash Request').id)
    @requisition = Requisition.find(params[:id]).update(voided: true, workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
  end

  def reject_request
    new_state = WorkflowState.where(state: 'Rejected',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Petty Cash Request').id)
    @requisition = Requisition.find(params[:id]).update(workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
  end

  def collect_funds
    new_state = WorkflowState.where(state: 'Collected',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Petty Cash Request').id)
    @requisition = Requisition.find(params[:id]).update(workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
  end

  def task_params
    params.require(:requisition).permit(:purpose, :project_id, :initiated_by, :initiated_on, :requisition_type,
                                        :workflow_state_id, :amount)
  end
end
