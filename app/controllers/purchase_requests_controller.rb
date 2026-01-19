class PurchaseRequestsController < ApplicationController

  before_action :set_categories, only: [:new, :register_asset, :show, :create]
  before_action :set_employees, only: [:new, :show, :create, :edit, :update, :request_payment]
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

  def register_asset
  @requisition = Requisition.find(params[:id])
  @asset = @requisition.assets.build(asset_params)

  respond_to do |format|
    if @asset.save
      format.html { redirect_to requisition_path(@requisition), notice: "Asset registered successfully." }
      format.js   # Will render register_asset.js.erb
    else
      format.html { render :final_step_view, status: :unprocessable_entity }
      format.js   # Will render register_asset.js.erb with errors
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
    new_state = WorkflowState.where(state: 'Under Procurement',
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

  def initiate_payment_request
    new_state = WorkflowState.where(state: 'Pending Payment Request',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
    @requisition = Requisition.find(params[:id]).update(workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
  end

  def schedule_ipc_meeting
  requisition = Requisition.find(params[:id])
    employee_ids = params[:employee_ids]
    meeting_date = Date.parse(params[:meeting_date])
     raise "Missing meeting date" unless meeting_date.present?
    employees = Employee.where(id: employee_ids)
    raise "No employees selected" if employees.empty?
    employees.each do |employee|
    RequisitionMailer.notify_ipc_members(requisition, employee, meeting_date).deliver_later
  end

  render json: { message: "Emails sent successfully" }, status: :ok
    rescue => e
    logger.error "Failed to schedule IPC meeting: #{e.message}"
    render json: { error: "Failed to send invitations" }, status: :internal_server_error
 end


  def request_payments
    @requisition = Requisition.find(params[:id])
    current_state = @requisition.workflow_state&.state # Get the current state
     cleaned_amount_string = params[:requisition][:amount].gsub(',', '')
  approved_amount = cleaned_amount_string.to_f # Ensure it's a float for comparison
    supplier = params[:requisition][:supplier]

    new_state = WorkflowState.find_by(
      state: 'Payments Requested',
      workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request')&.id
    )

    unless new_state
      flash[:error] = "Error: 'Payment Requested' workflow state not found."
      redirect_to "/requisitions/#{params[:id]}" and return
    end

    # Apply the threshold check only when the requisition is 'Under Procurement'
    if current_state == 'Pending Payment Request'
      threshold = GlobalProperty.purchase_request_threshold
      if approved_amount <= threshold
        process_payment_request_and_update(@requisition, new_state, approved_amount, supplier)
      else
        flash[:alert] = "The approved amount (£#{'%.2f' % approved_amount}) exceeds the purchase request threshold (£#{'%.2f' % threshold}).Please Request IPC."
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
  def request_payment
    @requisition = Requisition.find(params[:id])
    current_state = @requisition.workflow_state&.state # Get the current state
      cleaned_amount_string = params[:requisition][:amount].gsub(',', '')
  approved_amount = cleaned_amount_string.to_f

    supplier = params[:requisition][:supplier]

    # Check if this is an LPO issuance
    if params[:commit] == "Issue LPO"
      lpo_new_state = WorkflowState.find_by(
        state: 'LPO Issued',
        workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request')&.id
      )

      unless lpo_new_state
        flash[:error] = "Error: 'LPO Issued' workflow state not found."
        redirect_to "/requisitions/#{@requisition.id}" and return
      end

      # Validate supplier presence
      if supplier.blank?
        flash[:error] = "Supplier name is required before issuing LPO."
        redirect_to "/requisitions/#{@requisition.id}" and return
      end

      # Validate amount presence
      if approved_amount <= 0
        flash[:error] = "Total amount must be greater than 0 before issuing LPO."
        redirect_to "/requisitions/#{@requisition.id}" and return
      end

      # Apply threshold check when requisition is in appropriate state
      if current_state == 'Pending Payment Request'
        threshold = GlobalProperty.purchase_request_threshold
        if approved_amount <= threshold
          process_lpo_issuance_and_update(@requisition, lpo_new_state, approved_amount, supplier)
        else
          flash[:alert] = "The approved amount (£#{'%.2f' % approved_amount}) exceeds the purchase request threshold (£#{'%.2f' % threshold}). Please Request IPC."
          redirect_to "/requisitions/#{@requisition.id}" and return
        end
      else
        # For any other state, proceed with LPO issuance without threshold check
        process_lpo_issuance_and_update(@requisition, lpo_new_state, approved_amount, supplier)
      end
      return
    end

    # Original payment request logic
    new_state = WorkflowState.find_by(
      state: 'Payment Requested',
      workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request')&.id
    )

    unless new_state
      flash[:error] = "Error: 'Payment Requested' workflow state not found."    
      redirect_to "/requisitions/#{@requisition.id}" and return
    end

    # Apply the threshold check only when the requisition is 'Under Procurement'
    if current_state == 'Pending Payment Request'
      threshold = GlobalProperty.purchase_request_threshold
      if approved_amount <= threshold
        process_payment_request_and_update(@requisition, new_state, approved_amount, supplier)
      else
        flash[:alert] = "The approved amount (£#{'%.2f' % approved_amount}) exceeds the purchase request threshold (£#{'%.2f' % threshold}).Please Request IPC."
        redirect_to "/requisitions/#{@requisition.id}" and return
      end
    else
      # For any other state, proceed with the payment request without a threshold check.
      process_payment_request_and_update(@requisition, new_state, approved_amount, supplier)
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Purchase Request not found."
    redirect_to "/requisitions/#{@requisition.id}"
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "Failed to complete procurement: #{e.message}"
    redirect_to "/requisitions/#{@requisition.id}"
  rescue StandardError => e
    flash[:error] = "An unexpected error occurred: #{e.message}"
    redirect_to "/requisitions/#{@requisition.id}"
  end

  def approve_funds
    new_state = WorkflowState.where(state: 'Funds Approved',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
    @requisition = Requisition.find(params[:id]).update(workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
  end

  def reject_funds
    new_state = WorkflowState.where(state: 'Funds Rejected',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
    @requisition = Requisition.find(params[:id]).update(workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
  end

  def confirm_delivery
    new_state = WorkflowState.where(state: 'Delivered',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
    @requisition = Requisition.find(params[:id]).update(workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
  end
  def withdraw_request
    new_state = WorkflowState.where(state: 'Withdrawn',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
    @requisition = Requisition.find(params[:id]).update(approved_by: current_user.id, workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
  end

  def confirm_lpo_acceptance
    @requisition = Requisition.find(params[:id])
    current_state = @requisition.workflow_state&.state
    
    # Get and validate parameters
    cleaned_amount_string = params[:requisition][:amount].gsub(',', '')
    approved_amount = cleaned_amount_string.to_f
    supplier = params[:requisition][:supplier]

    new_state = WorkflowState.find_by(
      state: 'LPO Issued',
      workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request')&.id
    )

    unless new_state
      flash[:error] = "Error: 'LPO Issued' workflow state not found."
      redirect_to "/requisitions/#{@requisition.id}" and return
    end

    # Validate supplier presence
    if supplier.blank?
      flash[:error] = "Supplier name is required before issuing LPO."
      redirect_to "/requisitions/#{@requisition.id}" and return
    end

    # Validate amount presence
    if approved_amount <= 0
      flash[:error] = "Total amount must be greater than 0 before issuing LPO."
      redirect_to "/requisitions/#{@requisition.id}" and return
    end

    # Apply threshold check when requisition is in appropriate state
    if current_state == 'Pending Payment Request'
      threshold = GlobalProperty.purchase_request_threshold
      if approved_amount <= threshold
        process_lpo_issuance_and_update(@requisition, new_state, approved_amount, supplier)
      else
        flash[:alert] = "The approved amount (£#{'%.2f' % approved_amount}) exceeds the purchase request threshold (£#{'%.2f' % threshold}). Please Request IPC."
        redirect_to "/requisitions/#{@requisition.id}" and return
      end
    else
      # For any other state, proceed with LPO issuance without threshold check
      process_lpo_issuance_and_update(@requisition, new_state, approved_amount, supplier)
    end
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Purchase Request not found."
    redirect_to "/requisitions/#{@requisition.id}"
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "Failed to issue LPO: #{e.message}"
    redirect_to "/requisitions/#{@requisition.id}"
  rescue StandardError => e
    flash[:error] = "An unexpected error occurred: #{e.message}"
    redirect_to "/requisitions/#{@requisition.id}"
  end

  # Handle form submission for LPO issuance (PATCH method)
  def confirm_lpo_acceptance_form
    confirm_lpo_acceptance
  end
 def accept_item
   requisition = Requisition.find(params[:id])
   transition = WorkflowStateTransition.find_by(workflow_state_id: requisition.workflow_state_id, action: 'Accept Item')
 
   if transition.nil?
     flash[:error] = 'Accept Item workflow transition is not configured for the current state.'
     return redirect_to "/requisitions/#{params[:id]}"
   end
 
   requisition.update(workflow_state_id: transition.next_state)
   redirect_to "/requisitions/#{params[:id]}" 
 end
 def reject_item
   new_state = WorkflowState.where(state: 'Item Rejected',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
     @requisition = Requisition.find(params[:id]).update(workflow_state_id: new_state.first.id)
     redirect_to "/requisitions/#{params[:id]}"
 end
def finish_process
  new_state = WorkflowState.where(state: 'Process Completed',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
    @requisition = Requisition.find(params[:id]).update(workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
end
def rescind_request
  new_state = WorkflowState.where(state: 'Rescinded',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
    @requisition = Requisition.find(params[:id]).update(workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
end
def confirm_item_delivery
  new_state = WorkflowState.where(state: 'Item Delivered',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
    @requisition = Requisition.find(params[:id]).update(workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
end
def approve_payments
  new_state = WorkflowState.where(state: 'Funds Approved',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
    @requisition = Requisition.find(params[:id]).update(workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
end
def approve_item
   new_state = WorkflowState.where(state: 'Item Approved',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Purchase Request').id)
    @requisition = Requisition.find(params[:id]).update(workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
end 
  private
  def set_employees
      @employees = Employee.includes(:person).all.sort_by { |e| e.person.full_name }
  end
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

  # This helper method encapsulates the common logic for processing LPO issuance
  def process_lpo_issuance_and_update(requisition, new_state, approved_amount, supplier)
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
    flash[:notice] = "LPO issued successfully."
    redirect_to "/requisitions/#{requisition.id}"
  end

  def asset_params
     params.require(:requisition).permit(
    :asset_category_id, :description, :make, :model, :serial_number, :location, :value, :requisition_id, :tag_id, :status
     )
  end

   def set_categories
    @categories = AssetCategory.pluck(:category, :id)
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