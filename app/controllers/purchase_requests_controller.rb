class PurchaseRequestsController < ApplicationController
  def new
    @requisition = Requisition.new(requisition_type: "Purchase Request")
    @requisition.requisition_items.build
    @project_options = Project.all.collect { |x| [x.project_name, x.id] }
    @selected_project = Project.find_by_short_name(params[:prj])
  end

 def create
    # Determine the initial workflow state for Purchase Request
    state_id = InitialState.find_by_workflow_process_id(
      WorkflowProcess.find_by_workflow('Purchase Request')
    ).workflow_state_id

    # Initialize Requisition object with core parameters
    @requisition = Requisition.new(
      purpose: params[:requisition][:item_requested],
      initiated_by: current_user.id,
      initiated_on: params[:requisition][:initiated_on] || Date.today,
      requisition_type: "Purchase Request", 
      workflow_state_id: state_id,
      project_id: params[:requisition][:project_id]
    )

    ActiveRecord::Base.transaction do
      # Save the Requisition first
      raise ActiveRecord::Rollback unless @requisition.save
      RequisitionItem.create!(
        requisition_id: @requisition.id,
        quantity: params[:requisition][:quantity],
        item_description: params[:requisition][:item_description],
        value: 0 # Default value, or nil, as amount isn't used for PR
      )
    end # End of transaction block

    if @requisition.errors.empty?
     # supervisor = current_user.employee.supervisor

      # Send email (assuming this is only for PR now)
      #RequisitionMailer.notify_supervisor(@requisition, supervisor).deliver_now

      flash[:notice] = 'Purchase Request successful.'
      redirect_to "/requisitions/#{@requisition.id}" # Consider using Rails' path helpers
    else
      flash[:error] = 'Purchase Request failed.'
      render :new # Rerender the form with validation errors
    end
  rescue ActiveRecord::RecordInvalid => e
    # Catch validation errors from @requisition.save or RequisitionItem.create!
    flash[:error] = "Purchase Request failed: #{e.message}"
    render :new
  rescue StandardError => e
    # Catch any other unexpected errors during the process
    flash[:error] = "An unexpected error occurred: #{e.message}"
    render :new
  end

  def show
  @requisition = Requisition.find(params[:id])
  @project_options = Project.all.collect { |x| [x.project_name, x.id] }
  @selected_project = @requisition.project
  @projects = Project.all
end
def approve_request
  new_state = WorkflowState.where(state: 'Approved',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
    @requisition = Requisition.find(params[:id]).update(reviewed_by: current_user.id, workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
end
def reject_request
   new_state = WorkflowState.where(state: 'Rejected',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
    @requisition = Requisition.find(params[:id]).update(reviewed_by: current_user.id, workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
end
  def start_procurement
    new_state = WorkflowState.where(state: 'Under Procurement',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
    @requisition = Requisition.find(params[:id]).update(workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
  end
  def complete_procurement 
    new_state = WorkflowState.where(state: 'Procured',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
    @requisition = Requisition.find(params[:id]).update(approved_by: current_user.id, workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
  end

  private

  def purchase_request_params
    params.require(:requisition).permit(
      :initiated_on,
      :initiated_by,
      :item_requested,
      :project_id,
      :requisition_type,
      :purpose,
      :workflow_state_id,
      :quantity,
      :item_description
    )
  end
end