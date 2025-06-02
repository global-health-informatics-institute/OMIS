# app/models/timesheet.rb
class Timesheet < ApplicationRecord
  has_many :timesheet_tasks, foreign_key: :timesheet_id
  belongs_to :employee, foreign_key: :employee_id
  # Removed has_one :project, foreign_key: :project_id - this is typically on timesheet_task
  # If a timesheet *always* belongs to a single project, keep it, but confirm your schema.
  belongs_to :workflow_state, foreign_key: :state # Assuming 'state' here is a foreign key to WorkflowState
  before_validation :assign_state, on: :create
  has_many :comments, dependent: :destroy
  # You might also want validations for other core fields, e.g.:
  validates :timesheet_week, presence: true, uniqueness: { scope: :employee_id }
  validates :employee_id, presence: true
  validates :state, presence: true # Ensuring a state is always assigned

  # --- Existing Methods ---

  def status
    # This method seems to return the same as current_status.
    # Consider consolidating them or clarifying their distinct purposes.
    WorkflowState.find(self.state).state rescue ''
  end

  def assign_state
    # --- START DEBUG LOGGING ---
    Rails.logger.debug "TIMESHEET CALLBACK: Entering assign_state for new timesheet."

    # Get WorkflowProcess
    initial_workflow_process = WorkflowProcess.find_by_workflow('Timesheet')
    Rails.logger.debug "TIMESHEET CALLBACK: Found WorkflowProcess: #{initial_workflow_process.inspect}"

    if initial_workflow_process.nil?
      self.errors.add(:state, "could not be assigned (WorkflowProcess 'Timesheet' not found)")
      Rails.logger.error "TIMESHEET CALLBACK ERROR: WorkflowProcess 'Timesheet' is NIL! Cannot assign state."
      return # Exit early if critical dependency is missing
    end

    # Get InitialState
    initial_workflow_state_record = InitialState.find_by_workflow_process_id(initial_workflow_process.id)
    Rails.logger.debug "TIMESHEET CALLBACK: Found InitialState record: #{initial_workflow_state_record.inspect}"

    if initial_workflow_state_record.nil?
      self.errors.add(:state, "could not be assigned (InitialState for Timesheet workflow not found)")
      Rails.logger.error "TIMESHEET CALLBACK ERROR: InitialState for WorkflowProcess ID #{initial_workflow_process.id} is NIL! Cannot assign state."
      return # Exit early
    end

    # Assign the state
    self.state = initial_workflow_state_record.workflow_state_id
    Rails.logger.debug "TIMESHEET CALLBACK: Successfully set self.state to: #{self.state}"
    Rails.logger.debug "TIMESHEET CALLBACK: Exiting assign_state. Current self.state: #{self.state.inspect}"
    # --- END DEBUG LOGGING ---
  end

  def current_status
    # This method fetches the current status string from the WorkflowState model.
    WorkflowState.find(self.state).state rescue ''
  end

  def project_name
    # This method might be problematic if a Timesheet can have multiple projects via tasks.
    # If a Timesheet has one main project, ensure 'has_one :project' is correct and project_id exists.
    # Otherwise, you might want to retrieve projects via timesheet_tasks.
    self.project.project_name if self.project.present?
  end

  def period
    return "#{self.timesheet_week.strftime('%d %b %Y')} to #{self.timesheet_week.end_of_week.strftime('%d %b %Y')}"
  end

  def full_details
    tasks = self.timesheet_tasks
    full_timesheet = {}
    (tasks || []).each do |task|
      # Ensure task.project is not nil before accessing short_name
      project_short_name = task.project.short_name if task.project.present?
      next unless project_short_name # Skip if project is missing

      full_timesheet[project_short_name] ||= {'totals' => [0, 0, 0, 0, 0, 0, 0]}
      full_timesheet[project_short_name]["totals"][task.task_date.cwday] += task.duration.to_f

      full_timesheet[project_short_name][task.description] ||= [0, 0, 0, 0, 0, 0, 0]
      full_timesheet[project_short_name][task.description][task.task_date.cwday] += task.duration.to_f
    end
    return full_timesheet
  end

  private

end