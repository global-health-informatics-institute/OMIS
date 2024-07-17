class MainController < ApplicationController
  skip_before_action :logged_in?, only: [:home, :about]
  def home
    if current_user
      @employee = current_user.employee
      @person = @employee.person
      @upcoming_deadlines = ProjectTask.where("project_task_id in (?)",
                                              ProjectTaskAssignment.select(:project_task_id).where(assigned_to: current_user.employee_id,
                                                                          revoked: false )
                                              ).where.not(task_status: "Complete").order("deadline DESC").limit(5)

      @loe_targets = ProjectTeam.where("employee_id = ? and project_id in (?) and end_date is NULL",
                                       current_user.employee_id, Project.select(:project_id).where(is_active: true))
      @project_names = Project.select(:short_name).where(project_id: @loe_targets.collect { |x| x.project_id })
      @loe_current = @employee.loe()

      @total_hrs = 0.0
      (@loe_current || []).each_value do |v|
        @total_hrs += v
      end

      @projects = Project.select(:project_id, :project_name)
      p = Project.where(manager: current_user.employee_id)
      @upcoming_deadlines = []
      p.each do |proj|
        @upcoming_deadlines += proj.upcoming_deadlines
      end

      e = @employee
      jnrs = e.current_supervisees.collect{|x| x.supervisee}
      # by_s = WorkflowStateTransition.select(:workflow_state_id).where(by_supervisor: true).collect{|x| x.workflow_state_id }
      wp = WorkflowProcess.find_by(workflow: 'Timesheet')
      by_s = WorkflowStateTransition.joins("INNER JOIN workflow_states ON workflow_states.workflow_state_id = workflow_state_transitions.workflow_state_id")
                                    .where("workflow_states.workflow_process_id = ? AND workflow_state_transitions.by_supervisor = ?", wp.id, true)
                                    .collect{|x| x.workflow_state_id }
      # raise by_s.inspect
      @approvals = Timesheet.select("timesheet_id, employee_id, submitted_on, state").where("employee_id in (?) and submitted_on is not NULL and state in (?)", jnrs, by_s)
      # raise @approvals.inspect

    else
      people = Employee.select(:employee_id, :person_id).where(still_employed: true)
      @gender_summary, @age_summary = helpers.categorize_employees(
        Person.where(person_id: people.collect{|x|x.person_id}))
      @upcoming_deadlines = ProjectTask.where.not(task_status: "Complete")
      @employment_summary = Hash.new(0)
      @project_tasks = ProjectTask.where(voided:false)

      (people || []).each do |person|
        @employment_summary[person.employment_type.to_s] += 1
      end
    end
  end

  def about
  end
end
