class PurchaseRequestsController < ApplicationController
  def new
    @requisition = Requisition.new(requisition_type: "Purchase Request")
    @requisition.requisition_items.build
    @department_options = Department.all.collect { |x| [x.department_name, x.id] }
    @selected_department = Department.find_by_department_name(params[:department_name]) if params[:department_name].present?
  end

def create
  # 1. Find workflow configuration
  workflow_process = WorkflowProcess.find_by(workflow: 'Purchase Request')
  initial_state = InitialState.find_by(workflow_process_id: workflow_process.id) if workflow_process

  # 2. Initialize requisition with params
  @requisition = Requisition.new(
    initiated_by: current_user.id,
    initiated_on: params[:requisition][:initiated_on] || Date.today,
    purpose: params[:requisition][:purpose],
    requisition_type: "Purchase Request",
    workflow_state_id: initial_state&.workflow_state_id
  )

  # 3. Save all records in transaction
  ActiveRecord::Base.transaction do
    if @requisition.save
      # Create requisition item
      RequisitionItem.create(
        requisition_id: @requisition.id,
        quantity: params[:requisition][:quantity],
        item_description: params[:requisition][:item_description],
        value: params[:requisition][:amount] || 0
      )

      # Create attachment
      PurchaseRequestAttachment.create(
        requisition_id: @requisition.id,
        department_id: params[:requisition][:department_id],
        comments: params[:requisition][:comments],
        voided: false
      )

      # Success response
      if @requisition.errors.empty?
        # supervisor = current_user.employee.supervisor
        # RequisitionMailer.notify_supervisor(@requisition, supervisor).deliver_now
        flash[:notice] = 'Purchase Request successful sent to your supervisor.'
        redirect_to "/requisitions/#{@requisition.id}"
      else
        flash[:error] = 'Request failed'
        render :new
      end
    else
      flash[:error] = 'Request failed to save'
      render :new
    end
  end
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
    @requisition = Requisition.find(params[:id])

    new_state = WorkflowState.find_by(state: 'Procured',
                                      workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)

    unless new_state
      flash[:error] = "Error: 'Procured' workflow state not found."
      redirect_to "/requisitions/#{params[:id]}" and return
    end
    # Get the approved amount from the form parameters
    approved_amount = params[:requisition][:amount] # This is where the amount comes from the form

    ActiveRecord::Base.transaction do
      # Update the Requisition's state and approved_by
      @requisition.update!(approved_by: current_user.id, workflow_state_id: new_state.id)
      if @requisition.requisition_items.any?
        @requisition.requisition_items.first.update!(value: approved_amount)
      end
    end
    redirect_to "/requisitions/#{@requisition.id}", notice: "Procurement completed successfully."
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Purchase Request not found."
    redirect_to "/requisitions/#{params[:id]}"
  rescue ActiveRecord::RecordInvalid => e
    # Catch validation errors from @requisition.update! or RequisitionItem.update!
    flash[:error] = "Failed to complete procurement: #{e.message}"
   redirect_to "/requisitions/#{params[:id]}" and return# Render the show view to display errors
  rescue StandardError => e
    flash[:error] = "An unexpected error occurred: #{e.message}"
    redirect_to "/requisitions/#{params[:id]}" and return
  end

  private

  def purchase_request_params
    params.require(:requisition).permit(
      :initiated_on,
      :initiated_by,
      # :item_requested,
      :project_id,
      :requisition_type,
      :purpose,
      :workflow_state_id,
      :quantity,
      :item_description,
      :amount,
      :department_id,
      :comments 
    )
  end
end