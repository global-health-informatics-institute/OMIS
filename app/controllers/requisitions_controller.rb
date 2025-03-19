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
      @petty_cash_limit = Requisition.last&.petty_cash_limit || 35_000

    when 'Asset Request'
      @asset_types = AssetCategory.all.pluck(:category)
    when 'Travel Request'
      @employees = Employee.where(still_employed: true).pluck(:full_name)
    when 'Token Request'
      @token = SecureRandom.alphanumeric
      TokenLog.create(token: @token)
    end
  end

  # Creates a new requisition request
  def create
    @requisition = Requisition.new(requisition_params.merge(
                                     initiated_by: current_user.id,
                                     initiated_on: Date.today,
                                     workflow_state_id: initial_workflow_state
                                   ))

    if @requisition.save
      RequisitionItem.create(
        requisition_id: @requisition.id,
        value: params[:requisition][:amount].to_i,
        quantity: 1.0,
        item_description: 'Petty Cash'
      )

      flash[:notice] = 'Request submitted successfully.'
      redirect_to requisition_path(@requisition)
    else
      flash[:alert] = 'Request failed: ' + @requisition.errors.full_messages.join(', ')
      render :new
    end
  end

  private

  def initial_workflow_state
    WorkflowState.find_by(state: 'Requested')&.id # Ensure this matches your actual workflow state
  end

  # Approves a requisition request
  def approve_request
    update_requisition_status('Pending Review', 'Requisition is now pending review.')
  end

  # Rejects a requisition request
  def reject_request
    update_requisition_status('Rejected', 'Requisition has been rejected.')
  end

  # Approves funds for the requisition
  def approve_funds
    update_requisition_status('Finances Approved', 'Funds approved.')
  end

  # Marks the requisition as funds released
  def release_funds
    update_requisition_status('Prepared', 'Funds released.')
  end

  # Rescinds (cancels) a requisition
  def rescind_request
    if @requisition.update(voided: true, workflow_state_id: workflow_state_for('Rescinded'))
      flash[:notice] = 'Requisition has been rescinded.'
    else
      flash[:alert] = 'Failed to rescind requisition.'
    end
    redirect_to requisition_path(@requisition)
  end

  # Marks the requisition as funds collected
  def collect_funds
    update_requisition_status('Collected', 'Funds collected.')
  end

  private

  # Strong parameters to permit requisition attributes
  def requisition_params
    params.require(:requisition).permit(:purpose, :project_id, :requisition_type, :amount)
  end

  # Finds and sets the requisition before certain actions
  def set_requisition
    @requisition = Requisition.find_by(id: params[:id])
    return if @requisition

    flash[:alert] = 'Requisition not found.'
    redirect_to requisitions_path
  end

  # Returns the initial workflow state for new requisitions
  def initial_workflow_state
    WorkflowProcess.find_by(workflow: 'Petty Cash Request')&.initial_state&.workflow_state_id
  end

  # Updates the requisition's workflow state
  def update_requisition_status(new_state, success_message)
    state_id = workflow_state_for(new_state)
    return redirect_with_error('Workflow state not found.') unless state_id

    if @requisition.update(workflow_state_id: state_id, reviewed_by: current_user.id)
      flash[:notice] = success_message
    else
      flash[:alert] = 'Failed to update requisition.'
    end
    redirect_to requisition_path(@requisition)
  end

  # Finds the workflow state ID for a given state name
  def workflow_state_for(state)
    WorkflowState.find_by(state:,
                          workflow_process_id: WorkflowProcess.find_by(workflow: 'Petty Cash Request')&.id)&.id
  end

  # Redirects with an error message
  def redirect_with_error(message)
    flash[:alert] = message
    redirect_to requisition_path(params[:id])
  end

  private

  def requisition_params
    params.require(:requisition).permit(:amount, :description)
  end
end
