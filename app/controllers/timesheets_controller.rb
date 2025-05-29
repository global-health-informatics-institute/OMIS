class TimesheetsController < ApplicationController
  before_action :show
  def index
  end

  def new
  end

  def create
  end

  def edit
  end
  def update

  end
  def destroy
  end
  def show
    if !params[:period].nil?
      week = Date.parse(params[:period]).beginning_of_week.strftime("%Y-%m-%d")
      @timesheet = Timesheet.where(timesheet_week: week, employee_id: current_user.employee_id).first_or_create
    else
      @timesheet = Timesheet.find(params[:id])
    end

    is_owner = (@timesheet.employee_id == current_user.employee_id)
    is_supervisor = current_user.employee.current_supervisees.collect{|x| x.supervisee}.include?(@timesheet.employee_id)
    @possible_actions = possible_actions(@timesheet.state, is_owner, is_supervisor)

    @person = Employee.find(@timesheet.employee_id)

    @records = {}
    records = @timesheet.timesheet_tasks.select("project_id, task_date,description, duration, id").each do |v|
      if @records[v.project_id].blank?
        @records[v.project_id] = {v.description => { v.task_date.cwday => v.duration.floor(2)}}
      elsif @records[v.project_id][v.description].blank?
        @records[v.project_id][v.description] = { v.task_date.cwday => v.duration.floor(2)}
      end
      @records[v.project_id][v.description][v.task_date.cwday] = {duration: v.duration.floor(2),id: v.id}
    end

    #raise @records.inspect
    @projects = Project.where(project_id: records.collect{|p| p.project_id}.uniq).collect { |x| [x.project_id, x.short_name] }.to_h
    @project_options = Project.all.collect { |x| [x.project_name, x.id] }

    respond_to do |format|
      format.html
      format.json{render json: @user}
      format.xsl do
        helpers.weekly_spreadsheet(@records, @projects, @timesheet)
        send_file("tmp/timesheet.xls", :filename => "#{@person.person.full_name}.xls")
      end
      format.pdf do
        helpers.weekly_pdf(@records,@projects, @timesheet)
        send_file("tmp/timesheet.pdf", :filename => "#{@person.person.full_name}.pdf")
      end
    end
  end

  def submit_timesheet
    next_state = WorkflowState.where(state: 'Submitted',
                                    workflow_process_id: WorkflowProcess.find_by_workflow("Timesheet").id).first
    @timesheet = Timesheet.find(params[:id]).update(submitted_on: Time.now(), state: next_state.id)
    redirect_to "/time_sheets/#{params[:id]}"
  end

  def approve_timesheet
    next_state = WorkflowState.where(state: 'Approved',
                                     workflow_process_id: WorkflowProcess.find_by_workflow("Timesheet").id).first
    @timesheet = Timesheet.find(params[:id]).update(approved_on: Time.now(), approved_by: current_user.user_id,
                                                    state: next_state.id)
    redirect_to "/time_sheets/#{params[:id]}"
  end

  def recall_timesheet
    next_state = WorkflowState.where(state: 'Recalled',
                                     workflow_process_id: WorkflowProcess.find_by_workflow("Timesheet").id).first
    @timesheet = Timesheet.find(params[:id]).update(submitted_on: nil, state: next_state.id)
    redirect_to "/time_sheets/#{params[:id]}"
  end

  def reopen_timesheet
    next_state = WorkflowState.where(state: 'Re-opened',
                                     workflow_process_id: WorkflowProcess.find_by_workflow("Timesheet").id).first
    @timesheet = Timesheet.find(params[:id]).update(submitted_on: nil, approved_by: nil, approved_on: nil, state: next_state.id)
    redirect_to "/time_sheets/#{params[:id]}"
  end

  def resubmit_timesheet
    next_state = WorkflowState.where(state: 'Re-submitted',
                                     workflow_process_id: WorkflowProcess.find_by_workflow("Timesheet").id).first
    @timesheet = Timesheet.find(params[:id]).update(submitted_on: Time.now(), state: next_state.id)
    redirect_to "/time_sheets/#{params[:id]}"
  end

  def reject_timesheet
    Rails.logger.debug "--- ENTERING reject_timesheet action ---"
    Rails.logger.debug "Params: #{params.inspect}"

    # Capture the rejection reason
    # If the modal form is working, params[:rejection_reason] should be present.
    rejection_reason = params[:rejection_reason]
    Rails.logger.debug "Rejection Reason captured: '#{rejection_reason}'"

    # --- Authorization check removed as per your request for now ---
    # !!! IMPORTANT: Remember to re-add robust authorization for production. !!!

    if rejection_reason.blank?
      Rails.logger.warn "--- REJECTION FAILED: Rejection reason is blank. ---"
      flash[:alert] = 'Rejection reason cannot be blank.'
      redirect_to timesheet_path(@timesheet) # Redirect back to the timesheet show page
      return
    end

    # Check if @timesheet is found by set_timesheet
    unless @timesheet
      Rails.logger.error "--- REJECTION FAILED: Timesheet not found by set_timesheet (ID: #{params[:id]}) ---"
      flash[:alert] = 'Timesheet not found.'
      redirect_to timesheets_path # Redirect to index if timesheet not found
      return
    end
    Rails.logger.debug "--- Timesheet found: ID #{@timesheet.id}, Current Status: #{@timesheet.current_status} ---"

    # Find next state
    timesheet_workflow = WorkflowProcess.find_by_workflow("Timesheet")
    if timesheet_workflow.nil?
      Rails.logger.error "--- REJECTION FAILED: 'Timesheet' workflow process not found. ---"
      flash[:alert] = 'System error: Timesheet workflow not configured.'
      redirect_to timesheet_path(@timesheet)
      return
    end

    next_state = WorkflowState.where(state: 'Rejected', workflow_process_id: timesheet_workflow.id).first
    if next_state.nil?
      Rails.logger.error "--- REJECTION FAILED: 'Rejected' workflow state for Timesheet workflow not found. ---"
      flash[:alert] = 'System error: Rejected state not configured for timesheet workflow.'
      redirect_to timesheet_path(@timesheet)
      return
    end
    Rails.logger.debug "--- Next state identified: ID #{next_state.id}, State: #{next_state.state} ---"

    # Attempt to update the timesheet
    # Ensure you are also saving the rejection_reason if you have a column for it in Timesheet model
    # For example, if you have a `rejection_reason` column in your Timesheet model:
    # if @timesheet.update(state: next_state.id, submitted_on: nil, rejection_reason: rejection_reason)
    if @timesheet.update(state: next_state.id, submitted_on: nil) # Updated based on your Timesheet model structure
      Rails.logger.debug "--- Timesheet updated successfully to state ID #{next_state.id} ---"

      # Get the recipient email
      recipient_email = @timesheet&.employee&.person&.official_email || @timesheet&.employee&.person&.email_address
      Rails.logger.debug "Recipient Email: #{recipient_email.inspect}"

      if recipient_email.present?
        Rails.logger.debug "--- Attempting to send rejection email ---"
        # Ensure your mailer method accepts two arguments now: timesheet and rejection_reason
        RequisitionMailer.timesheet_rejected_mail(@timesheet, rejection_reason).deliver_now
        flash[:notice] = 'Timesheet rejected and requester notified.'
      else
        Rails.logger.warn "--- Email not sent: Missing recipient email for Timesheet ID #{@timesheet.id} ---"
        flash[:alert] = 'Timesheet rejected, but no email was sent (missing recipient email).'
      end
      redirect_to timesheet_path(@timesheet)
    else
      Rails.logger.error "--- TIMESHEET UPDATE FAILED. Errors: #{@timesheet.errors.full_messages.join(', ')} ---"
      flash[:alert] = "Error rejecting timesheet: #{@timesheet.errors.full_messages.to_sentence}"
      redirect_to timesheet_path(@timesheet)
    end
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error "--- RESCUE: ActiveRecord::RecordNotFound for Timesheet ID #{params[:id]} ---"
    flash[:alert] = 'Timesheet not found.'
    redirect_to timesheets_path
  rescue StandardError => e
    Rails.logger.error "--- RESCUE: Unexpected error during rejection: #{e.class}: #{e.message} ---"
    Rails.logger.error e.backtrace.join("\n")
    flash[:alert] = 'An unexpected error occurred during timesheet rejection.'
    if @timesheet
      redirect_to timesheet_path(@timesheet)
    else
      redirect_to timesheets_path
    end
  ensure
    Rails.logger.debug "--- EXITING reject_timesheet action ---"
  end

  private

  # Ensure set_timesheet is called before reject_timesheet
  def set_timesheet
    @timesheet = Timesheet.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @timesheet = nil
  end

  # Add a strong params method if you plan to use `params.require(:timesheet).permit(:rejection_reason)`
  # If you are directly using `params[:rejection_reason]` this is not strictly necessary for this method.
  # def timesheet_params
  #   params.permit(:rejection_reason)
  # end
end
