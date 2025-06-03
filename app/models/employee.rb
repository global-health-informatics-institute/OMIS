class Employee < ApplicationRecord
  belongs_to :person, foreign_key: :person_id
  has_one :user, foreign_key: :employee_id
  has_many :affiliations, foreign_key: :employee_id
  has_many :employee_designations, foreign_key: :employee_id
  has_many :project_teams, foreign_key: :project_id
  # supervisor
  has_many :given_supervisions, foreign_key: 'supervisor', class_name: 'Supervision'
  has_many :subordinates, through: :given_supervisions, source: :supervisee_employee

  # As subordinate
  has_one :received_supervision, foreign_key: 'supervisee', class_name: 'Supervision'
  has_one :supervisor, through: :received_supervision, source: :supervisor_employee

  def full_details(period = 'current')
    record = {}
    person = self.person
    record['id'] = id
    record['email'] = person.email_address
    record['gender'] = person.gender
    record['date_of_birth'] = person.birth_date
    record['phone_number'] = person.primary_phone
    record['employee_date'] = employment_date
    record['departure_date'] = departure_date
    record['marital_status'] = person.marital_status
    record['employee_name'] = { fname: person.first_name, mname: person.middle_name, lname: person.last_name }

    if period == 'current'
      record['branch'] = current_affiliations.collect { |x| x.pretty_display }
      record['designations'] = current_designations.collect { |x| x.pretty_display }
    # record["supervisors"] = s
    else
      record['branch'] = employee_affiliations.collect { |x| x.pretty_display }
      record['designations'] = designations.collect { |x| x.pretty_display }
      # record["supervisors"] = s
    end
    record
  end

  def current_position
    current_designations.collect { |x| x.pretty_display }.map { |x| x[:title] }.join(',')
  end
  def current_supervisors
    people = Supervision.where(supervisee: employee_id, ended_on: nil)
  end

  def current_supervisees
    people = Supervision.where(supervisor: employee_id, ended_on: nil)
  end
  def supervisor?
    # An employee is considered a supervisor if they have any active supervisees.
    # `current_supervisees` is already defined in your Employee model.
    self.current_supervisees.any?
  end

  def current_department
    current_affiliations.collect { |x| x.pretty_display }.map { |x| "#{x[:department_name]}" }.uniq.join(' | ')
  end

  def current_branches
    current_affiliations.collect { |x| x.pretty_display }.map do |x|
      "#{x[:branch_name]}, #{x[:branch_country]}"
    end.uniq.join(' | ')
  end

  def designations
    employee_designations
  end

  def current_designations
    employee_designations.where('end_date is null')
  end

  def employment_type
    designation = current_position
    if (designation.downcase.include? 'intern') & !(designation.downcase.include? 'volunteer')
      'Internship'
    elsif designation.downcase.include? 'volunteer'
      'Volunteer'
    else
      'Full-time'
    end
  end

  def employee_affiliations
    affiliations
  end

  def current_affiliations
    affiliations.where(is_terminated: false)
  end

  def current_projects
    ProjectTeam.where(employee_id: employee_id, voided: false)
  end

  def current_supervisors
    people = Supervision.where(supervisee: employee_id, ended_on: nil)
  end

  def current_supervisees
    people = Supervision.where(supervisor: employee_id, ended_on: nil)
  end

  def used_leave_days(leave_days_start_date = Date.today.beginning_of_month, end_date = Date.today,
                      leave_type: 'Annual Leave')
    timesheets = Timesheet.select('timesheet_id').where('employee_id = ?', employee_id)
    leave_records = TimesheetTask.where('project_id = ? AND task_date between ? and ? and timesheet_id in (?)',
                                        Project.find_by_short_name(leave_type).project_id,
                                        leave_days_start_date, end_date, timesheets)
    leave_hours_taken = leave_records.sum { |record| record.duration }
    (leave_hours_taken / 7.5).to_i
  end

  def compensatory_leave(start_date = 6.weeks.ago.to_date, end_date = Date.today)
    timesheets = Timesheet.select('timesheet_id').where('employee_id = ?', employee_id)
                          .collect { |x| x.timesheet_id }
    total_hours_worked = TimesheetTask.where('task_date between ? and ? and timesheet_id in (?) and
                                               project_id not in (?) and project_id not in (?)', start_date, end_date, timesheets,
                                             Project.find_by_short_name('Compensatory Leave').project_id,
                                             Project.where('short_name like ?', '%Leave%').collect { |x| x.project_id })
                                      .sum('duration').to_f
    weekdays_count = (start_date..end_date).count { |date| (1..5).include?(date.wday) }
    working_hours = GlobalProperty.find_by_property('number.of.hours').property_value.to_f
    compensatory_hours = TimesheetTask.where('project_id = ? AND task_date between ? and ? and timesheet_id in (?)',
                                             Project.find_by_short_name('Compensatory Leave').project_id,
                                             start_date, end_date, timesheets).sum('duration').to_f
    total_expected_hours = weekdays_count * working_hours
    total_extra_hours = total_hours_worked - total_expected_hours
    if total_extra_hours.positive?
      total_extra_hours - compensatory_hours
    else
      0.0
    end
    # raise weekdays_count.inspect
  end

  def leave_balance(leave_type: 'Annual Leave')
    LeaveSummary.where(employee_id: employee_id, leave_type: leave_type,
                       financial_year: Date.today.year).first.leave_days_balance.floor(2)
  rescue StandardError
    0.0
  end

  def loe(start_date = Date.today.beginning_of_month, end_date = Date.today.end_of_month)
    results = Hash.new(0.0)
    timesheets = Timesheet.select('timesheet_id').where('employee_id = ? and timesheet_week BETWEEN ? and ?',
                                                        employee_id, start_date.beginning_of_week, end_date)

    tasks = TimesheetTask.select('project_id, SUM(duration) as duration').where("timesheet_id in (?) and
                                task_date BETWEEN  ? and ?", timesheets, start_date, end_date).group(:project_id)

    cost_shared = Project.where('short_name in (?)', ['Crosscutting', 'Public Holiday', 'Annual Leave',
                                                      'Paternity Leave', 'Compassionate Leave', 'Study Leave',
                                                      'Sick Leave']).collect { |x| x.project_id }
    cost_shared_amount = 0.0

    (tasks || []).each do |task|
      if cost_shared.include?(task.project_id)
        cost_shared_amount += task.duration
      else
        results[task.project.short_name] = task.duration
      end
    end

    (current_projects || []).each do |proj|
      results[proj.project.short_name] += ((proj.allocated_effort / 100) * cost_shared_amount)
    end

    results
  end

  def pending_actions
    # this function is for getting things that a person should act on
    actions = []

    # Get things that I need to do routinely as an employee

    # Get things that need my approval or review as a supervisor
    supervisor_transitions = WorkflowStateActor.where(by_supervisor: true)
    # Get things that need my approval or review based on my role

    # outstanding timesheets
    actions += Timesheet.select('timesheet_id, employee_id, timesheet_week')
                        .where('employee_id in (?) and submitted_on is NULL', id)
                        .collect do |x|
      ["Submit #{x.timesheet_week.strftime('%d %b, %Y')} timesheet",
       "/timesheets/#{x.id}"]
    end
    # timesheet reviews

    jnrs = current_supervisees.collect { |x| x.supervisee }

    actions += Timesheet.select('timesheet_id, employee_id, submitted_on, timesheet_week')
                        .where('employee_id in (?) and submitted_on is not NULL and approved_on is NULL', jnrs)
                        .collect do |x|
      ["Review #{x.employee.person.first_name}\'s #{x.timesheet_week.strftime('%d %b, %Y')} timesheet",
       "/timesheets/#{x.id}"]
    end
    designation_ids = current_designations.collect(&:designation_id)

    allowed_transitions = WorkflowStateActor.where(
      employee_designation_id: current_designations.collect { |x| x.designation_id }
    ).where.not(workflow_state_id: [22, 27, 28, 29]).pluck(:workflow_state_id)
    # Add exception: allow workflow_state_id 28 for designation_id 78
    allowed_transitions << 28 if designation_ids.include?(12) && !allowed_transitions.include?(28)
    # requisition finance reviews
    actions += Requisition.where('workflow_state_id in (?)', allowed_transitions)
                          .collect do |x|
      ["Review #{x.user.person.first_name}\'s #{x.requisition_type} requisition for #{x.purpose}",
       "/requisitions/#{x.id}"]
    end

    # self requisitions
    owner_actionable_states = WorkflowStateTransition.where(by_owner: true).pluck(:workflow_state_id)
    owner_actionable_states << 24 # Explicitly include the "Approved" state (ID 24)

    actions += Requisition.where('workflow_state_id in (?) and initiated_by = ?', owner_actionable_states.uniq, id) # Use .uniq to avoid duplicates
                          .collect do |x|
      if x.workflow_state_id == 28
        ["Collect Funds for #{x.requisition_type} request: #{x.purpose}",
         "/requisitions/#{x.id}"]
      else
        ["Check #{x.requisition_type} request: #{x.purpose}",
         "/requisitions/#{x.id}"]
      end
    end

    # requisition reviews
    actions += Requisition.where('workflow_state_id in (?) and initiated_by in (?)', WorkflowStateTransition
                          .where(by_supervisor: true).collect { |x| x.workflow_state_id }, jnrs)
                          .collect do |x|
      ["Review #{x.user.person.first_name}\'s #{x.requisition_type} requisition for #{x.purpose}",
       "/requisitions/#{x.id}"]
    end

    actions += LeaveRequest.where('status in (?) and employee_id in (?)', WorkflowStateTransition
                           .where(by_owner: true).collect { |x| x.workflow_state_id }, id)
                           .collect { |x| ['Review leave request', "/leave_requests/#{x.id}"] }

    actions += LeaveRequest.where('status in (?) and employee_id in (?) and approved_on is NULL', WorkflowStateTransition
                           .where(by_supervisor: true).collect do |x|
      x.workflow_state_id
    end, jnrs)
                           .collect do |x|
      ["Review #{x.employee.user.person.first_name}'s' #{x.leave_type} request",
       "/leave_requests/#{x.id}"]
    end
    # raise actions.inspect
    actions
  end
end
