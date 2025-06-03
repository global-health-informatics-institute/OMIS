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
    # Initialize the employee ID that will be used to fetch or create the timesheet
    target_employee_id = current_user.employee_id

    # Initialize @timesheet to nil
    @timesheet = nil
    if params[:period].present?
      week = Date.parse(params[:period]).beginning_of_week.strftime("%Y-%m-%d")
      if params[:employee_id].present? && current_user.supervisor?
        target_employee_id = params[:employee_id]
      end

      # Fetch or create the timesheet for the determined employee_id and the given week.
      @timesheet = Timesheet.where(timesheet_week: week, employee_id: target_employee_id).first_or_create
    elsif params[:id].present? && params[:id].to_s.match?(/\A\d+\z/) # Checks if string consists only of digits
      begin
        @timesheet = Timesheet.find(params[:id])
        # If a timesheet is found by ID, update target_employee_id to match the timesheet's owner.
        target_employee_id = @timesheet.employee_id
      rescue ActiveRecord::RecordNotFound
        # If ID is invalid (e.g., not found), @timesheet remains nil, and fallback logic will apply.
        Rails.logger.warn "Timesheet with ID #{params[:id]} not found. Falling back to default timesheet."
        @timesheet = nil # Ensure @timesheet is nil so fallback can apply
      end
    end

    unless @timesheet
      week = Date.current.beginning_of_week.strftime("%Y-%m-%d")
      @timesheet = Timesheet.where(timesheet_week: week, employee_id: current_user.employee_id).first_or_create
    end

    # --- NEW LOGIC: Check for previous timesheet ---
    # This check should happen after @timesheet is guaranteed to be set.
    @has_previous_timesheet = Timesheet.exists?(
      employee_id: @timesheet.employee_id,
      timesheet_week: @timesheet.timesheet_week.prev_week.beginning_of_week # Ensure we compare beginning of week
    )

    is_owner = (@timesheet.employee_id == current_user.employee_id)
    # Determine if the current user is a supervisor of the timesheet's employee.
    is_supervisor = current_user.employee.current_supervisees.collect{|x| x.supervisee}.include?(@timesheet.employee_id)

    unless is_owner || is_supervisor
      raise ActionController::RoutingError.new('Not Found')
    end

    # Determine possible actions based on timesheet state and user roles.
    @possible_actions = possible_actions(@timesheet.state, is_owner, is_supervisor)

    # Retrieve the Employee object associated with the timesheet.
    @person = Employee.find(@timesheet.employee_id)

    # --- Timesheet Records Processing ---
    @records = {} # Initialize hash to store structured timesheet task data.
    # Select specific attributes from timesheet tasks for efficiency.
    records = @timesheet.timesheet_tasks.select("project_id, task_date,description, duration, id").each do |v|
      # Structure the records by project_id, then description, then day of the week.
      @records[v.project_id] ||= {} # Initialize project hash if not present
      @records[v.project_id][v.description] ||= {} # Initialize description hash if not present
      # Store duration (rounded) and task ID for the specific day.
      @records[v.project_id][v.description][v.task_date.cwday] = {duration: v.duration.floor(2),id: v.id}
    end

    # Retrieve project details for projects referenced in the timesheet tasks.
    @projects = Project.where(project_id: records.collect{|p| p.project_id}.uniq).collect { |x| [x.project_id, x.short_name] }.to_h
    # Retrieve all projects for dropdown options (e.g., when adding new tasks).
    @project_options = Project.all.collect { |x| [x.project_name, x.id] }

    # --- Respond to Different Formats ---
    respond_to do |format|
      format.html # Renders the HTML view (e.g., show.html.erb)
      format.json{render json: @user} # NOTE: This might be a bug. Consider rendering @timesheet or relevant data.
      format.xsl do
        # Generate and send an Excel spreadsheet.
        helpers.weekly_spreadsheet(@records, @projects, @timesheet)
        send_file("tmp/timesheet.xls", :filename => "#{@person.person.full_name}.xls")
      end
      format.pdf do
        # Generate and send a PDF document.
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
    rejection_reason = params[:description]
    Rails.logger.debug "Rejection Reason captured: '#{rejection_reason}'"

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
    if @timesheet.update(state: next_state.id, submitted_on: nil) # Updated based on your Timesheet model structure
      Rails.logger.debug "--- Timesheet updated successfully to state ID #{next_state.id} ---"
      # Create a new comment record
      comment = @timesheet.comments.create(description: rejection_reason, workflow_state_id: next_state.id) # You might have a 'comment_type' column

      Rails.logger.debug "--- Timesheet updated successfully to state ID #{next_state.id} ---"
      Rails.logger.debug "--- Rejection reason saved to comments table ---"

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
end
