class RequisitionsController < ApplicationController
  # before_action :show
  skip_before_action :verify_authenticity_token, only: %i[approve_request reject_request approve_funds deny_funds]
  skip_before_action :logged_in?, only: %i[approve_request reject_request approve_funds deny_funds]
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
      render :new
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

        update_success = @requisition.update(
          workflow_state_id: new_state.id,
          approval_token: nil,
          reviewed_by: params[:reviewer_first_name] # Storing person.first_name directly
        )

        if update_success
          RequisitionMailer.request_approved_email(@requisition).deliver_now

          admin_users = User.joins(employee: :employee_designations)
                            .where(employee_designations: { designation_id: 12 })
                            .distinct

          admin_users.each do |admin|
            RequisitionMailer.notify_admin(@requisition, admin).deliver_now
          end

          # Render a plain success message for email approval
          render plain: 'Requisition approved successfully and admin has notified. You can now close this window.', layout: false
        else
          render plain: 'Error approving requisition via email. Please try again or contact support.', status: :unprocessable_entity, layout: false
        end
      elsif current_user
        # Approval within the application (user is logged in)
        new_state = WorkflowState.find_by(
          state: 'Approved',
          workflow_process_id: WorkflowProcess.find_by_workflow('Petty Cash Request').id
        )

        if @requisition.update(workflow_state_id: new_state.id, reviewed_by: current_user.user_id)
          RequisitionMailer.request_approved_email(@requisition).deliver_now

          admin_users = User.joins(employee: :employee_designations)
                            .where(employee_designations: { designation_id: 12 })
                            .distinct

          admin_users.each do |admin|
            RequisitionMailer.notify_admin(@requisition, admin).deliver_now
          end

          flash[:notice] = 'Requisition approved and notifications sent.'
          redirect_to "/requisitions/#{@requisition.id}"
        else
          flash[:alert] = 'Error approving requisition.'
          redirect_to "/requisitions/#{@requisition.id}"
        end
      else
        flash[:alert] = 'Invalid approval request.'
        redirect_to "/requisitions/#{@requisition.id}"
      end
    else
      flash[:alert] = 'Requisition not found.'
      redirect_to "/requisitions/#{@requisition.id}"
    end
  end

  def reject_request
    @requisition = Requisition.find_by(requisition_id: params[:id])

    if @requisition
      if params[:rejection_token].present?
        # Rejection via email (token is present)
        workflow_process = WorkflowProcess.find_by(workflow: 'Petty Cash Request')
        rejected_state = WorkflowState.find_by(state: 'Rejected', workflow_process_id: workflow_process.id)

        if @requisition.update(workflow_state_id: rejected_state.id, rejection_token: nil)
          # Notify the requester
          recipient_email = @requisition&.user&.email
          if recipient_email.present?
            RequisitionMailer.rejected_request_email(@requisition).deliver_now
            render plain: 'Requisition rejected successfully. You can now close this window.', layout: false
          else
            Rails.logger.warn "No recipient email for requisition ##{@requisition.id}"
            render plain: 'Requisition rejected and email sent to the requester for review, but no confirmation email was sent (missing recipient email). You can now close this window.', layout: false
          end
        else
          render plain: 'Error rejecting requisition via email. Please try again or contact support.', status: :unprocessable_entity, layout: false
        end
      elsif current_user
        # if @requisition.reason.blank?
        #   flash[:alert] = 'Reason is required when rejecting a request'
        #   redirect_to "/requisitions/#{@requisition.id}"
        #   return
        # end
        # Rejection within the application (token is absent, user is logged in)
        workflow_process = WorkflowProcess.find_by(workflow: 'Petty Cash Request')
        rejected_state = WorkflowState.find_by(state: 'Rejected', workflow_process_id: workflow_process.id)

        if @requisition.update(reviewed_by: current_user.user_id, workflow_state_id: rejected_state.id)
          # Notify the requester
          recipient_email = @requisition&.user&.email
          if recipient_email.present?
            RequisitionMailer.rejected_request_email(@requisition).deliver_now
            flash[:notice] = 'Requisition rejected.'
          else
            Rails.logger.warn "No recipient email for requisition ##{@requisition.id}"
            flash[:alert] = 'Requisition rejected, but no email was sent (missing recipient email).'
          end
          redirect_to "/requisitions/#{@requisition.id}"
          nil
        else
          flash[:alert] = 'Error rejecting requisition.'
          redirect_to "/requisitions/#{@requisition.id}"
          nil
        end
      else
        flash[:alert] = 'Invalid rejection request.'
        redirect_to "/requisitions/#{@requisition.id}"
        nil
      end
    else
      flash[:alert] = 'Requisition not found.'
      redirect_to "/requisitions/#{@requisition.id}"
      nil
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
    @requisition = Requisition.find_by(requisition_id: params[:id])
    unless @requisition
      flash[:alert] = 'Requisition not found.'
      return redirect_to "/requisitions/#{params[:id]}"
    end

    workflow_process = WorkflowProcess.find_by(workflow: 'Petty Cash Request')
    denied_state = WorkflowState.find_by(state: 'Finances Rejected', workflow_process_id: workflow_process.id)

    if params[:deny_funds_token].present?
      # Denial via email
      if @requisition.update(workflow_state_id: denied_state.id, deny_funds_token: nil)
        send_funds_denied_email(@requisition)
        render plain: 'Funds denied successfully and requester notified. You can now close this window.', layout: false and return
      else
        render plain: 'Error denying funds via email. Please try again or contact support.', status: :unprocessable_entity, layout: false and return
      end
    elsif current_user
      # Denial within the application
      if @requisition.update(approved_by: current_user.user_id, workflow_state_id: denied_state.id)
        send_funds_denied_email(@requisition)
        flash[:notice] = 'Funds denied and email sent to the requester.'
      else
        flash[:alert] = 'Error denying funds.'
      end
      redirect_to "/requisitions/#{@requisition.id}"
    else
      flash[:alert] = 'Invalid denial request.'
      redirect_to "/requisitions/#{@requisition.id}"
    end
  end
  
  def send_funds_denied_email(requisition)
    recipient_email = requisition&.user&.email
    if recipient_email.present?
      RequisitionMailer.funds_denied_email(requisition).deliver_now
    else
      Rails.logger.warn "No recipient email for requisition ##{requisition.id}"
      flash[:alert] = 'Funds denied, but no email was sent (missing recipient email).'
    end
  end
  

  def approve_funds
    @requisition = Requisition.find_by(requisition_id: params[:id])
    if @requisition
      if params[:approval_funds_token].present?
        # Approval via email (token is present)
        workflow_process = WorkflowProcess.find_by(workflow: 'Petty Cash Request')
        approved_state = WorkflowState.find_by(state: 'Prepared', workflow_process_id: workflow_process.id)

        if @requisition.update(workflow_state_id: approved_state.id, approval_funds_token: nil)
          recipient_email = @requisition&.user&.email
          if recipient_email.present?
            RequisitionMailer.funds_approved_email(@requisition).deliver_now
            # Instead of redirecting, we render a simple success message
            render plain: 'Funds approved successfully and requester notified . You can now close this window.', layout: false
          else
            Rails.logger.warn "No recipient email for requisition ##{@requisition.id}"
            render plain: 'Funds approved successfully, but no confirmation email was sent (missing recipient email). You can now close this window.', layout: false
          end
        else
          render plain: 'Error approving funds via email. Please try again or contact support.', status: :unprocessable_entity, layout: false
        end
      elsif current_user
        # Approval within the application (user is logged in)
        workflow_process = WorkflowProcess.find_by(workflow: 'Petty Cash Request')
        approved_state = WorkflowState.find_by(state: 'Prepared', workflow_process_id: workflow_process.id)

        if @requisition.update(approved_by: current_user.user_id, workflow_state_id: approved_state.id)
          recipient_email = @requisition&.user&.email
          if recipient_email.present?
            RequisitionMailer.funds_approved_email(@requisition).deliver_now
            flash[:notice] = 'Funds approved and requester notified.'
          else
            Rails.logger.warn "No recipient email for requisition ##{@requisition.id}"
            flash[:alert] = 'Funds approved, but no email was sent (missing recipient email).'
          end
          redirect_to "/requisitions/#{@requisition.id}"
          nil
        else
          flash[:alert] = 'Error approving funds.'
          redirect_to "/requisitions/#{@requisition.id}"
          nil
        end
      else
        flash[:alert] = 'Invalid approval request.'
        redirect_to "/requisitions/#{@requisition.id}"
        nil
      end
    else
      flash[:alert] = 'Requisition not found.'
      redirect_to "/requisitions/#{params[:id]}"
      nil
    end
  end

  def rescind_request
    new_state = WorkflowState.where(state: 'Rescinded',
                                    workflow_process_id: WorkflowProcess.find_by_workflow('Petty Cash Request').id)
    @requisition = Requisition.find(params[:id]).update(voided: true, workflow_state_id: new_state.first.id)
    redirect_to "/requisitions/#{params[:id]}"
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

  private

  def task_params
    params.require(:requisition).permit(:purpose, :project_id, :initiated_by, :initiated_on,
                                        :requisition_type, :workflow_state_id, :amount)
  end
end
