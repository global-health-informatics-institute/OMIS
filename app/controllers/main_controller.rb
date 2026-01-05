class MainController < ApplicationController
  attr_reader :notifications

  skip_before_action :logged_in?, only: [:home, :about]
  def home
    if current_user
      @page_title = "User Dashboard"
      @employee = current_user.employee
      @person = @employee.person
      @outstanding_timesheets = Timesheet.select("timesheet_id, employee_id, timesheet_week")
                                         .where("employee_id in (?) and submitted_on is NULL", @employee.id).length

      @unused_leave = (@employee.leave_balance(leave_type: 'Annual Leave') - @employee.used_leave_days(
        Date.today.beginning_of_year, Date.today.end_of_year, leave_type: 'Annual Leave'))

      # Notifications, birthdays, anniversaries, and farewells, new employees
      @notifications = {
        'Birthdays' => Person
                       .where("TO_CHAR(birth_date, 'MM-DD') = ?", Date.today.strftime('%m-%d'))
                       .where(person_id: Employee.select(:person_id).where(still_employed: true))
                       .pluck(:first_name, :last_name)
      }

      # Create list of upcoming deadlines and activities
      @upcoming_deadlines = Hash.new([])
      ProjectTask.where("project_task_id in (?)", ProjectTaskAssignment.select(:project_task_id)
                                                                       .where(assigned_to: current_user.employee_id,
                                                                              revoked: false ))
                                       .where.not(task_status: "Complete").order("deadline DESC").limit(5)
                                       .each do |x|
        @upcoming_deadlines[x.deadline.to_time.to_i].append(x.task_description)
      end

      (Project.where(manager: current_user.employee_id) || []).each do |proj|
        proj.upcoming_deadlines.each do |x|
          @upcoming_deadlines[x.deadline.to_time.to_i].append(x.task_description)
        end
      end
      (LeaveRequest.where.not(approved_by: nil).where('employee_id = ? and start_on > ?',
                                                      current_user.employee_id, DateTime.now())|| []).each do |leave_request|
        key = leave_request.start_on.to_date.to_time.to_i
        if @upcoming_deadlines[key].blank?
          @upcoming_deadlines[key] = ["#{leave_request.leave_type} starting #{leave_request.start_on.strftime('%d %b, %Y %H:%M')}"]
        else
          @upcoming_deadlines[key].append("#{leave_request.leave_type} starting #{leave_request.start_on.strftime('%d %b, %Y %H:%M')}")
        end
      end

      @loe_targets = ProjectTeam.where("employee_id = ? and project_id in (?) and end_date is NULL",
                                       current_user.employee_id, Project.select(:project_id).where(is_active: true))
      @unallocated_loe = 100 - @loe_targets.collect { |x| (x.allocated_effort)}.sum
      @project_names = Project.select(:short_name).where(project_id: @loe_targets.collect { |x| x.project_id })
      @loe_current = @employee.loe()
      @projects_with_effort = Project
        .select("projects.project_id, projects.short_name, project_teams.allocated_effort")
        .joins("INNER JOIN project_teams ON project_teams.project_id = projects.project_id")
        .where(project_teams: { employee_id: current_user.employee_id, end_date: nil })
      # TODO: remove clutter loe_targets
      @total_hrs = 0.0
      (@loe_current || []).each_value do |v|
        @total_hrs += v
      end

      @pending_actions = current_user.employee.pending_actions
      @projects = Project.select(:project_id, :project_name)


      e = @employee
      jnrs = e.current_supervisees.collect{|x| x.supervisee}
      # by_s = WorkflowStateTransition.select(:workflow_state_id).where(by_supervisor: true).collect{|x| x.workflow_state_id }
      wp = WorkflowProcess.find_by(workflow: 'Timesheet')
      wpr= WorkflowProcess.find_by(workflow: 'Petty Cash Request')
      by_s = WorkflowStateTransition.joins("INNER JOIN workflow_states ON workflow_states.workflow_state_id = workflow_state_transitions.workflow_state_id")
                                    .where("workflow_states.workflow_process_id = ? AND workflow_state_transitions.by_supervisor = ?", wp.id, true)
                                    .collect{|x| x.workflow_state_id }
      by_s_r = WorkflowStateTransition.joins("INNER JOIN workflow_states ON workflow_states.workflow_state_id = workflow_state_transitions.workflow_state_id")
                                      .where("workflow_states.workflow_process_id = ? AND workflow_state_transitions.by_supervisor = ?", wpr.id, true)
                                      .collect{|x| x.workflow_state_id }
      # actor = WorkflowStateActor.select("workflow_state_transition, employee_designation_id").where("voided = ?", false).collect{|x| x.employee_designation_id }
      @approvals = Timesheet.select("timesheet_id, employee_id, submitted_on, state")
                            .where("employee_id in (?) and submitted_on is not NULL and state in (?)", jnrs, by_s)
      @requests = Requisition.select("requisition_id, initiated_by, initiated_on, workflow_state_id, requisition_type")
                             .where("initiated_by in (?) and approved_by is NULL and workflow_state_id in (?) and voided = ?", jnrs, by_s_r, false)

      @my_requisitions = Requisition.select("requisition_id, purpose, requisition_type, reviewed_by, approved_by").where("initiated_by = ?", current_user.employee_id)

    else
      @page_title = "Application Dashboard"
      people = Employee.select(:employee_id, :person_id).where(still_employed: true)
      @gender_summary, @age_summary = helpers.categorize_employees(
        Person.where(person_id: people.collect{|x|x.person_id}))
      @upcoming_deadlines = ProjectTask.where.not(task_status: "Complete")
      @employment_summary = Hash.new(0)
      @project_tasks = ProjectTask.where(voided:false)
      @retention = ReportStatistic.where(statistic_description: 'Retention Rate')
                                  .order('period_start desc').limit(12)
                                  .collect{|x| [x.period_label, (x.statistic_value*100)]}.to_h

      @turnover = ReportStatistic.where(statistic_description: 'Turnover Rate')
                                 .order('period_start desc').limit(12)
                                 .collect{|x| [x.period_label, (x.statistic_value*100)]}.to_h
      (people || []).each do |person|
        @employment_summary[person.employment_type.to_s] += 1
      end
    end
  end

  def about
  end

  def leave_dashboard

  end
end
