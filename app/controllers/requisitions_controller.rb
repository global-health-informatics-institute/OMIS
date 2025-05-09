class RequisitionsController < ApplicationController
  # before_action :show
  skip_before_action :verify_authenticity_token, only: :approve_request
  skip_before_action :logged_in?, only: :approve_request
  def index
  end

  def show
    @requisition = Requisition.find(params[:id])
    @projects = Project.all
    @petty_cash_limit = GlobalProperty.petty_cash_limit.to_f if @requisition.requisition_type == 'Petty Cash'
    is_owner = (@requisition.initiated_by == current_user.employee_id)
    is_supervisor = current_user.employee.current_supervisees.collect do |x|
      x.supervisee
    end.include?(@requisition.initiated_by)
    @possible_actions = possible_actions(@requisition.workflow_state_id, is_owner, is_supervisor)
    # raise @possible_actions.inspect
  end

  def update
    @requisition = Requisition.find(params[:id])

    # Ensure workflow_state_id has a value if it's being updated
    req_params = task_params
    if req_params[:workflow_state_id].blank?
      req_params[:workflow_state_id] = @requisition.workflow_state_id # keep existing if blank
    end

    # Update requisition items if amount is provided
    @requisition.requisition_items.first.update(value: req_params[:amount]) if req_params[:amount].present?

    if @requisition.update(req_params.except(:amount))
      redirect_to "/requisitions/#{@requisition.id}", notice: 'Requisition was successfully updated.'
    else
      render :edit
    end
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
    state_id = InitialState.find_by_workflow_process_id(
      WorkflowProcess.find_by_workflow('Petty Cash Request')
    ).workflow_state_id

    @requisition = Requisition.new(
      purpose: params[:requisition][:purpose],
      initiated_by: current_user.id,
      initiated_on: Date.today,
      requisition_type: params[:requisition][:requisition_type],
      workflow_state_id: state_id,
      project_id: params[:requisition][:project_id]
    )

    ActiveRecord::Base.transaction do
      raise ActiveRecord::Rollback unless @requisition.save # Save the requisition to trigger the callback

      RequisitionItem.create(
        requisition_id: @requisition.id,
        value: params[:requisition][:amount],
        quantity: 1.0,
        item_description: 'Petty Cash'
      )

      # If saving fails, rollback the transaction
    end

    if @requisition.errors.empty?
      supervisor = current_user.employee.supervisor

      # Send email without error checking
      RequisitionMailer.notify_supervisor(@requisition, supervisor).deliver_now

      flash[:notice] = 'Request successful. An email has been sent to your supervisor.'
      redirect_to "/requisitions/#{@requisition.id}"
    else
      flash[:error] = 'Request failed'
      render :new # Or wherever your new requisition form is
    end
  end

  def approve_request
    @requisition = Requisition.find_by(requisition_id: params[:id])

    if @requisition
      if params[:approval_token].present?
        # Approval via email (token is present)
        new_state = WorkflowState.find_by(
          state: 'Approved',
          workflow_process_id: WorkflowProcess.find_by_workflow('Petty Cash Request').id
        )

        if @requisition.update(workflow_state_id: new_state.id)
          @requisition.update(approval_token: nil) # One-time use
          # Send approval email
          recipient_email = @requisition&.user&.email
          if recipient_email.present?
            RequisitionMailer.request_approved_email(@requisition).deliver_now
            flash[:notice] = 'Requisition approved via email and notification sent.'
          else
            Rails.logger.warn "No recipient email for requisition ##{@requisition.id}"
            flash[:alert] = 'Requisition approved via email, but no notification sent (missing recipient email).'
          end
          redirect_to "/requisitions/#{@requisition.id}"
          return
        else
          flash[:alert] = 'Error approving requisition via email.'
          redirect_to "/requisitions/#{@requisition.id}"
          return
        end
      elsif current_user
        # Approval within the application (token is absent, user is logged in)
        new_state = WorkflowState.find_by(
          state: 'Approved',
          workflow_process_id: WorkflowProcess.find_by_workflow('Petty Cash Request').id
        )

        if @requisition.update(reviewed_by: current_user.user_id, workflow_state_id: new_state.id)
          # Send approval email
          recipient_email = @requisition&.user&.email
          if recipient_email.present?
            RequisitionMailer.request_approved_email(@requisition).deliver_now
            flash[:notice] = 'Requisition approved and notification sent.'
          else
            Rails.logger.warn "No recipient email for requisition ##{@requisition.id}"
            flash[:alert] = 'Requisition approved, but no notification sent (missing recipient email).'
          end
          redirect_to "/requisitions/#{@requisition.id}"
          return
        else
          flash[:alert] = 'Error approving requisition.'
          redirect_to "/requisitions/#{@requisition.id}"
          return
        end
      else
        flash[:alert] = 'Invalid approval request.'
        redirect_to "/requisitions/#{@requisition.id}"
        return
      end
    else
      flash[:alert] = 'Requisition not found.'
      redirect_to "/requisitions/#{@requisition.id}"
      return
    end
  end

  def resubmit_request
    @requisition = Requisition.find(params[:id])
    @projects = Project.all
    @petty_cash_limit = GlobalProperty.petty_cash_limit.to_f

    new_state = WorkflowState.find_by(
      state: 'Requested',
      workflow_process_id: WorkflowProcess.find_by_workflow('Petty Cash Request')&.id
    )

    if new_state.nil?
      flash[:alert] = 'Could not find workflow state for resubmission.'
      return redirect_to "/requisitions/#{@requisition.id}" # YOUR STYLE
    end
    amount_valid = true

    # Validate amount
    if params[:requisition][:amount].present?
      new_amount = params[:requisition][:amount].to_f
      if new_amount > @petty_cash_limit
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.replace('flash-messages',
                                   partial: 'layouts/flashes',
                                   locals: { flash: { notice: "Value must be less than or equal to MWK #{format(
                                     '%.2f', @petty_cash_limit
                                   )}" } }),
              turbo_stream.replace('requisition-form',
                                   partial: 'requisitions/requested_petty_cash',
                                   locals: { requisition: @requisition })
            ]
          end
          format.html { render :show }
        end
        return
      end
    end
    # Successful update

    if amount_valid && @requisition.update(
      purpose: params[:requisition][:purpose],
      project_id: params[:requisition][:project_id],
      requisition_type: params[:requisition][:requisition_type],
      workflow_state_id: new_state.id
    )
      if params[:requisition][:amount].present? && amount_valid # Re-check to be safe
        @requisition.requisition_items.first.update(value: new_amount)
      end

      supervisor = current_user.employee.supervisor
      RequisitionMailer.resubmitted_mail(@requisition, supervisor).deliver_now
      flash[:notice] = 'Requisition resubmitted successfully. An email has been sent to your supervisor.'
      redirect_to "/requisitions/#{@requisition.id}" # YOUR STYLE
    else
      flash.now[:alert] = 'Failed to update the requisition: ' +
                          @requisition.errors.full_messages.join(', ')
      render :show
    end
  end

  def deny_funds
    process = WorkflowProcess.find_by_workflow('Petty Cash Request')
    new_state = WorkflowState.find_by(state: 'Finances Rejected', workflow_process_id: process.id)

    @requisition = Requisition.find_by(requisition_id: params[:id])

    if @requisition.update(approved_by: current_user.user_id, workflow_state_id: new_state.id)
      recipient_email = @requisition&.user&.email

      if recipient_email.present?
        begin
          RequisitionMailer.funds_denied_email(@requisition).deliver_now
        rescue StandardError => e
          Rails.logger.error("Funds denial email failed to send: #{e.message}")
          flash[:alert] = 'Funds denied, but email could not be sent.'
        else
          flash[:notice] = 'Funds denied and requester notified.'
        end
      else
        Rails.logger.warn("No recipient email for requisition ##{@requisition.id}")
        flash[:alert] = 'Funds denied, but no email was sent (missing recipient email).'
      end
    else
      flash[:error] = 'Error denying funds.'
    end

    redirect_to "/requisition/#{@requisition.id}"
  end

  def approve_funds
    process = WorkflowProcess.find_by_workflow('Petty Cash Request')
    new_state = WorkflowState.find_by(state: 'Prepared', workflow_process_id: process.id)

    @requisition = Requisition.find_by(requisition_id: params[:id])

    if @requisition.update(approved_by: current_user.user_id, workflow_state_id: new_state.id)
      recipient_email = @requisition&.user&.email

      if recipient_email.present?
        begin
          RequisitionMailer.funds_approved_email(@requisition).deliver_now
        rescue StandardError => e
          Rails.logger.error("Email failed to send: #{e.message}")
          flash[:alert] = 'Funds approved, but email could not be sent.'
        else
          flash[:notice] = 'Funds approved and requester notified.'
        end
      else
        Rails.logger.warn("No recipient email for requisition ##{@requisition.id}")
        flash[:alert] = 'Funds approved, but no email was sent (missing recipient email).'
      end
    else
      flash[:error] = 'Error approving funds.'
    end

    redirect_to "/requisition/#{@requisition.id}"
  end

  def rescind_request
    new_state = WorkflowState.where(state: 'Rescinded',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Petty Cash Request').id)
    @requisition = Requisition.find(params[:id]).update(voided: true, workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
  end

  def reject_request
    workflow_process = WorkflowProcess.find_by(workflow: 'Petty Cash Request')
    new_state = WorkflowState.find_by(state: 'Rejected',
                                      workflow_process_id: workflow_process.id)

    @requisition = Requisition.find(params[:id])
    @requisition.update(workflow_state_id: new_state.id)

    if @requisition.update(reviewed_by: current_user.user_id,
                           workflow_state_id: new_state.id)
      # rejected_by: current_user.user_id
      recipient_email = @requisition&.user&.email

      if recipient_email.present?
        begin
          RequisitionMailer.rejected_request_email(@requisition).deliver_now
        rescue StandardError => e
          Rails.logger.error("Rejection email failed to send: #{e.message}")
          flash[:alert] = 'Request rejected, but email could not be sent.'
        else
          flash[:notice] = 'Request rejected and requester notified.'
        end
      else
        Rails.logger.warn("No recipient email for requisition ##{@requisition.id}")
        flash[:alert] = 'Request rejected, but no email was sent (missing recipient email).'
      end
    else
      flash[:error] = 'Error rejecting request.'
    end

    redirect_to "/requisition/#{@requisition.id}"
  end

  def recall_request
    new_state = WorkflowState.where(state: 'Recalled',
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

  # def task_params
  #   params.require(:requisition).permit(:purpose, :project_id, :initiated_by, :initiated_on, :requisition_type,
  #                                       :workflow_state_id, :amount)
  # end
  private

  private

  def task_params
    params.require(:requisition).permit(:purpose, :project_id, :initiated_by, :initiated_on,
                                        :requisition_type, :workflow_state_id, :amount)
  end
end
