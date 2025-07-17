class PurchaseRequestsController < ApplicationController
  def new
    @requisition = Requisition.new(requisition_type: "Purchase Request")
    @requisition.requisition_items.build
    @department_options = Department.all.collect { |x| [x.department_name, x.id] }
    @selected_department = Department.find_by_department_name(params[:department_name]) if params[:department_name].present?

    # Load only stakeholders marked as donors
    @stakeholder_options = Stakeholder.where(is_donor: true).pluck(:stakeholder_name, :stakeholder_id)

    # Pre-select stakeholder if coming from params
    @selected_stakeholder = Stakeholder.find_by(stakeholder_id: params[:stakeholder_id]) if params[:stakeholder_id].present?
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
      workflow_state_id: initial_state&.workflow_state_id,
      department_id: params[:requisition][:department_id]
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
          stakeholder_id: params[:requisition][:stakeholder_id],
          comments: params[:requisition][:comments],
          item_requested: params[:requisition][:item_requested],
          supplier: params[:requisition][:supplier],
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

  def source_quotations
    new_state = WorkflowState.where(state: 'Under Procurement',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
    @requisition = Requisition.find(params[:id]).update(workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
  end

  def require_ipc
    new_state = WorkflowState.where(state: 'Under IPC',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
    @requisition = Requisition.find(params[:id]).update(workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
  end

  def request_payment
    @requisition = Requisition.find(params[:id])
    current_state = @requisition.workflow_state&.state # Get the current state
    approved_amount = params[:requisition][:amount].to_f # Ensure it's a float for comparison
    supplier = params[:requisition][:supplier]

    new_state = WorkflowState.find_by(
      state: 'Payment Requested',
      workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request')&.id
    )

    unless new_state
      flash[:error] = "Error: 'Payment Requested' workflow state not found."
      redirect_to "/requisitions/#{params[:id]}" and return
    end

    # Apply the threshold check only when the requisition is 'Under Procurement'
    if current_state == 'Under Procurement'
      threshold = GlobalProperty.purchase_request_threshold
      if approved_amount <= threshold
        process_payment_request_and_update(@requisition, new_state, approved_amount, supplier)
      else
        flash[:alert] = "The approved amount (£#{'%.2f' % approved_amount}) exceeds the purchase request threshold (£#{'%.2f' % threshold}). Cannot proceed with payment."
        redirect_to "/requisitions/#{@requisition.id}" and return
      end
    else
      # For any other state, proceed with the payment request without a threshold check.
      process_payment_request_and_update(@requisition, new_state, approved_amount, supplier)
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Purchase Request not found."
    redirect_to "/requisitions/#{params[:id]}"
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "Failed to complete procurement: #{e.message}"
    redirect_to "/requisitions/#{params[:id]}"
  rescue StandardError => e
    flash[:error] = "An unexpected error occurred: #{e.message}"
    redirect_to "/requisitions/#{params[:id]}"
  end

  def approve_funds
    new_state = WorkflowState.where(state: 'Funds Approved',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
    @requisition = Requisition.find(params[:id]).update(workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
  end

  def deny_funds
    new_state = WorkflowState.where(state: 'Funds Rejected',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
    @requisition = Requisition.find(params[:id]).update(workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
  end
  def toggle_ipc
  @requisition = Requisition.find(params[:id])
  attachment = @requisition.purchase_request_attachment

  if attachment.present?
    attachment.update(requires_ipc: ActiveModel::Type::Boolean.new.cast(params[:requires_ipc]))
  end

  respond_to do |format|
    format.turbo_stream { flash.now[:notice] = "IPC selection updated." }
    format.html { redirect_to requisition_path(@requisition), notice: "IPC selection updated." }
  end
end


  private

  # This helper method encapsulates the common logic for processing payment requests
  def process_payment_request_and_update(requisition, new_state, approved_amount, supplier)
    ActiveRecord::Base.transaction do
      # Update the Requisition's state and approved_by
      requisition.update!(approved_by: current_user.id, workflow_state_id: new_state.id)

      if requisition.requisition_items.any?
        requisition.requisition_items.first.update!(value: approved_amount)
      end

      # Update supplier in PurchaseRequestAttachment
      if supplier.present?
        attachment = requisition.purchase_request_attachment || requisition.build_purchase_request_attachment
        attachment.supplier = supplier
        attachment.save!
      end
    end
    flash[:notice] = "Payment request processed successfully."
    redirect_to "/requisitions/#{requisition.id}"
  end

  def purchase_request_params
    params.require(:requisition).permit(
      :initiated_on,
      :initiated_by,
      :project_id,
      :requisition_type,
      :purpose,
      :workflow_state_id,
      :quantity,
      :item_description,
      :amount,
      :department_id,
      :comments,
      :supplier,
      :item_requested,
      :stakeholder_id
    )
  end
end